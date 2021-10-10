#if defined _store_included
	#endinput
#endif
#define _store_included

#define CHAT_TAG "[ElitePowered] "

#define ABILITY_NAME_LENGTH 64
#define ELITE_MAX_MENU_ITEMS 1024
#define ELITE_MAX_HANDLERS 32
#define ELITE_MAX_LEVELS 128

native Elite_RegisterHandler(String:type[], Function:reset, Function:config, Function:level, Function:use, Function:remove);
native Elite_SetDataIndex(itemid, index);
native Elite_GetDataIndex(itemid);
native Elite_GetClientSkillLevel(client, const String:skill[]);
native Elite_GetClientSkillLevelId(client, id);
native Elite_GetClientLevel(client);
native Elite_GainXP(client, exp);