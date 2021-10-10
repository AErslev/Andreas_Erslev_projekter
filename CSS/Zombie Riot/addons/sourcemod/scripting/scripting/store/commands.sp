#if defined STANDALONE_BUILD
#include <sourcemod>
#include <sdktools>

#include <store>
#include <zephstocks>
#endif

new String:g_szCommands[STORE_MAX_ITEMS][128];

new g_iCommands = 0;

#if defined STANDALONE_BUILD
public OnPluginStart()
#else
public Commands_OnPluginStart()
#endif
{
	Store_RegisterHandler("command", "", Commands_OnMapStart, Commands_Reset, Commands_Config, Commands_Equip, Commands_Remove, false);
}

public Commands_OnMapStart()
{
}

public Commands_Reset()
{
	g_iCommands = 0;
}

public Commands_Config(&Handle:kv, itemid)
{
	Store_SetDataIndex(itemid, g_iCommands);
	
	KvGetString(kv, "command", g_szCommands[g_iCommands], sizeof(g_szCommands[]));
	
	++g_iCommands;
	return true;
}

public Commands_Equip(client, id)
{
	new m_iData = Store_GetDataIndex(id);
	decl String:m_szCommand[256];
	strcopy(STRING(m_szCommand), g_szCommands[m_iData]);

	decl String:m_szClientID[11];
	decl String:m_szUserID[11];
	new String:m_szSteamID[32] = "\"";
	new String:m_szName[66] = "\"";

	IntToString(client, STRING(m_szClientID));
	IntToString(GetClientUserId(client), STRING(m_szUserID));
	GetClientAuthString(client, m_szSteamID[1], sizeof(m_szSteamID)-1);
	GetClientName(client, m_szName[1], sizeof(m_szName)-1);

	m_szSteamID[strlen(m_szSteamID)] = '"';
	m_szName[strlen(m_szName)] = '"';

	ReplaceString(STRING(m_szCommand), "{clientid}", m_szClientID);
	ReplaceString(STRING(m_szCommand), "{userid}", m_szUserID);
	ReplaceString(STRING(m_szCommand), "{steamid}", m_szSteamID);
	ReplaceString(STRING(m_szCommand), "{name}", m_szName);

	ServerCommand("%s", m_szCommand);

	return 0;
}

public Commands_Remove(client)
{
	return 0;
}