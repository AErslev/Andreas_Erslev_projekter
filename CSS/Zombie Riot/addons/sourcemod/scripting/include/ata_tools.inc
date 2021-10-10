/**
 * =============================================================================
 * SourceMod ATA Tools
 *
 * (C)2009-2011 ata-clan.de
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Version: $Id$
 */

#pragma semicolon 1

#include <sourcemod>
#include <sdktools_functions>

#if !defined(CSS_TEAM_NONE)
	#define CSS_TEAM_NONE							0
#endif
#if !defined(CSS_TEAM_SPECTATOR)
	#define CSS_TEAM_SPECTATOR				1
#endif
#if !defined(CSS_TEAM_T)
	#define CSS_TEAM_T								2
#endif
#if !defined(CSS_TEAM_CT)
	#define CSS_TEAM_CT								3
#endif

#define ATA_WEAPONCLASSES	27
/*
new String:g_WeaponClasses[ATA_WEAPONCLASSES][16] =
{
	"weapon_usp",
	"weapon_glock",
	"weapon_deagle",
	"weapon_p228",
	"weapon_elite",
	"weapon_fiveseven",
	"weapon_m4a1",
	"weapon_ak47",
	"weapon_aug",
	"weapon_sg552",
	"weapon_galil",
	"weapon_famas",
	"weapon_scout",
	"weapon_sg550",
	"weapon_m249",
	"weapon_g3sg1",
	"weapon_ump45",
	"weapon_mp5navy",
	"weapon_m3",
	"weapon_xm1014",
	"weapon_tmp",
	"weapon_mac10",
	"weapon_p90",
	"weapon_awp",
	"weapon_smokegrenade",
	"weapon_hegrenade",
	"weapon_flashbang"
//	"weapon_c4"	// dont know if this is the real classname
};
*/

// damage types
#define DMG_GENERIC									0
#define DMG_CRUSH										(1 << 0)
#define DMG_BULLET									(1 << 1)
#define DMG_SLASH										(1 << 2)
#define DMG_BURN										(1 << 3)
#define DMG_VEHICLE									(1 << 4)
#define DMG_FALL										(1 << 5)
#define DMG_BLAST										(1 << 6)
#define DMG_CLUB										(1 << 7)
#define DMG_SHOCK										(1 << 8)
#define DMG_SONIC										(1 << 9)
#define DMG_ENERGYBEAM							(1 << 10)
#define DMG_PREVENT_PHYSICS_FORCE		(1 << 11)
#define DMG_NEVERGIB								(1 << 12)
#define DMG_ALWAYSGIB								(1 << 13)
#define DMG_DROWN										(1 << 14)
#define DMG_TIMEBASED								(DMG_PARALYZE | DMG_NERVEGAS | DMG_POISON | DMG_RADIATION | DMG_DROWNRECOVER | DMG_ACID | DMG_SLOWBURN)
#define DMG_PARALYZE								(1 << 15)
#define DMG_NERVEGAS								(1 << 16)
#define DMG_POISON									(1 << 17)
#define DMG_RADIATION								(1 << 18)
#define DMG_DROWNRECOVER						(1 << 19)
#define DMG_ACID										(1 << 20)
#define DMG_SLOWBURN								(1 << 21)
#define DMG_REMOVENORAGDOLL					(1 << 22)
#define DMG_PHYSGUN									(1 << 23)
#define DMG_PLASMA									(1 << 24)
#define DMG_AIRBOAT									(1 << 25)
#define DMG_DISSOLVE								(1 << 26)
#define DMG_BLAST_SURFACE						(1 << 27)
#define DMG_DIRECT									(1 << 28)
#define DMG_BUCKSHOT								(1 << 29)

// ----------------------------------------------------------------------------
public bool:RemoveWeaponFromSlot(client, slot)
// ----------------------------------------------------------------------------
{
	new nEntityID = GetPlayerWeaponSlot(client, slot);
	if(nEntityID < 0)
		return false;

	decl String:sEntityName[32];
	GetEdictClassname(nEntityID, sEntityName, sizeof(sEntityName));

	if(strcmp(sEntityName, "weapon_knife") == 0)
		return true;

	RemovePlayerItem(client, nEntityID);
	RemoveEdict(nEntityID);

	return true;
}

// ----------------------------------------------------------------------------
public GetPlayerEntities(client, const String:sEntityName[], pnEntityIDs[], String:psEntityNames[][], nMaxEntityCount, nMaxEntityNameSize)
// ----------------------------------------------------------------------------
{
	new nEntityCount = 0;
	new nEntityID = -1;
	new iEntities = FindSendPropOffs("CBaseCombatCharacter", sEntityName);
	if(iEntities != -1)
	{
		for(new i=0; i<=128; i+=4)
		{
			nEntityID = GetEntDataEnt2(client, (iEntities+i));
			if(!IsValidEdict(nEntityID))
				continue;
			GetEdictClassname(nEntityID, psEntityNames[nEntityCount], nMaxEntityNameSize);
			pnEntityIDs[nEntityCount] = nEntityID;
			nEntityCount++;
		}
	}

	return nEntityCount;
}

