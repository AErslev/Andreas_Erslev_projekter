//Created by: [NotD] l0calh0st
//Website: www.notdelite.com

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

new classIndex[MAXPLAYERS + 1];
new classIndexPre[MAXPLAYERS + 1];

//Squads
new Handle:kitTimer;

new kitArray[MAXPLAYERS + 1];

#define TEAM_SPECTATOR 1
#define TEAM_T 2
#define TEAM_CT 3

#define ASSAULT 0
#define MEDIC 1
#define ENGINEER 2
#define SNIPER 3
#define SUPPORT 4
#define PISTOL 5

#define REVIVERADIUS 75
#define FLAGRADIUS 200

#define CTs_Win	 8
#define Terrorists_Win 9
/*
* Rank Defines "Score needed"
* Number of needed kills double
* Usually first rank up is special ability
* 
* Example: ASSAULT CLASS
* --------------------------
* DEFAULT - GALIL
* 0 - C4
* 1 - WEAPON_SG552
* 2 - WEAPON_AK47
* 3 - WEAPON_M4A1y
* 
* Example: MEDIC CLASS
* --------------------------
* DEFAULT - MAC10
* 0 - Medic Healing 1374
* 1 - WEAPON_TMP
* 2 - Medic Reviving
* 3 - WEAPON_UMP45
* 
* Example: ENGINEER CLASS
* --------------------------
* DEFAULT - M3
* 0 - BUILD PROPS
* 1 - WEAPON_XM1014
* 2 - ROCKET LAUNCHER
* 3 - WEAPON_AUG
* 
* Example: SNIPER CLASS
* --------------------------
* DEFAULT - SCOUT
* 0 - Trip Mines
* 1 - Weapon_SG550
* 2 - Weapon_G3SG1
* 3 - Weapon_awp
* 
* Example: SUPPORT CLASS
* --------------------------
* DEFAULT - MP5 
* 0 - GIVE AMMO
* 1 - WEAPON_P90
* 2 - HE GRENADE
* 3 - WEAPON_M249
*
* Example: PISTOL CLASS
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
new Handle:g_Cvar_Enable      = INVALID_HANDLE;
new Handle:g_Cvar_Delay       = INVALID_HANDLE;
new Handle:g_Cvar_Mode        = INVALID_HANDLE;
new Handle:g_Cvar_tntDetDelay = INVALID_HANDLE;
new Handle:g_Cvar_PlantDelay  = INVALID_HANDLE;

new Handle:g_tntpack[MAXPLAYERS+1][128];

new String:g_TNTModel[128];
new String:g_plant_sound[128];

new g_ent_location_offset;
new g_offsCollisionGroup;
new g_WeaponParent;

//Rocket stuff
new Handle:hGameCfg;
new Handle:hDetonate;
new Handle:hNadeLoop;

new Handle:hDamage;
new Handle:hRadius;
new Handle:hSpeed;
new Handle:hType;
new Handle:hEnable;
new Handle:hReplace;
new Handle:hTeam;

new Float:SpinVel[3] = {0.0, 0.0, 20.0};
new Float:SteamOrigin[3] = {-10.0,0.0,0.0};
new Float:SteamAngle[3] = {0.0,-180.0,0.0};

new Float:NadeDamage;
new Float:NadeRadius;
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

new ragdollIndex[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
	name = "NotD Battlefield",
	author = "[NotD] l0calh0st",
	description = "Battlefield Mod for CS:S",
	url = "http://www.notdelite.com"
};

AddDownload()
{
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

public OnPluginStart()
{
	
	kitTimer = CreateTimer(1.0, KitLoop, _, TIMER_REPEAT);
	
	// commands
	RegConsoleCmd("cheer", Command_ChooseSpecial);
		
	g_WeaponParent = FindSendPropOffs("CBaseCombatWeapon", "m_hOwnerEntity");
	if (g_WeaponParent == -1)
    {
        SetFailState("[BF] Failed to get weapon parent.");
    }
	g_offsCollisionGroup = FindSendPropOffs("CBaseEntity", "m_CollisionGroup");
	if (g_offsCollisionGroup == -1)
    {
        SetFailState("[BF] Didn't get collision group offset.");
    }
	
	//Rocket launcher
	hGameCfg = LoadGameConfigFile("css.missile");
	StartPrepSDKCall(SDKCall_Entity);
	PrepSDKCall_SetFromConf(hGameCfg, SDKConf_Virtual, "Detonate");
	hDetonate = EndPrepSDKCall();
    StartPrepSDKCall(SDKCall_GameRules);
	
	hDamage = CreateConVar("missile_damage", "100.0", "Sets the maximum amount of damage the missiles can do", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 1.0);
	hRadius = CreateConVar("missile_radius", "350.0", "Sets the explosive radius of the missiles", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 1.0);
	hSpeed = CreateConVar("missile_speed", "500.0", "Sets the speed of the missiles", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 100.0 ,true, 10000.0);
	hType = CreateConVar("missile_type", "0", "type of missile to use, 0 = dumb missiles, 1 = homing missiles, 2 = crosshair guided", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 2.0);
	hEnable = CreateConVar("missile_enable", "1", "1 enables plugin, 0 disables plugin", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 1.0);
	hReplace = CreateConVar("missile_replace", "1", "replace this weapon with missiles, 0 = grenade, 1 = flashbang, 2 = smoke", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 2.0);
	hTeam = CreateConVar("missile_team", "0", "which team can use missiles, 0 = any, 1 = only terrorists, 2 = only counter terrorists", FCVAR_PLUGIN|FCVAR_NOTIFY|FCVAR_REPLICATED, true, 0.0, true, 2.0);
	
	g_Cvar_tntAmount   = CreateConVar("sm_tnt_amount", "3", " Number of tnt packs per player at spawn (max 10)", FCVAR_PLUGIN);
	//	g_Cvar_Admins      = CreateConVar("sm_tnt_admins", "0", " Allow Admins only to use tnt", FCVAR_PLUGIN);
	g_Cvar_Enable      = CreateConVar("sm_tnt_enabled", "1", " Enable/Disable the TNT plugin", FCVAR_PLUGIN);
	g_Cvar_Delay       = CreateConVar("sm_tnt_delay", "3.0", " Delay between spawning and making tnt available", FCVAR_PLUGIN);
	//	g_Cvar_Restrict    = CreateConVar("sm_tnt_restrict", "0", " Class to restrict TNT to (see forum thread)", FCVAR_PLUGIN);
	g_Cvar_Mode        = CreateConVar("sm_tnt_mode", "0", " Detonation mode: 0=radio 1=crosshairs 2=timer", FCVAR_PLUGIN);
	g_Cvar_tntDetDelay = CreateConVar("sm_tnt_det_delay", "0.5", " Detonation delay", FCVAR_PLUGIN);
	g_Cvar_PlantDelay  = CreateConVar("sm_tnt_plant_delay", "1", " Delay between planting TNT", FCVAR_PLUGIN);
	
	NadeRadius = GetConVarFloat(hRadius);
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

CleanUp()
{
	new maxent = GetMaxEntities(), String:name[64];
	for (new i=GetMaxClients();i<maxent;i++)
	{
		if ( IsValidEdict(i) && IsValidEntity(i) )
		{
			GetEdictClassname(i, name, sizeof(name));
			if ( ( StrContains(name, "weapon_") != -1 || StrContains(name, "item_") != -1 ) && GetEntDataEnt2(i, g_WeaponParent) == -1 )
				RemoveEdict(i);
		}
	}
}

public Action:RemoveRagdoll(Handle:timer, any:client)
{
	//Initialize:
	if(IsValidEntity(ragdollIndex[client]))
	{
		RemoveEdict(ragdollIndex[client]);
		ragdollIndex[client] = -1;
	}
}

public Action:Command_ChooseSpecial(client, args)
{
	if (GetClientTeam(client) != 1 && IsPlayerAlive(client))
	{
		if (classIndex[client] == SNIPER)
			tnt(client);
		else if (classIndex[client] == MEDIC)
		{
			if (canDropKit[client])
			{
				CreateKit(client);
				canDropKit[client] = false;
				CreateTimer(5.0, resetKit, client);
			}
			else
				PrintToChat(client, "[BF] You cannot drop a kit at the moment.");
			
			if (classIndex[client] == MEDIC)
				CommandRevive(client);
		}
		else if (classIndex[client] == SUPPORT)
		{
			if (canDropKit[client])
			{
				CreateKit(client);
				canDropKit[client] = false;
				CreateTimer(5.0, resetKit, client);
			}
			else
				PrintToChat(client, "[BF] You cannot drop a kit at the moment.");
		}
		else if (classIndex[client] == ENGINEER)
		{
			if (rocketAmount[client] > 0 && canShootRocket[client])
			{
				CreateGrenadeClient(client);
				rocketAmount[client]--;
				canShootRocket[client] = false;
				CreateTimer(3.5, resetRocket, client);
				PrintToChat(client, "[SM] Rockets left: %i", rocketAmount[client]);
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

public Action:resetKit(Handle:timer, any:client)
{
	canDropKit[client] = true;
}

public OnPluginEnd() 
{
	KillTimer(kitTimer);
	kitTimer = INVALID_HANDLE;
}

public OnEventShutdown()
{
	UnhookEvent("player_death", PlayerDeath);
	UnhookEvent("player_spawn",PlayerSpawn);
	UnhookEvent("round_start", RoundStart);
	UnhookEvent("round_end", RoundEnd);
	
	UnhookEntityOutput("prop_physics", "OnTakeDamage", TakeDamage);
	UnhookEntityOutput("prop_physics", "OnBreak", Break);
}


public RoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	for (new x = 1; x < maxPlayers + 1; x++)
	{
		if (kitArray[x] == 0)
			kitArray[x] = -1;
	
		if (kitArray[x] != -1)
		{
			RemoveEdict(kitArray[x]);
			kitArray[x] = -1;
		}
	}
}

public RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{	
	for (new x = 1; x < MAXPLAYERS; x++)
	{
		if (!IsValidEdict(x))
			continue;
			
		if (classIndex[x] == ASSAULT && IsPlayerAlive(x))
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
		NadeDamage = StringToFloat(newVal);
	}
	
	else if (cvar == hRadius)
	{
		NadeRadius = StringToFloat(newVal);
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

public OnMapStart()
{	
	AddDownload();
	//Rocket stuff
	new Float:WorldMinHull[3], Float:WorldMaxHull[3];
	GetEntPropVector(0, Prop_Send, "m_WorldMins", WorldMinHull);
	GetEntPropVector(0, Prop_Send, "m_WorldMaxs", WorldMaxHull);
	
	PrecacheModel("models/weapons/w_missile_closed.mdl");
	PrecacheModel("models/items/boxmrounds.mdl");
	PrecacheModel("models/props_c17/doll01.mdl");
	PrecacheModel("models/props/slow/bluetube/slow_bluetube.mdl");
	PrecacheModel("models/items/healthkit.mdl");
	PrecacheSound("notdelite/classes/rocket1.wav");
	PrecacheSound("notdelite/classes/revive.wav");
	PrecacheSound("notdelite/classes/grenadelauncher.wav");
	
	HookEvent("player_death", PlayerDeath);
	HookEvent("player_spawn",PlayerSpawn);
	HookEvent("player_say", Event_PlayerSay, EventHookMode_Pre);
	
	if (GetConVarInt(g_Cvar_Enable))
	{		
		HookEntityOutput("prop_physics", "OnTakeDamage", TakeDamage);
		HookEntityOutput("prop_physics", "OnBreak", Break);
		
		g_ent_location_offset = FindSendPropOffs("CCSPlayer", "m_vecOrigin");
		
		g_TNTModel = "models/weapons/w_c4_planted.mdl";
		PrecacheModel(g_TNTModel, true);
		
		PrecacheSound("weapons/c4/c4_plant.wav", true);
		strcopy(g_plant_sound, sizeof(g_plant_sound), "weapons/c4/c4_plant.wav");
	}
	maxPlayers = GetMaxClients();
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client;
	client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (classIndex[client] != classIndexPre[client])
	{
		classIndex[client] = classIndexPre[client];
		
		if (kitArray[client] == 0)
			kitArray[client] = -1;
			
		if (kitArray[client] != -1)
		{
			if (IsValidEdict(kitArray[client]))
			{
				RemoveEdict(kitArray[client]);
				kitArray[client] = -1;
			}
		}
	}
	
	tntAmount[client] = 3;
	rocketAmount[client] = 3;
	grenadeAmount[client] = 3;
	canShootRocket[client] = true;
	canShootGrenade[client] = true;
	canDropKit[client] = true;
	
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
	
	CreateTimer(15.0, RemoveRagdoll, victimid);

	CleanUp();
	
	return Plugin_Continue;
}

CommandRevive(client)
{
	new Float:playerVec[3];
	new Float:ragdollVec[3];
	new String:name[25];
	GetClientAbsOrigin(client, playerVec);
	new clientTeam = GetClientTeam(client);
	
	for (new x = 1; x < maxPlayers + 1; x++)
	{
		if (!IsValidEdict(x))
			continue;
			
		if (IsPlayerAlive(x))
			continue;
			
		if (ragdollIndex[x] == -1)
			continue;
			
		GetEntPropVector(ragdollIndex[x], Prop_Send, "m_vecOrigin", ragdollVec);
		if (GetClientTeam(x) == clientTeam)
		{
			if (ragdollVec[0] > playerVec[0] - REVIVERADIUS && ragdollVec[0] < playerVec[0] + REVIVERADIUS && ragdollVec[1] > playerVec[1] - REVIVERADIUS && ragdollVec[1] < playerVec[1] + REVIVERADIUS)
			{
				//Collision is done for ZombieHell so that players don't get stuck.
				SetEntData(client, g_offsCollisionGroup, 2, 4, true);
				CS_RespawnPlayer(x);
				CreateTimer(0.5, RemoveCollision, x);
				CreateTimer(2.0, AddCollision, x);
				CreateTimer(2.0, AddCollision, client);
				
				TeleportEntity(x, playerVec, NULL_VECTOR, NULL_VECTOR);
				RemoveEdict(ragdollIndex[x]);
				ragdollIndex[x] = -1;
				GetClientName(client, name, sizeof(name));
				EmitSoundToAll("notdelite/classes/revive.wav", client, SNDCHAN_AUTO, 100);
				PrintCenterText(x, "You have been revived by: %s", name);
				break;
			}
		}
	}
	return 0;
}

public Action:AddCollision(Handle:timer, any:client)
{
	SetEntData(client, g_offsCollisionGroup, 5, 4, true);
}

public Action:RemoveCollision(Handle:timer, any:client)
{
	SetEntData(client, g_offsCollisionGroup, 2, 4, true);
}

CreateKit(client)
{
	new Float:vec[3];
	GetClientAbsOrigin(client, vec);
	
	if (kitArray[client] == 0)
		kitArray[client] = -1;
		
	if (kitArray[client] != -1)
	{
		if (IsValidEdict(kitArray[client]))
		{
			RemoveEdict(kitArray[client]);
			kitArray[client] = -1;
		}
	}
	
	
	if (classIndex[client] == MEDIC)
	{
		kitArray[client] = CreateEntityByName("prop_dynamic_override");
		DispatchKeyValue(kitArray[client], "solid","0");
		DispatchKeyValue(kitArray[client], "model", "models/items/healthkit.mdl");
		DispatchSpawn(kitArray[client]);
		SetEntPropEnt(kitArray[client], Prop_Send, "m_hOwnerEntity", client);
		TeleportEntity(kitArray[client], vec, NULL_VECTOR, NULL_VECTOR);
	}
	else if (classIndex[client] == SUPPORT)
	{
		kitArray[client] = CreateEntityByName("prop_dynamic_override");
		DispatchKeyValue(kitArray[client], "solid","0");
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
						if (IsValidEdict(kitIndex))
						{
							RemoveEdict(kitIndex);
							kitArray[kitOwner] = -1;
						}
					}
				}
				else
				{
					ownerTeam = GetClientTeam(kitOwner);
					GetEntPropVector(kitIndex, Prop_Data, "m_vecOrigin", origin);
					PrintToServer("Origin %f %f %f", origin[0], origin[1], origin[2]);
					for (new x = 1; x < maxPlayers + 1; x++)
					{
						if (IsValidEdict(x))
						{
							if (!IsClientInGame(x))
								continue;
						
							if (!IsPlayerAlive(x))
								continue;

							if (ownerTeam != GetClientTeam(x))
								continue;

							GetClientAbsOrigin(x, targetVec);
							
							if (GetVectorDistance(origin, targetVec) < 200)
							{
								if (classIndex[kitOwner] == MEDIC)
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
								else if (classIndex[kitOwner] == SUPPORT)
								{
									PrintToServer("Client should be getting ammo");

								}
							}
						}
					}
				}
			}
		}
	}
}




public OnClientDisconnect(client)
{
	classIndex[client] = 0;
	
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
	classIndex[client] = 0;
	
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
		GetEntDataVector(ent, g_ent_location_offset, tnt_pos);
		TE_SetupEnergySplash(tnt_pos, NULL_VECTOR, true);
		TE_SendToAll(0.1);
		
		GetEdictClassname(ent, classname, sizeof(classname));
		if (StrEqual(classname, "prop_physics", false))
		{
			RemoveEdict(ent);
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
							PrintToChat(client, "[SM] Too far away to plant");
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
							PrintToChat(client, "[SM] Mines left: %i", tntAmount[client]);
							
							EmitSoundToAll(g_plant_sound, ent, _, _, _, 0.8);
							
							CreateTimer(5.0, Prime, ent);
							CreateTimer(GetConVarFloat(g_Cvar_PlantDelay), AllowPlant, client);
							g_can_plant[client] = false;
						}
					}
					else
					{
						PrintToChat(client, "[SM] No mines left");
					}
				}
			}
		}
		else
		{
			PrintToChat(client, "[SM] TNT unavailable.  Please wait....");
		}
	}
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
		GetEntDataVector(entity, g_ent_location_offset, tnt_pos);
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
	
	new Float:NadePos[3];
	GetEntPropVector(caller, Prop_Send, "m_vecOrigin", NadePos);
	
	new NadeIndex = CreateEntityByName("hegrenade_projectile");
	if (NadeIndex != -1)
	{
		DispatchSpawn(NadeIndex);
		NadePos[2] += 20;
		TeleportEntity(NadeIndex, NadePos, NULL_VECTOR, NULL_VECTOR);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity", client);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hThrower", client);
		SetEntProp(NadeIndex, Prop_Send, "m_iTeamNum", GetClientTeam(client));
		DetonateGrenade(NadeIndex);
	}
	
	AcceptEntityInput(caller,"kill");
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
		GetEntDataVector(tnt_entity[owner][tntpack], g_ent_location_offset, tnt_pos);
		new Float:targetVector[3];
		GetClientAbsOrigin(client, targetVector);
		
		new Float:distance = GetVectorDistance(targetVector, tnt_pos);
		
		if (pack_primed[owner][tntpack])
		{
			if (distance > 100)
			{
				PrintToChat(client, "[SM] Too far away to defuse");
			}
			else
			{
				CreateTimer(2.0, RemoveTNT, tnt_entity[owner][tntpack]);
				tnt_entity[client][tntpack] = 0;
				
				tntAmount[client]++;
				
				if (tntAmount[client] >= GetConVarInt(g_Cvar_tntAmount))
					tntAmount[client] = GetConVarInt(g_Cvar_tntAmount);
				
				PrintToChat(client, "[SM] TNT left: %i", tntAmount[client]);
				PrintToChat(owner, "[SM] TNT pack defused");
			}
		}
		else
		{
			PrintToChat(client, "[SM] Cannot be defused yet...");
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
					PrintToChat(client, "[SM] This is not your TNT pack");
				}
				else
				{
					AcceptEntityInput(tnt_entity[owner][tntpack], "break");
				}
			}
			else
			{
				PrintToChat(client, "[SM] Still priming...Cannot be detonated yet...");
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

public Action:KillExplosion(Handle:timer, any:ent)
{
	if (IsValidEntity(ent))
	{
		new String:classname[256];
		GetEdictClassname(ent, classname, sizeof(classname));
		if (StrEqual(classname, "env_explosion", false))
		{
			RemoveEdict(ent);
		}
	}
}

public Action:NadeLoop(Handle:timer)
{
	new NadeIndex = -1;
	while ((NadeIndex = FindEntityByClassname(NadeIndex, "flashbang_projectile")) != -1)
	{		
		decl Float:NadePos[3];
		GetEntPropVector(NadeIndex, Prop_Send, "m_vecOrigin", NadePos);
		
		new client = GetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity");
		decl Float:InitialAng[3];
		
		if (classIndex[client] == ENGINEER)
		{
			if (GetEntityMoveType(NadeIndex) != MOVETYPE_FLY)
			{
				SetEntProp(NadeIndex, Prop_Data, "m_nNextThinkTick", -1);
				SetEntityModel(NadeIndex, "models/weapons/w_missile_closed.mdl");
				SetEntPropVector(NadeIndex, Prop_Data, "m_vecAngVelocity", SpinVel);
				
				new NadeOwner = GetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity");
				decl Float:OwnerAng[3];
				GetClientEyeAngles(NadeOwner, OwnerAng);
				decl Float:OwnerPos[3];
				GetClientEyePosition(NadeOwner, OwnerPos);
				TR_TraceRayFilter(OwnerPos, OwnerAng, MASK_SOLID, RayType_Infinite,  RayDontHitOwnerOrNade, NadeIndex);
				decl Float:InitialPos[3];
				TR_GetEndPosition(InitialPos);
				decl Float:InitialVec[3];
				MakeVectorFromPoints(NadePos, InitialPos, InitialVec);
				NormalizeVector(InitialVec, InitialVec);
				ScaleVector(InitialVec, NadeSpeed);
				InitialVec[0] *= 2;
				InitialVec[1] *= 2;
				InitialVec[2] *= 2;
				
				GetVectorAngles(InitialVec, InitialAng);
				TeleportEntity(NadeIndex, NULL_VECTOR, InitialAng, InitialVec);
				
				//EmitSoundToAll("notdelite/classes/rocket1.wav", NadeIndex, SNDCHAN_AUTO, 75);
				
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
		else if (classIndex[client] == ASSAULT)
		{
			if (GetEntityMoveType(NadeIndex) == MOVETYPE_FLY)
			{
				SetEntProp(NadeIndex, Prop_Data, "m_nNextThinkTick", -1);
				CreateTimer(0.1, SetGrenadeLauncher, NadeIndex);
				SetEntPropVector(NadeIndex, Prop_Data, "m_vecAngVelocity", SpinVel);
				SetEntityModel(NadeIndex, "models/weapons/w_missile_closed.mdl");
				new NadeOwner = GetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity");
				decl Float:OwnerAng[3];
				GetClientEyeAngles(NadeOwner, OwnerAng);
				decl Float:OwnerPos[3];
				GetClientEyePosition(NadeOwner, OwnerPos);
				TR_TraceRayFilter(OwnerPos, OwnerAng, MASK_SOLID, RayType_Infinite,  RayDontHitOwnerOrNade, NadeIndex);
				decl Float:InitialPos[3];
				TR_GetEndPosition(InitialPos);
				decl Float:InitialVec[3];
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
			{
				return Plugin_Continue;
			}
			
			//StopSound(entity, SNDCHAN_AUTO, "notdelite/classes/rocket1.wav");
			DetonateGrenade(entity);
			return Plugin_Handled;
		}
	}
	if (StrEqual(sample, "weapons/flashbang/grenade_hit1.wav", false))
	{
		if (StrEqual(ReplaceNade, "flashbang_projectile", false))
		{
			new NadeTeam = GetEntProp(entity, Prop_Send, "m_iTeamNum");
			if ((NadeAllowTeam != 1) && (NadeAllowTeam != NadeTeam))
			{
				return Plugin_Continue;
			}
			
			CreateGrenade(entity);
			return Plugin_Handled;
		}
	}
	if (StrEqual(sample, "weapons/smokegrenade/grenade_hit1.wav", false))
	{
		if (StrEqual(ReplaceNade, "smokegrenade_projectile", false))
		{
			new NadeTeam = GetEntProp(entity, Prop_Send, "m_iTeamNum");
			if ((NadeAllowTeam != 1) && (NadeAllowTeam != NadeTeam))
			{
				return Plugin_Continue;
			}
			
			CreateGrenade(entity);
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

CreateGrenade(FlashOrSmokeIndex)
{
	//StopSound(FlashOrSmokeIndex, SNDCHAN_AUTO, "notdelite/classes/rocket1.wav");
	new Float:NadePos[3];
	GetEntPropVector(FlashOrSmokeIndex, Prop_Send, "m_vecOrigin", NadePos);
	new FlashOrSmokeOwner = GetEntPropEnt(FlashOrSmokeIndex, Prop_Send, "m_hOwnerEntity");
	new FlashOrSmokeOwnerTeam = GetEntProp(FlashOrSmokeOwner, Prop_Send, "m_iTeamNum");
	RemoveEdict(FlashOrSmokeIndex);
	new NadeIndex = CreateEntityByName("hegrenade_projectile");
	if (NadeIndex != -1)
	{
		DispatchSpawn(NadeIndex);
		TeleportEntity(NadeIndex, NadePos, NULL_VECTOR, NULL_VECTOR);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hOwnerEntity", FlashOrSmokeOwner);
		SetEntPropEnt(NadeIndex, Prop_Send, "m_hThrower", FlashOrSmokeOwner);
		SetEntProp(NadeIndex, Prop_Send, "m_iTeamNum", FlashOrSmokeOwnerTeam);
		DetonateGrenade(NadeIndex);
	}
}

DetonateGrenade(NadeIndex)
{
	SetEntPropFloat(NadeIndex, Prop_Send, "m_DmgRadius", NadeRadius);
	SetEntPropFloat(NadeIndex, Prop_Send, "m_flDamage", NadeDamage);
	SDKCall(hDetonate, NadeIndex);
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
			RemoveEdict(PreviousIndex);
		}
		PreviousIndex = NadeIndex;
	}
	if (PreviousIndex)
	{
		//StopSound(PreviousIndex, SNDCHAN_AUTO, "notdelite/classes/rocket1.wav");
		RemoveEdict(PreviousIndex);
	}
}

CreateGrenadeClient(client)
{
	new NadeIndex = CreateEntityByName("flashbang_projectile");
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
		if (classIndex[client] == ASSAULT)
			SetEntityMoveType(NadeIndex, MOVETYPE_FLY);
	}
	if (classIndex[client] == ASSAULT)
		EmitSoundToAll("notdelite/classes/grenadelauncher.wav", client, SNDCHAN_AUTO, 75);
}
