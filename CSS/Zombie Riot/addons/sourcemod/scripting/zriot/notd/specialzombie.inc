/**
 * ====================
 *     Zombie Riot
 *   File: specialzombie.inc
 *   Author: [NotD] l0calh0st
 *   www.notdelite.com
 * ====================
 */
new Handle:repeatTimer;
new Handle:smokerSpawnTimer;
new maxPlayers; 

new Handle:hNOTDGameConf = INVALID_HANDLE;
new Handle:hGetEyePosition = INVALID_HANDLE;
new colorSmoker[4];
new colorIfrat[4];
new Float:fireballVec[3];
new g_Sprite;
new mothercrabIndex = -1;
new slimerIndex = 0;
new Float:slimerTargetVec[3];
new g_ExplosionSprite;
new g_FlameHalo;
new g_SmokeModel;

#define SMOKERMODEL "models/player/slow/bloodsucker_pack/slow_chernobyl.mdl"
#define GIGANTEMODEL "models/player/slow/el_g_fix2/slow_gigante.mdl"
#define MOTHERCRABMODEL "models/player/slow/mothercrab/slow_mothercrab.mdl"
#define IFRATMODEL "models/player/techknow/ferno/ferno.mdl"
#define CRABMODEL "models/player/slow/babycrab_v2/slow_babycrab.mdl"
#define SLIMERMODEL "models/player/slow/slimer/slow.mdl"

public Action:SpecialZombie(Handle:timer)
{		
	if (maxPlayers == 0)
		maxPlayers = GetMaxClients();
		
	new String:model[75];
	for (new client = 1; client < maxPlayers; client++)
	{
	
		if (!IsValidEdict(client))
			continue; 
	
		if (IsFakeClient(client) && IsClientInGame(client))
		{
			
			GetClientModel(client, model, sizeof(model));
			if (StrEqual(model, SMOKERMODEL))
			{
				new target;
				target = GetClientAimTarget(client, true);

				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
				//Send player info!
				if (target > 0 && GetClientTeam(target) != 2)
				{
					new Float:clientVec[3];
					new Float:targetVec[3];
					GetClientAbsOrigin(client, clientVec);
					GetClientAbsOrigin(target, targetVec);
					
					if (GetVectorDistance(clientVec, targetVec) < 1000)
					{
						clientVec[2] += 10;
						targetVec[2] += 10;
						new Float:clientEyeVec[3];
						new Float:targetWepVec[3];
						SDKCall(hGetEyePosition, client, clientEyeVec);
						SDKCall(hGetEyePosition, target, targetWepVec);
						TE_SetupBeamPoints(clientEyeVec, targetWepVec, g_Sprite, 0, 0, 0, 0.5, 3.0, 3.0, 10, 0.0, colorSmoker, 0);
						TE_SendToAll();
						
						new Float:eyeVec[3];
						new Float:speedVec[3];
						GetClientEyeAngles(client, eyeVec);
						GetAngleVectors(eyeVec, speedVec, NULL_VECTOR, NULL_VECTOR);
						speedVec[0]*=-500; 
						speedVec[1]*=-500; 
						speedVec[2] = -250.0;
						SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 0.2);
						TeleportEntity(target, NULL_VECTOR, NULL_VECTOR, speedVec);
					}
				}
				continue;
			}
			else if (StrEqual(model, MOTHERCRABMODEL))
			{
				new target;
				target = GetClientAimTarget(client, true);
				
				if (target > 0)
				{
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
				if (GetRandomInt(1, 100) == 75)
				{
					
				}
			}
			else if (StrEqual(model, GIGANTEMODEL))
			{
				new target;
				target = GetClientAimTarget(client, true);
				
				new Float:clientVec[3];
				new Float:targetVec[3];
				
				if (target > 0)
				{
					GetClientAbsOrigin(client, clientVec);
					GetClientAbsOrigin(target, targetVec);
					if (GetVectorDistance(clientVec, targetVec) < 100)
					{
						new Float:eyeAngles[3];
						new Float:push[3];
						GetClientEyeAngles(client, eyeAngles);
						push[0] = (2500.0 * Cosine(DegToRad(eyeAngles[1])));
						push[1] = (2500.0 * Sine(DegToRad(eyeAngles[1])));
						push[2] = 1500.0;
						TeleportEntity(target, NULL_VECTOR, NULL_VECTOR, push);
						EmitSoundToAll("npc/zombie/zombie_alert1.wav", client);
						ScreenShake(target);
						
						new targetHealth = (GetClientHealth(target) - 10);
						
						if ((targetHealth) <= 0)
							 ForcePlayerSuicide(target);
						else
							SetEntityHealth(target, targetHealth);
					}
				}
				if (GetClientHealth(client) < 10000)
				{
					SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.5);
				}
				
				new randomNum;
				randomNum = GetRandomInt(1, 150);
				if (randomNum == 75)
				{
					for (new x = 1; x < maxPlayers; x++)
					{
						if (!IsValidEdict(x))
							continue;
						
						if (GetClientTeam(x) == 3)
						{
							new Float:push[3];
							push[0] = GetRandomFloat(-300.0, 300.0);
							push[1] = GetRandomFloat(-300.0, 300.0);
							push[2] = GetRandomFloat(100.0, 350.0);
							TeleportEntity(x, NULL_VECTOR, NULL_VECTOR, push);
							ScreenShake(x);
						}
					}
					EmitSoundToAll("player/pl_fallpain3.wav", client);
				}
			}
			else if (StrEqual(model, IFRATMODEL))
			{
				new target;
				new Float:clientVec[3];
				GetClientAbsOrigin(client, clientVec);
				target = GetClientAimTarget(client, true);
				
				if (target > 0)
				{
					new Float:targetVec[3];
					GetClientAbsOrigin(target, targetVec);
					if (GetVectorDistance(clientVec, targetVec) < 100)
					{
						IgniteEntity(target, 1.0, false);
					}
					if (GetRandomInt(1, 100) == 25)
					{
						new Float:clientEyeVec[3];
						SDKCall(hGetEyePosition, client, clientEyeVec);
						GetClientAbsOrigin(target, targetVec);
						EmitSoundToAll("npc/ichthyosaur/attack_growl3.wav", client);
						TE_SetupBeamPoints(clientEyeVec, targetVec, g_Sprite, 0, 0, 0, 4.0, 3.0, 3.0, 10, 2.0, colorIfrat, 0);
						TE_SendToAll();
						TE_SetupBeamRingPoint(targetVec, 100.0, 200.0, g_Sprite, g_FlameHalo, 1, 1, 3.0, 3.5, 5.0, colorIfrat, 0, FBEAM_SOLID);
						
						SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 0.0);
						fireballVec[0] = targetVec[0];
						fireballVec[1] = targetVec[1];
						fireballVec[2] = targetVec[2];
						CreateTimer(3.0, FireballExplosion, client);
					}
				}
			}
			else if (StrEqual(model, SLIMERMODEL))
			{
				slimerIndex = client;
				new randomNum = GetRandomInt(1, 100);
				if (randomNum == 63)
				{
					SetEntityRenderMode(client, RENDER_TRANSCOLOR);
					SetEntityRenderColor(client, 0, 0, 0, 0);
					CreateTimer(GetRandomFloat(2.0, 6.0), ResetVisibility, client);
					EmitSoundToAll("npc/zombie_poison/pz_breathe_loop1.wav", client);
				}
				else if (randomNum == 50)
				{
					new target = GetClientAimTarget(client, true);
					if (target > 0)
					{
						EmitSoundToAll("npc/strider/charging.wav", client);
						SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 0.0);
						GetClientAbsOrigin(target, slimerTargetVec);
						CreateTimer(1.0, DelayedSlimerTeleport);
					}
				}
			}
			else if (StrEqual(model, CRABMODEL))
			{
				if (mothercrabIndex != -1 && gDay == 17)
				{
					new Float:crabVec[3];
					new Float:mothercrabVec[3];
					if (IsClientInGame(mothercrabIndex))
					{
						GetClientAbsOrigin(client, crabVec);
						GetClientAbsOrigin(mothercrabIndex, mothercrabVec);
						if (GetVectorDistance(crabVec, mothercrabVec) > 1500)
						{
							new Float:speedVec[3];
							speedVec[0] = (GetRandomFloat(-700.0, 700.0)); 
							speedVec[1] = (GetRandomFloat(-700.0, 700.0)); 
							speedVec[2] = (GetRandomFloat(500.0, 1300.0));
							TeleportEntity(client, mothercrabVec, NULL_VECTOR, speedVec);
						}
					}
					else
						CreateTimer(1.0, SpawnMothercrab);
				}
			}
		}
	}
}

