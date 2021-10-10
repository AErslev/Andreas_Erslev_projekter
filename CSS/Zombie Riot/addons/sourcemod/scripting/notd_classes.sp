//Unique_Compile_String: v2a//

//Created by: [NotD] l0calh0st
//Website: www.notdelite.com

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

new g_iClassIndex[MAXPLAYERS + 1];
new g_iClassIndexPre[MAXPLAYERS + 1];
new g_iTargetEntity[MAXPLAYERS + 1];
new g_iTargetHealth[MAXPLAYERS + 1];
new Float:g_fClientOrigin[MAXPLAYERS + 1][3];
new Float:g_fTargetOrigin[MAXPLAYERS + 1][3];
new bool:g_bWithinMedicRange[MAXPLAYERS + 1];

//Effects
new g_BeamSprite;
new g_HaloSprite;
new g_iColorGreen[4] = {0, 200, 0, 255};
new g_iColorBlue[4] = {0, 0, 255, 255};

#define CLASS_NONE 0
#define CLASS_ASSAULT 1
#define CLASS_MEDIC 2
#define CLASS_ENGINEER 3
#define CLASS_SNIPER 4
#define CLASS_SUPPORT 5
#define CLASS_PISTOL 6

#define REVIVERADIUS 75
#define FLAGRADIUS 200

/*
* Rank Defines "Score needed"
* Number of needed kills double
* Usually first rank up is special ability
* 
* Example: CLASS_ASSAULT CLASS
* --------------------------
* DEFAULT - GALIL
* 0 - C4
* 1 - WEAPON_SG552
* 2 - WEAPON_AK47
* 3 - WEAPON_M4A1y
* 
* Example: CLASS_MEDIC CLASS
* --------------------------
* DEFAULT - MAC10
* 0 - Medic Healing 1374
* 1 - WEAPON_TMP
* 2 - Medic Reviving
* 3 - WEAPON_UMP45
* 
* Example: CLASS_ENGINEER CLASS
* --------------------------
* DEFAULT - M3
* 0 - BUILD PROPS
* 1 - WEAPON_XM1014
* 2 - ROCKET LAUNCHER
* 3 - WEAPON_AUG
* 
* Example: CLASS_SNIPER CLASS
* --------------------------
* DEFAULT - SCOUT
* 0 - Trip Mines
* 1 - Weapon_SG550
* 2 - Weapon_G3SG1
* 3 - Weapon_awp
* 
* Example: CLASS_SUPPORT CLASS
* --------------------------
* DEFAULT - MP5 
* 0 - GIVE AMMO
* 1 - WEAPON_P90
* 2 - HE GRENADE
* 3 - WEAPON_M249
*
* Example: CLASS_PISTOL CLASS
* --------------------------
* DEFAULT - GLOCK
* 0 - weapon_usp
* 1 - weapon_228
* 2 - weapon_deagle
* 3 - weapon_fiveseven
* 4 - weapon_elites
*
0 - galil
1 - ak47
2 - scout
3 - sg552
4 - awp
5 - g3sg1
6 - famas
7 - m4a1
8 - aug
9 - sg550
10 - m3
11 - xm1014
12 - mac10
13 - tmp
14 - mp5navy
15 - ump45
16 - p90
17 - m249
18 - glock
19 - usp
20 - p228
21 - deagle
22 - elite
23 - fiveseven
*/

new tntAmount[MAXPLAYERS+1];
new g_tntEnabled[MAXPLAYERS+1];
new tnt_entity[MAXPLAYERS+1][128];

new bool:pack_primed[MAXPLAYERS+1][128];
new bool:g_can_plant[MAXPLAYERS+1];

new Handle:g_Cvar_tntAmount   = INVALID_HANDLE;
new Handle:g_Cvar_Enable	  = INVALID_HANDLE;
new Handle:g_Cvar_Delay	   = INVALID_HANDLE;
new Handle:g_Cvar_Mode		= INVALID_HANDLE;
new Handle:g_Cvar_tntDetDelay = INVALID_HANDLE;
new Handle:g_Cvar_PlantDelay  = INVALID_HANDLE;

new Handle:g_tntpack[MAXPLAYERS+1][128];

new String:g_TNTModel[128];
new String:g_plant_sound[128];

new g_offsCollisionGroup;
new g_WeaponParent;

//Rocket stuff
new Handle:hNadeLoop;

new Handle:hDamage;
new Handle:hRadius;
new Handle:hSpeed;
new Handle:hType;
new Handle:hEnable;
new Handle:hReplace;
new Handle:hTeam;
new Float:WorldMinHull[3];
new Float:WorldMaxHull[3];
new vecOriginOffset;

//Kit data
new kitArray[MAXPLAYERS + 1];

new Float:SpinVel[3] = {0.0, 0.0, 20.0};
new Float:SteamOrigin[3] = {-10.0,0.0,0.0};
new Float:SteamAngle[3] = {0.0,-180.0,0.0};

new NadeDamage;
new NadeRadius;
new Float:NadeSpeed;
new String:ReplaceNade[50];
new NadeAllowTeam;
new maxPlayers;

new Float:SteamSpeed;
new Float:SteamSpreadSpeed;
new Float:SteamJetLength;
new Float:SteamRate;
new bool:canShootRocket[MAXPLAYERS + 1];
new bool:canShootGrenade[MAXPLAYERS + 1];
new bool:canDropKit[MAXPLAYERS + 1];

new rocketAmount[MAXPLAYERS + 1];
new grenadeAmount[MAXPLAYERS + 1];

new tntPlanted[MAXPLAYERS+1];

new ragdollIndex[MAXPLAYERS + 1];

//Timers
new Handle:kitTimer = INVALID_HANDLE;

public Plugin:myinfo = 
{
	name = "NotD Classes",
	author = "[NotD] l0calh0st",
	description = "Classes for CS:S",
	url = "http://www.notdelite.com"
};

