#if defined _itemsapi_included_
  #endinput
#endif
#define _itemsapi_included_
 
#define ITEM_NAME_LEN				64	// max length of item names
#define MAX_ATTRIBUTE_NAME_LEN		64	// max length of an attribute name
#define ITEM_CLASS_LEN				64	// max length of an item class name
 
enum TFiaSlotType
{
	TFia_Slot_unknown=0,				// items will never be put in this category, but it may have uses
	TFia_Slot_head,					// this is the most important item class, so it comes first :)
	TFia_Slot_misc,	
	TFia_Slot_action,
	TFia_Slot_primary,
	TFia_Slot_secondary,
	TFia_Slot_melee,
	TFia_Slot_building,
	TFia_Slot_pda,
	TFia_Slot_pda2,
	TFia_Slot_wearable,				// items will never be put in this category, but it may overridden to this category (ItemsApi_GetSlotEx)
};

/**
 * Returns true if the items schema is cached and available
 *
**/
native bool:ItemsApi_Ready();


/**
 * Returns the item equip slot of an item, unknown on failure
 *
 * @param num1    An Item Definition Index
 * @param num2    If true, will attempt to re-categorize weapons into logical slots (spy revolvers returned as TFia_Slot_primary instead of TFia_Slot_secondary)
**/
native TFiaSlotType:ItemsApi_GetSlot(defindex, bool:recategorize = false);


/**
 * Returns the item equip slot of an item, unknown on failure
 * Use this to filter out "tf_wearable" items which may be returned as weapons otherwise (items like the razorback or buff banner)
 *
 * @param num1    An Item Definition Index
 * @param num2    A TFiaSlotType to override the return slot index if it is a "tf_werable" but not a TFia_Slot_head or TFia_Slot_misc type (usually a weapon wearable)
 * @param num3    If true, will attempt to re-categorize weapons into logical slots (spy revolvers returned as TFia_Slot_primary instead of TFia_Slot_secondary)
**/
native TFiaSlotType:ItemsApi_GetSlotEx(defindex, TFiaSlotType:weapon_wearable = TFia_Slot_wearable, bool:recategorize = false);


/**
 * Returns true if an item is paintable
 *
 * @param num1    An Item Definition Index
**/
native bool:ItemsApi_Paintable(defindex);


/**
 * Returns true if an item is wearable (tf_wearable)
 *
 * @param num1    An Item Definition Index
**/
native bool:ItemsApi_Wearable(defindex);


/**
 * Returns length of string written to buffer, 0 on failure.
 *
 * @param num1    An Item Definition Index
 * @param num2    buffer to write class name of size ITEM_CLASS_LEN
**/
native ItemsApi_GetClassName(defindex, String:name[]);


/**
 * Returns length of string written to buffer, 0 on failure.
 *
 * @param num1    An Item Definition Index
 * @param num2    buffer to write item name of size ITEM_NAME_LEN
 * @param num3    if true, default item names will be processed to make them more readable
**/
native ItemsApi_GetName(defindex, String:name[], bool:rename = false); 


/**
 * Returns the actual number of attributes an item has, 0 on failure or no attributes.
 *
 * @param num1    An Item Definition Index
**/
native ItemsApi_GetNumAttributes(defindex);


/**
 * Returns the value of the requested attribute, and writes its name to the buffer, 0.0 on failure.
 *
 * @param num1    An Item Definition Index
 * @param num2    An attribute id 0 +
 * @param num3    buffer to write item name of size MAX_ATTRIBUTE_NAME_LEN
**/
native Float:ItemsApi_GetAttribute(defindex, attribid, String:attribname[]);



public SharedPlugin:__pl_itemsapi =
{
	name = "itemsapi",
	file = "itemsapi.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

public __pl_itemsapi_SetNTVOptional()
{
	MarkNativeAsOptional("ItemsApi_Ready");
	MarkNativeAsOptional("ItemsApi_GetSlot");
	MarkNativeAsOptional("ItemsApi_GetSlotEx");
	MarkNativeAsOptional("ItemsApi_Paintable");
	MarkNativeAsOptional("ItemsApi_Wearable");
	MarkNativeAsOptional("ItemsApi_GetClassName");
	MarkNativeAsOptional("ItemsApi_GetName");
	MarkNativeAsOptional("ItemsApi_GetNumAttributes");
	MarkNativeAsOptional("ItemsApi_GetAttribute");
}