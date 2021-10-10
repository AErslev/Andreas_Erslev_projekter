#if defined _voicehook2_included
	#endinput
#endif
#define _voicehook2_included

forward VoiceHook2_OnBroadcastVoice(client, const String:data[], bytes);

public Extension:__ext_voicehook2 = 
{
	name = "VoiceHook2",
	file = "voicehook2.ext",
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