public OnPluginStart()
{
	
	HookEvent("player_death", PlayerDeath);
	HookEvent("player_spawn",PlayerSpawn);
	HookEvent("player_say", Event_PlayerSay, EventHookMode_Pre);
	
	// commands
	RegConsoleCmd("cheer", Command_ChooseSpecial);
		
	g_WeaponParent = FindSendPropOffs("CBaseCombatWeapon", "m_hOwnerEntity");
	if (g_WeaponParent == -1)
	{
		SetFailState("[NotD] Failed to get weapon parent.");
	}
	g_offsCollisionGroup = FindSendPropOffs("CBaseEntity", "m_CollisionGroup");
	if (g_offsCollisionGroup == -1)
	{
		SetFailState("[NotD] Didn't get collision group offset.");
	}
	
	hDamage = CreateConVar("missile_damage", "100.0", "Sets the magnitude of the missile.", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 1.0);
	hRadius = CreateConVar("missile_radius", "350.0", "Sets the explosive radius of the missiles", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 1.0);
	hSpeed = CreateConVar("missile_speed", "500.0", "Sets the speed of the missiles", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 100.0 ,true, 10000.0);
	hType = CreateConVar("missile_type", "0", "type of missile to use, 0 = dumb missiles, 1 = homing missiles, 2 = crosshair guided", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 2.0);
	hEnable = CreateConVar("missile_enable", "1", "1 enables plugin, 0 disables plugin", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 1.0);
	hReplace = CreateConVar("missile_replace", "1", "replace this weapon with missiles, 0 = grenade, 1 = flashbang, 2 = smoke", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 2.0);
	hTeam = CreateConVar("missile_team", "0", "which team can use missiles, 0 = any, 1 = only terrorists, 2 = only counter terrorists", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 2.0);
	
	g_Cvar_tntAmount   = CreateConVar("sm_tnt_amount", "3", " Number of tnt packs per player at spawn (max 10)", FCVAR_PLUGIN);
	//	g_Cvar_Admins	  = CreateConVar("sm_tnt_admins", "0", " Allow Admins only to use tnt", FCVAR_PLUGIN);
	g_Cvar_Enable	  = CreateConVar("sm_tnt_enabled", "1", " Enable/Disable the TNT plugin", FCVAR_PLUGIN);
	g_Cvar_Delay	   = CreateConVar("sm_tnt_delay", "3.0", " Delay between spawning and making tnt available", FCVAR_PLUGIN);
	//	g_Cvar_Restrict	= CreateConVar("sm_tnt_restrict", "0", " Class to restrict TNT to (see forum thread)", FCVAR_PLUGIN);
	g_Cvar_Mode		= CreateConVar("sm_tnt_mode", "0", " Detonation mode: 0=radio 1=crosshairs 2=timer", FCVAR_PLUGIN);
	g_Cvar_tntDetDelay = CreateConVar("sm_tnt_det_delay", "0.5", " Detonation delay", FCVAR_PLUGIN);
	g_Cvar_PlantDelay  = CreateConVar("sm_tnt_plant_delay", "1", " Delay between planting TNT", FCVAR_PLUGIN);
	
	NadeDamage = GetConVarInt(hDamage);
	NadeRadius = GetConVarInt(hRadius);
	NadeSpeed = GetConVarFloat(hSpeed);
	NadeAllowTeam = GetConVarInt(hTeam) + 1;
	
	SteamSpeed = NadeSpeed / 5.0;
	SteamSpreadSpeed = (NadeSpeed / 20.0) + 20.0;
	SteamJetLength = (NadeSpeed / 20.0) + 10.0;
	SteamRate = NadeSpeed / 2.0;
	
	if (GetConVarInt(hEnable))
	{
		AddNormalSoundHook(NormalSHook:NadeBounce);
		hNadeLoop = CreateTimer(0.1, NadeLoop, INVALID_HANDLE, TIMER_REPEAT);
	}
	
	ReplaceNade = "flashbang_projectile";
	
	HookConVarChange(hDamage, ConVarChange);
	HookConVarChange(hRadius, ConVarChange);
	HookConVarChange(hSpeed, ConVarChange);
	HookConVarChange(hType, ConVarChange);
	HookConVarChange(hEnable, ConVarChange);
	HookConVarChange(hReplace, ConVarChange);
	HookConVarChange(hTeam, ConVarChange);
}

public Action:CS_OnCSWeaponDrop(client, weaponIndex)
{
	if(IsClientInGame(client) && IsFakeClient(client))
		AcceptEntityInput(weaponIndex, "Kill");
}

public Action:RemoveRagdoll2(Handle:timer, any:client)
{
	//Initialize:
	if(ragdollIndex[client] != -1 && IsValidEntity(ragdollIndex[client]))
	{
		AcceptEntityInput(ragdollIndex[client], "Kill");
		ragdollIndex[client] = -1;
	}
}

public Action:Command_ChooseSpecial(client, args)
{
	if (GetClientTeam(client) != 1 && IsPlayerAlive(client))
	{
		if (g_iClassIndex[client] == CLASS_ASSAULT)
		{
			if (grenadeAmount[client] > 0 && canShootGrenade[client])
			{
				CreateGrenadeClient(client);
				grenadeAmount[client]--;
				canShootGrenade[client] = false;
				CreateTimer(1.0, resetGrenade, client);
				PrintToChat(client, "[NotD] Grenades left: %i", grenadeAmount[client]);
			}
		}
		else if (g_iClassIndex[client] == CLASS_SNIPER)
			tnt(client);
		else if (g_iClassIndex[client] == CLASS_MEDIC)
		{
			if (canDropKit[client])
			{
				CreateKit(client);
				canDropKit[client] = false;
				CreateTimer(5.0, resetKit, client);
			}
			else
				PrintToChat(client, "[NotD] You cannot drop a kit at the moment.");
		}
		else if (g_iClassIndex[client] == CLASS_SUPPORT)
		{
			if (canDropKit[client])
			{
				CreateKit(client);
				canDropKit[client] = false;
				CreateTimer(5.0, resetKit, client);
			}
			else
				PrintToChat(client, "[NotD] You cannot drop a kit at the moment.");
		}
		else if (g_iClassIndex[client] == CLASS_ENGINEER)
		{
			if (rocketAmount[client] > 0 && canShootRocket[client] && tntPlanted[client] < 3)
			{
				CreateGrenadeClient(client);
				rocketAmount[client]--;
				canShootRocket[client] = false;
				CreateTimer(1.0, resetRocket, client);
				PrintToChat(client, "[NotD] Rockets left: %i", rocketAmount[client]);
			}
		}
	}
	return Plugin_Handled;
}


public Action:resetRocket(Handle:timer, any:client)
{
	canShootRocket[client] = true;
}

public Action:resetGrenade(Handle:timer, any:client)
{
	canShootGrenade[client] = true;
}

public RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{	
	for (new x = 1; x < MAXPLAYERS; x++)
	{
		if (!IsValidEdict(x))
			continue;
			
		if (g_iClassIndex[x] == CLASS_ASSAULT && IsPlayerAlive(x))
			SetEntPropFloat(x, Prop_Data, "m_flLaggedMovementValue", 1.3);
	}
	if (GetConVarInt(g_Cvar_Enable))
	{
		for (new client = 1; client <= MaxClients; client++)
		{
			for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
			{
				if (tnt_entity[client][i] != 0)
				{
					CreateTimer(2.0, RemoveTNT, tnt_entity[client][i]);
					tnt_entity[client][i] = 0;
				}
			}
		}
	}
	
}

public ConVarChange(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	if (cvar == hDamage)
	{
		NadeDamage = StringToInt(newVal);
	}
	
	else if (cvar == hRadius)
	{
		NadeRadius = StringToInt(newVal);
	}
	
	else if (cvar == hSpeed)
	{
		NadeSpeed = StringToFloat(newVal);
		SteamSpeed = NadeSpeed / 5.0;
		SteamSpreadSpeed = (NadeSpeed / 20.0) + 20.0;
		SteamJetLength = (NadeSpeed / 20.0) + 10.0;
		SteamRate = NadeSpeed / 2.0;
	}
	
	else if (cvar == hEnable)
	{
		switch (StringToInt(newVal))
		{
			case 0:
			{
				CloseHandle(hNadeLoop);
				RemoveNormalSoundHook(NormalSHook:NadeBounce);
				RemoveActiveMissiles();
			}
			case 1:
			{
				AddNormalSoundHook(NormalSHook:NadeBounce);
				hNadeLoop = CreateTimer(0.1, NadeLoop, INVALID_HANDLE, TIMER_REPEAT);
			}
		}
	}
	
	else if (cvar == hReplace)
	{
		switch (StringToInt(newVal))
		{
			case 0:
			{
				RemoveActiveMissiles();
				ReplaceNade = "hegrenade_projectile";
			}
			case 1:
			{
				RemoveActiveMissiles();
				ReplaceNade = "flashbang_projectile";
			}
			case 2:
			{
				RemoveActiveMissiles();
				ReplaceNade = "smokegrenade_projectile";
			}
		}
	}
	
	else if (cvar == hTeam)
	{
		NadeAllowTeam = GetConVarInt(hTeam) + 1;
	}
}

