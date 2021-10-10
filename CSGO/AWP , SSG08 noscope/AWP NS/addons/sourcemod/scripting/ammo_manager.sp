/**
* Ammo Manager by Root
*
* Description:
*   Allows to setup different clips/reserved ammo for any weapons as well as enabling ammo replenishment and realistic reload.
*
* Version 1.3
* Changelog & more info at http://goo.gl/4nKhJ
*/

// ====[ INCLUDES ]=================================================
#include <sdkhooks>
#include <sdktools>
#undef REQUIRE_EXTENSIONS
#include <cstrike>

// ====[ CONSTANTS ]================================================
#define PLUGIN_NAME    "Ammo Manager"
#define PLUGIN_VERSION "1.3"

enum weapontype
{
	init,
	drop,
	pickup,
	replen
};

enum ammotype // trie array values
{
	defaultclip, // original clip size
	clipsize,    // desired clip size
	ammosize,    // reserved ammo
	array_size   // size of trie array
};

// Ammo setup convars for CS:S and CS:GO
static const String:ammocvars[][] =
{
	"ammo_338mag_max",
	"ammo_357sig_max",
	"ammo_45acp_max",
	"ammo_50AE_max",
	"ammo_556mm_box_max",
	"ammo_556mm_max",
	"ammo_57mm_max",
	"ammo_762mm_max",
	"ammo_9mm_max",
	"ammo_buckshot_max",
	"ammo_357sig_small_max", // Ammo for usp
	"ammo_357sig_min_max", // Ammo for cz75a
	"ammo_556mm_small_max" // And for m4a1 with silencer (CS:GO)
};

// ====[ VARIABLES ]================================================
new	Handle:WeaponsTrie, // Trie array to save weapon names, its clips and reserved ammo
	EngineVersion:CurrentVersion,
	ammosetup[sizeof(ammocvars)], // Array to store original ammo convar values
	bool:enabled, bool:saveclips, // Global booleans to use instead of global handles
	bool:reserveammo, bool:realismreload,
	bool:replenish, bool:restock, bool:ffa,
	m_iAmmo, m_hMyWeapons, m_hActiveWeapon, // Datamap offsets to setup ammunition for player
	m_hOwner, m_iClip1, m_iClip2, // Offsets to setup ammunition for weapons only
	m_iPrimaryAmmoType, m_iSecondaryAmmoType,
	prefixlength, MAX_AMMOCVARS, MAX_WEAPONS; // Max. bound for ammo convars and m_hMyWeapons array datamap

// ====[ PLUGIN ]===================================================
public Plugin:myinfo =
{
	name        = PLUGIN_NAME,
	author      = "Root",
	description = "Allows to setup different clips/reserved ammo for any weapons as well as enabling ammo replenishment and realistic reload",
	version     = PLUGIN_VERSION,
	url         = "http://dodsplugins.com/",
}


/* APLRes:AskPluginLoad2()
 *
 * Called before the plugin starts up.
 * ----------------------------------------------------------------- */
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	// Mark GetEngineVersion as optional native due to older SM versions and GetEngineVersionCompat() stock
	MarkNativeAsOptional("GetEngineVersion");
}

/* OnPluginStart()
 *
 * When the plugin starts up.
 * ------------------------------------------------------------------ */
