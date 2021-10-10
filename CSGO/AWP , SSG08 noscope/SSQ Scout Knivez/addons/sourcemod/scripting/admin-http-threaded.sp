#pragma semicolon 1

//////////////////////////////
//		DEFINITIONS			//
//////////////////////////////

#define PLUGIN_NAME "VikingCMS - HTTP Admins - SourceMod Plugin"
#define PLUGIN_AUTHOR "Zephyrus"
#define PLUGIN_DESCRIPTION "The SourceMod plugin for the VikingCMS HTTP admin system."
#define PLUGIN_VERSION "1.0.1"
#define PLUGIN_URL ""

//////////////////////////////
//			INCLUDES		//
//////////////////////////////

#include <sourcemod>

#include <zephstocks>
#include <EasyTrie>
#include <EasyJSON>
#include <VikingCMS>

//////////////////////////////
//			ENUMS			//
//////////////////////////////

//////////////////////////////////
//		GLOBAL VARIABLES		//
//////////////////////////////////

new Handle:g_hAdminFlags = INVALID_HANDLE;
new Handle:g_hAdminImmunity = INVALID_HANDLE;

//////////////////////////////////
//		PLUGIN DEFINITION		//
//////////////////////////////////

public Plugin:myinfo = 
{
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
};

//////////////////////////////
//		PLUGIN FORWARDS		//
//////////////////////////////

public OnPluginStart()
{
	// Supress warnings about unused variables.....
	if(g_bL4D || g_bL4D2 || g_bND) {}

	g_hAdminFlags = CreateTrie();
	g_hAdminImmunity = CreateTrie();
}

//////////////////////////////
//		CLIENT FORWARDS		//
//////////////////////////////

public Action:OnClientPreAdminCheck(client)
{
	if(IsFakeClient(client))
		return Plugin_Handled;

	// Get the SteamID
	new String:m_szAuthID[64];
	GetClientAuthString(client, STRING(m_szAuthID));

	new String:m_szFlags[50];
	new m_unImmunity = 0;
	if(GetTrieString(g_hAdminFlags, m_szAuthID, STRING(m_szFlags)))
	{
		GetTrieValue(g_hAdminImmunity, m_szAuthID, m_unImmunity);
		GiveClientAdmin(client, m_szFlags, m_unImmunity);
	}

	// Create params
	new Handle:m_hParams = EasyHTTP_CreateParams();
	EasyHTTP_WriteParamString(m_hParams, "sip", "");
	EasyHTTP_WriteParamString(m_hParams, "port", "");
	EasyHTTP_WriteParamInt(m_hParams, "sid", GetFriendID(client));

	// Request the admin state of the client
	new bool:ret = VikingCMS_QueryAPI("getAdmin", GET, m_hParams, GetAdmin, GetClientUserId(client));
	EasyHTTP_DestroyParams(m_hParams);

	// Check if the query was successful
	if(!ret)
	{
		LogError("Failed to check whether %N (%s) is an admin.", client, m_szAuthID);
		return Plugin_Continue;
	}

	return Plugin_Handled;
}

public OnRebuildAdminCache(AdminCachePart:part)
{	
	if (part == AdminCache_Admins)
	{
		LoopAuthorizedPlayers(client)
			OnClientPreAdminCheck(client);
	}
}

//////////////////////////////
//	  EASYHTTP CALLBACK 	//
//////////////////////////////

public GetAdmin(any:userid, Handle:json, bool:success)
{
	// Make sure our client is still ingame
	new client = GetClientOfUserId(userid);
	if(!client)
		return;

	// Check if the request failed for whatever reason
	if(!success)
	{
		// Player is not an admin
		RunAdminCacheChecks(client);
		NotifyPostAdminCheck(client);
		return;
	}

	new String:m_szAuthID[64];
	GetClientAuthString(client, STRING(m_szAuthID));

	// Check if the JSON contains the admin object
	new Handle:m_hAdmin = INVALID_HANDLE;
	if(!JSONGetObject(json, "admin", m_hAdmin) || m_hAdmin == INVALID_HANDLE)
	{
		// Remove him if we had him in cache
		decl tmp;
		if(GetTrieValue(g_hAdminImmunity, m_szAuthID, tmp))
		{
			RemoveFromTrie(g_hAdminFlags, m_szAuthID);
			RemoveFromTrie(g_hAdminImmunity, m_szAuthID);
			RemoveClientAdmin(client);
		}

		// Player is not an admin
		RunAdminCacheChecks(client);
		NotifyPostAdminCheck(client);

		return;
	}

	new String:m_szIdentifier[64];
	new String:m_szFlags[64];
	new m_unImmunity;

	// Check if the JSON contains the necessary values
	if(!JSONGetString(m_hAdmin, "identifier", STRING(m_szIdentifier)) || !JSONGetString(m_hAdmin, "flags", STRING(m_szFlags)) || !JSONGetInteger(m_hAdmin, "immunity", m_unImmunity))
	{
		if(RemoveFromTrie(g_hAdminFlags, m_szAuthID) || RemoveFromTrie(g_hAdminImmunity, m_szAuthID))
			RemoveClientAdmin(client);

		// Player is not an admin
		RunAdminCacheChecks(client);
		NotifyPostAdminCheck(client);

		return;
	}

	// Give flags and immunity
	new AdminId:m_Admin = GiveClientAdmin(client, m_szFlags, m_unImmunity);
	SetTrieString(g_hAdminFlags, m_szAuthID, m_szFlags);
	SetTrieValue(g_hAdminImmunity, m_szAuthID, m_unImmunity);

	RunAdminCacheChecks(client);
	NotifyPostAdminCheck(client);
}

public AdminId:GiveClientAdmin(client, String:flags[], immunity)
{
	new String:m_szAuthID[64];
	GetClientAuthString(client, STRING(m_szAuthID));

	RemoveClientAdmin(client);
	
	new AdminId:m_Admin = CreateAdmin(m_szAuthID);
	if (!BindAdminIdentity(m_Admin, AUTHMETHOD_STEAM, m_szAuthID))
	{
		LogError("Could not bind fetched HTTP admin (identity \"%s\")", m_szAuthID);
		return INVALID_ADMIN_ID;
	}

	// Apply immunity level
	SetAdminImmunityLevel(m_Admin, immunity);
	
	// Apply each flag
	new m_unLength = strlen(flags);
	new AdminFlag:m_Flag;
	for (new i=0; i<m_unLength; i++)
	{
		if (!FindFlagByChar(flags[i], m_Flag))
			continue;
		SetAdminFlag(m_Admin, m_Flag, true);
	}

	return m_Admin;
}

public RemoveClientAdmin(client)
{
	new String:m_szAuthID[64];
	GetClientAuthString(client, STRING(m_szAuthID));

	// For dynamic admins we clear anything already in the cache.
	new AdminId:m_Admin;
	if ((m_Admin = FindAdminByIdentity(AUTHMETHOD_STEAM, m_szAuthID)) != INVALID_ADMIN_ID)
	{
		RemoveAdmin(m_Admin);
	}
}