public Action:resetKit(Handle:timer, any:client)
{
	canDropKit[client] = true;
}

public OnMapEnd()
{
	if (kitTimer != INVALID_HANDLE)
	{
		KillTimer(kitTimer);
		kitTimer = INVALID_HANDLE;
	}
}

CreateKit(client)
{
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	
	if (kitArray[client] == 0)
		kitArray[client] = -1;
		
	if (kitArray[client] != -1)
	{
		//RemoveEdict(kitArray[client]);
		AcceptEntityInput(kitArray[client], "Kill");
		kitArray[client] = -1;
	}
	
	
	if (g_iClassIndex[client] == CLASS_MEDIC)
	{
		new entityCount = GetEntityCount();
		
		if (entityCount > GetMaxEntities())
			return;
		
		kitArray[client] = CreateEntityByName("prop_dynamic_override");
		//DispatchKeyValue(kitArray[client], "solid","0");
		DispatchKeyValue(kitArray[client], "model", "models/items/healthkit.mdl");
		DispatchSpawn(kitArray[client]);
		SetEntPropEnt(kitArray[client], Prop_Send, "m_hOwnerEntity", client);
		TeleportEntity(kitArray[client], vec, NULL_VECTOR, NULL_VECTOR);
	}
	else if (g_iClassIndex[client] == CLASS_SUPPORT)
	{
		new entityCount = GetEntityCount();
		
		if (entityCount > GetMaxEntities())
			return;
		
		kitArray[client] = CreateEntityByName("prop_dynamic_override");
		//DispatchKeyValue(kitArray[client], "solid","0");
		DispatchKeyValue(kitArray[client], "model", "models/items/boxmrounds.mdl");
		DispatchSpawn(kitArray[client]);
		SetEntPropEnt(kitArray[client], Prop_Send, "m_hOwnerEntity", client);
		TeleportEntity(kitArray[client], vec, NULL_VECTOR, NULL_VECTOR);
	}
}

public Action:KitLoop(Handle:timer)
{
	new kitIndex = -1;
	new kitOwner = -1;
	new Float:origin[3];
	new Float:targetVec[3];
	new ownerTeam = -1;

	while ((kitIndex = FindEntityByClassname(kitIndex, "prop_dynamic")) != -1)
	{
		if (IsValidEntity(kitIndex))
		{
			kitOwner = GetEntPropEnt(kitIndex, Prop_Send, "m_hOwnerEntity");
			if (kitOwner > 0)
			{
				
				if (!IsPlayerAlive(kitOwner))
				{
					if (kitIndex != -1)
					{
						//RemoveEdict(kitIndex);
						AcceptEntityInput(kitIndex, "Kill");
						kitArray[kitOwner] = -1;
					}
				}
				else
				{
					ownerTeam = GetClientTeam(kitOwner);
					GetEntPropVector(kitIndex, Prop_Data, "m_vecOrigin", origin);
					//PrintToServer("Origin %f %f %f", origin[0], origin[1], origin[2]);
					for (new x = 1; x < maxPlayers + 1; x++)
					{
						if (!IsValidEdict(x))
							continue;

						if (!IsClientInGame(x))
							continue;
					
						if (!IsPlayerAlive(x))
							continue;

						if (ownerTeam != GetClientTeam(x))
							continue;

						GetClientAbsOrigin(x, targetVec);
						
						if (GetVectorDistance(origin, targetVec) < 200)
						{
							if (g_iClassIndex[kitOwner] == CLASS_MEDIC)
							{
								new clientHP = GetClientHealth(x);
								
								if (clientHP < 100)
								{
									SetEntityHealth(x, clientHP + 2);
								}
								else
								{
									if (clientHP > 100)
										SetEntityHealth(x, 100);
								}
							}
							else if (g_iClassIndex[kitOwner] == CLASS_SUPPORT)
							{
								PrintToServer("Client should be getting ammo");
								new weaponid;
								new String:weaponname[25];
								weaponid = GetPlayerWeaponSlot(x, 0);
								GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
								SetWeaponAmmo(x, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(x, GetWeaponAmmoOffset(weaponname)) + 5);
								weaponid = GetPlayerWeaponSlot(x, 1);
								GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
								SetWeaponAmmo(x, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(x, GetWeaponAmmoOffset(weaponname)) + 5);
								if (tntAmount[x] < 3)
									tntAmount[x]++;
								if (rocketAmount[x] < 3)
									rocketAmount[x]++;
								if (grenadeAmount[x] < 3)
									grenadeAmount[x]++;
							}
						}
					}
				}
			}
		}
	}
}

public OnMapStart()
{	
	AddDownload();
	PrecacheModels();
	PrecacheSounds();
	//Rocket stuff

	vecOriginOffset = FindSendPropOffs("CCSPlayer", "m_vecOrigin");
	GetEntPropVector(0, Prop_Send, "m_WorldMins", WorldMinHull);
	GetEntPropVector(0, Prop_Send, "m_WorldMaxs", WorldMaxHull);
	
	if (GetConVarInt(g_Cvar_Enable))
	{		
		HookEntityOutput("prop_physics", "OnTakeDamage", TakeDamage);
		HookEntityOutput("prop_physics", "OnBreak", Break);
		
		g_TNTModel = "models/weapons/w_c4_planted.mdl";
		PrecacheModel(g_TNTModel, true);
		
		PrecacheSound("weapons/c4/c4_plant.wav", true);
		strcopy(g_plant_sound, sizeof(g_plant_sound), "weapons/c4/c4_plant.wav");
	}
	kitTimer = CreateTimer(1.0, KitLoop, _, TIMER_REPEAT);
	
	maxPlayers = GetMaxClients();
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(GetClientTeam(client) <= CS_TEAM_SPECTATOR)
		return Plugin_Continue;

	if (g_iClassIndex[client] != g_iClassIndexPre[client])
		g_iClassIndex[client] = g_iClassIndexPre[client];
	if (g_iClassIndex[client] == CLASS_ASSAULT)
		SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.1);
	
	tntAmount[client] = 3;
	rocketAmount[client] = 3;
	grenadeAmount[client] = 3;
	canShootRocket[client] = true;
	canShootGrenade[client] = true;
	
	if (GetConVarInt(g_Cvar_Enable))
	{
		
		for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
		{
			tnt_entity[client][i] = 0;
		}
		
		CreateTimer(GetConVarFloat(g_Cvar_Delay), SetTNT, client);
	}

	return Plugin_Continue; //Good
}

public Action:PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victimid;
	
	victimid = GetClientOfUserId(GetEventInt(event, "userid"));
		
	for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
	{
		if (tnt_entity[victimid][i] != 0)
		{
			CreateTimer(2.0, RemoveTNT, tnt_entity[victimid][i]);
			tnt_entity[victimid][i] = 0;
		}
	}
	
	tntAmount[victimid] = 3;

	ragdollIndex[victimid] = GetEntPropEnt(victimid, Prop_Send, "m_hRagdoll");
	
	CreateTimer(0.0, RemoveRagdoll2, victimid);

	return Plugin_Continue;
}

public Action:AddCollision(Handle:timer, any:client)
{
	SetEntData(client, g_offsCollisionGroup, 5, 4, true);
}

public Action:RemoveCollision(Handle:timer, any:client)
{
	SetEntData(client, g_offsCollisionGroup, 2, 4, true);
}

