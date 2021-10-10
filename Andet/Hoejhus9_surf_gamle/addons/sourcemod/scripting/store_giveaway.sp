#pragma semicolon 1

#define PLUGIN_AUTHOR "Totenfluch"
#define PLUGIN_VERSION "2.00"

#include <sourcemod>
#include <sdktools>
#include <store>
#include <multicolors>
#include <autoexecconfig>

#pragma newdecls required

Handle g_hChatTag;
char ttag[] = "GGC";

Handle g_hMinPlayerGiveaway;
int g_iMinPlayerGiveaway;

Handle g_hMaxGiveaway;
int g_iMaxGiveaway;

public Plugin myinfo = 
{
	name = "Store Giveaway", 
	author = PLUGIN_AUTHOR, 
	description = "Allows Admins and Players to start a Giveaway with credits", 
	version = PLUGIN_VERSION, 
	url = "http://ggc-base.de"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_giveaway", giveawayCallback, ADMFLAG_ROOT);
	RegConsoleCmd("sm_playergiveaway", playergiveawayCallback);
	
	AutoExecConfig_SetFile("storeGiveaway");
	AutoExecConfig_SetCreateFile(true);
	
	g_hChatTag = AutoExecConfig_CreateConVar("giveaway_chattag", "GGC", "sets the chat tag before every message for Giveaways");
	g_hMinPlayerGiveaway = AutoExecConfig_CreateConVar("giveaway_minCredits", "500", "Minimum amount of credits a Player giveaway can be started with");
	g_hMaxGiveaway = AutoExecConfig_CreateConVar("giveaway_maxCredits", "10000", "Maximum amount of credits any giveaway can be started with");
	
	AutoExecConfig_CleanFile();
	AutoExecConfig_ExecuteFile();
	
	LoadTranslations("storeGiveaway.phrases");
}

public void OnConfigsExecuted() {
	GetConVarString(g_hChatTag, ttag, sizeof(ttag));
	g_iMinPlayerGiveaway = GetConVarInt(g_hMinPlayerGiveaway);
	g_iMaxGiveaway = GetConVarInt(g_hMaxGiveaway);
}

public Action giveawayCallback(int client, int args) {
	char logfile[255];
	BuildPath(Path_SM, logfile, sizeof(logfile), "logs/store_giveaway.txt");
	if (args != 1 && args != 2) {
		CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits or args");
		return Plugin_Handled;
	} else if (args == 1) {
		char args1[20];
		GetCmdArg(1, args1, sizeof(args1));
		int amount = StringToInt(args1);
		if (amount == 0) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits");
			return Plugin_Handled;
		}
		
		if (amount > g_iMaxGiveaway) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (Max %s)", g_iMaxGiveaway);
			return Plugin_Handled;
		}
		
		int winner = GetRandomPlayer(client);
		Store_SetClientCredits(winner, Store_GetClientCredits(winner) + amount);
		char winnerName[MAX_NAME_LENGTH + 8];
		GetClientName(winner, winnerName, sizeof(winnerName));
		CPrintToChatAll("%t", "announceWinner", ttag, winnerName, amount);
		
		char giveawayStarterName[MAX_NAME_LENGTH + 8];
		GetClientName(client, giveawayStarterName, sizeof(giveawayStarterName));
		CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
		CPrintToChat(winner, "%t", "announceSelfWinner", ttag, giveawayStarterName, amount);
		CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
		
		char winner_id[20];
		GetClientAuthId(winner, AuthId_Steam2, winner_id, sizeof(winner_id));
		char initiator_id[20];
		GetClientAuthId(client, AuthId_Steam2, initiator_id, sizeof(initiator_id));
		LogToFile(logfile, "Initiator: %s (%s) | Amount: %i | Winner: %N (%s)", giveawayStarterName, initiator_id, amount, winner, winner_id);
		
	} else if (args == 2) {
		char args1[20];
		GetCmdArg(1, args1, sizeof(args1));
		int amount = StringToInt(args1);
		if (amount == 0) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (0...)");
			return Plugin_Handled;
		}
		
		if (amount > g_iMaxGiveaway) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (Max %s)", g_iMaxGiveaway);
			return Plugin_Handled;
		}
		
		char args2[20];
		GetCmdArg(2, args2, sizeof(args2));
		int amount2 = StringToInt(args2);
		if (amount2 == 0) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (0...)");
			return Plugin_Handled;
		}
		
		if ((amount / amount2) <= 1) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (split too little)");
			return Plugin_Handled;
		}
		
		if ((amount / amount2) >= 10000) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (split too high)");
			return Plugin_Handled;
		}
		
		int splitAmount = amount / amount2;
		
		for (int i = 0; i < amount2; i++) {
			int winner = GetRandomPlayer(client);
			Store_SetClientCredits(winner, Store_GetClientCredits(winner) + splitAmount);
			char winnerName[MAX_NAME_LENGTH + 8];
			char giveawayStarterName[MAX_NAME_LENGTH + 8];
			GetClientName(client, giveawayStarterName, sizeof(giveawayStarterName));
			
			GetClientName(winner, winnerName, sizeof(winnerName));
			CPrintToChatAll("%t", "announceWinner", ttag, winnerName, splitAmount);
			
			
			CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
			CPrintToChat(winner, "%t", "announceSelfWinner", ttag, giveawayStarterName, splitAmount);
			CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
			
			char winner_id[20];
			GetClientAuthId(winner, AuthId_Steam2, winner_id, sizeof(winner_id));
			char initiator_id[20];
			GetClientAuthId(client, AuthId_Steam2, initiator_id, sizeof(initiator_id));
			LogToFile(logfile, "Initiator: %s (%s) | Amount: %i | Winner: %N (%s)", giveawayStarterName, initiator_id, splitAmount, winner, winner_id);
		}
		
	}
	return Plugin_Handled;
}