// ----------------------------------------------------------------------------
public bool:RemoveRandomWeaponFromSlot(client, String:sItem[], nItemSize)
// ----------------------------------------------------------------------------
{
	new String:sWeaponNames[32][32];
	new pnWeaponIDs[32];
	new nWeaponCount = GetPlayerEntities(client, "m_hMyWeapons", pnWeaponIDs, sWeaponNames, 32, 32);

	// sort out knife, C4 and world entity
	new nValidWeaponCount = 0;
	new piValidWeapon[32];	// Index to valid item in pnWeaponIDs array
	for(new i=0; i<nWeaponCount; i++)
	{
		if(	strcmp(sWeaponNames[i], "weapon_knife") != 0 &&
				strcmp(sWeaponNames[i], "weapon_c4") != 0 &&
				pnWeaponIDs[i] != 0)
		{
			piValidWeapon[nValidWeaponCount++] = i;
		}
	}

	if(nValidWeaponCount > 0)
	{
		new iRemove		= piValidWeapon[GetRandomInt(1, nValidWeaponCount)-1];
		new nRemoveWeapon	= pnWeaponIDs[iRemove];

//		PrintToChatAll("test: %d %d %d %s", nValidWeaponCount, iRemove, nRemoveWeapon, sWeaponNames[iRemove]);

		RemovePlayerItem(client, nRemoveWeapon);
		RemoveEdict(nRemoveWeapon);

		EquipKnife(client, false);

		strcopy(sItem, nItemSize, sWeaponNames[iRemove]);

		return true;
	}

	return false;
}

// ----------------------------------------------------------------------------
public EquipKnife(client, bool:bRemoveOther)
// ----------------------------------------------------------------------------
{
	new nEntityID = -1;
	new nEntityIDKnife = -1;
	new String:sEntityName[32];

	new iItems = FindSendPropOffs("CBaseCombatCharacter", "m_hMyWeapons");
	if(iItems != -1)
	{
		for(new i=0; i<=128; i+=4)
		{
			nEntityID = GetEntDataEnt2(client, (iItems+i));
			if(!IsValidEdict(nEntityID))
				continue;
			GetEdictClassname(nEntityID, sEntityName, sizeof(sEntityName));

			if(strcmp(sEntityName, "weapon_knife") == 0)
			{
				nEntityIDKnife = nEntityID;
//				EquipPlayerWeapon(client, nEntityID);
				if(!bRemoveOther)
					break;
			}
			else if(bRemoveOther && strcmp(sEntityName, "weapon_c4") != 0)
			{
				RemovePlayerItem(client, nEntityID);
				RemoveEdict(nEntityID);
			}
		}
	}

	if(nEntityIDKnife != -1)
		EquipPlayerWeapon(client, nEntityIDKnife);
}

// ----------------------------------------------------------------------------
public SetPlayerAlpha(client, alpha)
// ----------------------------------------------------------------------------
{
	// player model
	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, 255, 255, 255, alpha);

	// weapon model
	new iItems = FindSendPropOffs("CBaseCombatCharacter", "m_hMyWeapons");
	if(iItems != -1)
	{
		for(new i=0; i<=128; i+=4)
		{
			new nEntityID = GetEntDataEnt2(client, (iItems+i));
			if(!IsValidEdict(nEntityID))
				continue;

			SetEntityRenderMode(nEntityID, RENDER_TRANSCOLOR);
			SetEntityRenderColor(nEntityID, 255, 255, 255, alpha);
		}
	}
}

enum FX
{
	FxNone = 0,
	FxPulseFast,
	FxPulseSlowWide,
	FxPulseFastWide,
	FxFadeSlow,
	FxFadeFast,
	FxSolidSlow,
	FxSolidFast,
	FxStrobeSlow,
	FxStrobeFast,
	FxStrobeFaster,
	FxFlickerSlow,
	FxFlickerFast,
	FxNoDissipation,
	FxDistort,					// Distort/scale/translate flicker
	FxHologram,					// kRenderFxDistort + distance fade
	FxExplode,					// Scale up really big!
	FxGlowShell,				// Glowing Shell
	FxClampMinScale,		// Keep this sprite from getting very small (SPRITES only!)
	FxEnvRain,					// for environmental rendermode, make rain
	FxEnvSnow,					// for environmental rendermode, make snow
	FxSpotlight,
	FxRagdoll,
	FxPulseFastWider,
};