public CommandHeal(client)
{
	//Initialize:
	new target = GetClientAimTarget(client);
	
	if (target < 1)
		return -1;
	
	//Spamming the use key causes this to show up if the target is out of range  =/
	if (g_iTargetEntity[client] > 0)
	{
		if (target != g_iTargetEntity[client])
			PrintToChat(client, "[NotD] You can only heal one person at a time.");
		else
			PrintToChat(client, "[NotD] You are already healing %N.", target);
		
		return -1;
	}
	
	if (GetClientTeam(client) == GetClientTeam(target))
	{
		g_iTargetEntity[client] = target;
		CreateTimer(0.5, CommandMedic, client, TIMER_FLAG_NO_MAPCHANGE);
	}
	return -1;
}

public Action:CommandMedic(Handle:Timer, any:client)
{
	if (!IsClientInGame(client) || !IsClientInGame(g_iTargetEntity[client]) || !IsPlayerAlive(client) || !IsPlayerAlive(g_iTargetEntity[client]))
	{
		g_bWithinMedicRange[client] = false;
		g_iTargetEntity[client] = -1;
		return Plugin_Handled;
	}
	
	GetClientAbsOrigin(client, g_fClientOrigin[client]);
	GetClientAbsOrigin(g_iTargetEntity[client], g_fTargetOrigin[g_iTargetEntity[client]]);
	new Float:distance = GetVectorDistance(g_fClientOrigin[client], g_fTargetOrigin[g_iTargetEntity[client]]);
	
	//Initial
	if (!g_bWithinMedicRange[client])
	{
		if (distance < 200.0)
		{
			g_iTargetHealth[g_iTargetEntity[client]] = GetClientHealth(g_iTargetEntity[client]);
			
			if (g_iTargetHealth[g_iTargetEntity[client]] < 100)
			{
				PrintToChat(client, "[NotD] You are now healing %N. Healing will occur as long as %N is within range", g_iTargetEntity[client], g_iTargetEntity[client]);
				SetEntityHealth(g_iTargetEntity[client], g_iTargetHealth[g_iTargetEntity[client]] + 2);
				g_fClientOrigin[client][2] += 10.0;
				TE_SetupBeamRingPoint(g_fClientOrigin[client], 10.0, 100.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, g_iColorGreen, 10, 0);
				TE_SendToAll();
				g_fTargetOrigin[g_iTargetEntity[client]][2] += 10.0;
				TE_SetupBeamRingPoint(g_fTargetOrigin[g_iTargetEntity[client]], 100.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, g_iColorBlue, 10, 0);
				TE_SendToAll();
				PrintToChat(client, "[NotD] %N's health: %d", g_iTargetEntity[client], g_iTargetHealth[g_iTargetEntity[client]]);
				g_bWithinMedicRange[client] = true;
				CreateTimer(0.5, CommandMedic, client, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				if (g_iTargetHealth[g_iTargetEntity[client]] > 100)
					SetEntityHealth(g_iTargetEntity[client], 100);
				
				g_bWithinMedicRange[client] = false;
				PrintToChat(client, "[NotD] %N has full health.", g_iTargetEntity[client]);
				g_iTargetEntity[client] = -1;
			}
		}
		else
			g_iTargetEntity[client] = -1;
	}
	else	//Subsequent
	{
		if (distance < 200.0)
		{
			g_iTargetHealth[g_iTargetEntity[client]] = GetClientHealth(g_iTargetEntity[client]);
			
			if (g_iTargetHealth[g_iTargetEntity[client]] < 100)
			{
				SetEntityHealth(g_iTargetEntity[client], g_iTargetHealth[g_iTargetEntity[client]] + 2);
				g_fClientOrigin[client][2] += 10.0;
				TE_SetupBeamRingPoint(g_fClientOrigin[client], 10.0, 100.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, g_iColorGreen, 10, 0);
				TE_SendToAll();
				g_fTargetOrigin[g_iTargetEntity[client]][2] += 10.0;
				TE_SetupBeamRingPoint(g_fTargetOrigin[g_iTargetEntity[client]], 100.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, g_iColorBlue, 10, 0);
				TE_SendToAll();
				PrintToChat(client, "[NotD] %N's health: %d", g_iTargetEntity[client], g_iTargetHealth[g_iTargetEntity[client]]);
				CreateTimer(0.5, CommandMedic, client, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				if (g_iTargetHealth[g_iTargetEntity[client]] > 100)
					SetEntityHealth(g_iTargetEntity[client], 100);
				
				g_bWithinMedicRange[client] = false;
				PrintToChat(client, "[NotD] %N has full health.", g_iTargetEntity[client]);
				g_iTargetEntity[client] = -1;
			}
		}
		else
		{
			g_bWithinMedicRange[client] = false;
			PrintToChat(client, "[NotD] %N is out of range, healing stopped.", g_iTargetEntity[client]);
			g_iTargetEntity[client] = -1;
		}
	}
	return Plugin_Handled;
}

public CommandSupply(client)
{
	//Initialize:
	new target = GetClientAimTarget(client);
	
	if (target < 1)
		return;
	
	//Spamming the use key causes this to show up if the target is out of range  =/
	g_iTargetEntity[client] = 0;
	if (g_iTargetEntity[client] > 0)
	{
		if (target != g_iTargetEntity[client])
			PrintToChat(client, "[NotD] You can only supply ammo to one person at a time.");
		else
			PrintToChat(client, "[NotD] You are already supplying ammo to %N.", target);
		
		return;
	}
	
	if (GetClientTeam(client) == GetClientTeam(target))
	{
		g_iTargetEntity[client] = target;
		CreateTimer(0.5, CommandAmmo, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:CommandAmmo(Handle:Timer, any:client)
{
	if (!IsClientInGame(client) || !IsClientInGame(g_iTargetEntity[client]) || !IsPlayerAlive(client) || !IsPlayerAlive(g_iTargetEntity[client]))
	{
		g_bWithinMedicRange[client] = false;
		g_iTargetEntity[client] = -1;
		return Plugin_Handled;
	}
	
	GetClientAbsOrigin(client, g_fClientOrigin[client]);
	GetClientAbsOrigin(g_iTargetEntity[client], g_fTargetOrigin[g_iTargetEntity[client]]);
	new Float:distance = GetVectorDistance(g_fClientOrigin[client], g_fTargetOrigin[g_iTargetEntity[client]]);
	new weaponid;
	new String:weaponname[25];
	
	//Initial
	if (!g_bWithinMedicRange[client])
	{
		if (distance < 200.0)
		{
			weaponid = GetPlayerWeaponSlot(client, 0);
			GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
			SetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname)) + 5);
			weaponid = GetPlayerWeaponSlot(client, 1);
			GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
			SetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname)) + 5);
			if (tntAmount[client] < 3)
				tntAmount[client]++;
			if (rocketAmount[client] < 3)
				rocketAmount[client]++;
			if (grenadeAmount[client] < 3)
				grenadeAmount[client]++;
			g_fClientOrigin[client][2] += 10.0;
			TE_SetupBeamRingPoint(g_fClientOrigin[client], 10.0, 400.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, g_iColorGreen, 10, 0);
			TE_SendToAll();
			g_fTargetOrigin[g_iTargetEntity[client]][2] += 10.0;
			TE_SetupBeamRingPoint(g_fTargetOrigin[g_iTargetEntity[client]], 400.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, g_iColorBlue, 10, 0);
			TE_SendToAll();
			PrintToChat(client, "[NotD] %N has been given ammo.");
			CreateTimer(0.5, CommandAmmo, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		else
			g_iTargetEntity[client] = -1;
	}
	else	//Subsequent
	{
		if (distance < 200.0)
		{
			weaponid = GetPlayerWeaponSlot(client, 0);
			GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
			SetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname)) + 5);
			weaponid = GetPlayerWeaponSlot(client, 1);
			GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
			SetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname)) + 5);
			if (tntAmount[client] < 3)
				tntAmount[client]++;
			if (rocketAmount[client] < 3)
				rocketAmount[client]++;
			if (grenadeAmount[client] < 3)
				grenadeAmount[client]++;
			g_fClientOrigin[client][2] += 10.0;
			TE_SetupBeamRingPoint(g_fClientOrigin[client], 10.0, 400.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, g_iColorGreen, 10, 0);
			TE_SendToAll();
			g_fTargetOrigin[g_iTargetEntity[client]][2] += 10.0;
			TE_SetupBeamRingPoint(g_fTargetOrigin[g_iTargetEntity[client]], 400.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, g_iColorBlue, 10, 0);
			TE_SendToAll();
			PrintToChat(client, "[NotD] %N has been given ammo.");
			CreateTimer(0.5, CommandAmmo, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			g_bWithinMedicRange[client] = false;
			PrintToChat(client, "[NotD] %N is out of range, supplying stopped.", g_iTargetEntity[client]);
			g_iTargetEntity[client] = -1;
		}
	}
	return Plugin_Handled;
}

