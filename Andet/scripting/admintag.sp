#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "GoldeneK"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>

#pragma newdecls required

EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Server Tags [CS-NOLIMIT]", 
	author = PLUGIN_AUTHOR, 
	description = "Server tags :P", 
	version = PLUGIN_VERSION, 
	url = "http://alliedmods.net"
};

public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if (g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("Ten plugin jest tylko na serwery CSGO i CSS. // This plugins is only for CSGO and CSS servers");
		HookEvent("player_team", Event1);
		HookEvent("player_spawn", Event1);
	}
}
public Action Event1(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (0 < client)
	{
		HandleTag(client);
	}
	return Plugin_Continue;
}
public Action HandleTag(int client)
{
	if (GetUserFlagBits(client) == ADMFLAG_CUSTOM2)
	{
		CS_SetClientClanTag(client, "< J.A >");
	}
	else if (GetUserFlagBits(client) == ADMFLAG_CUSTOM3)
	{
		CS_SetClientClanTag(client, "< A >");
	}
	else if (GetUserFlagBits(client) == ADMFLAG_CUSTOM4)
	{
		CS_SetClientClanTag(client, "< H.A >");
	}
	else if (GetUserFlagBits(client) == ADMFLAG_ROOT)
	{
		CS_SetClientClanTag(client, "< Owner >");
	}
	else if (GetUserFlagBits(client) == ADMFLAG_CUSTOM1)
	{
		CS_SetClientClanTag(client, "< Mod >");
	}
	else if (GetUserFlagBits(client) == ADMFLAG_RESERVATION)
	{
		CS_SetClientClanTag(client, "< VIP >");
	}
	else
	{
		CS_SetClientClanTag(client, "< Player >");
	}
} 