public OnPluginStart()
{
	// Find and store offsets properly, because those will be used a bit often
	m_iAmmo              = FindSendPropOffsEx("CBasePlayer",       "m_iAmmo");
	m_hMyWeapons         = FindSendPropOffsEx("CBasePlayer",       "m_hMyWeapons");
	m_hActiveWeapon      = FindSendPropOffsEx("CBasePlayer",       "m_hActiveWeapon");
	m_hOwner             = FindSendPropOffsEx("CBaseCombatWeapon", "m_hOwner");
	m_iClip1             = FindSendPropOffsEx("CBaseCombatWeapon", "m_iClip1");
	m_iClip2             = FindSendPropOffsEx("CBaseCombatWeapon", "m_iClip2");
	m_iPrimaryAmmoType   = FindSendPropOffsEx("CBaseCombatWeapon", "m_iPrimaryAmmoType");
	m_iSecondaryAmmoType = FindSendPropOffsEx("CBaseCombatWeapon", "m_iSecondaryAmmoType");

	// Create version ConVar
	CreateConVar("sm_ammo_manager_version", PLUGIN_VERSION, PLUGIN_NAME, FCVAR_NOTIFY|FCVAR_DONTRECORD);

	// Register ConVars without using global handles
	decl Handle:registar; // Hook ConVar changes and set global booleans when convar is just created
	HookConVarChange((registar = CreateConVar("sm_ammo_enabled", "1", "Whether or not enable Ammo Manager plugin",   FCVAR_PLUGIN, true, 0.0, true, 1.0)), OnConVarChange); enabled       = GetConVarBool(registar);
	HookConVarChange((registar = CreateConVar("sm_ammo_setclip", "0", "Whether or not set clip size (experimental)", FCVAR_PLUGIN, true, 0.0, true, 1.0)), OnConVarChange); saveclips     = GetConVarBool(registar);
	HookConVarChange((registar = CreateConVar("sm_ammo_reserve", "1", "Whether or not set reserved ammo settings",   FCVAR_PLUGIN, true, 0.0, true, 1.0)), OnConVarChange); reserveammo   = GetConVarBool(registar);
	HookConVarChange((registar = CreateConVar("sm_ammo_realism", "0", "Whether or not enable realistic reload mode", FCVAR_PLUGIN, true, 0.0, true, 1.0)), OnConVarChange); realismreload = GetConVarBool(registar);
	HookConVarChange((registar = CreateConVar("sm_ammo_refill",  "0", "Whether or not refill weapon clip on kill",   FCVAR_PLUGIN, true, 0.0, true, 1.0)), OnConVarChange); replenish     = GetConVarBool(registar);
	HookConVarChange((registar = CreateConVar("sm_ammo_restock", "0", "Whether or not restock weapon ammo on kill",  FCVAR_PLUGIN, true, 0.0, true, 1.0)), OnConVarChange); restock       = GetConVarBool(registar);
	HookConVarChange((registar = CreateConVar("sm_ammo_ffa",     "0", "Whether or not use ffa mode for ammo replen", FCVAR_PLUGIN, true, 0.0, true, 1.0)), OnConVarChange); ffa           = GetConVarBool(registar);
	CloseHandle(registar);

	// I assume other games (such as DoD:S) got 'weapon_' prefix and 48 weapons max
	prefixlength  = 7;
	MAX_WEAPONS   = 48;
	MAX_AMMOCVARS = 10;

	CurrentVersion = GetEngineVersionCompat();
	switch (CurrentVersion)
	{
		case Engine_CSS, Engine_CSGO:
		{
			if (CurrentVersion == Engine_CSGO)
			{
				// Setup appropriate values for CS:GO
				MAX_AMMOCVARS += 3; // CS:GO got 3 more ammo convars than CS:S
				MAX_WEAPONS   = 64;
			}

			// Loop through all cstrike ammo convars
			for (new i; i < MAX_AMMOCVARS; i++)
			{
				// Store default ammo values and hook its changes
				ammosetup[i] = GetConVarInt(FindConVar(ammocvars[i]));
				HookConVarChange(FindConVar(ammocvars[i]), OnAmmoSettingsChanged);
			}

			// Manually trigger ammo setup on startup
			RestoreAmmoSetup(enabled, reserveammo);
		}
		case Engine_TF2: prefixlength += 3; // Because TF2 got 'tf_weapon_' prefix (which is 3 chars longer)
	}

	// Hook death (for refill and restock features)
	HookEvent("player_death", OnPlayerDeath);

	// Create most important thing - a trie structure
	WeaponsTrie = CreateTrie();
	AutoExecConfig();
}

/* OnConVarChange()
 *
 * Called when ConVar value has changed.
 * ------------------------------------------------------------------ */