enum Render
{
	Normal = 0, 				// src
	TransColor, 				// c*a+dest*(1-a)
	TransTexture,				// src*a+dest*(1-a)
	Glow,								// src*a+dest -- No Z buffer checks -- Fixed size in screen space
	TransAlpha,					// src*srca+dest*(1-srca)
	TransAdd,						// src*a+dest
	Environmental,			// not drawn, used for environmental effects
	TransAddFrameBlend,	// use a fractional frame value to blend between animation frames
	TransAlphaAdd,			// src + dest*(1-a)
	WorldGlow,					// Same as kRenderGlow but not fixed size in screen space
	None,								// Don't render.
};

// ----------------------------------------------------------------------------
stock SetGlow(client, FX:fx = FxNone, r = 255, g = 255, b = 255, Render:render = Normal, nAmount = 255)
// ----------------------------------------------------------------------------
{
	SetEntProp(client, Prop_Send, "m_nRenderFX", _:fx, 1);
	SetEntProp(client, Prop_Send, "m_nRenderMode", _:render, 1);

	new nOffsetClrRender = GetEntSendPropOffs(client, "m_clrRender");
	SetEntData(client, nOffsetClrRender, r, 1, true);
	SetEntData(client, nOffsetClrRender + 1, g, 1, true);
	SetEntData(client, nOffsetClrRender + 2, b, 1, true);
	SetEntData(client, nOffsetClrRender + 3, nAmount, 1, true);
}

// ----------------------------------------------------------------------------
stock ImpactKnockback(nClientAttacker, nClientVictim, Float:fKnockback, Float:fUp = 0.0)
// ----------------------------------------------------------------------------
{
	decl Float:pfEyeAngles[3];
	GetClientEyeAngles(nClientAttacker, pfEyeAngles);

	decl Float:pfKnockbackAngles[3];
	pfKnockbackAngles[0] = FloatMul(Cosine(DegToRad(pfEyeAngles[1])), fKnockback);
	pfKnockbackAngles[1] = FloatMul(Sine(DegToRad(pfEyeAngles[1])), fKnockback);
	pfKnockbackAngles[2] = FloatMul(Sine(DegToRad(pfEyeAngles[0]+fUp)), fKnockback);

	TeleportEntity(nClientVictim, NULL_VECTOR, NULL_VECTOR, pfKnockbackAngles);
}

// ----------------------------------------------------------------------------
stock AddExtraGore(Handle:hBloodDrips, Handle:hBloodSpray, nClientAttacker, nClientVictim, nGoreAmount, Float:fKnockback, Float:fUp = 0.0)
// ----------------------------------------------------------------------------
{
	// add some extra blood and gib

	decl Float:pfOrigin[3];
	GetClientAbsOrigin(nClientVictim, pfOrigin);
	pfOrigin[2] += 35.0;

	// emit blood spray sound
	EmitAmbientSound("player/pl_wade2.wav", pfOrigin, SOUND_FROM_WORLD, SNDLEVEL_NORMAL);

	decl Float:pfDirection[3];
	for(new i=0; i<nGoreAmount; i++)
	{
		pfDirection[0] = GetRandomFloat(-1.0, 1.0);
		pfDirection[1] = GetRandomFloat(-1.0, 1.0);
		pfDirection[2] = GetRandomFloat(0.0, 75.0);

		if(hBloodDrips != INVALID_HANDLE)
			SDKCall(hBloodDrips, pfOrigin, pfDirection, 247);	// blood drips
		if(hBloodSpray != INVALID_HANDLE)
			SDKCall(hBloodSpray, pfOrigin, pfDirection, 247, 10, 1);	// blood spray

		// blood decals
		new nEntityIDBlood = CreateEntityByName("env_blood");
		if(IsValidEdict(nEntityIDBlood))
		{
			decl String:sAngles[128];
			Format(sAngles, 128, "%f %f %f", pfDirection[0], pfDirection[1], -1.0);

			DispatchSpawn(nEntityIDBlood);
			DispatchKeyValue(nEntityIDBlood, "color", "0");
			DispatchKeyValue(nEntityIDBlood, "amount", "1000");
			DispatchKeyValue(nEntityIDBlood, "spraydir", sAngles);
			DispatchKeyValue(nEntityIDBlood, "spawnflags", "12");
			AcceptEntityInput(nEntityIDBlood, "EmitBlood", nClientVictim);
			RemoveEdict(nEntityIDBlood);
		}
	}

//	ImpactKnockback(nClientAttacker, AddGibModel(pfOrigin, "models/gibs/hgibs.mdl"), fKnockback, fUp);
	ImpactKnockback(nClientAttacker, AddGibModel(pfOrigin, "models/gibs/hgibs_rib.mdl"), fKnockback, fUp);
	ImpactKnockback(nClientAttacker, AddGibModel(pfOrigin, "models/gibs/hgibs_spine.mdl"), fKnockback, fUp);
	ImpactKnockback(nClientAttacker, AddGibModel(pfOrigin, "models/gibs/hgibs_scapula.mdl"), fKnockback, fUp);
	ImpactKnockback(nClientAttacker, AddGibModel(pfOrigin, "models/gibs/hgibs_scapula.mdl"), fKnockback, fUp);
	ImpactKnockback(nClientAttacker, AddGibModel(pfOrigin, "models/gibs/hgibs_scapula.mdl"), fKnockback, fUp);
}