stock GetWeaponAmmo(client, slot)
{
	new ammoOffset = FindSendPropInfo("CCSPlayer", "m_iAmmo");
	return GetEntData(client, ammoOffset+(slot*4));
}

stock SetWeaponAmmo(client, slot, ammo)
{
	new ammoOffset = FindSendPropInfo("CCSPlayer", "m_iAmmo");
	return SetEntData(client, ammoOffset+(slot*4), ammo);
}

public GetWeaponAmmoOffset(String:Weapon[])
{
	if(StrEqual(Weapon, "weapon_deagle", false))
	{
		return 1;
	}
	else if(StrEqual(Weapon, "weapon_ak47", false) || StrEqual(Weapon, "weapon_aug", false) || StrEqual(Weapon, "weapon_g3sg1", false) || StrEqual(Weapon, "weapon_scout", false))
	{
		return 2;
	}
	else if(StrEqual(Weapon, "weapon_famas", false) || StrEqual(Weapon, "weapon_galil", false) || StrEqual(Weapon, "weapon_m4a1", false) || StrEqual(Weapon, "weapon_sg550", false) || StrEqual(Weapon, "weapon_sg552", false))
	{
		return 3;
	}
	else if(StrEqual(Weapon, "weapon_m249", false))
	{
		return 4;
	}
	else if(StrEqual(Weapon, "weapon_awp", false))
	{
		return 5;
	}
	else if(StrEqual(Weapon, "weapon_elite", false) || StrEqual(Weapon, "weapon_glock", false) || StrEqual(Weapon, "weapon_mp5navy", false) || StrEqual(Weapon, "weapon_tmp", false))
	{
		return 6;
	}
	else if(StrEqual(Weapon, "weapon_xm1014", false) || StrEqual(Weapon, "weapon_m3", false))
	{
		return 7;
	}
	else if(StrEqual(Weapon, "weapon_mac10", false) || StrEqual(Weapon, "weapon_ump45", false) || StrEqual(Weapon, "weapon_usp", false))
	{
		return 8;
	}
	else if(StrEqual(Weapon, "weapon_p228", false))
	{
		return 9;
	}
	else if(StrEqual(Weapon, "weapon_fiveseven", false) || StrEqual(Weapon, "weapon_p90", false))
	{
		return 10;
	}
	else if(StrEqual(Weapon, "weapon_hegrenade", false))
	{
		return 11;
	}
	else if(StrEqual(Weapon, "weapon_flashbang", false))
	{
		return 12;
	}
	else if(StrEqual(Weapon, "weapon_smokegrenade", false))
	{
		return 13;
	}
	return -1;
}

public ClassMenuHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			g_iClassIndexPre[param1] = CLASS_ASSAULT;
			PrintToChat(param1, "[NotD] You have selected Marine. You will respawn as this class.");
		}
		else if (param2 == 2)
		{
			g_iClassIndexPre[param1] = CLASS_MEDIC;
			PrintToChat(param1, "[NotD] You have selected Medic. You will respawn as this class.");
		}
		else if (param2 == 3)
		{
			g_iClassIndexPre[param1] = CLASS_ENGINEER;
			PrintToChat(param1, "[NotD] You have selected Engineer. You will respawn as this class.");
		}
		else if (param2 == 4)
		{
			g_iClassIndexPre[param1] = CLASS_SNIPER;
			PrintToChat(param1, "[NotD] You have selected Sniper. You will respawn as this class.");
		}
		else if (param2 == 5)
		{
			g_iClassIndexPre[param1] = CLASS_SUPPORT;
			PrintToChat(param1, "[NotD] You have selected Support. You will respawn as this class.");
		}
	} 
	else if (action == MenuAction_Cancel) 
	{
	}
}

public Panel_ClassMenu(client)
{
	new Handle:panel = CreatePanel();
	SetPanelTitle(panel, "CLASSES");
	DrawPanelItem(panel, "Marine");
	DrawPanelItem(panel, "Medic");
	DrawPanelItem(panel, "Engineer");
	DrawPanelItem(panel, "Sniper");
	DrawPanelItem(panel, "Support");
	//Exit menu option
	
	SendPanelToClient(panel, client, ClassMenuHandler, 0);
	
	CloseHandle(panel);
}

public OnClientDisconnect(client)
{
	g_iClassIndex[client] = g_iClassIndexPre[client] = CLASS_NONE;
	
	if (GetConVarInt(g_Cvar_Enable))
	{
		
		for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
		{
			if (tnt_entity[client][i] != 0)
			{
				CreateTimer(2.0, RemoveTNT, tnt_entity[client][i]);
				tnt_entity[client][i] = 0;
			}
		}
	}
}

public OnClientPostAdminCheck(client)
{
	Panel_ClassMenu(client);
	g_iClassIndex[client] = 0;
	
	tntAmount[client] = 3;
	rocketAmount[client] = 3;
	grenadeAmount[client] = 3;
	canShootGrenade[client] = true;
	canShootRocket[client] = true;
	canDropKit[client] = true;
}

public Event_PlayerSay(Handle:event, const String:name[], bool:dontBroadcast) 
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (client == 0)
		return;
	
	new String:text[192];
	
	GetEventString(event, "text", text, 191);
	if (StrEqual(text, "!class"))
		Panel_ClassMenu(client);
}

public Action:SetTNT(Handle:timer, any:client)
{
	g_tntEnabled[client] = 1;
	g_can_plant[client] = true;
}

public Action:RemoveTNT(Handle:timer, any:ent)
{
	if (IsValidEntity(ent))
	{
		new Float:tnt_pos[3], String:classname[256];
		GetEntDataVector(ent, vecOriginOffset, tnt_pos);
		TE_SetupEnergySplash(tnt_pos, NULL_VECTOR, true);
		TE_SendToAll(0.1);
		
		GetEdictClassname(ent, classname, sizeof(classname));
		if (StrEqual(classname, "prop_physics", false))
		{
			//RemoveEdict(ent);
			AcceptEntityInput(ent, "Kill");
		}
	}
}