public Action:ResetVisibility(Handle:timer, any:client)
{
	SetEntityRenderColor(client, 255, 255, 255, 255);
}

public Action:DelayedSlimerTeleport(Handle:timer)
{
	new Float:slimerVec[3];
	GetClientAbsOrigin(slimerIndex, slimerVec);
	TE_SetupSmoke(slimerVec, g_SmokeModel, 50.0, 2);
	TE_SendToAll();
	slimerTargetVec[2]+= 10.0;
	TeleportEntity(slimerIndex, slimerTargetVec, NULL_VECTOR, NULL_VECTOR);
	SetEntPropFloat(slimerIndex, Prop_Data, "m_flLaggedMovementValue", 2.0);
}

public Action:FireballExplosion(Handle:timer, any:client)
{
	new g_ent = CreateEntityByName("env_explosion");
	DispatchKeyValue(g_ent, "iMagnitude", "5000");
	DispatchKeyValue(g_ent, "iRadiusOverride", "200");
	DispatchSpawn(g_ent);
	TeleportEntity(g_ent, fireballVec, NULL_VECTOR, NULL_VECTOR);
	AcceptEntityInput(g_ent, "Explode");
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 2.5);
	//TE_SetupExplosion(fireballVec, g_ExplosionSprite, 5.0, 1, 0, 200, 4000);
	//TE_SendToAll();
	//CreateTimer(1.0, KillExplosion, g_ent);
}

public Action:KillExplosion(Handle:timer, any:client)
{
	if (IsValidEntity(client))
    {
        new String:classname[256];
        GetEdictClassname(client, classname, sizeof(classname));
        if (StrEqual(classname, "env_explosion", false))
        {
            RemoveEdict(client);
        }
    }
}

public ScreenShake(client)
{
	new Handle:msg;
	msg = StartMessageOne("Shake", client);
	
	BfWriteByte(msg, 0);
 	BfWriteFloat(msg, 20.0);
 	BfWriteFloat(msg, 100.0);
 	BfWriteFloat(msg, 3.0);
	EndMessage();
}

public Action:RemovePoison(Handle:timer, any:client)
{
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
	SetEntityRenderColor(client, 255, 255, 255, 255);
}

public Action:SpawnMothercrab(Handle:timer)
{
	//Reset
	mothercrabIndex = -1;

	for (new x = 1; x < maxPlayers; x++)
	{
		if (!IsValidEdict(x))
			continue; 
			
		if (GetClientTeam(x) == 2 && IsPlayerAlive(x))
		{
			Zombify(x, 17);
			PrintToServer("Mothercrab found and set!");
			mothercrabIndex = x;
			break;
		}
	}
}