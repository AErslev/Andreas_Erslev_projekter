#if defined _fakebots_included
	#endinput
#endif
#define _fakebots_included

forward OnFakeClientStatus(client, String:steamid[], maxlen, &ping, &connected);
forward OnStrangeKill(client);

public Extension:__ext_fakebots = 
{
	name = "fakebots",
	file = "fakebots.ext",
#if defined AUTOLOAD_EXTENSIONS
	autoload = 1,
#else
	autoload = 0,
#endif
#if defined REQUIRE_EXTENSIONS
	required = 1,
#else
	required = 0,
#endif
};