public tnt(client)
{
	g_tntEnabled[client] = true;
	g_can_plant[client] = true;
	if (GetConVarInt(g_Cvar_Enable))
	{
		if (g_tntEnabled[client])
		{	
			if (IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) > 1)
			{ 
				if (g_can_plant[client])
				{
					if (tntAmount[client] > 0)
					{
						if (tntAmount[client] >= 10)
						{
							tntAmount[client] = 10;
						}
						
						new Float:vAngles[3];
						new Float:vOrigin[3];
						new Float:pos[3];
						new Float:pos_angles[3];
						
						GetClientEyePosition(client,vOrigin);
						GetClientEyeAngles(client, vAngles);
						
						new Handle:trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceEntityFilterPlayer);
						
						if(TR_DidHit(trace))
						{
							TR_GetEndPosition(pos, trace);
						}
						CloseHandle(trace);
						
						if (pos[2] >= (vOrigin[2] - 50))
							pos_angles[0] = 90.0;
						else
						pos_angles[0] = 0.0;
						
						new Float:distance = GetVectorDistance(vOrigin, pos);
						
						if (distance > 100)
						{
							PrintToChat(client, "[NotD] Too far away to plant");
						}
						else
						{
							TE_SetupSparks(pos, NULL_VECTOR, 2, 1);
							TE_SendToAll(0.1);
							
							new ent = CreateEntityByName("prop_physics_override");
							tnt_entity[client][tntAmount[client]] = ent;
							pack_primed[client][tntAmount[client]] = false;
							
							g_tntpack[client][tntAmount[client]] = CreateDataPack();
							WritePackCell(g_tntpack[client][tntAmount[client]], client);
							WritePackCell(g_tntpack[client][tntAmount[client]], tntAmount[client]);
							CreateTimer(5.0, SetDefuseState, g_tntpack[client][tntAmount[client]]);
							
							SetEntityModel(ent, g_TNTModel);
							DispatchKeyValue(ent, "StartDisabled", "false");
							DispatchKeyValue(ent, "ExplodeRadius", "200");
								
							DispatchKeyValue(ent, "ExplodeDamage", "0");
							
							DispatchKeyValue(ent, "massScale", "1.0");
							DispatchKeyValue(ent, "inertiaScale", "0.1");
							DispatchKeyValue(ent, "pressuredelay", "2.0");
							
							DispatchSpawn(ent);
							SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", client);
							AcceptEntityInput(ent, "Enable");
							AcceptEntityInput(ent, "TurnOn");
							AcceptEntityInput(ent, "DisableMotion");	
							TeleportEntity(ent, pos, pos_angles, NULL_VECTOR);
							
							tntAmount[client]--;
							tntPlanted[client]++;
							PrintToChat(client, "[NotD] Mines left: %i", tntAmount[client]);
							
							EmitSoundToAll(g_plant_sound, ent, _, _, _, 0.8);
							
							CreateTimer(5.0, Prime, ent);
							CreateTimer(GetConVarFloat(g_Cvar_PlantDelay), AllowPlant, client);
							g_can_plant[client] = false;
						}
					}
					else
					{
						PrintToChat(client, "[NotD] No mines left");
					}
				}
			}
		}
		else
		{
			PrintToChat(client, "[NotD] TNT unavailable.  Please wait....");
		}
	}
	return 0;
}

public bool:TraceEntityFilterPlayer(entity, contentsMask)
{
	return entity > GetMaxClients() || !entity;
} 

public Action:AllowPlant(Handle:timer, any:client)
{
	g_can_plant[client] = true;
}

public Action:Prime(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		new String:tntname[128];
		Format(tntname, sizeof(tntname), "TNT-%i", entity);
		DispatchKeyValue(entity, "targetname", tntname);
		
		DispatchKeyValue(entity, "physdamagescale", "9999.0");
		DispatchKeyValue(entity, "spawnflags", "304");
		DispatchKeyValue(entity, "health", "1");
		SetEntProp(entity, Prop_Data, "m_takedamage", 2);
		
		AcceptEntityInput(entity, "EnableDamageForces");
		
		if (GetConVarInt(g_Cvar_Mode) == 2)
		{
			CreateTimer(1.0, Fuse, entity, TIMER_REPEAT);
			CreateTimer(GetConVarFloat(g_Cvar_tntDetDelay), DelayedDetonation, entity);
		}
	}
	
	return Plugin_Continue;
}

public Action:DelayedDetonation(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		AcceptEntityInput(entity, "break");
	}
}

public Action:Fuse(Handle:timer, any:entity)
{
	if (IsValidEntity(entity))
	{
		new Float:tnt_pos[3];
		GetEntDataVector(entity, vecOriginOffset, tnt_pos);
		TE_SetupSparks(tnt_pos, NULL_VECTOR, 2, 1);
		TE_SendToAll(0.1);
	}
	else
	{
		KillTimer(timer);
	}
}

public Action:SetDefuseState(Handle:timer, any:tntpack)
{
	ResetPack(tntpack);
	new owner = ReadPackCell(tntpack);
	new tntnumber = ReadPackCell(tntpack);
	CloseHandle(tntpack);
	
	pack_primed[owner][tntnumber] = true;
}

public TakeDamage(const String:output[], caller, activator, Float:delay)
{	
	for (new client = 1; client <= MaxClients; client++)
	{
		for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
		{
			if (tnt_entity[client][i] == caller)
			{
				AcceptEntityInput(caller,"break");
				break;
			}
		}
	}
}

public Break(const String:output[], caller, activator, Float:delay)
{	
	new client = GetEntPropEnt(caller, Prop_Send, "m_hOwnerEntity");
	new clientTeam;
	
	new Float:NadePos[3];
	GetEntPropVector(caller, Prop_Send, "m_vecOrigin", NadePos);
	
	if (client != -1)
		clientTeam = GetClientTeam(client);
	
	new NadeIndex = CreateEntityByName(ReplaceNade);
	if (NadeIndex != -1)
	{
		DispatchSpawn(NadeIndex);

		NadePos[2] += 20;
		TeleportEntity(NadeIndex, NadePos, NULL_VECTOR, NULL_VECTOR);
		if (client != -1)
		{
			SetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity", client);
			SetEntPropEnt(NadeIndex, Prop_Send, "m_hThrower", client);
			if (clientTeam == 2 || clientTeam == 3)
				SetEntProp(NadeIndex, Prop_Send, "m_iTeamNum", clientTeam);
		}
		DetonateGrenade(NadeIndex);
	}
	
	AcceptEntityInput(caller,"kill");
	
	tntPlanted[client] = 0;
}

public Action:defuse(client, args)
{
	if (GetConVarInt(g_Cvar_Enable))
	{
		new aim_entity = GetClientAimTarget(client, false);
		
		new owner;
		new tntpack;
		
		for (new target = 1; target <= MaxClients; target++)
		{
			for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
			{
				if (tnt_entity[target][i] == aim_entity)
				{
					owner = target;
					tntpack = i;
					break;
				}
			}
		}
		
		if (owner == 0)
			return Plugin_Handled;
		
		new Float:tnt_pos[3];
		GetEntDataVector(tnt_entity[owner][tntpack], vecOriginOffset, tnt_pos);
		new Float:targetVector[3];
		GetClientAbsOrigin(client, targetVector);
		
		new Float:distance = GetVectorDistance(targetVector, tnt_pos);
		
		if (pack_primed[owner][tntpack])
		{
			if (distance > 100)
			{
				PrintToChat(client, "[NotD] Too far away to defuse");
			}
			else
			{
				CreateTimer(2.0, RemoveTNT, tnt_entity[owner][tntpack]);
				tnt_entity[client][tntpack] = 0;
				
				tntAmount[client]++;
				
				if (tntAmount[client] >= GetConVarInt(g_Cvar_tntAmount))
					tntAmount[client] = GetConVarInt(g_Cvar_tntAmount);
				
				PrintToChat(client, "[NotD] TNT left: %i", tntAmount[client]);
				PrintToChat(owner, "[NotD] TNT pack defused");
			}
		}
		else
		{
			PrintToChat(client, "[NotD] Cannot be defused yet...");
		}
	}
	
	return Plugin_Handled;
}

