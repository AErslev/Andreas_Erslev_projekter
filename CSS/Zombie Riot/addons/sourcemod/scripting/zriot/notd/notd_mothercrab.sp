/**
 * ====================
 *     Zombie Riot
 *   File: mothercrab.inc
 *   Author: [NotD] l0calh0st
 *   www.notdelite.com
 * ====================
 */

#include <sourcemod>
#include <sdktools>

new Handle:repeatTimer;
new Handle:spawnHeadcrabTimer;

new maxPlayers;
#define MOTHERCRABMODEL "models/player/slow/mothercrab/slow_mothercrab.mdl"

public OnPluginStart()
{
	repeatTimer = CreateTimer(0.1, DotInfo, _, TIMER_REPEAT);
	maxPlayers = GetMaxClients();
}

public OnMapStart()
{
	PrecacheSound("npc/zombie/zombie_alert1.wav", true);
	PrecacheSound("npc/ichthyosaur/snap.wav", true);
}

public OnPluginEnd()
{
	if (repeatTimer != INVALID_HANDLE) 
		KillTimer(repeatTimer);
	repeatTimer = INVALID_HANDLE;
}

public Action:DotInfo(Handle:timer)
{	
	new String:model[75];
	for (new client = 1; client < maxPlayers; client++)
	{
		if (!IsValidEdict(client))
			continue; 
	
		if (IsFakeClient(client) && IsClientInGame(client))
		{
			
			GetClientModel(client, model, sizeof(model))
			if (StrEqual(model, MOTHERCRABMODEL))
			{
				new target;
				target = GetClientAimTarget(client, true);
				
				new Float:clientVec[3];
				new Float:targetVec[3];
				GetClientAbsOrigin(client, clientVec);
				GetClientAbsOrigin(target, targetVec);
				if (GetVectorDistance(clientVec, targetVec) < 100)
				{
					if (GetEntPropFloat(target, Prop_Data, "m_flLaggedMovementValue") != 0.5)
					{
						SetEntPropFloat(target, Prop_Data, "m_flLaggedMovementValue", 0.5);
						SetEntityRenderColor(target, 150, 255, 150, 255);
						CreateTimer(4.0, RemovePoison, target);
					}
				}
			}
		}
	}
}

public Action:RemovePoison(Handle:timer, any:target)
{
	SetEntPropFloat(target, Prop_Data, "m_flLaggedMovementValue", 1.0);
	SetEntityRenderColor(target, 255, 255, 255, 255);
}