//Unique_Compile_String: v2a//

/**
 * ====================
 *	 Zombie Riot
 *   File: zombieriot.sp
 *   Author: Greyscale
 * ==================== 
 */
 
/*
- Removed requirement for notd.games gamedata file.
- Replaced "EyePosition" SDKCall with GetClientEyeAngles native.
- Removed requirement of plugin.zombieriot gamedata file.
- Replaced "RemoveAllItems" SDKCall with a coded alternative.
- Replaced "TerminateRound" SDKCall with the CS_TerminateRound native.
  - Removed hardcoded #defines for round end reasons.
- Removed requirement for plugin.bf gamedata file.
- Replaced "Detonate" SDKCall with a coded alternative.
- Removed several occurances of ServerCommand() being used to issue admin commands to initiate basic gameplay actions such as slaying / respawning / modifying speed.
- Fixed a bug in NotD Classes where an important variable wasn't reset on disconnect.
- Fixed a bug in NotD Classes where the class panel appeared before a client joined a team.
- Fixed a bug in NotD Classes where players were always assumed to be assault class unless selecting something else.
- Made changes to weaponrestrict.inc so that errors are not spammed on compile.

Notes:
- The internal restriction feature doesn't appear to be completed, or it has been disabled in this version. Finishing / repairing the feature would be trivial, but in the interest of not charging for unnecessary work, it has been avoided.
- It seems a large majority of features in NoTD Classes are incomplete or not impliemented. Adding these features would be costly, so only minor maintenance was performed.
- The following features appear to be unfinished:
-   Classes: Equipment unlocks based on kills.
-   Classes: Ability for Engineer to spawn props.
-   Classes: Ability for Snipers to lay trip mines.
-   Classes: Ability for Medic to give ammo.
-   Classes: Ability for Assault to spawn C4.
*/

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

#undef REQUIRE_PLUGIN
#include <market>

#define VERSION "1.9.1"

#include "zriot/zombieriot"
#include "zriot/global"
#include "zriot/cvars"
#include "zriot/translation"
#include "zriot/offsets"
#include "zriot/ambience"
#include "zriot/zombiedata"
#include "zriot/daydata"
#include "zriot/targeting"
#include "zriot/overlays"
#include "zriot/zombie"
#include "zriot/hud"
#include "zriot/sayhooks"
#include "zriot/teamcontrol"
#include "zriot/weaponrestrict"
#include "zriot/commands"
//NotD Includes
#include "zriot/notd/specialzombie"
//End NotD Includes
#include "zriot/event"

public Plugin:myinfo =
{
	name = "Zombie Riot", 
	author = "Greyscale", 
	description = "Humans stick together to fight off zombie attacks", 
	version = VERSION, 
	url = ""
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateGlobals();
	
	return APLRes_Success;
}

public OnPluginStart()
{
	LoadTranslations("common.phrases.txt");
	LoadTranslations("zombieriot.phrases.txt");
	
	// ======================================================================
	
	ZRiot_PrintToServer("Plugin loading");
	
	// ======================================================================
	
	ServerCommand("bot_kick");
	
	// ======================================================================
	
	HookEvents();
	HookChatCmds();
	CreateCvars();
	HookCvars();
	CreateCommands();
	HookCommands();
	FindOffsets();
	InitTeamControl();
	InitWeaponRestrict();
	
	// ======================================================================
	
	trieDeaths = CreateTrie();
	
	// ======================================================================
	
	market = LibraryExists("market");
	
	// ======================================================================
	
	CreateConVar("gs_zombieriot_version", VERSION, "[ZRiot] Current version of this plugin", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_UNLOGGED|FCVAR_DONTRECORD|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	// ======================================================================
	
	ZRiot_PrintToServer("Plugin loaded");
}

public OnPluginEnd()
{
	//NotD Addon
	if (repeatTimer != INVALID_HANDLE) 
		KillTimer(repeatTimer);
	repeatTimer = INVALID_HANDLE;
	if (smokerSpawnTimer != INVALID_HANDLE) 
		KillTimer(smokerSpawnTimer);
	smokerSpawnTimer = INVALID_HANDLE;
	//End NotD Addon
	ZRiotEnd();
}

public OnLibraryRemoved(const String:name[])
{
	if (StrEqual(name, "market"))
	{
		market = false;
	}
}
 
public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "market"))
	{
		market = true;
	}
}