// ----------------------------------------------------------------------------
public AddGibModel(Float:pfOrigin[3], String:sModel[])
// ----------------------------------------------------------------------------
{
	decl Float:pfDirection[3];
	pfDirection[0] = GetRandomFloat(-1.0, 1.0);
	pfDirection[1] = GetRandomFloat(-1.0, 1.0);
	pfDirection[2] = GetRandomFloat(150.0, 200.0);

	new nEntityIDPhysics = CreateEntityByName("prop_physics");
	if(nEntityIDPhysics < (GetMaxEntities() * 0.9))
	{
		DispatchKeyValue(nEntityIDPhysics, "model", sModel);
		SetEntProp(nEntityIDPhysics, Prop_Send, "m_CollisionGroup", 1); 
		DispatchSpawn(nEntityIDPhysics);
		TeleportEntity(nEntityIDPhysics, pfOrigin, pfDirection, pfDirection);
		CreateTimer(23.5, TimerRemoveEntity, nEntityIDPhysics);
	}
	return nEntityIDPhysics;
}

// ----------------------------------------------------------------------------
public Action:TimerRemoveEntity(Handle:timer, any:nEntityID)
// ----------------------------------------------------------------------------
{
	if(IsValidEdict(nEntityID))
	{
//		decl String:sEdictClassname[64];
//		GetEdictClassname(nEntityID, sEdictClassname, sizeof(sEdictClassname)); 
//		if(strcmp(sEdictClassname, "prop_physics") == 0)
			RemoveEdict(nEntityID);
	}
}

// ----------------------------------------------------------------------------
public SafeCloseHandle(&Handle:rHandle)
// ----------------------------------------------------------------------------
{
	if(rHandle != INVALID_HANDLE)
	{
		CloseHandle(rHandle);
		rHandle = INVALID_HANDLE;
	}
}

// ----------------------------------------------------------------------------
public bool:IsNumeric(String:sString[])
// ----------------------------------------------------------------------------
{
	for(new i=0; i<strlen(sString); i++)
		if(!IsCharNumeric(sString[i]) && sString[i])
			return false;
	return true;
}

// ----------------------------------------------------------------------------
stock DealDamage(nClientVictim, nDamage, nClientAttacker = 0, nDamageType = DMG_GENERIC, String:sWeapon[] = "")
// ----------------------------------------------------------------------------
{
	// taken from: http://forums.alliedmods.net/showthread.php?t=111684
	// thanks to the authors!
	if(	nClientVictim > 0 &&
			IsValidEdict(nClientVictim) &&
			IsClientInGame(nClientVictim) &&
			IsPlayerAlive(nClientVictim) &&
			nDamage > 0)
	{
		new EntityPointHurt = CreateEntityByName("point_hurt");
		if(EntityPointHurt != 0)
		{
			new String:sDamage[16];
			IntToString(nDamage, sDamage, sizeof(sDamage));

			new String:sDamageType[32];
			IntToString(nDamageType, sDamageType, sizeof(sDamageType));

			DispatchKeyValue(nClientVictim,			"targetname",		"war3_hurtme");
			DispatchKeyValue(EntityPointHurt,		"DamageTarget",	"war3_hurtme");
			DispatchKeyValue(EntityPointHurt,		"Damage",				sDamage);
			DispatchKeyValue(EntityPointHurt,		"DamageType",		sDamageType);
			if(!StrEqual(sWeapon, ""))
				DispatchKeyValue(EntityPointHurt,	"classname",		sWeapon);
			DispatchSpawn(EntityPointHurt);
			AcceptEntityInput(EntityPointHurt,	"Hurt",					(nClientAttacker != 0) ? nClientAttacker : -1);
			DispatchKeyValue(EntityPointHurt,		"classname",		"point_hurt");
			DispatchKeyValue(nClientVictim,			"targetname",		"war3_donthurtme");

			RemoveEdict(EntityPointHurt);
		}
	}
}