public Action:det(client, args)
{
	if (GetConVarInt(g_Cvar_Enable))
	{
		if (GetConVarInt(g_Cvar_Mode) == 1)
		{
			new aim_entity = GetClientAimTarget(client, false);
			
			new owner;
			new tntpack;
			
			for (new target = 1; target <= MaxClients; target++)
			{
				for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
				{
					if (tnt_entity[target][i] == aim_entity)
					{
						owner = target;
						tntpack = i;
						break;
					}
				}
			}
			
			if (owner == 0)
				return Plugin_Handled;
			
			
			if (pack_primed[owner][tntpack])
			{
				if (client != owner)
				{
					PrintToChat(client, "[NotD] This is not your TNT pack");
				}
				else
				{
					AcceptEntityInput(tnt_entity[owner][tntpack], "break");
				}
			}
			else
			{
				PrintToChat(client, "[NotD] Still priming...Cannot be detonated yet...");
			}
		}
		else if (GetConVarInt(g_Cvar_Mode) == 0)
		{
			for (new i = GetConVarInt(g_Cvar_tntAmount); i > 0 ; i--)
			{
				if (tnt_entity[client][i] != 0)
				{
					if (IsValidEntity(tnt_entity[client][i]))
					{
						AcceptEntityInput(tnt_entity[client][i], "break");
					}
				}
			}
		}
	}
	
	return Plugin_Handled;
}

public Action:KillExplosion2(Handle:timer, any:ent)
{
	if (IsValidEntity(ent))
	{
		new String:classname[256];
		GetEdictClassname(ent, classname, sizeof(classname));
		if (StrEqual(classname, "env_explosion", false))
		{
			//RemoveEdict(ent);
			AcceptEntityInput(ent, "Kill");
		}
	}
}

public Action:NadeLoop(Handle:timer)
{
	new NadeIndex = -1;
	while ((NadeIndex = FindEntityByClassname(NadeIndex, ReplaceNade)) != -1)
	{		
		decl Float:NadePos[3];
		GetEntPropVector(NadeIndex, Prop_Send, "m_vecOrigin", NadePos);
		
		new client = GetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity");
		if (client == 0 || client == -1 || !IsClientConnected(client) || !IsClientInGame(client))
			return Plugin_Handled;

		decl Float:InitialAng[3];
		decl Float:InitialVec[3];
		decl Float:OwnerPos[3];
		decl Float:InitialPos[3];
		decl Float:OwnerAng[3];
		
		if (g_iClassIndex[client] == CLASS_ENGINEER)
		{
			if (GetEntityMoveType(NadeIndex) != MOVETYPE_FLY)
			{
				SetEntityModel(NadeIndex, "models/weapons/w_missile_closed.mdl");
				SetEntPropVector(NadeIndex, Prop_Data, "m_vecAngVelocity", SpinVel);
				
				new NadeOwner = GetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity");
				GetClientEyeAngles(NadeOwner, OwnerAng);
				GetClientEyePosition(NadeOwner, OwnerPos);
				TR_TraceRayFilter(OwnerPos, OwnerAng, MASK_SOLID, RayType_Infinite,  RayDontHitOwnerOrNade, NadeIndex);
				TR_GetEndPosition(InitialPos);
				MakeVectorFromPoints(NadePos, InitialPos, InitialVec);
				NormalizeVector(InitialVec, InitialVec);
				ScaleVector(InitialVec, NadeSpeed);
				InitialVec[0] *= 2;
				InitialVec[1] *= 2;
				InitialVec[2] *= 2;
				
				GetVectorAngles(InitialVec, InitialAng);
				TeleportEntity(NadeIndex, NULL_VECTOR, InitialAng, InitialVec);
				
				new SteamIndex = CreateEntityByName("env_steam");
				if (SteamIndex != -1)
				{
					DispatchKeyValue(SteamIndex, "spawnflags", "0");
					DispatchKeyValue(SteamIndex, "InitialState", "1");
					DispatchKeyValue(SteamIndex, "type", "0");
					DispatchKeyValueFloat(SteamIndex, "SpreadSpeed", SteamSpreadSpeed);
					DispatchKeyValueFloat(SteamIndex, "Speed", SteamSpeed);
					DispatchKeyValue(SteamIndex, "StartSize", "5");
					DispatchKeyValue(SteamIndex, "EndSize", "20");
					DispatchKeyValueFloat(SteamIndex, "Rate", SteamRate);
					DispatchKeyValue(SteamIndex, "rendercolor", "0 0 0");
					DispatchKeyValueFloat(SteamIndex, "JetLength", SteamJetLength);
					DispatchKeyValue(SteamIndex, "renderamt", "255");
					DispatchKeyValue(SteamIndex, "rollspeed", "50");
					DispatchSpawn(SteamIndex);
					ActivateEntity(SteamIndex);
					
					decl String:NadeName[20];
					Format(NadeName, sizeof(NadeName), "Nade_%i", NadeIndex);
					DispatchKeyValue(NadeIndex, "targetname", NadeName);
					SetVariantString(NadeName);
					AcceptEntityInput(SteamIndex, "SetParent");
					TeleportEntity(SteamIndex, SteamOrigin, SteamAngle, NULL_VECTOR);
				}
			}
		}
		else if (g_iClassIndex[client] == CLASS_ASSAULT)
		{
			if (GetEntityMoveType(NadeIndex) == MOVETYPE_FLY)
			{
				CreateTimer(0.1, SetGrenadeLauncher, NadeIndex);
				SetEntPropVector(NadeIndex, Prop_Data, "m_vecAngVelocity", SpinVel);
				SetEntityModel(NadeIndex, "models/weapons/w_missile_closed.mdl");
				new NadeOwner = GetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity");

				GetClientEyeAngles(NadeOwner, OwnerAng);
				GetClientEyePosition(NadeOwner, OwnerPos);
				TR_TraceRayFilter(OwnerPos, OwnerAng, MASK_SOLID, RayType_Infinite,  RayDontHitOwnerOrNade, NadeIndex);
				
				TR_GetEndPosition(InitialPos);
				MakeVectorFromPoints(NadePos, InitialPos, InitialVec);
				NormalizeVector(InitialVec, InitialVec);
				ScaleVector(InitialVec, NadeSpeed);
				
				GetVectorAngles(InitialVec, InitialAng);
				InitialVec[0] *= 1.5;
				InitialVec[1] *= 1.5;
				InitialVec[2] *= 1.5;
				TeleportEntity(NadeIndex, NULL_VECTOR, InitialAng, InitialVec);
			}
		}
	}
	return Plugin_Continue;
}

public Action:SetGrenadeLauncher(Handle:timer, any:ent)
{
	if(IsValidEntity(ent))
		SetEntityMoveType(ent, MOVETYPE_FLYGRAVITY);
}

public bool:RayDontHitOwnerOrNade(entity, contentsMask, any:data)
{
	new NadeOwner = GetEntPropEnt(data, Prop_Send, "m_hOwnerEntity");
	return ((entity != data) && (entity != NadeOwner));
}

