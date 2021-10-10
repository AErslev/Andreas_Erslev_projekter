#pragma semicolon 1

#define PLUGIN_AUTHOR "Totenfluch"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <store>
#include <autoexecconfig>
#include <multicolors>
#include <smlib>

#pragma newdecls required

#define MAX_ENTRYS 1024

int g_iClientAction[MAXPLAYERS + 1];
int g_iClientChoice[MAXPLAYERS + 1];

Handle g_hChatTag;
char g_cTag[16] = "GGC";

char dbconfig[] = "gsxh_multiroot";
Database g_DB;

int currSpamTime = 0;

Handle g_hLowJackpotTime;
int g_iLowJackpotTime;

Handle g_hMediumJackpotTime;
int g_iMediumJackpotTime;

Handle g_hHighJackpotTime;
int g_iHighJackpotTime;

enum jackpotEntry {
	bool:jeActive, 
	String:jePlayerid[20], 
	jeAmount
}

int theLowJackpot[MAX_ENTRYS][jackpotEntry];
bool g_bLowJackpotActive = false;
int g_iLowTimeleft = -1;

Handle g_hLowMaxJackpotThreshold;
int g_iLowMaxJackpotThreshold;

Handle g_hLowMinJackpotThreshold;
int g_iLowMinJackpotThreshold;

int theMediumJackpot[MAX_ENTRYS][jackpotEntry];
bool g_bMediumJackpotActive = false;
int g_iMediumTimeleft = -1;

Handle g_hMediumMaxJackpotThreshold;
int g_iMediumMaxJackpotThreshold;

Handle g_hMediumMinJackpotThreshold;
int g_iMediumMinJackpotThreshold;


int theHighJackpot[MAX_ENTRYS][jackpotEntry];
bool g_bHighJackpotActive = false;
int g_iHighTimeleft = -1;

Handle g_hHighMaxJackpotThreshold;
int g_iHighMaxJackpotThreshold;

Handle g_hHighMinJackpotThreshold;
int g_iHighMinJackpotThreshold;


Handle g_hSpamCooldown;
int g_iSpamCooldown;

Handle g_hMaxEntrys;
int g_iMaxEntrys;

Handle g_hLowVIPonlyStart;
bool g_bLowVIPonlyStart;

Handle g_hMediumVIPonlyStart;
bool g_bMediumVIPonlyStart;

Handle g_hHighVIPonlyStart;
bool g_bHighVIPonlyStart;

Handle g_hHouseMargin;
float g_fHouseMargin;

public Plugin myinfo = 
{
	name = "Zephstore Jackpot", 
	author = PLUGIN_AUTHOR, 
	description = "Adds a Jackpot system to Zephstore", 
	version = PLUGIN_VERSION, 
	url = "http://ggc-base.de"
};

