#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <store>
#include <zephstocks>

new g_cvarMin = -1;
new g_cvarMax = -1;

public Plugin:myinfo = {
	name = "Store Credit Raffles",
	author = "Zephyrus",
	description = "Store Credit Raffles",
	version = "1.0",
	url = ""
}

public OnPluginStart() {
	RegAdminCmd("sm_raffle", Generate_Raffle, ADMFLAG_CHAT, "Generates a random number for a raffle.");

	g_cvarMin = RegisterConVar("sm_store_raffle_min_credits", "10", "Minimum amount of credits", TYPE_INT);
	g_cvarMax = RegisterConVar("sm_store_raffle_max_credits", "20", "Maximum amount of credits", TYPE_INT);
}

public Action:Generate_Raffle(client, args)
{
	new target = -1;
	new targets[MAXPLAYERS] = {0,...};
	new itargets = 0;
	for(new i=1;i<MaxClients;++i)
	{
		if(IsClientInGame(i))
		{
			targets[itargets++]=i;
		}
	}

	new winner = targets[GetRandomInt(0,itargets-1)];
	new credits = GetRandomInt(g_eCvars[g_cvarMin][aCache], g_eCvars[g_cvarMax][aCache]);

	PrintCenterTextAll("%N won %d credits in the raffle", winner, credits);

	Store_SetClientCredits(winner, Store_GetClientCredits(winner)+credits);

	return Plugin_Handled;
}