public Action playergiveawayCallback(int client, int args) {
	char logfile[255];
	BuildPath(Path_SM, logfile, sizeof(logfile), "logs/store_giveaway.txt");
	if (args != 1 && args != 2) {
		CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits or args");
		return Plugin_Handled;
	} else if (args == 1) {
		char args1[20];
		GetCmdArg(1, args1, sizeof(args1));
		int amount = StringToInt(args1);
		if (amount == 0 || amount < g_iMinPlayerGiveaway) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (min %s)", g_iMinPlayerGiveaway);
			return Plugin_Handled;
		}
		
		if (amount > g_iMaxGiveaway) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (Max %s)", g_iMaxGiveaway);
			return Plugin_Handled;
		}
		
		int initiatorCredits = Store_GetClientCredits(client);
		if ((initiatorCredits - amount) < 0) {
			CReplyToCommand(client, "{darkred}[-T-] You don't have enough credits to do that");
			return Plugin_Handled;
		} else {
			Store_SetClientCredits(client, initiatorCredits - amount);
			
			int winner = GetRandomPlayer(client);
			Store_SetClientCredits(winner, Store_GetClientCredits(winner) + amount);
			char winnerName[MAX_NAME_LENGTH + 8];
			GetClientName(winner, winnerName, sizeof(winnerName));
			
			
			char giveawayStarterName[MAX_NAME_LENGTH + 8];
			GetClientName(client, giveawayStarterName, sizeof(giveawayStarterName));
			
			CPrintToChatAll("%t", "announceWinnerByPlayer", ttag, winnerName, giveawayStarterName, amount);
			CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
			CPrintToChat(winner, "%t", "announceSelfWinner", ttag, giveawayStarterName, amount);
			CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
			
			char winner_id[20];
			GetClientAuthId(winner, AuthId_Steam2, winner_id, sizeof(winner_id));
			char initiator_id[20];
			GetClientAuthId(client, AuthId_Steam2, initiator_id, sizeof(initiator_id));
			LogToFile(logfile, "Initiator: %s (%s) | Amount: %i | Winner: %N (%s)", giveawayStarterName, initiator_id, amount, winner, winner_id);
		}
	} else if (args == 2) {
		char args1[20];
		GetCmdArg(1, args1, sizeof(args1));
		int amount = StringToInt(args1);
		
		if (amount == 0 || amount < g_iMinPlayerGiveaway) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (min %s)", g_iMinPlayerGiveaway);
			return Plugin_Handled;
		}
		
		if (amount > g_iMaxGiveaway) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (Max %s)", g_iMaxGiveaway);
			return Plugin_Handled;
		}
		
		int initiatorCredits = Store_GetClientCredits(client);
		if ((initiatorCredits - amount) < 0) {
			CReplyToCommand(client, "{darkred}[-T-] You don't have enough credits to do that");
			return Plugin_Handled;
		}
		Store_SetClientCredits(client, initiatorCredits - amount);
		
		
		if (amount == 0) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (0...)");
			return Plugin_Handled;
		}
		
		
		char args2[20];
		GetCmdArg(2, args2, sizeof(args2));
		int amount2 = StringToInt(args2);
		
		if (amount2 == 0) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (0...)");
			return Plugin_Handled;
		}
		
		if ((amount / amount2) <= 1) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (split too little)");
			return Plugin_Handled;
		}
		
		if ((amount / amount2) >= 10000) {
			CReplyToCommand(client, "{darkred}[-T-] Invalid amount of credits (too much split)");
			return Plugin_Handled;
		}
		
		int splitAmount = amount / amount2;
		
		for (int i = 0; i < amount2; i++) {
			int winner = GetRandomPlayer(client);
			Store_SetClientCredits(winner, Store_GetClientCredits(winner) + splitAmount);
			char winnerName[MAX_NAME_LENGTH + 8];
			GetClientName(winner, winnerName, sizeof(winnerName));
			char giveawayStarterName[MAX_NAME_LENGTH + 8];
			GetClientName(client, giveawayStarterName, sizeof(giveawayStarterName));
			
			CPrintToChatAll("%t", "announceWinnerByPlayer", ttag, winnerName, giveawayStarterName, splitAmount);
			
			CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
			CPrintToChat(winner, "%t", "announceSelfWinner", ttag, giveawayStarterName, splitAmount);
			CPrintToChat(winner, "{darkred}^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^-.-^");
			
			char winner_id[20];
			GetClientAuthId(winner, AuthId_Steam2, winner_id, sizeof(winner_id));
			char initiator_id[20];
			GetClientAuthId(client, AuthId_Steam2, initiator_id, sizeof(initiator_id));
			LogToFile(logfile, "Initiator: %s (%s) | Amount: %i | Winner: %N (%s)", giveawayStarterName, initiator_id, splitAmount, winner, winner_id);
		}
		
	}
	
	return Plugin_Handled;
}

stock int GetRandomPlayer(int initiator)
{
	int clients[65];
	int clientCount;
	for (int i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i) && i != initiator && !IsFakeClient(i))
		clients[clientCount++] = i;
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount - 1)];
}


stock bool isValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
}