public void OnPluginStart() {
	char error[255];
	g_DB = SQL_Connect(dbconfig, true, error, sizeof(error));
	SQL_SetCharset(g_DB, "utf8");
	
	LoadTranslations("store_jackpot.phrases");
	
	AutoExecConfig_SetFile("store_jackpot");
	AutoExecConfig_SetCreateFile(true);
	
	g_hChatTag = AutoExecConfig_CreateConVar("jackpot_chattag", "GGC", "sets the chat tag before every message for the Jackpot Plugin");
	
	
	g_hLowVIPonlyStart = AutoExecConfig_CreateConVar("Jackpot_startLowVipOnly", "0", "Only VIP's (Custom 6) can start a Low Jackpot");
	g_hMediumVIPonlyStart = AutoExecConfig_CreateConVar("Jackpot_startMediumVipOnly", "0", "Only VIP's (Custom 6) can start a Medium Jackpot");
	g_hHighVIPonlyStart = AutoExecConfig_CreateConVar("Jackpot_startHighVipOnly", "0", "Only VIP's (Custom 6) can start a High Jackpot");
	
	g_hHouseMargin = AutoExecConfig_CreateConVar("Jackpot_houseMargin", "0.95", "Percentage of how much the Server takes 1.00 - x = Margin | 0.95 -> 5%");
	
	g_hLowJackpotTime = AutoExecConfig_CreateConVar("Jackpot_lowJackpotTime", "60", "Low Jackpot duration in seconds");
	g_hMediumJackpotTime = AutoExecConfig_CreateConVar("Jackpot_mediumJackpotTime", "180", "Medium Jackpot duration in seconds");
	g_hHighJackpotTime = AutoExecConfig_CreateConVar("Jackpot_highJackpotTime", "210", "High Jackpot duration in seconds");
	
	g_hLowMaxJackpotThreshold = AutoExecConfig_CreateConVar("Jackpot_Low_maxThreshold", "1000", "maximum amount of credits you can play Low Jackpot with");
	g_hLowMinJackpotThreshold = AutoExecConfig_CreateConVar("Jackpot_Low_minThreshold", "50", "minimum amount of credits you can play Low Jackpot with");
	
	g_hMediumMaxJackpotThreshold = AutoExecConfig_CreateConVar("Jackpot_Medium_maxThreshold", "5000", "maximum amount of credits you can play Medium Jackpot with");
	g_hMediumMinJackpotThreshold = AutoExecConfig_CreateConVar("Jackpot_Medium_minThreshold", "1000", "minimum amount of credits you can play Medium Jackpot with");
	
	g_hHighMaxJackpotThreshold = AutoExecConfig_CreateConVar("Jackpot_High_maxThreshold", "10000", "maximum amount of credits you can play High Jackpot with");
	g_hHighMinJackpotThreshold = AutoExecConfig_CreateConVar("Jackpot_High_minThreshold", "5000", "minimum amount of credits you can play High Jackpot with");
	
	g_hSpamCooldown = AutoExecConfig_CreateConVar("Jackpot_spamCooldown", "1000", "cooldown in s between messages");
	g_hMaxEntrys = AutoExecConfig_CreateConVar("Jackpot_MaxEntrys", "2", "maximum amount of times you can enter a jackpot");
	
	char createTableQuery[4096];
	Format(createTableQuery, sizeof(createTableQuery), "CREATE TABLE IF NOT EXISTS jackpot (`Id`BIGINT NOT NULL AUTO_INCREMENT, `timestamp`TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `playerid`VARCHAR(20)NOT NULL, `amount`INT NOT NULL, PRIMARY KEY(`Id`), UNIQUE(`playerid`))ENGINE = InnoDB; ");
	SQL_TQuery(g_DB, SQLErrorCheckCallback, createTableQuery);
	
	Format(createTableQuery, sizeof(createTableQuery), "CREATE TABLE IF NOT EXISTS jackpot_log ( `Id` BIGINT NOT NULL AUTO_INCREMENT , `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , `playerid` VARCHAR(20) NOT NULL , `amount` INT NOT NULL , `concat` VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL , PRIMARY KEY (`Id`)) ENGINE = InnoDB;");
	SQL_TQuery(g_DB, SQLErrorCheckCallback, createTableQuery);
	
	AutoExecConfig_CleanFile();
	AutoExecConfig_ExecuteFile();
	
	RegConsoleCmd("sm_jackpot", cmdJackpot, "Opens the Jackpot Menu");
	RegConsoleCmd("sm_jp", cmdJackpot, "Opens the Jackpot Menu");
	HookEvent("player_spawn", onPlayerSpawn);
}

public void OnConfigsExecuted() {
	GetConVarString(g_hChatTag, g_cTag, sizeof(g_cTag));
	
	g_iLowJackpotTime = GetConVarInt(g_hLowJackpotTime);
	g_iMediumJackpotTime = GetConVarInt(g_hMediumJackpotTime);
	g_iHighJackpotTime = GetConVarInt(g_hHighJackpotTime);
	
	g_iLowMinJackpotThreshold = GetConVarInt(g_hLowMinJackpotThreshold);
	g_iLowMaxJackpotThreshold = GetConVarInt(g_hLowMaxJackpotThreshold);
	
	g_iMediumMinJackpotThreshold = GetConVarInt(g_hMediumMinJackpotThreshold);
	g_iMediumMaxJackpotThreshold = GetConVarInt(g_hMediumMaxJackpotThreshold);
	
	g_iHighMinJackpotThreshold = GetConVarInt(g_hHighMinJackpotThreshold);
	g_iHighMaxJackpotThreshold = GetConVarInt(g_hHighMaxJackpotThreshold);
	
	g_iSpamCooldown = GetConVarInt(g_hSpamCooldown);
	g_iMaxEntrys = GetConVarInt(g_hMaxEntrys);
	
	g_bLowVIPonlyStart = GetConVarBool(g_hLowVIPonlyStart);
	g_bMediumVIPonlyStart = GetConVarBool(g_hMediumVIPonlyStart);
	g_bHighVIPonlyStart = GetConVarBool(g_hHighVIPonlyStart);
	
	g_fHouseMargin = GetConVarFloat(g_hHouseMargin);
}