public Action:NadeBounce(clients[64], &numClients, String:sample[PLATFORM_MAX_PATH], &entity, &channel, &Float:volume, &level, &pitch, &flags)
{
	if (StrEqual(sample, "weapons/hegrenade/he_bounce-1.wav", false))
	{
		if (StrEqual(ReplaceNade, "hegrenade_projectile", false))
		{
			new NadeTeam = GetEntProp(entity, Prop_Send, "m_iTeamNum");
			if ((NadeAllowTeam != 1) && (NadeAllowTeam != NadeTeam))
				return Plugin_Continue;
				
			DetonateGrenade(entity);
			return Plugin_Handled;
		}
	}
	else if (StrEqual(sample, "weapons/flashbang/grenade_hit1.wav", false))
	{
		if (StrEqual(ReplaceNade, "flashbang_projectile", false))
		{
			new NadeTeam = GetEntProp(entity, Prop_Send, "m_iTeamNum");
			if ((NadeAllowTeam != 1) && (NadeAllowTeam != NadeTeam))
				return Plugin_Continue;
			
			DetonateGrenade(entity);
			return Plugin_Handled;
		}
	}
	else if (StrEqual(sample, "weapons/smokegrenade/grenade_hit1.wav", false))
	{
		if (StrEqual(ReplaceNade, "smokegrenade_projectile", false))
		{
			new NadeTeam = GetEntProp(entity, Prop_Send, "m_iTeamNum");
			if ((NadeAllowTeam != 1) && (NadeAllowTeam != NadeTeam))
				return Plugin_Continue;
			
			DetonateGrenade(entity);
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

CreateGrenade(entity)
{
	new Float:NadePos[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", NadePos);
	new FlashOrSmokeOwner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	new FlashOrSmokeOwnerTeam = GetEntProp(FlashOrSmokeOwner, Prop_Send, "m_iTeamNum");
	AcceptEntityInput(entity, "Kill");

	new NadeIndex = CreateEntityByName(ReplaceNade);
	if (NadeIndex != -1)
	{
		DispatchSpawn(NadeIndex);

		SetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity", FlashOrSmokeOwner);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hThrower", FlashOrSmokeOwner);
		SetEntProp(NadeIndex, Prop_Send, "m_iTeamNum", FlashOrSmokeOwnerTeam);	
		TeleportEntity(NadeIndex, NadePos, NULL_VECTOR, NULL_VECTOR);
		DetonateGrenade(NadeIndex);
	}
}

DetonateGrenade(entity)
{
	decl _iOwner, Float:_fPos[3];
	GetEntPropVector(entity, Prop_Send, "m_vecOrigin", _fPos);
	_iOwner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	
	AcceptEntityInput(entity, "Kill");
	new _iExplosion = CreateEntityByName("env_explosion");
	if (_iExplosion != -1)
	{
		decl String:_iBuffer[64];

		DispatchKeyValueVector(_iExplosion, "Origin", _fPos);
		IntToString(NadeRadius, _iBuffer, 64);
		DispatchKeyValue(_iExplosion, "iRadiusOverride", _iBuffer);
		IntToString(NadeDamage, _iBuffer, 64);
		DispatchKeyValue(_iExplosion, "iMagnitude", _iBuffer);
		DispatchSpawn(_iExplosion);

		SetEntPropEnt(_iExplosion, Prop_Send, "m_hOwnerEntity", _iOwner);
		AcceptEntityInput(_iExplosion, "Explode");
		AcceptEntityInput(_iExplosion, "Kill");
	}
}

RemoveActiveMissiles()
{
	new NadeIndex = -1;
	new PreviousIndex = 0;
	while ((NadeIndex = FindEntityByClassname(NadeIndex, ReplaceNade)) != -1)
	{
		if (PreviousIndex)
		{
			//StopSound(PreviousIndex, SNDCHAN_AUTO, "notdelite/classes/rocket1.wav");
			//RemoveEdict(PreviousIndex);
			AcceptEntityInput(PreviousIndex, "Kill");
		}
		PreviousIndex = NadeIndex;
	}
	if (PreviousIndex)
	{
		//StopSound(PreviousIndex, SNDCHAN_AUTO, "notdelite/classes/rocket1.wav");
		//RemoveEdict(PreviousIndex);
		AcceptEntityInput(PreviousIndex, "Kill");
	}
}

CreateGrenadeClient(client)
{
	new NadeIndex = CreateEntityByName(ReplaceNade);
	new Float:vecOrigin[3];
	new Float:vecAngle[3];
	if (NadeIndex != -1)
	{
		DispatchSpawn(NadeIndex);

		GetClientAbsOrigin(client, vecOrigin);
		GetClientAbsOrigin(client, vecAngle);
		vecOrigin[2] += 50;
		TeleportEntity(NadeIndex, vecOrigin, vecAngle, NULL_VECTOR);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity", client);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hThrower", client);
		SetEntProp(NadeIndex, Prop_Send, "m_iTeamNum", client);
		if (g_iClassIndex[client] == CLASS_ASSAULT)
			SetEntityMoveType(NadeIndex, MOVETYPE_FLY);
	}
	if (g_iClassIndex[client] == CLASS_ASSAULT)
		EmitSoundToAll("notdelite/classes/grenadelauncher.wav", client, SNDCHAN_AUTO, 75);
	//else if (g_iClassIndex[client] == CLASS_ENGINEER)
		//EmitSoundToAll("notdelite/classes/rocket1.wav", NadeIndex, SNDCHAN_AUTO, 75);
}

public OnEntityCreated(entity, const String:classname[])
{
	if(entity >= 0)
	{
		if(StrEqual(classname, ReplaceNade, false))
			CreateTimer(0.1, Timer_OnEntityCreated, EntIndexToEntRef(entity));
	}
}

public Action:Timer_OnEntityCreated(Handle:timer, any:ref)
{
	new entity = EntRefToEntIndex(ref);
	if(entity != INVALID_ENT_REFERENCE)
	{
		LogError("Created %d", entity);
		SetEntProp(entity, Prop_Data, "m_nNextThinkTick", -1);
	}
	
	return Plugin_Continue;
}

stock CreateGrenadePos(client, Float:vec[3])
{
	new NadeIndex = CreateEntityByName(ReplaceNade);
	if (NadeIndex != -1)
	{
		DispatchSpawn(NadeIndex);
		TeleportEntity(NadeIndex, vec, NULL_VECTOR, NULL_VECTOR);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity", client);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hThrower", client);
		SetEntProp(NadeIndex, Prop_Send, "m_iTeamNum", client);
		SetEntityMoveType(NadeIndex, MOVETYPE_FLYGRAVITY);
	}
}

stock AddDownload()
{
	AddFileToDownloadsTable("sound/notdelite/classes/grenadelauncher.wav");
	AddFileToDownloadsTable("sound/notdelite/classes/revive.wav");
	AddFileToDownloadsTable("sound/notdelite/classes/rocket1.wav");
	AddFileToDownloadsTable("materials/models/weapons/w_missile/missile side.vmt");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.dx80.vtx");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.dx90.vtx");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.mdl");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.phy");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.sw.vtx");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.vvd");
}

stock PrecacheModels()
{
	PrecacheModel("models/weapons/w_missile_closed.mdl");
	PrecacheModel("models/items/boxmrounds.mdl");
	PrecacheModel("models/props_c17/doll01.mdl");
	PrecacheModel("models/items/healthkit.mdl");
	g_TNTModel = "models/weapons/w_c4_planted.mdl";
	PrecacheModel(g_TNTModel, true);
}

stock PrecacheSounds()
{
	PrecacheSound("notdelite/classes/rocket1.wav");
	PrecacheSound("notdelite/classes/revive.wav");
	PrecacheSound("notdelite/classes/grenadelauncher.wav");
	PrecacheSound("weapons/c4/c4_plant.wav", true);
}