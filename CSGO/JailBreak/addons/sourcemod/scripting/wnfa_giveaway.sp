#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Totenfluch"
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <store>
#include <multicolors>

char ttag[] = "WNFA";

public Plugin myinfo = 
{
	name = "storeGiveaway",
	author = PLUGIN_AUTHOR,
	description = "gives credits to players",
	version = PLUGIN_VERSION,
	url = "http://ggc-base.de"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_giveaway", giveawayCallback, ADMFLAG_ROOT);
	
	LoadTranslations("storeGiveaway.phrases");
}

public Action giveawayCallback(int client, int args){
	if(args != 1){
		CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits or args");
		return;
	}else if(args == 1){
		char args1[20];
		GetCmdArg(1, args1, sizeof(args1));
		int amount = StringToInt(args1);
		if(amount == 0){
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits");
			return;
		}
		int winner = GetRandomPlayer(client);
		Store_SetClientCredits(winner, Store_GetClientCredits(winner) + amount);
		char winnerName[MAX_NAME_LENGTH + 8];
		GetClientName(winner, winnerName, sizeof(winnerName));
		CPrintToChatAll("%t", "announceWinner", ttag, winnerName, amount);
	}
	
}

stock int GetRandomPlayer(int initiator)
{
	int clients[65];
	int clientCount;
	for (new i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i) && i != initiator)
		clients[clientCount++] = i;
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount - 1)];
}


stock bool isValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
}
