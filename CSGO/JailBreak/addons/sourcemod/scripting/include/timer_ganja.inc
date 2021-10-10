#if defined _timer_ganja_included
 #endinput
#endif
#define _timer_ganja_included

#define MAX_ENTITIES 2048
#define MAX_TAG_SIZE 32
#define MAX_ZONES 64

// MANAGER
forward Manager_OnClientInZone(client, id, String:zone[], String:tag[]);

native Manager_GetClientZone(client, String:zone[], maxsize1, String:tag[], maxsize2);
native Manager_GetZoneTag(String:zone[], String:tag[], maxsize);
native Manager_GetEntityByTag(start, String:tag[]);
native Manager_GetEntityTag(ent, String:tag[],  maxsize);
native Manager_GetNumOfZones(String:type[]="");

// DATABASE
forward Database_OnConnected(Handle:database, bool:mysql);

native Handle:Database_GetHandle();
native bool:Database_IsMySQL();

// ACHIEVEMENTS
native Achievements_Update(client);
native Achievements_Display(client, String:steamid[], bool:exitback);

// RANK
forward Rank_OnStatsLoaded(client);

native Rank_GivePlayerPoints(client, amount);
native Rank_GetClientID(client);
native Rank_GetPlayerKills(client);
native Rank_GetPlayerDeaths(client);
native Rank_GetPlayerZombieKills(client);
native Rank_GetPlayerHumanKills(client);
native Rank_GetPlayerEscapes(client);
native Rank_Display(client, String:steamid[], chat, panel);

// CHAT MANAGER
native Chat_SetClientTag(client, slot, String:tag[]);
native Chat_SetClientMsgColor(client, String:color[]);