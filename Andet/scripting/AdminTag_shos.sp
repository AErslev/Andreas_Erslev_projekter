#include <sourcemod>
#include <cstrike>

public OnPluginStart()
{
	HookEvent("player_team", Event, EventHookMode:1);
	HookEvent("player_spawn", Event, EventHookMode:1);
	return 0;
}

public Action:Event(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	HandleTag(client);
	return Action:0;
}

public OnClientPostAdminCheck(client)
{
	HandleTag(client);
	return 0;
}

HandleTag(client)
{
	if (0 < client)
	{
		if (GetUserFlagBits(client) & 16384)
		{
			CS_SetClientClanTag(client, "[Owner]");
		}
		else
		{
			if (GetUserFlagBits(client) & 32768)
			{
				CS_SetClientClanTag(client, "[VIP");
			}
			if (GetUserFlagBits(client) & 65536)
			{
				CS_SetClientClanTag(client, "[Admin]");
			}
			if (GetUserFlagBits(client) & 131072)
			{
				CS_SetClientClanTag(client, "[Admin-VIP]");
			}
			if (GetUserFlagBits(client) & 262144)
			{
				CS_SetClientClanTag(client, "[Super-Admin]");
			}
			if (GetUserFlagBits(client) & 524288)
			{
				CS_SetClientClanTag(client, "[Head-Admin]");
			}
			CS_SetClientClanTag(client, "");
		}
	}
}

