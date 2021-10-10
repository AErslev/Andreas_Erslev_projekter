#pragma semicolon 1
#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <clientprefs>
#include <smlib>
#include <morecolors>
#include <store>
#include <zephstocks> 

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo =
{
	name = "Store Gloves",
	author = "AbNeR_CSS",
	description = "Gloves to store",
	version = PLUGIN_VERSION,
	url = "www.tecnohardclan.com"
}

enum Gloves{
	String:szModel[PLATFORM_MAX_PATH],
	iCacheID,
	iSlot
}

char glovesEquipped[MAXPLAYERS+1][PLATFORM_MAX_PATH];
char gloveOriginal[MAXPLAYERS+1][PLATFORM_MAX_PATH];

bool gloveChanged[MAXPLAYERS+1];
int g_eGloves[STORE_MAX_ITEMS][Gloves];
int g_iGloves = 0;

public void OnPluginStart()
{
	HookEvent("player_spawn", EventPlayerSpawn);
	HookEvent("player_death", EventPlayerDeath);
	HookEvent("player_team", EventJoinTeam);
	Store_RegisterHandler("Gloves", "model", GlovesOnMapStart, GlovesReset, GlovesConfig, GlovesEquip, GlovesRemove, true); 
}

public void OnClientPutInServer(int client)
{
	clearGlovesOriginalClient(client);
	clearGlovesEquippedClient(client);
	gloveChanged[client] = false;
}

public void GlovesOnMapStart()
{
	for(int i=0;i<g_iGloves;++i)
	{
		g_eGloves[i][iCacheID] = PrecacheModel2(g_eGloves[i][szModel], true);
		Downloader_AddFileToDownloadsTable(g_eGloves[i][szModel]);
	}
	clearGlovesOriginal();
}	

public void OnMapStart()
{
	for(int i = 0;i < g_iGloves;i++)
	{
		if(!IsModelPrecached(g_eGloves[i][szModel]))
		{
			g_eGloves[i][iCacheID] = PrecacheModel2(g_eGloves[i][szModel], true);
			Downloader_AddFileToDownloadsTable(g_eGloves[i][szModel]);
		}
	}
	clearGlovesOriginal();
}

void clearGlovesEquippedClient(int client)
{
	Format(glovesEquipped[client], sizeof(glovesEquipped[]), "");
}

void clearGlovesOriginalClient(int client)
{
	Format(gloveOriginal[client], sizeof(gloveOriginal[]), "");
}

void clearGlovesOriginal()
{
	for(int i = 1;i <=MaxClients;i++)
	{
		Format(gloveOriginal[i], sizeof(gloveOriginal[]), "");
	}
}

public void GlovesReset() 
{ 
	g_iGloves = 0; 
}

public int GlovesConfig(Handle &kv, int itemid) 
{
	Store_SetDataIndex(itemid, g_iGloves);
	KvGetString(kv, "model", g_eGloves[g_iGloves][szModel], PLATFORM_MAX_PATH);
	g_eGloves[g_iGloves][iSlot] = KvGetNum(kv, "slot");
	
	if(FileExists(g_eGloves[g_iGloves][szModel], true))
	{
		++g_iGloves;
		
		for(int i=0;i<g_iGloves;++i)
		{
			if(!IsModelPrecached(g_eGloves[i][szModel]))
			{
				g_eGloves[i][iCacheID] = PrecacheModel2(g_eGloves[i][szModel], true);
				Downloader_AddFileToDownloadsTable(g_eGloves[i][szModel]);
			}
		}
		return true;
	}
	return false;
}

public int GlovesRemove(int client, int id) 
{
	clearGlovesEquippedClient(client);
	SetEntPropString(client, Prop_Send, "m_szArmsModel",  gloveOriginal[client]);
	RefreshGloves(client);
	gloveChanged[client] = true;
	return 0;
}

public int GlovesEquip(int client, int id)
{
	int m_iData = Store_GetDataIndex(id);
	if(StrEqual(gloveOriginal[client], ""))
		GetEntPropString(client, Prop_Send, "m_szArmsModel", gloveOriginal[client], sizeof(gloveOriginal[]));
	SetEntPropString(client, Prop_Send, "m_szArmsModel",  g_eGloves[m_iData][szModel]);
	
	Format(glovesEquipped[client], sizeof(glovesEquipped[]), g_eGloves[m_iData][szModel]);
	RefreshGloves(client);
	gloveChanged[client] = true;
	return 0;
}

RefreshGloves(int client)
{
	int weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(weapon != -1)
	{
		DataPack p = new DataPack();
		p.WriteCell(client);
		p.WriteCell(weapon);
		RemovePlayerItem(client, weapon);
		CreateTimer(0.1, RefreshGlovesTime, p);
	}
	
}

// RefreshGloves(int client)
// {
	// char tmpGloves[PLATFORM_MAX_PATH];
	// Format(tmpGloves, sizeof(tmpGloves), gloveOriginal[client]);
	// int team = GetClientTeam(client);
	// DataPack p = new DataPack();
	// p.WriteCell(client);
	// p.WriteString(tmpGloves);
	
	// if(team == CS_TEAM_T)
	// {
		// CS_SwitchTeam(client, CS_TEAM_CT);
		// CreateTimer(0.01, ChangeTR, p);
	// }
	// else if(team == CS_TEAM_CT)
	// {
		// CS_SwitchTeam(client, CS_TEAM_T);	
		// CreateTimer(0.01, ChangeCT, p);
	// }
// }

public Action RefreshGlovesTime(Handle time, DataPack p)
{
	p.Reset();
	int client = p.ReadCell();
	int weapon = p.ReadCell();
	if(weapon != -1)
		EquipPlayerWeapon(client, weapon);
}

// public Action ChangeCT(Handle time, DataPack p)
// {
	// char tmpGlove[PLATFORM_MAX_PATH];
	// p.Reset();
	// int client = p.ReadCell();
	// p.ReadString(tmpGlove, sizeof(tmpGlove));
	// CS_SwitchTeam(client, 3);
	// Format(gloveOriginal[client], sizeof(gloveOriginal[]), tmpGlove);
// }

// public Action ChangeTR(Handle time, DataPack p)
// {
	// char tmpGlove[PLATFORM_MAX_PATH];
	// p.Reset();
	// int client = p.ReadCell();
	// p.ReadString(tmpGlove, sizeof(tmpGlove));
	// CS_SwitchTeam(client, 2);
	// Format(gloveOriginal[client], sizeof(gloveOriginal[]), tmpGlove);
// }

public Action EventPlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	clearGlovesOriginalClient(client);
	gloveChanged[client] = false;
}

public Action EventJoinTeam(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	clearGlovesOriginalClient(client);
}

public Action EventPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(StrEqual(gloveOriginal[client], ""))
		GetEntPropString(client, Prop_Send, "m_szArmsModel", gloveOriginal[client], sizeof(gloveOriginal[]));
		
	if(!StrEqual(glovesEquipped[client], ""))
		SetEntPropString(client, Prop_Send, "m_szArmsModel",  glovesEquipped[client]);
		
	if(gloveChanged[client])
	{
		RefreshGloves(client);
		gloveChanged[client] = false;
	}
}

public IsValidClient(client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;

	return true;
}
