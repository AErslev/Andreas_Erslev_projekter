#if defined _vikingcms_included
	#endinput
#endif
#define _vikingcms_included

enum EAPIMethod
{
	GET,
	POST,
	DELETE,
}

native bool:VikingCMS_QueryAPI(const String:interface[], const EAPIMethod:method, &Handle:params, Function:callback, any:data=0);

public SharedPlugin:__pl_vikingcms = {

	name = "vikingcms",
	file = "vikingcms.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};