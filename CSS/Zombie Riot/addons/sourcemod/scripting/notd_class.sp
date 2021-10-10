//Created by: [NotD] l0calh0st
//Website: www.notdelite.com

//Includes:
#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0.0"
#define ASSAULT 1
#define MEDIC 2
#define ENGINEER 3
#define SNIPER 4
#define SUPPORT 5

static bool:prethinkBuffer[MAXPLAYERS + 1];
static Float:clientPosition[MAXPLAYERS + 1][3];
static Float:targetPosition[MAXPLAYERS + 1][3];
static targetEnt[MAXPLAYERS + 1];
static bool:isInHealing[MAXPLAYERS + 1];
static bool:isInSupply[MAXPLAYERS + 1];
static targetHP[MAXPLAYERS + 1];
static classIndex[MAXPLAYERS + 1];
static classIndexPre[MAXPLAYERS + 1];
static bool:askSound[MAXPLAYERS + 1];

new Handle:repeatTimer = INVALID_HANDLE;
new MaxPlayers;

//Effects
new g_BeamSprite;
new g_HaloSprite;
new greenColor[4] = {0, 200, 0, 255};
new blueColor[4] = {0, 0, 255, 255};
new redColor[4] = {200, 0, 0, 255};

public Plugin:myinfo = 
{
	name = "NotD Classes",
	author = "[NotD] l0calh0st",
	description = "Allows class-like features in CS:S",
	version = PLUGIN_VERSION,
	url = "http://www.notdelite.com"
};

public OnPluginStart()
{
	CreateConVar("notd_class_version", PLUGIN_VERSION, "Version of the NotD Class", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	HookEvent("player_spawn",PlayerSpawn);
	HookEvent("player_say", PlayerSay, EventHookMode_Pre);
	repeatTimer = CreateTimer(1.0, AskSound, _, TIMER_REPEAT);
}

public OnPluginEnd()
{
	if (repeatTimer != INVALID_HANDLE)
		KillTimer(repeatTimer);
	repeatTimer = INVALID_HANDLE;
}

public Action:AskSound(Handle:timer)
{
	for (new client = 1; client < MaxPlayers; client++)
	{
		if (!IsValidEdict(client))
			continue;
		
		if (!IsClientInGame(client))
			continue;
			
		if (!IsPlayerAlive(client))
			continue;
		
		if (GetClientTeam(client) != 3)
			continue;
		
		SetEntityRenderMode(client, RENDER_TRANSCOLOR);
		
		if (GetClientHealth(client) < 20)
		{
			if (askSound[client] == false)
			{
				EmitSoundToAll("vo/npc/male01/imhurt02.wav", client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 1.0);
				askSound[client] = true;
				SetEntityRenderColor(client, 255, 100, 100, 255);
			}
		}
	}
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client;
	client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (classIndex[client] != classIndexPre[client] && classIndexPre[client] != 0)
	{
		classIndex[client] = classIndexPre[client];
	}
	
	if (classIndex[client] == 0)
		Panel_ClassMenu(client);
		
	//Class Related Spawning
	if (classIndex[client] == ASSAULT && IsPlayerAlive(client))
		SetSpeed(client, 1.2);
	else if (classIndex[client] == SUPPORT && IsPlayerAlive(client))
		GivePlayerItem(client, "weapon_m249");
}

public Action:PlayerSay(Handle:event, const String:name[], bool:dontBroadcast) 
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if (client == 0)
		return;
	
	new String:text[192];
	
	GetEventString(event, "text", text, 191);
	if (StrEqual(text, "!class"))
		Panel_ClassMenu(client);
}

public OnMapStart()
{
	MaxPlayers = GetMaxClients();
	
	g_BeamSprite = PrecacheModel("materials/sprites/laser.vmt", true); 
	g_HaloSprite = PrecacheModel("materials/sprites/halo01.vmt", true);
	
	for (new i = 1; i <= MaxPlayers; i++)
	{
		targetEnt[i] = -1;
		askSound[i] = false;
	}
	
	PrecacheSound("vo/npc/male01/ammo04.wav");
	PrecacheSound("vo/npc/male01/health05.wav");
	PrecacheSound("vo/npc/male01/imhurt02.wav");
}

