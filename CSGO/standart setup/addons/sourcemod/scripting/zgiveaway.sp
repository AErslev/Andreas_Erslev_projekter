#include <sourcemod>
#include <colorvariables>
#include <sdktools>
#include <store>
#include <zephstocks>


ConVar sm_flag = null;
ConVar sm_giveaway_credits = null;
ConVar sm_minplayers = null;
ConVar sm_chattag = null;

char zflag[32];

public Plugin:myinfo = {
	name = "zGiveaway",
	author = "Black Flash",
	description = "Giveaway plugin compatible with zephyrus store.",
	version = "2.0",
	url = "www.terra2.forumeiros.com"
}

public OnPluginStart()
{
	sm_flag = CreateConVar("sm_flag", "ADMFLAG_ROOT", "Flag required to use guiveaway command");
	GetConVarString(sm_flag, zflag, sizeof(zflag));
	
	sm_giveaway_credits = CreateConVar("sm_giveaway_credits", "5000", "Number of credits given.");
	sm_minplayers = CreateConVar("sm_minplayers", "5", "Minimum players required in the server for the giveaway to happen.");
	sm_chattag = CreateConVar("sm_chattag", "[SM]", "Chat Tag that appears in front of everything this plugin says.");
	RegAdminCmd("sm_giveaway", CommandGiveaway, sm_flag, "Start giveaway");
	AutoExecConfig(true, "plugin.zsorteio");
	LoadTranslations("zgiveaway.phrases");
}

public Action:CommandGiveaway(client, args)
{
	int minplayers = GetConVarInt(sm_minplayers);
	int creditsgiven = GetConVarInt(sm_giveaway_credits);
	int maxlen = 32;
	new String:firsttag[32];
	GetConVarString(sm_chattag, firsttag, maxlen);
	
	if( GetClientCount() > minplayers )
	{
		int random = GetRandomInt(1, GetClientCount());
		if (IsClientInGame(random))
		{
			new String:sday[10]; 
			new String:smonth[10]; 
			new String:syear[10]; 
			FormatTime(sday, sizeof(sday), "%d");
			FormatTime(smonth, sizeof(smonth), "%m");
			FormatTime(syear, sizeof(syear), "%Y");
			new day = StringToInt(sday); 
			new month = StringToInt(smonth); 
			new year = StringToInt(syear);
			
			CPrintToChatAll("%t","GiveAway Result", firsttag, random, creditsgiven);
			CPrintToChat(random, "%t","Client GiveAway Result", creditsgiven);
			Store_SetClientCredits(random, Store_GetClientCredits(random)+creditsgiven);
			char authid[50];
			char cname[50];
			GetClientAuthId(client, AuthId_Steam2, authid, sizeof(authid));
			GetClientName(client, cname, sizeof(cname));
			LogToFile("addons/sourcemod/logs/zgiveaway/zgiveawayfile.log", "The admin %s (%s) did a giveaway in %i/%i/%i", cname, authid, day, month, year);
		}  
		return Plugin_Handled;
	} else 
	{
		CPrintToChat(client, "%t", "Minimum Players", firsttag, minplayers);
	}
	return Plugin_Handled;
}