public OnConVarChange(Handle:convar, const String:oldValue[], const String:newValue[])
{
	// Retrieve the convar name
	decl String:cvarName[16];
	GetConVarName(convar, cvarName, sizeof(cvarName));

	// Now compare chars from convar names to properly set global booleans
	switch (cvarName[11])
	{
		case 'b': RestoreAmmoSetup(bool:StringToInt(newValue), true); // second arg means plugin has toggled
		case 'c': saveclips      = bool:StringToInt(newValue);
		case 'e': RestoreAmmoSetup(bool:StringToInt(newValue), false); // only reserved ammo has been changed
		case 'l': realismreload  = bool:StringToInt(newValue);
		case 'i': replenish      = bool:StringToInt(newValue);
		case 't': restock        = bool:StringToInt(newValue);
		default:  ffa            = bool:StringToInt(newValue);
	}
}

/* OnAmmoSettingsChanged()
 *
 * Called when ammo cvars settings has changed.
 * ------------------------------------------------------------------ */
public OnAmmoSettingsChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	// If plugin is enabled and should set reserved ammo, reset changes
	if (enabled && reserveammo) SetConVarBool(convar, false);
}

/* OnMapStart()
 *
 * When the map starts.
 * ------------------------------------------------------------------ */
public OnMapStart()
{
	// Get the config and set weapons trie values eventually
	decl String:filepath[PLATFORM_MAX_PATH], Handle:file, clipnammo[array_size];
	BuildPath(Path_SM, filepath, sizeof(filepath), "configs/ammo_manager.txt");

	// Check whether or not plugin config is exists
	if ((file = OpenFile(filepath, "r")) != INVALID_HANDLE)
	{
		ClearTrie(WeaponsTrie);

		decl String:fileline[PLATFORM_MAX_PATH];
		decl String:datas[4][PLATFORM_MAX_PATH];

		// Read every line in config
		while (ReadFileLine(file, fileline, sizeof(fileline)))
		{
			// Break ; symbols from config (a javalia's method)
			if (ExplodeString(fileline, ";", datas, sizeof(datas), sizeof(datas[])) == 4)
			{
				// Properly setup default clip size and other ammo values
				clipnammo[defaultclip] = StringToInt(datas[1]);
				clipnammo[clipsize]    = StringToInt(datas[2]);
				clipnammo[ammosize]    = StringToInt(datas[3]);
				SetTrieArray(WeaponsTrie, datas[0], clipnammo, array_size);
			}
		}
	}
	else
	{
		// No config, wtf? Restore ammo settings and properly disable plugin
		RestoreAmmoSetup(false, true);
		SetFailState("Unable to load plugin configuration file \"%s\"!", filepath);
	}

	// Close a config handle
	CloseHandle(file);
}

/* OnEntityCreated()
 *
 * When an entity is created.
 * ------------------------------------------------------------------ */
public OnEntityCreated(entity, const String:classname[])
{
	decl dummy[1];

	// Hook entity spawning if plugin is enabling and entity classname is exists in a trie
	if (enabled && GetTrieArray(WeaponsTrie, classname[prefixlength], dummy, 0))
	{
		SDKHook(entity, SDKHook_SpawnPost, OnWeaponSpawned);
	}
}

/* OnWeaponSpawned()
 *
 * When a weapon is successfully spawned.
 * ------------------------------------------------------------------ */
public OnWeaponSpawned(weapon)
{
	// Use SDKHookEx in case if not weapon was passed (due to ignored first 7/10 characters)
	if (SDKHookEx(weapon, SDKHook_Reload, OnWeaponReload))
	{
		// Set weapon clip and reserve ammo when its just spawned
		if (saveclips) SetWeaponClip(weapon, weapontype:init);

		// Just pass weapon owner, even if it is not yet exists
		if (reserveammo) SetWeaponReservedAmmo(GetEntDataEnt2(weapon, m_hOwner), weapon, weapontype:init);
	}
}

/* OnClientPutInServer()
 *
 * Called when a client is entering the game.
 * ------------------------------------------------------------------ */
public OnClientPutInServer(client)
{
	// Use both spawn hooks as a backend if equipment did not changed
	SDKHook(client, SDKHook_Spawn,           OnPlayerSpawn);
	SDKHook(client, SDKHook_WeaponDropPost,  OnWeaponDropPost);
	SDKHook(client, SDKHook_WeaponEquipPost, OnWeaponEquipPost);
}

/* OnPlayerSpawn()
 *
 * Called when the player spawns.
 * ------------------------------------------------------------------ */
