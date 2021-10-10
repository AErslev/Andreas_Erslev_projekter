#if defined _bansystem_included
	#endinput
#endif
#define _bansystem_included

#define MAX_BAN_HANDLERS 64
#define CHAT_TAG "[Bans] "

#define PLAYER_BANNED_PERMANENTLY 0
#define PLAYER_BANNED_FROM_SESSION -1
#define PLAYER_NOT_BANNED -2

enum AuthType
{
	k_Unknown,
	k_SteamID,
	k_Name,
	k_IP,
}

native Bans_RegisterHandler(String:id[], bool:sessionbans, Function:enforceban=INVALID_FUNCTION, Function:removeban=INVALID_FUNCTION, Function:renderreasons=INVALID_FUNCTION, Function:renderdata=INVALID_FUNCTION);
native Bans_GetPlayerBan(client, String:handler[], String:reason[], maxlen1, String:data[], maxlen2);

public SharedPlugin:__pl_nerocms_bans = {

	name = "bansystem.base",
	file = "bansystem.base.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};