public OnMapStart()
{
	MapChangeCleanup();
	
	LoadModelData();
	LoadDownloadData();
	
	BuildPath(Path_SM, gMapConfig, sizeof(gMapConfig), "configs/zriot");
	
	LoadZombieData(true);
	LoadDayData(true);
	
	CheckMapConfig();
	//NotD Addon
	PrecacheSound("npc/zombie/zombie_alert1.wav", true);
	PrecacheSound("npc/ichthyosaur/snap.wav", true);
	PrecacheSound("player/pl_fallpain3.wav", true);
	PrecacheSound("npc/ichthyosaur/attack_growl3.wav", true);
	PrecacheSound("npc/ichthyosaur/snap.wav", true);
	PrecacheSound("npc/zombie_poison/pz_breathe_loop1.wav", true);
	PrecacheSound("npc/strider/charging.wav", true);
	
	g_Sprite = PrecacheModel("materials/sprites/laser.vmt");
	//g_ExplosionSprite = PrecacheModel("sprites/sprite_fire01.vmt");
	g_FlameHalo = PrecacheModel("sprites/orangeglow1.vtf");
	g_SmokeModel = PrecacheModel("materials/effects/fire_cloud2.vmt");
	PrecacheModel(SMOKERMODEL);
	colorSmoker[0] = 5;
	colorSmoker[1] = 245;
	colorSmoker[2] = 5;
	colorSmoker[3] = 245;
	colorIfrat[0] = 255;
	colorIfrat[1] = 50;
	colorIfrat[2] = 50;
	colorIfrat[3] = 245;
	
}

public OnConfigsExecuted()
{
	UpdateTeams();
	
	FindMapSky();
	FindHostname();
	
	LoadAmbienceData();
	
	decl String:mapconfig[PLATFORM_MAX_PATH];
	
	GetCurrentMap(mapconfig, sizeof(mapconfig));
	Format(mapconfig, sizeof(mapconfig), "sourcemod/zombieriot/%s.cfg", mapconfig);
	
	decl String:path[PLATFORM_MAX_PATH];
	Format(path, sizeof(path), "cfg/%s", mapconfig);
	
	if (FileExists(path))
	{
		ServerCommand("exec %s", mapconfig);
	}
}

public OnClientPutInServer(client)
{
	new bool:fakeclient = IsFakeClient(client);
	
	InitClientDeathCount(client);
	
	new deathcount = GetClientDeathCount(client);
	new deaths_before_zombie = GetDayDeathsBeforeZombie(gDay);
	
	bZombie[client] = !fakeclient ? ((deaths_before_zombie > 0) && (fakeclient || (deathcount >= deaths_before_zombie))) : true;
	
	bZVision[client] = !IsFakeClient(client);
	
	gZombieID[client] = -1;
	
	gTarget[client] = -1;
	RemoveTargeters(client);
	
	tRespawn[client] = INVALID_HANDLE;
	
	ClientHookUse(client);
	
	FindClientDXLevel(client);
}

public OnClientDisconnect(client)
{
	if (!IsPlayerHuman(client))
		return;
	
	new count;
	
	new maxplayers = GetMaxClients();
	for (new x = 1; x <= maxplayers; x++)
	{
		if (!IsClientInGame(x) || !IsPlayerHuman(x) || GetClientTeam(x) <= CS_TEAM_SPECTATOR)
			continue;
		
		count++;
	}
	
	if (count <= 1 && tHUD != INVALID_HANDLE)
	{
		TerminateRound(5.0, CSRoundEnd_TerroristWin);
	}
}

MapChangeCleanup()
{
	gDay = 0;
	
	ClearArray(restrictedWeapons);
	ClearTrie(trieDeaths);
	
	tAmbience = INVALID_HANDLE;
	tHUD = INVALID_HANDLE;
	tFreeze = INVALID_HANDLE;
}

CheckMapConfig()
{
	decl String:mapname[64];
	GetCurrentMap(mapname, sizeof(mapname));
	
	Format(gMapConfig, sizeof(gMapConfig), "%s/%s", gMapConfig, mapname);
	
	LoadZombieData(false);
	LoadDayData(false);
}

ZRiotEnd()
{
	TerminateRound(3.0, CSRoundEnd_GameStart);
	
	SetHostname(hostname);
	
	UnhookCvars();
	UnhookEvents();
	
	ServerCommand("bot_all_weapons");
	//ServerCommand("bot_kick");
	
	new maxplayers = GetMaxClients();
	for (new x = 1; x <= maxplayers; x++)
	{
		if (!IsClientInGame(x))
		{
			continue;
		}
		
		if (tRespawn[x] != INVALID_HANDLE)
		{
			CloseHandle(tRespawn[x]);
			tRespawn[x] = INVALID_HANDLE;
		}
	}
}