public void OnMapStart() {
	CreateTimer(1.0, refreshTimer, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action refreshTimer(Handle Timer) {
	if (g_iLowTimeleft > 0)
		g_iLowTimeleft--;
	else if (g_iLowTimeleft == 0)
		endJackpot(1);
	
	if (g_iMediumTimeleft > 0)
		g_iMediumTimeleft--;
	else if (g_iMediumTimeleft == 0)
		endJackpot(2);
	
	if (g_iHighTimeleft > 0)
		g_iHighTimeleft--;
	else if (g_iHighTimeleft == 0)
		endJackpot(3);
	
	if (currSpamTime++ >= g_iSpamCooldown) {
		CPrintToChatAll("%T", "spam", LANG_SERVER, g_cTag);
		currSpamTime = 0;
	}
}


public void onPlayerSpawn(Handle event, const char[] name, bool dontBroadcast) {
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	char playerid[20];
	GetClientAuthId(client, AuthId_Steam2, playerid, sizeof(playerid));
	char findRewardQuery[256];
	Format(findRewardQuery, sizeof(findRewardQuery), "SELECT * FROM jackpot WHERE playerid = '%s';", playerid);
	SQL_TQuery(g_DB, findRewardQueryCallback, findRewardQuery, client);
}

public void findRewardQueryCallback(Handle owner, Handle hndl, const char[] error, any data) {
	int client = data;
	char playerid[20];
	while (SQL_FetchRow(hndl)) {
		int amount = SQL_FetchIntByName(hndl, "amount");
		SQL_FetchStringByName(hndl, "playerid", playerid, sizeof(playerid));
		if (Store_IsClientLoaded(client)) {
			Store_SetClientCredits(client, Store_GetClientCredits(client) + amount);
			CPrintToChat(client, "%t", "reward_offline", g_cTag, amount);
			char findRewardQuery[256];
			Format(findRewardQuery, sizeof(findRewardQuery), "DELETE FROM jackpot WHERE playerid = '%s';", playerid);
			SQL_TQuery(g_DB, SQLErrorCheckCallback, findRewardQuery, client);
		}
	}
}

public void endJackpot(int type) {
	if (type == 1) {
		int winningNumber = GetRandomInt(0, getAllBetCredits(1) - 1);
		int wherearewe = 0;
		for (int i = 0; i < MAX_ENTRYS; i++) {
			if (theLowJackpot[i][jeActive]) {
				if (winningNumber >= wherearewe && winningNumber < wherearewe + theLowJackpot[i][jeAmount]) {
					awardStuff(theLowJackpot[i][jePlayerid], getAllBetCredits(1), 1);
					logEnding(theLowJackpot[i][jePlayerid], theLowJackpot[i][jeAmount], type);
					clearJackpot(1);
					break;
				} else if (!theLowJackpot[i][jeActive]) {
					awardStuff(theLowJackpot[i - 1][jePlayerid], getAllBetCredits(1), 1);
					logEnding(theLowJackpot[i][jePlayerid], theLowJackpot[i][jeAmount], type);
					clearJackpot(1);
				} else {
					wherearewe += theLowJackpot[i][jeAmount];
				}
			}
		}
	} else if (type == 2) {
		int winningNumber = GetRandomInt(0, getAllBetCredits(2) - 1);
		int wherearewe = 0;
		for (int i = 0; i < MAX_ENTRYS; i++) {
			if (theMediumJackpot[i][jeActive]) {
				if (winningNumber >= wherearewe && winningNumber < wherearewe + theMediumJackpot[i][jeAmount]) {
					awardStuff(theMediumJackpot[i][jePlayerid], getAllBetCredits(2), 2);
					logEnding(theMediumJackpot[i][jePlayerid], theMediumJackpot[i][jeAmount], type);
					clearJackpot(2);
					break;
				} else if (!theMediumJackpot[i][jeActive]) {
					awardStuff(theMediumJackpot[i - 1][jePlayerid], getAllBetCredits(2), 2);
					logEnding(theMediumJackpot[i][jePlayerid], theMediumJackpot[i][jeAmount], type);
					clearJackpot(2);
				} else {
					wherearewe += theMediumJackpot[i][jeAmount];
				}
			}
		}
	} else if (type == 3) {
		int winningNumber = GetRandomInt(0, getAllBetCredits(3) - 1);
		int wherearewe = 0;
		for (int i = 0; i < MAX_ENTRYS; i++) {
			if (theHighJackpot[i][jeActive]) {
				if (winningNumber >= wherearewe && winningNumber < wherearewe + theHighJackpot[i][jeAmount]) {
					awardStuff(theHighJackpot[i][jePlayerid], getAllBetCredits(3), 3);
					logEnding(theHighJackpot[i][jePlayerid], theHighJackpot[i][jeAmount], type);
					clearJackpot(3);
					break;
				} else if (!theHighJackpot[i][jeActive]) {
					awardStuff(theHighJackpot[i - 1][jePlayerid], getAllBetCredits(3), 3);
					logEnding(theHighJackpot[i][jePlayerid], theHighJackpot[i][jeAmount], type);
					clearJackpot(3);
				} else {
					wherearewe += theHighJackpot[i][jeAmount];
				}
			}
		}
	}
}

public void logEnding(char[] winnerid2, int amount, int type) {
	char winnerid[20];
	strcopy(winnerid, sizeof(winnerid), winnerid2);
	
	char concat[4096];
	for (int i = 0; i < MAX_ENTRYS; i++) {
		if (type == 1)
			if (theLowJackpot[i][jeActive]) {
			Format(concat, sizeof(concat), "%s[%s;%i] ", concat, theLowJackpot[i][jePlayerid], theLowJackpot[i][jeAmount]);
		}
		if (type == 2)
			if (theMediumJackpot[i][jeActive]) {
			Format(concat, sizeof(concat), "%s[%s;%i] ", concat, theMediumJackpot[i][jePlayerid], theMediumJackpot[i][jeAmount]);
		}
		if (type == 3)
			if (theHighJackpot[i][jeActive]) {
			Format(concat, sizeof(concat), "%s[%s;%i] ", concat, theHighJackpot[i][jePlayerid], theHighJackpot[i][jeAmount]);
		}
	}
	
	char createLogEntryQuery[512];
	Format(createLogEntryQuery, sizeof(createLogEntryQuery), "INSERT INTO `jackpot_log` (`Id`, `timestamp`, `playerid`, `amount`, `concat`) VALUES ('', CURRENT_TIMESTAMP, '%s', '%i', '%s');", winnerid, amount, concat);
	SQL_TQuery(g_DB, SQLErrorCheckCallback, createLogEntryQuery);
}

public void awardStuff(char[] playerid, int amount, int type) {
	float realAmount = float(amount) * g_fHouseMargin;
	amount = RoundToNearest(realAmount);
	
	
	char rPlayerId[20];
	strcopy(rPlayerId, sizeof(rPlayerId), playerid);
	char typeName[16];
	if (type == 1)
		strcopy(typeName, sizeof(typeName), "Low");
	else if (type == 2)
		strcopy(typeName, sizeof(typeName), "Medium");
	else if (type == 3)
		strcopy(typeName, sizeof(typeName), "High");
	
	int client;
	if ((client = findPlayerById(rPlayerId)) != -1) {
		Store_SetClientCredits(client, Store_GetClientCredits(client) + amount);
		char clientName[MAX_NAME_LENGTH + 8];
		GetClientName(client, clientName, sizeof(clientName));
		CPrintToChatAll("%T", "jackpot_won", client, g_cTag, clientName, amount, typeName);
	} else {
		char insertRewardQuery[1024];
		Format(insertRewardQuery, sizeof(insertRewardQuery), "INSERT INTO `jackpot` (`Id`, `timestamp`, `playerid`, `amount`) VALUES (NULL, CURRENT_TIMESTAMP, '%s', '%i');", rPlayerId, amount);
		SQL_TQuery(g_DB, SQLErrorCheckCallback, insertRewardQuery);
		CPrintToChatAll("%T", "jackpot_won", client, g_cTag, rPlayerId, amount, typeName);
	}
}

public int findPlayerById(char playerid[20]) {
	for (int i = 1; i < MAXPLAYERS; i++) {
		if (!isValidClient(i))
			continue;
		char cId[20];
		GetClientAuthId(i, AuthId_Steam2, cId, sizeof(cId));
		if (StrEqual(playerid, cId))
			return i;
	}
	return -1;
}

public Action cmdJackpot(int client, int args) {
	Menu jackpotMenu = CreateMenu(jackpotMenuHandler);
	SetMenuTitle(jackpotMenu, "Jackpot");
	if (g_bLowJackpotActive || g_bMediumJackpotActive || g_bHighJackpotActive) {
		char betCredits[64];
		Format(betCredits, sizeof(betCredits), "%T", "menu_bet_credits", client);
		AddMenuItem(jackpotMenu, "bet", betCredits);
	}
	if (!g_bLowJackpotActive || !g_bMediumJackpotActive || !g_bHighJackpotActive) {
		char startJackpotOption[64];
		Format(startJackpotOption, sizeof(startJackpotOption), "%T", "menu_start_jackpot", client);
		AddMenuItem(jackpotMenu, "start", startJackpotOption);
		
	}
	
	int lowBet = getClientBetCredits(client, 1);
	if (lowBet >= 0 && g_bLowJackpotActive) {
		char display[128];
		int maxBet = getAllBetCredits(1);
		float winchance = (float(lowBet) / float(maxBet)) * 100;
		Format(display, sizeof(display), "Low Jackpot: %i/%i Bet | %.2f%s Chance (%is left)", lowBet, maxBet, winchance, "%", g_iLowTimeleft);
		AddMenuItem(jackpotMenu, "x", display, ITEMDRAW_DISABLED);
	}
	
	lowBet = getClientBetCredits(client, 2);
	if (lowBet >= 0 && g_bMediumJackpotActive) {
		char display[128];
		int maxBet = getAllBetCredits(2);
		float winchance = (float(lowBet) / float(maxBet)) * 100;
		Format(display, sizeof(display), "Medium Jackpot: %i/%i Bet | %.2f%s Chance (%is left)", lowBet, maxBet, winchance, "%", g_iMediumTimeleft);
		AddMenuItem(jackpotMenu, "x", display, ITEMDRAW_DISABLED);
	}
	
	lowBet = getClientBetCredits(client, 3);
	if (lowBet >= 0 && g_bHighJackpotActive) {
		char display[128];
		int maxBet = getAllBetCredits(3);
		float winchance = (float(lowBet) / float(maxBet)) * 100;
		Format(display, sizeof(display), "High Jackpot: %i/%i Bet | %.2f%s Chance (%is left)", lowBet, maxBet, winchance, "%", g_iHighTimeleft);
		AddMenuItem(jackpotMenu, "x", display, ITEMDRAW_DISABLED);
	}
	
	DisplayMenu(jackpotMenu, client, 1);
	return Plugin_Handled;
}

public int jackpotMenuHandler(Handle menu, MenuAction action, int client, int item) {
	char cValue[32];
	GetMenuItem(menu, item, cValue, sizeof(cValue));
	if (action == MenuAction_Select) {
		if (StrEqual(cValue, "bet")) {
			if (g_bLowJackpotActive || g_bMediumJackpotActive || g_bHighJackpotActive) {
				openJackpotChooserToBet(client);
			} else {
				CPrintToChat(client, "%t", "error_jackpot_not_active", g_cTag);
			}
		} else if (StrEqual(cValue, "start")) {
			if (!g_bLowJackpotActive || !g_bMediumJackpotActive || !g_bHighJackpotActive) {
				openJackpotChooserToCreate(client);
			} else {
				CPrintToChat(client, "%t", "error_jackpot_active", g_cTag);
			}
		}
	} else if (action == MenuAction_Cancel) {
		if (item == MenuCancel_Timeout)
			cmdJackpot(client, 0);
	}
}

public void openJackpotChooserToBet(int client) {
	Menu betJackpotMenu = CreateMenu(betJackpotMenuHandler);
	SetMenuTitle(betJackpotMenu, "Bet on a Jackpot");
	if (g_bLowJackpotActive) {
		AddMenuItem(betJackpotMenu, "betlow", "Low Jackpot");
	}
	if (g_bMediumJackpotActive) {
		AddMenuItem(betJackpotMenu, "betmedium", "Medium Jackpot");
	}
	if (g_bHighJackpotActive) {
		AddMenuItem(betJackpotMenu, "bethigh", "High Jackpot");
	}
	
	DisplayMenu(betJackpotMenu, client, 60);
}

public int betJackpotMenuHandler(Handle menu, MenuAction action, int client, int item) {
	char cValue[32];
	GetMenuItem(menu, item, cValue, sizeof(cValue));
	if (action == MenuAction_Select) {
		if (StrEqual(cValue, "betlow")) {
			if (getEntrys(client, 1) < g_iMaxEntrys)
				openBetCreditsToJackpot(client, 1);
			else
				CPrintToChat(client, "%t", "too_many_entrys", g_cTag);
		} else if (StrEqual(cValue, "betmedium")) {
			if (getEntrys(client, 2) < g_iMaxEntrys)
				openBetCreditsToJackpot(client, 2);
			else
				CPrintToChat(client, "%t", "too_many_entrys", g_cTag);
		} else if (StrEqual(cValue, "bethigh")) {
			if (getEntrys(client, 3) < g_iMaxEntrys)
				openBetCreditsToJackpot(client, 3);
			else
				CPrintToChat(client, "%t", "too_many_entrys", g_cTag);
		}
	}
}

public void openBetCreditsToJackpot(int client, int type) {
	if (type == -1)
		return;
	Menu betOnJackpotMenu = CreateMenu(betOnJackpotMenuHandler);
	char menuTitle[64];
	if (type == 1)
		Format(menuTitle, sizeof(menuTitle), "Bet on Low Jackpot with Credits (%is left)", g_iLowTimeleft);
	else if (type == 2)
		Format(menuTitle, sizeof(menuTitle), "Bet on Medium Jackpot with Credits (%is left)", g_iMediumTimeleft);
	else if (type == 3)
		Format(menuTitle, sizeof(menuTitle), "Bet on High Jackpot with Credits (%is left)", g_iHighTimeleft);
	SetMenuTitle(betOnJackpotMenu, menuTitle);
	
	int min;
	int max;
	if (type == 1) {
		min = g_iLowMinJackpotThreshold;
		max = g_iLowMaxJackpotThreshold;
	} else if (type == 2) {
		min = g_iMediumMinJackpotThreshold;
		max = g_iMediumMaxJackpotThreshold;
	} else if (type == 3) {
		min = g_iHighMinJackpotThreshold;
		max = g_iHighMaxJackpotThreshold;
	}
	
	if (min >= Store_GetClientCredits(client)) {
		CPrintToChat(client, "%t", "not_enough_credits", g_cTag);
		return;
	}
	
	if (max >= Store_GetClientCredits(client)) {
		max = Store_GetClientCredits(client);
	}
	
	int tempMoney = min;
	int increaseBy = max / 20;
	int step = 0;
	int reduce = 0;
	while (tempMoney <= max) {
		char cTempMoney[128];
		IntToString(tempMoney, cTempMoney, sizeof(cTempMoney));
		AddMenuItem(betOnJackpotMenu, cTempMoney, cTempMoney);
		if (++step < (5 - reduce))
			tempMoney += increaseBy;
		else {
			increaseBy *= 5;
			step = 0;
			tempMoney += increaseBy;
			reduce = 1;
		}
	}
	g_iClientChoice[client] = type;
	DisplayMenu(betOnJackpotMenu, client, 60);
}

public int betOnJackpotMenuHandler(Handle menu, MenuAction action, int client, int item) {
	if (action == MenuAction_Select) {
		char cValue[32];
		GetMenuItem(menu, item, cValue, sizeof(cValue));
		int iValue = StringToInt(cValue);
		int type = g_iClientChoice[client];
		if(type == 1 && !g_bLowJackpotActive){
			CPrintToChat(client, "%t", "jackpot_no_longer_active", g_cTag);
			return;
		}else if(type == 2 && !g_bMediumJackpotActive){
			CPrintToChat(client, "%t", "jackpot_no_longer_active", g_cTag);
			return;
		}else if(type == 3 && !g_bHighJackpotActive){
			CPrintToChat(client, "%t", "jackpot_no_longer_active", g_cTag);
			return;
		}
		
		if (Store_GetClientCredits(client) >= iValue) {
			Store_SetClientCredits(client, Store_GetClientCredits(client) - iValue);
			betOnJackpot(client, iValue, g_iClientChoice[client]);
			cmdJackpot(client, 0);
		} else {
			CPrintToChat(client, "%t", "not_enough_credits", g_cTag);
		}
	}
}

public void betOnJackpot(int client, int amount, int type) {
	char playerid[20];
	GetClientAuthId(client, AuthId_Steam2, playerid, sizeof(playerid));
	if (type == 1) {
		if (g_bLowJackpotActive) {
			addEntry(playerid, amount, type);
		}
	} else if (type == 2) {
		if (g_bMediumJackpotActive) {
			addEntry(playerid, amount, type);
		}
	} else if (type == 3) {
		if (g_bHighJackpotActive) {
			addEntry(playerid, amount, type);
		}
	}
}

public void openJackpotChooserToCreate(int client) {
	g_iClientAction[client] = -1;
	Menu createJackpotMenu = CreateMenu(createJackpotMenuHandler);
	SetMenuTitle(createJackpotMenu, "Create a Jackpot");
	if (!g_bLowJackpotActive && (!g_bLowVIPonlyStart || CheckCommandAccess(client, "sm_pedo", ADMFLAG_CUSTOM6, true))) {
		AddMenuItem(createJackpotMenu, "low", "Start Low Jackpot");
	}else if(g_bLowJackpotActive){
		AddMenuItem(createJackpotMenu, "x", "Start Low Jackpot (Active)", ITEMDRAW_DISABLED);
	}else{
		AddMenuItem(createJackpotMenu, "x", "Start Low Jackpot (VIP Only)", ITEMDRAW_DISABLED);
	}
	if (!g_bMediumJackpotActive && (!g_bMediumVIPonlyStart || CheckCommandAccess(client, "sm_pedo", ADMFLAG_CUSTOM6, true))) {
		AddMenuItem(createJackpotMenu, "medium", "Start Medium Jackpot");
	}else if(g_bMediumJackpotActive){
		AddMenuItem(createJackpotMenu, "x", "Start Medium Jackpot (Active)", ITEMDRAW_DISABLED);
	}else{
		AddMenuItem(createJackpotMenu, "x", "Start Medium Jackpot (VIP Only)", ITEMDRAW_DISABLED);
	}
	if (!g_bHighJackpotActive && (!g_bHighVIPonlyStart || CheckCommandAccess(client, "sm_pedo", ADMFLAG_CUSTOM6, true))) {
		AddMenuItem(createJackpotMenu, "high", "Start High Jackpot");
	}else if(g_bHighJackpotActive){
		AddMenuItem(createJackpotMenu, "x", "Start High Jackpot (Active)", ITEMDRAW_DISABLED);
	}else{
		AddMenuItem(createJackpotMenu, "x", "Start High Jackpot (VIP Only)", ITEMDRAW_DISABLED);
	}
	
	DisplayMenu(createJackpotMenu, client, 60);
}

public int createJackpotMenuHandler(Handle menu, MenuAction action, int client, int item) {
	char cValue[32];
	GetMenuItem(menu, item, cValue, sizeof(cValue));
	if (action == MenuAction_Select) {
		if (StrEqual(cValue, "low")) {
			g_iClientAction[client] = 1;
			openBetCreditsToStartJackpot(client);
		} else if (StrEqual(cValue, "medium")) {
			g_iClientAction[client] = 2;
			openBetCreditsToStartJackpot(client);
		} else if (StrEqual(cValue, "high")) {
			g_iClientAction[client] = 3;
			openBetCreditsToStartJackpot(client);
		}
	}
}

public void openBetCreditsToStartJackpot(int client) {
	if (g_iClientAction[client] == -1)
		return;
	Menu createJackpotMenuCredits = CreateMenu(createJackpotMenuCreditsHandler);
	char menuTitle[64];
	if (g_iClientAction[client] == 1)
		Format(menuTitle, sizeof(menuTitle), "Create Low Jackpot with Credits");
	else if (g_iClientAction[client] == 2)
		Format(menuTitle, sizeof(menuTitle), "Create Medium Jackpot with Credits");
	else if (g_iClientAction[client] == 3)
		Format(menuTitle, sizeof(menuTitle), "Create High Jackpot with Credits");
	SetMenuTitle(createJackpotMenuCredits, menuTitle);
	
	int min;
	int max;
	if (g_iClientAction[client] == 1) {
		min = g_iLowMinJackpotThreshold;
		max = g_iLowMaxJackpotThreshold;
	} else if (g_iClientAction[client] == 2) {
		min = g_iMediumMinJackpotThreshold;
		max = g_iMediumMaxJackpotThreshold;
	} else if (g_iClientAction[client] == 3) {
		min = g_iHighMinJackpotThreshold;
		max = g_iHighMaxJackpotThreshold;
	}
	
	if (min >= Store_GetClientCredits(client)) {
		CPrintToChat(client, "%t", "not_enough_credits", g_cTag);
		return;
	}
	
	if (max >= Store_GetClientCredits(client)) {
		max = Store_GetClientCredits(client);
	}
	
	int tempMoney = min;
	int increaseBy = max / 20;
	int step = 0;
	int reduce = 0;
	while (tempMoney <= max) {
		char cTempMoney[128];
		IntToString(tempMoney, cTempMoney, sizeof(cTempMoney));
		AddMenuItem(createJackpotMenuCredits, cTempMoney, cTempMoney);
		if (++step < (5 - reduce))
			tempMoney += increaseBy;
		else {
			increaseBy *= 5;
			step = 0;
			tempMoney += increaseBy;
			reduce = 1;
		}
	}
	char cTempMoney[128];
	IntToString(max, cTempMoney, sizeof(cTempMoney));
	AddMenuItem(createJackpotMenuCredits, cTempMoney, cTempMoney);
	DisplayMenu(createJackpotMenuCredits, client, 60);
}

public int createJackpotMenuCreditsHandler(Handle menu, MenuAction action, int client, int item) {
	if (action == MenuAction_Select) {
		char cValue[32];
		GetMenuItem(menu, item, cValue, sizeof(cValue));
		int iValue = StringToInt(cValue);
		
		int type = g_iClientAction[client];
		if(type == 1 && g_bLowJackpotActive){
			CPrintToChat(client, "%t", "error_jackpot_active_single", g_cTag);
			return;
		}else if(type == 2 && g_bMediumJackpotActive){
			CPrintToChat(client, "%t", "error_jackpot_active_single", g_cTag);
			return;
		}else if(type == 3 && g_bHighJackpotActive){
			CPrintToChat(client, "%t", "error_jackpot_active_single", g_cTag);
			return;
		}
		
		if (Store_GetClientCredits(client) >= iValue) {
			Store_SetClientCredits(client, Store_GetClientCredits(client) - iValue);
			createJackpot(client, iValue, g_iClientAction[client]);
			cmdJackpot(client, 0);
		} else {
			CPrintToChat(client, "%t", "not_enough_credits", g_cTag);
		}
	}
}

public void createJackpot(int client, int amount, int type) {
	char playerid[20];
	GetClientAuthId(client, AuthId_Steam2, playerid, sizeof(playerid));
	if (type == 1) {
		if (!g_bLowJackpotActive) {
			g_bLowJackpotActive = true;
			g_iLowTimeleft = g_iLowJackpotTime;
			theLowJackpot[0][jeActive] = true;
			strcopy(theLowJackpot[0][jePlayerid], 20, playerid);
			theLowJackpot[0][jeAmount] = amount;
			char clientName[MAX_NAME_LENGTH + 8];
			GetClientName(client, clientName, sizeof(clientName));
			CPrintToChatAll("%T", "jackpot_started", client, g_cTag, clientName, "Low");
		} else {
			CPrintToChat(client, "%t", "error_jackpot_active_single", g_cTag);
		}
	} else if (type == 2) {
		if (!g_bMediumJackpotActive) {
			g_bMediumJackpotActive = true;
			g_iMediumTimeleft = g_iMediumJackpotTime;
			theMediumJackpot[0][jeActive] = true;
			strcopy(theMediumJackpot[0][jePlayerid], 20, playerid);
			theMediumJackpot[0][jeAmount] = amount;
			char clientName[MAX_NAME_LENGTH + 8];
			GetClientName(client, clientName, sizeof(clientName));
			CPrintToChatAll("%T", "jackpot_started", client, g_cTag, clientName, "Medium");
		} else {
			CPrintToChat(client, "%t", "error_jackpot_active_single", g_cTag);
		}
	} else if (type == 3) {
		if (!g_bHighJackpotActive) {
			g_bHighJackpotActive = true;
			g_iHighTimeleft = g_iHighJackpotTime;
			theHighJackpot[0][jeActive] = true;
			strcopy(theHighJackpot[0][jePlayerid], 20, playerid);
			theHighJackpot[0][jeAmount] = amount;
			char clientName[MAX_NAME_LENGTH + 8];
			GetClientName(client, clientName, sizeof(clientName));
			CPrintToChatAll("%T", "jackpot_started", client, g_cTag, clientName, "High");
		} else {
			CPrintToChat(client, "%t", "error_jackpot_active_single", g_cTag);
		}
	}
}

public int getClientBetCredits(int client, int type) {
	char playerid[20];
	GetClientAuthId(client, AuthId_Steam2, playerid, sizeof(playerid));
	int amount = 0;
	if (type == 1)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (StrEqual(playerid, theLowJackpot[i][jePlayerid]) && theLowJackpot[i][jeActive])
		amount += theLowJackpot[i][jeAmount];
	
	if (type == 2)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (StrEqual(playerid, theMediumJackpot[i][jePlayerid]) && theMediumJackpot[i][jeActive])
		amount += theMediumJackpot[i][jeAmount];
	
	if (type == 3)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (StrEqual(playerid, theHighJackpot[i][jePlayerid]) && theHighJackpot[i][jeActive])
		amount += theHighJackpot[i][jeAmount];
	
	return amount;
}

public int getAllBetCredits(int type) {
	int amount = 0;
	if (type == 1)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (theLowJackpot[i][jeActive])
		amount += theLowJackpot[i][jeAmount];
	
	if (type == 2)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (theMediumJackpot[i][jeActive])
		amount += theMediumJackpot[i][jeAmount];
	
	if (type == 3)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (theHighJackpot[i][jeActive])
		amount += theHighJackpot[i][jeAmount];
	
	return amount;
}

public void clearJackpot(int type) {
	if (type == 1) {
		g_bLowJackpotActive = false;
		for (int i = 0; i < MAX_ENTRYS; i++) {
			theLowJackpot[i][jeActive] = false;
			strcopy(theLowJackpot[i][jePlayerid], 20, "");
			theLowJackpot[i][jeAmount] = -1;
		}
	} else if (type == 2) {
		g_bMediumJackpotActive = false;
		for (int i = 0; i < MAX_ENTRYS; i++) {
			theMediumJackpot[i][jeActive] = false;
			strcopy(theMediumJackpot[i][jePlayerid], 20, "");
			theMediumJackpot[i][jeAmount] = -1;
		}
	} else if (type == 3) {
		g_bHighJackpotActive = false;
		for (int i = 0; i < MAX_ENTRYS; i++) {
			theHighJackpot[i][jeActive] = false;
			strcopy(theHighJackpot[i][jePlayerid], 20, "");
			theHighJackpot[i][jeAmount] = -1;
		}
	}
}

public void addEntry(char playerid[20], int amount, int type) {
	if (type == 1) {
		for (int i = 0; i < MAX_ENTRYS; i++) {
			if (!theLowJackpot[i][jeActive]) {
				theLowJackpot[i][jeActive] = true;
				strcopy(theLowJackpot[i][jePlayerid], 20, playerid);
				theLowJackpot[i][jeAmount] = amount;
				break;
			}
		}
	} else if (type == 2) {
		for (int i = 0; i < MAX_ENTRYS; i++) {
			if (!theMediumJackpot[i][jeActive]) {
				theMediumJackpot[i][jeActive] = true;
				strcopy(theMediumJackpot[i][jePlayerid], 20, playerid);
				theMediumJackpot[i][jeAmount] = amount;
				break;
			}
		}
	} else if (type == 3) {
		for (int i = 0; i < MAX_ENTRYS; i++) {
			if (!theHighJackpot[i][jeActive]) {
				theHighJackpot[i][jeActive] = true;
				strcopy(theHighJackpot[i][jePlayerid], 20, playerid);
				theHighJackpot[i][jeAmount] = amount;
				break;
			}
		}
	}
}

public int getEntrys(int client, int type) {
	char playerid[20];
	GetClientAuthId(client, AuthId_Steam2, playerid, sizeof(playerid));
	int amount = 0;
	if (type == 1)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (StrEqual(playerid, theLowJackpot[i][jePlayerid]) && theLowJackpot[i][jeActive])
		amount++;
	
	if (type == 2)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (StrEqual(playerid, theMediumJackpot[i][jePlayerid]) && theMediumJackpot[i][jeActive])
		amount++;
	
	if (type == 3)
		for (int i = 0; i < MAX_ENTRYS; i++)
	if (StrEqual(playerid, theHighJackpot[i][jePlayerid]) && theHighJackpot[i][jeActive])
		amount++;
	
	return amount;
}

public bool isValidClient(int client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
}

public void SQLErrorCheckCallback(Handle owner, Handle hndl, const char[] error, any data) {
	if (!StrEqual(error, ""))
		LogError(error);
} 