public OnGameFrame()
{
	//Loop:
	for (new client = 1; client <= MaxPlayers; client++)
	{
		//Connected and alive:
		if (IsClientInGame(client) && IsPlayerAlive(client))
		{
			//Use Key:
			if (GetClientButtons(client) & IN_USE)
			{
				//Overflow:
				if (!prethinkBuffer[client])
				{
					//Action:
					CommandUse(client);
					
					//UnHook:
					prethinkBuffer[client] = true;
				}
			}
			else
				prethinkBuffer[client] = false;
		}
	}
}

CommandUse(client)
{
	//Initialize:
	new target = GetClientAimTarget(client);
	
	if (target < 1)
		return;
	
	if (classIndex[client] == MEDIC)
	{
		if (targetEnt[client] > 0)
		{
			if (target != targetEnt[client])
				PrintToChat(client, "[NotD] You can only heal one person at a time.");
			else
				PrintToChat(client, "[NotD] You are already healing %N.", target);
			
			return;
		}
		
		if (GetClientTeam(client) == GetClientTeam(target))
		{
			targetEnt[client] = target;
			EmitSoundToAll("vo/npc/male01/health05.wav", client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 1.0);
			CreateTimer(0.5, CommandMedic, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	else if (classIndex[client] == SUPPORT)
	{
		if (targetEnt[client] > 0)
		{
			if (target != targetEnt[client])
				PrintToChat(client, "[NotD] You can only supply to one person at a time.");
			else
				PrintToChat(client, "[NotD] You are already supplying %N.", target);
			
			return;
		}
		
		if (GetClientTeam(client) == GetClientTeam(target))
		{
			targetEnt[client] = target;
			EmitSoundToAll("vo/npc/male01/ammo04.wav", client, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 1.0);
			CreateTimer(0.5, CommandSupport, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action:CommandMedic(Handle:Timer, any:client)
{
	if (!IsClientInGame(client) || !IsClientInGame(targetEnt[client]) || !IsPlayerAlive(client) || !IsPlayerAlive(targetEnt[client]))
	{
		isInHealing[client] = false;
		targetEnt[client] = -1;
		return Plugin_Handled;
	}
	
	GetClientAbsOrigin(client, clientPosition[client]);
	GetClientAbsOrigin(targetEnt[client], targetPosition[targetEnt[client]]);
	new Float:distance = GetVectorDistance(clientPosition[client], targetPosition[targetEnt[client]]);
	
	//Initial
	if (!isInHealing[client])
	{
		if (distance < 200.0)
		{
			targetHP[targetEnt[client]] = GetClientHealth(targetEnt[client]);
			
			if (targetHP[targetEnt[client]] < 100)
			{
				if (targetHP[targetEnt[client]] > 20)
				{
					askSound[targetEnt[client]] = false;
					SetEntityRenderColor(client, 255, 255, 255, 255);
				}
				PrintToChat(client, "[NotD] You are now healing %N. Healing will occur as long as %N is within range", targetEnt[client], targetEnt[client]);
				SetEntityHealth(targetEnt[client], targetHP[targetEnt[client]] + 2);
				clientPosition[client][2] += 10.0;
				TE_SetupBeamRingPoint(clientPosition[client], 10.0, 400.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, greenColor, 10, 0);
				TE_SendToAll();
				targetPosition[targetEnt[client]][2] += 10.0;
	  			TE_SetupBeamRingPoint(targetPosition[targetEnt[client]], 400.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, blueColor, 10, 0);
				TE_SendToAll();
				PrintToChat(client, "[NotD] %N's health: %d", targetEnt[client], targetHP[targetEnt[client]]);
				isInHealing[client] = true;
				CreateTimer(1.0, CommandMedic, client, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				if (targetHP[targetEnt[client]] > 100)
				{
					SetEntityHealth(targetEnt[client], 100);
				}
				
				isInHealing[client] = false;
				PrintToChat(client, "[NotD] %N has full health.", targetEnt[client]);
				targetEnt[client] = -1;
			}
		}
		else
			targetEnt[client] = -1;
	}
	else	//Subsequent
	{
		if (distance < 200.0)
		{
			targetHP[targetEnt[client]] = GetClientHealth(targetEnt[client]);
			
			if (targetHP[targetEnt[client]] < 100)
			{
				if (targetHP[targetEnt[client]] > 20)
				{
					askSound[targetEnt[client]] = false;
				}
				SetEntityHealth(targetEnt[client], targetHP[targetEnt[client]] + 2);
				clientPosition[client][2] += 10.0;
				TE_SetupBeamRingPoint(clientPosition[client], 10.0, 100.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, greenColor, 10, 0);
				TE_SendToAll();
				targetPosition[targetEnt[client]][2] += 10.0;
	  			TE_SetupBeamRingPoint(targetPosition[targetEnt[client]], 100.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, blueColor, 10, 0);
				TE_SendToAll();
				PrintToChat(client, "[NotD] %N's health: %d", targetEnt[client], targetHP[targetEnt[client]]);
				CreateTimer(1.0, CommandMedic, client, TIMER_FLAG_NO_MAPCHANGE);
			}
			else
			{
				if (targetHP[targetEnt[client]] > 100)
					SetEntityHealth(targetEnt[client], 100);
				
				isInHealing[client] = false;
				PrintToChat(client, "[NotD] %N has full health.", targetEnt[client]);
				targetEnt[client] = -1;
			}
		}
		else
		{
			isInHealing[client] = false;
			PrintToChat(client, "[NotD] %N is out of range, healing stopped.", targetEnt[client]);
			targetEnt[client] = -1;
		}
	}
	return Plugin_Handled;
}

public Action:CommandSupport(Handle:Timer, any:client)
{
	if (!IsClientInGame(client) || !IsClientInGame(targetEnt[client]) || !IsPlayerAlive(client) || !IsPlayerAlive(targetEnt[client]))
	{
		isInSupply[client] = false;
		targetEnt[client] = -1;
		return Plugin_Handled;
	}
	
	GetClientAbsOrigin(client, clientPosition[client]);
	GetClientAbsOrigin(targetEnt[client], targetPosition[targetEnt[client]]);
	new Float:distance = GetVectorDistance(clientPosition[client], targetPosition[targetEnt[client]]);
	
	//Initial
	if (!isInSupply[client])
	{
		if (distance < 200.0)
		{
			GiveAmmo(targetEnt[client]);
			clientPosition[client][2] += 10.0;
			TE_SetupBeamRingPoint(clientPosition[client], 10.0, 100.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, redColor, 10, 0);
			TE_SendToAll();
			targetPosition[targetEnt[client]][2] += 10.0;
			TE_SetupBeamRingPoint(targetPosition[targetEnt[client]], 100.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, greenColor, 10, 0);
			TE_SendToAll();
			PrintToChat(client, "[NotD] %N has been given ammo.", targetEnt[client]);
			isInSupply[client] = true;
			CreateTimer(1.0, CommandSupport, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			isInSupply[client] = false;
			targetEnt[client] = -1;
		}
	}
	else	//Subsequent
	{
		if (distance < 200.0)
		{
			GiveAmmo(targetEnt[client]);
			clientPosition[client][2] += 10.0;
			TE_SetupBeamRingPoint(clientPosition[client], 10.0, 100.0, g_BeamSprite, g_HaloSprite, 0, 15, 0.5, 5.0, 0.0, redColor, 10, 0);
			TE_SendToAll();
			targetPosition[targetEnt[client]][2] += 10.0;
			TE_SetupBeamRingPoint(targetPosition[targetEnt[client]], 100.0, 10.0, g_BeamSprite, g_HaloSprite, 0, 10, 0.5, 10.0, 0.5, greenColor, 10, 0);
			TE_SendToAll();
			PrintToChat(client, "[NotD] %N has been given ammo.", targetEnt[client]);
			CreateTimer(1.0, CommandSupport, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			isInSupply[client] = false;
			PrintToChat(client, "[NotD] %N is out of range, supplying stopped.", targetEnt[client]);
			targetEnt[client] = -1;
		}
	}
	return Plugin_Handled;
}

public ClassMenuHandler(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select)
	{
		if (param2 == 1)
		{
			if (classIndex[param1] == 0)
			{
				classIndex[param1] = ASSAULT;
				SetSpeed(param1, 1.2);
				PrintToChat(param1, "[NotD] You have selected Assault. Enjoy your swiftness.");
			}
			else
			{
				classIndexPre[param1] = ASSAULT;
				PrintToChat(param1, "[NotD] You have selected Marine. Enjoy your swiftness. You will respawn as this class.");
			}
		}
		else if (param2 == 2)
		{
			if (classIndex[param1] == 0)
			{
				classIndex[param1] = MEDIC;
				PrintToChat(param1, "[NotD] You have selected Medic. Press 'E' or +USE to heal players.");
			}
			else
			{
				classIndexPre[param1] = MEDIC;
				PrintToChat(param1, "[NotD] You have selected Medic. Press 'E' or +USE to heal players. You will respawn as this class.");
			}
		}
		else if (param2 == 3)
		{
			if (classIndex[param1] == 0)
			{
				classIndex[param1] = SNIPER;
				PrintToChat(param1, "[NotD] You have selected Sniper. You have access to all the sniper weapons.");
			}
			else
			{
				classIndexPre[param1] = SNIPER;
				PrintToChat(param1, "[NotD] You have selected Sniper. You have access to all the sniper weapons. You will respawn as this class.");
			}
		}
		else if (param2 == 4)
		{
			if (classIndex[param1] == 0)
			{
				classIndex[param1] = SUPPORT;
				PrintToChat(param1, "[NotD] You have selected Support. Press 'E' or +USE to give ammo to players.");
			}
			else
			{
				classIndexPre[param1] = SUPPORT;
				PrintToChat(param1, "[NotD] You have selected Support. Press 'E' or +USE to give ammo to players. You will respawn as this class.");
			}
		}
	}
}

public Panel_ClassMenu(client)
{
	new Handle:panel = CreatePanel();
	SetPanelTitle(panel, "Class Menu");
	DrawPanelItem(panel, "Assault [Speed]");
	DrawPanelItem(panel, "Medic [Healing]");
	DrawPanelItem(panel, "Sniper [Snipers]");
	DrawPanelItem(panel, "Support [M249|AMMO]");
	DrawPanelItem(panel, "Exit");
	SendPanelToClient(panel, client, ClassMenuHandler, 0);
	
	CloseHandle(panel);
}

public OnClientDisconnect(client)
{
	classIndex[client] = 0;
	askSound[client] = false;
	if ( IsClientInGame(client) ) 
    { 
        SDKUnhook(client, SDKHook_WeaponEquip, OnWeaponEquip); 
    } 
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

public GiveAmmo(client)
{
	new weaponid;
	new String:weaponname[25];
	weaponid = GetPlayerWeaponSlot(client, 0);
	if (weaponid > 0)
	{
		GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
		SetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname)) + 5);
	}
	
	weaponid = GetPlayerWeaponSlot(client, 1);
	if (weaponid > 0)
	{
		GetEdictClassname(weaponid, weaponname, sizeof(weaponname));
		SetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname), GetWeaponAmmo(client, GetWeaponAmmoOffset(weaponname)) + 5);
	}
}

stock SetSpeed(client, Float:speed)
{
	SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", speed);
}

public OnClientPutInServer(client) 
{ 
    SDKHook(client, SDKHook_WeaponEquip, OnWeaponEquip);
} 

public Action:OnWeaponEquip(client, weapon) 
{ 
    decl String:weaponName[32]; 
    GetEdictClassname(weapon, weaponName, sizeof(weaponName)); 
     
    if (StrEqual(weaponName, "weapon_m249") && classIndex[client] != SUPPORT) 
    { 
		PrintToChat(client, "[NotD] You must be 'SUPPORT' class to equip a M249.");
        return Plugin_Handled; 
    }
	if (StrEqual(weaponName, "weapon_awp") || StrEqual(weaponName, "weapon_scout") ||
	    StrEqual(weaponName, "weapon_sg550") || StrEqual(weaponName, "weapon_g3sg1"))
	{
		if (classIndex[client] != SNIPER)
		{
			PrintToChat(client, "[NotD] You must be 'SNIPER' class to equip sniper weapons.");
			return Plugin_Handled;
		}
	}
     
    return Plugin_Continue; 
}  