public OnPlayerSpawn(client)
{
	// I wont loop every time when player spawns, so check if plugin is enabled firstly
	if (enabled)
	{
		// Set ammunition before player equips a weapon
		SetSpawnAmmunition(client, true);

		// When player just spawns, create a timer to give proper ammo after the player spawns
		CreateTimer(0.1, Timer_PostEquip, GetClientUserId(client)|(_:pickup << 16), TIMER_FLAG_NO_MAPCHANGE);
	}
}

/* OnPlayerDeath()
 *
 * Called after player dies.
 * ------------------------------------------------------------------ */
public OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	// Make sure plugin is enabled, and at least refill or restock is enabled too
	if (enabled && (replenish || restock))
	{
		// Get the attacker and a victim user ids from event keys
		new attackerID = GetEventInt(event, "attacker");
		new attacker   = GetClientOfUserId(attackerID);
		new client     = GetClientOfUserId(GetEventInt(event, "userid"));

		// Make sure attacker and victim is valid, and if FFA is activated - ignore team check on killing
		if ((attacker && client) && (ffa || GetClientTeam(attacker) != GetClientTeam(client)))
		{
			// Refill player ammo after a small delay, because some bullets may be shot after
			CreateTimer(0.1, Timer_PostEquip, attackerID|(_:replen << 16), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

/* OnWeaponDropPost()
 *
 * Called when a client drops his weapon.
 * ------------------------------------------------------------------ */
public OnWeaponDropPost(client, weapon)
{
	if (enabled)
	{
		// Save weapon clip and its ammo after dropping
		if (saveclips)   SetWeaponClip(weapon, weapontype:drop);
		if (reserveammo) SetWeaponReservedAmmo(client, weapon, weapontype:drop);
	}
}

/* OnWeaponEquipPost()
 *
 * Called when a client equips a weapon.
 * ------------------------------------------------------------------ */
public OnWeaponEquipPost(client, weapon)
{
	if (enabled)
	{
		// Set stored weapon clip and its ammo for this client on every weapon pickup
		if (saveclips)   SetWeaponClip(weapon, weapontype:pickup);
		if (reserveammo) SetWeaponReservedAmmo(client, weapon, weapontype:pickup);
	}
}

/* OnWeaponReload()
 *
 * Called when a weapon is about to reload.
 * ------------------------------------------------------------------ */
public Action:OnWeaponReload(weapon)
{
	if (enabled && (saveclips || realismreload))
	{
		decl String:classname[64], clipnammo[array_size];

		// Retrieve weapon classname in 'if' statement, because it may fail at some time (c) KyleS
		if (GetEdictClassname(weapon, classname, sizeof(classname)) && CurrentVersion == Engine_CSGO)
		{
			// Properly replace weapon classnames for CS:GO
			switch (GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 60: classname = "weapon_m4a1_silencer";
				case 61: classname = "weapon_usp_silencer";
				case 63: classname = "weapon_cz75a";
			}
		}

		// Make sure this weapon is exists in Weapons Trie
		if (GetTrieArray(WeaponsTrie, classname[prefixlength], clipnammo, array_size))
		{
			// If clip size is more than 0 and less than defined, deny weapon reloading
			if (saveclips && 0 < clipnammo[clipsize] <= GetEntData(weapon, m_iClip1))
			{
				return Plugin_Handled;
			}
			else
			{
				// Reset 'garand' clip size to 0 if realistic reload is enabled (DoD:S)
				if (realismreload && StrEqual(classname[7], "garand"))
					SetEntData(weapon, m_iClip1, 0);

				// Otherwise create timer to correct clipsize/ammo during reloading
				new Handle:data = INVALID_HANDLE, client = GetEntDataEnt2(weapon, m_hOwner);
				CreateDataTimer(0.1, Timer_FixAmmunition, data, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);

				// Add entity reference, client uid and weapon clips in data timer
				WritePackCell(data, EntIndexToEntRef(weapon));
				WritePackCell(data, GetClientUserId(client));
				WritePackCell(data, clipnammo[defaultclip]);
				WritePackCell(data, clipnammo[clipsize]);
			}
		}
	}

	return Plugin_Continue;
}

/* CS_OnBuyCommand()
 *
 * Called when a player attempts to purchase an item.
 * ------------------------------------------------------------------ */
public Action:CS_OnBuyCommand(client, const String:weapon[])
{
	// No need to create timer unless plugin should save weapon clips
	if (enabled && saveclips)
	{
		// Create a delay when player buys weapon
		CreateTimer(0.1, Timer_PostEquip, GetClientUserId(client)|(_:pickup << 16), TIMER_FLAG_NO_MAPCHANGE);
	}
}

/* Timer_FixAmmunition()
 *
 * Called during weapon is reloading.
 * ------------------------------------------------------------------ */
public Action:Timer_FixAmmunition(Handle:event, any:data)
{
	if (data == INVALID_HANDLE)
	{
		LogError("Invalid data timer!");
		return Plugin_Stop;
	}

	ResetPack(data);

	// Retrieve all the data from timer
	new weapon  = EntRefToEntIndex(ReadPackCell(data));
	new client  = GetClientOfUserId(ReadPackCell(data));
	new oldclip = ReadPackCell(data);
	new newclip = ReadPackCell(data);

	// If weapon reference or client is invalid, stop timer immediately
	if (weapon == INVALID_ENT_REFERENCE || !client)
		return Plugin_Stop;

	// To find WeaponID in m_iAmmo array we should add multiplied m_iPrimaryAmmoType datamap offset by 4 onto m_iAmmo player array, meh
	new WeaponID = GetEntData(weapon, m_iPrimaryAmmoType) * 4;

	// And get the current player ammo for this weapon
	new currammo = GetEntData(client, m_iAmmo + WeaponID);
	new realclip = GetEntData(weapon, m_iClip1), fixedammo;

	// Create some static variables for proper reloading stuff
	static lastweapon[MAXPLAYERS + 1], bool:reloading[MAXPLAYERS + 1];

	// Does weapon is reloading at the moment?
	if (bool:GetEntProp(weapon, Prop_Data, "m_bInReload", true))
	{
		// Store index of weapon that is reloading now
		lastweapon[client] = weapon;

		// Check if player got any ammo and haven't reloaded before
		if (!reloading[client] && currammo)
		{
			if (realismreload)
			{
				// Reset clip to 0 for realistic reload
				SetEntData(weapon, m_iClip1, 0);
			}
			if (saveclips)
			{
				// Correct player ammo once during reloading
				if (newclip > oldclip)
					fixedammo = currammo - (newclip - realclip);
				else if (newclip < oldclip)
					fixedammo = currammo + (oldclip - newclip);

				// fixedammo cannot be equal to 0
				if (fixedammo)
					SetEntData(client, m_iAmmo + WeaponID, fixedammo);
			}
		}

		// Set boolean to make sure that clip has been set and ammo corrected once
		reloading[client] = true;
	}
	else // Player is not reloading anymore
	{
		// If player is not reloading anymore, check whether or not he's just switched weapon during reload
		if (lastweapon[client] == GetEntDataEnt2(client, m_hActiveWeapon))
		{
			// It's needed to compare a weapons which is started and ended reloading
			if (saveclips && reloading[client])
			{
				// Plugin should save different clips
				if (currammo + realclip >= newclip)
					SetEntData(weapon, m_iClip1, newclip);
			}
		}

		// Reset static variables within a timer
		lastweapon[client] = reloading[client] = false;

		// Also stop it because gun is already reloaded
		return Plugin_Stop;
	}

	return Plugin_Continue;
}

/* Timer_PostEquip()
 *
 * Sets weapon clip and reserved ammo on certain events.
 * ------------------------------------------------------------------ */
public Action:Timer_PostEquip(Handle:timer, any:data)
{
	new client = data & 0x0000FFFF;
	new type   = data >> 16;

	// Always validate client from delayed callbacks (timers etc...)
	if ((client = GetClientOfUserId(client)))
	{
		// Get the type of post equip ammunition
		switch (type)
		{
			case replen: // Replen weapon ammo after a kill
			{
				// Get the active player weapon and set its ammo appropriately
				new weapon = GetEntDataEnt2(client, m_hActiveWeapon);
				if (replenish) SetWeaponClip(weapon, weapontype:replen);
				if (restock)   SetWeaponReservedAmmo(client, weapon, weapontype:replen);
			}
			default: SetSpawnAmmunition(client, false); // Either OnPlayerSpawn or CS_OnBuyCommand has been fired
		}
	}
}

/* SetSpawnAmmunition()
 *
 * Sets player reserved ammo properly in pre and post spawn hooks.
 * ------------------------------------------------------------------ */
SetSpawnAmmunition(client, bool:prehook)
{
	// Loop through max game weapons to properly get all player weapons
	for (new i; i < MAX_WEAPONS; i += 4) // increase every offset by 4 units
	{
		new weapon  = -1;
		if ((weapon = GetEntDataEnt2(client, m_hMyWeapons + i)) != -1)
		{
			// On pre-spawn hook set m_iSecondaryAmmoType as default value
			if (saveclips)   SetWeaponClip(weapon, prehook ? init : pickup); // Otherwise set current ammo from this value
			if (reserveammo) SetWeaponReservedAmmo(client, weapon, prehook ? init : pickup);
		}
	}
}

/* SetWeaponClip()
 *
 * Sets weapon clip when its spawned, picked or dropped.
 * ------------------------------------------------------------------ */
SetWeaponClip(weapon, type)
{
	// Make sure weapon edict is valid
	if (weapon > MaxClients)
	{
		// Retrieve weapon classname
		decl String:classname[64], clipnammo[array_size];
		if (GetEdictClassname(weapon, classname, sizeof(classname)) && CurrentVersion == Engine_CSGO)
		{
			// Get the weapon definition index (like in hat fortress)
			switch (GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 60: classname = "weapon_m4a1_silencer";
				case 61: classname = "weapon_usp_silencer";
				case 63: classname = "weapon_cz75a";
			}
		}

		// Ignore first 7/10 characters in weapon string to avoid comparing with the prefix
		if (GetTrieArray(WeaponsTrie, classname[prefixlength], clipnammo, array_size))
		{
			if (clipnammo[clipsize])
			{
				switch (type)
				{
					case init:   SetEntData(weapon, m_iClip2, clipnammo[clipsize]); // When weapon just spawned, set m_iClip2 value to clip size from trie array
					case drop:   SetEntData(weapon, m_iClip2, GetEntData(weapon, m_iClip1)); // After dropping a weapon, set m_iClip2 value same as current (m_iClip1) size
					case pickup: SetEntData(weapon, m_iClip1, GetEntData(weapon, m_iClip2)); // And when weapon is picked, retrieve m_iClip2 value and set current clip size
					case replen: SetEntData(weapon, m_iClip1, clipnammo[clipsize]); // When player kills another, get the clip value from trie and set it for weapon immediately
				}
			}
		}
	}
}

/* SetWeaponReservedAmmo()
 *
 * Sets weapon reserved ammunition when its spawned, picked or dropped.
 * ------------------------------------------------------------------ */
SetWeaponReservedAmmo(client, weapon, type)
{
	if (weapon > MaxClients)
	{
		decl String:classname[64], clipnammo[array_size];

		// Replace whole weapon string for CS:GO after checking definition index
		if (GetEdictClassname(weapon, classname, sizeof(classname)) && CurrentVersion == Engine_CSGO)
		{
			switch (GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 60: classname = "weapon_m4a1_silencer";
				case 61: classname = "weapon_usp_silencer";
				case 63: classname = "weapon_cz75a";
			}
		}

		if (GetTrieArray(WeaponsTrie, classname[prefixlength], clipnammo, array_size))
		{
			// Get the weapon ID to properly find it in m_iAmmo array
			new WeaponID = GetEntData(weapon, m_iPrimaryAmmoType) * 4;

			// If ammo value is not set (= 0) dont do anything
			if (clipnammo[ammosize])
			{
				// Retrieve ammunition type when weapon is created, dropped or picked
				switch (type)
				{
					case init:   SetEntData(weapon, m_iSecondaryAmmoType, clipnammo[ammosize]); // Initialize reserved ammunition in unused m_iSecondaryAmmoType datamap offset
					case drop:   if (IsClientInGame(client)) SetEntData(weapon, m_iSecondaryAmmoType, GetEntData(client, m_iAmmo + WeaponID));
					case pickup: if (IsClientInGame(client)) SetEntData(client, m_iAmmo + WeaponID, GetEntData(weapon, m_iSecondaryAmmoType)); // Retrieve it
					case replen: if (IsClientInGame(client)) SetEntData(client, m_iAmmo + WeaponID, clipnammo[ammosize]); // Get desired max ammo value from trie and just set reserved ammo for this weapon
				}
			}
		}
	}
}

/* RestoreAmmoSetup()
 *
 * Restores original ammo settings for CS:S and CS:GO when plugin disables.
 * ------------------------------------------------------------------ */
RestoreAmmoSetup(bool:value, bool:toggled)
{
	if (toggled) enabled = value; // Plugin has toggled? set enabled value then
	else     reserveammo = value; // Otherwise seems like reserved ammo has been toggled

	switch (CurrentVersion)
	{
		case Engine_CSS, Engine_CSGO:
		{
			// Again loop through all ammo cvars
			for (new i; i < MAX_AMMOCVARS; i++)
			{
				// Set ammo cvar values to 0 if plugin is enabled, otherwise set original ammo values for all counter-strike cvars
				SetConVarInt(FindConVar(ammocvars[i]), (toggled && enabled || !toggled && reserveammo) ? 0 : ammosetup[i]);
			}
		}
	}
}

/* FindSendPropOffsEx()
 *
 * Returns the offset of the specified network property.
 * ------------------------------------------------------------------ */
FindSendPropOffsEx(const String:serverClass[64], const String:propName[64])
{
	new offset = FindSendPropOffs(serverClass, propName);

	// Disable plugin if a networkable send property offset was not found
	if (offset <= 0)
	{
		SetFailState("Unable to find offset \"%s::%s\"!", serverClass, propName);
	}

	return offset;
}

// https://forums.alliedmods.net/showthread.php?t=224362
stock EngineVersion:GetEngineVersionCompat()
{
	new EngineVersion:version;
	if (GetFeatureStatus(FeatureType_Native, "GetEngineVersion") != FeatureStatus_Available)
	{
		new sdkVersion = GuessSDKVersion();
		switch (sdkVersion)
		{
			case SOURCE_SDK_ORIGINAL:
			{
				version = Engine_Original;
			}

			case SOURCE_SDK_DARKMESSIAH:
			{
				version = Engine_DarkMessiah;
			}

			case SOURCE_SDK_EPISODE1:
			{
				version = Engine_SourceSDK2006;
			}

			case SOURCE_SDK_EPISODE2:
			{
				version = Engine_SourceSDK2007;
			}

			case SOURCE_SDK_BLOODYGOODTIME:
			{
				version = Engine_BloodyGoodTime;
			}

			case SOURCE_SDK_EYE:
			{
				version = Engine_EYE;
			}

			case SOURCE_SDK_CSS:
			{
				version = Engine_CSS;
			}

			case SOURCE_SDK_EPISODE2VALVE:
			{
				decl String:gameFolder[PLATFORM_MAX_PATH];
				GetGameFolderName(gameFolder, PLATFORM_MAX_PATH);
				if (StrEqual(gameFolder, "dod", false))
				{
					version = Engine_DODS;
				}
				else if (StrEqual(gameFolder, "hl2mp", false))
				{
					version = Engine_HL2DM;
				}
				else
				{
					version = Engine_TF2;
				}
			}

			case SOURCE_SDK_LEFT4DEAD:
			{
				version = Engine_Left4Dead;
			}

			case SOURCE_SDK_LEFT4DEAD2:
			{
				decl String:gameFolder[PLATFORM_MAX_PATH];
				GetGameFolderName(gameFolder, PLATFORM_MAX_PATH);
				if (StrEqual(gameFolder, "nucleardawn", false))
				{
					version = Engine_NuclearDawn;
				}
				else
				{
					version = Engine_Left4Dead2;
				}
			}

			case SOURCE_SDK_ALIENSWARM:
			{
				version = Engine_AlienSwarm;
			}

			case SOURCE_SDK_CSGO:
			{
				version = Engine_CSGO;
			}

			default:
			{
				version = Engine_Unknown;
			}
		}
	}
	else
	{
		version = GetEngineVersion();
	}

	return version;
}