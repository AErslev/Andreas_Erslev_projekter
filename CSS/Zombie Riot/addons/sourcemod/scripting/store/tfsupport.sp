#if defined STANDALONE_BUILD
#include <sourcemod>
#include <sdktools>

#include <store>
#include <zephstocks>

#include <tf2items>
#endif

new g_eTFUnusual[STORE_MAX_ITEMS];
new g_eTFHatDye[STORE_MAX_ITEMS][4];

new g_iTFUnusual = 0;
new g_iTFHatDye = 0;

new Handle:g_hHatIDs = INVALID_HANDLE;

#if defined STANDALONE_BUILD
public OnPluginStart()
#else
public TFSupport_OnPluginStart()
#endif
{
#if defined STANDALONE_BUILD
	new String:m_szGameDir[32];
	GetGameFolderName(m_szGameDir, sizeof(m_szGameDir));
	
	if(strcmp(m_szGameDir, "tf")==0)
		GAME_TF2 = true;
#endif
	if(!GAME_TF2)
		return;	

#if !defined STANDALONE_BUILD
	// This is not a standalone build, we don't want hats to kill the whole plugin for us	
	if(GetExtensionFileStatus("tf2items.ext")!=1)
	{
		LogError("TF2Items isn't installed or failed to load. TF2 support will be disabled. Please install TF2Items. (https://forums.alliedmods.net/showthread.php?t=115100)");
		return;
	}
#endif

	if(!TFSupport_ReadItemSchema())
		return;
	
	Store_RegisterHandler("tfunusual", "unusual_id", TFSupport_OnMapStart, TFSupport_Reset, TFUnusual_Config, TFSupport_Equip, TFSupport_Remove, true);
	Store_RegisterHandler("tfhatdye", "color", TFSupport_OnMapStart, TFSupport_Reset, TFHatDye_Config, TFSupport_Equip, TFSupport_Remove, true);
}

public TFSupport_OnMapStart()
{
}

public TFSupport_Reset()
{
	g_iTFUnusual = 0;
}

public TFUnusual_Config(&Handle:kv, itemid)
{
	Store_SetDataIndex(itemid, g_iTFUnusual);
	
	g_eTFUnusual[g_iTFUnusual] = KvGetNum(kv, "unusual_id");
	
	++g_iTFUnusual;
	return true;
}

public TFHatDye_Config(&Handle:kv, itemid)
{
	Store_SetDataIndex(itemid, g_iTFHatDye);
	
	KvGetColor(kv, "color", g_eTFHatDye[g_iTFHatDye][0], g_eTFHatDye[g_iTFHatDye][1], g_eTFHatDye[g_iTFHatDye][2], g_eTFHatDye[g_iTFHatDye][3]);
	
	++g_iTFHatDye;
	return true;
}

public TFSupport_Equip(client, id)
{
	return 0;
}

public TFSupport_Remove(client)
{
	return 0;
}

public Action:TF2Items_OnGiveNamedItem(client, String:classname[], iItemDefinitionIndex, &Handle:hItem)
{
	new m_iEquippedUnusual = Store_GetEquippedItem(client, "tfunusual");
	new m_iEquippedDye = Store_GetEquippedItem(client, "tfhatdye");

	if(m_iEquippedUnusual < 0 && m_iEquippedDye < 0)
		return Plugin_Continue;

	if(FindValueInArray(g_hHatIDs, iItemDefinitionIndex)==-1)
		return Plugin_Continue;

	hItem = TF2Items_CreateItem(OVERRIDE_ATTRIBUTES | PRESERVE_ATTRIBUTES);
	new m_iDyeId = 0;
	if(m_iEquippedUnusual >=0 && m_iEquippedDye >=0)
	{
		TF2Items_SetNumAttributes(hItem, 2);
		m_iDyeId = 1;
	}
	else
		TF2Items_SetNumAttributes(hItem, 1);

	if(m_iEquippedUnusual >= 0)
	{
		new m_iDataUnusual = Store_GetDataIndex(m_iEquippedUnusual);
		TF2Items_SetQuality(hItem, 5);
		TF2Items_SetAttribute(hItem, 0, 134, float(g_eTFUnusual[m_iDataUnusual]));
	}

	if(m_iEquippedDye >= 0)
	{
		new m_iDataDye = Store_GetDataIndex(m_iEquippedDye);
		TF2Items_SetAttribute(hItem, m_iDyeId, 142, float(RgbToDec(g_eTFHatDye[m_iDataDye][0], g_eTFHatDye[m_iDataDye][1], g_eTFHatDye[m_iDataDye][2])));
	}

	return Plugin_Changed;
}

public RgbToDec(r, g, b)
{
	decl String:hex[32];
	Format(hex, sizeof(hex), "%02X%02X%02X", r, g, b);
	
	decl ret;
	StringToIntEx(hex, ret, 16);
	
	return ret;
}

public bool:TFSupport_ReadItemSchema()
{
	new Handle:m_hKV = CreateKeyValues("items_game");
	FileToKeyValues(m_hKV, "scripts/items/items_game.txt");

	g_hHatIDs = CreateArray(1);

	KvJumpToKey(m_hKV, "items");
	KvGotoFirstSubKey(m_hKV);

	decl String:m_szItemID[64];
	decl String:m_szSlot[64];
	do
	{
		KvGetSectionName(m_hKV, m_szItemID, sizeof(m_szItemID));
		KvGetString(m_hKV, "item_slot", m_szSlot, sizeof(m_szSlot));
		if(strcmp(m_szSlot, "head")==0)
			PushArrayCell(g_hHatIDs, StringToInt(m_szItemID));
	} while (KvGotoNextKey(m_hKV));

	CloseHandle(m_hKV);
	return true;
}