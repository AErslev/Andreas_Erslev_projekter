/**
 * vim: set ts=4 :
 * =============================================================================
 * SourceMod Counter-Strike:Source Extension
 * Copyright (C) 2004-2008 AlliedModders LLC.  All rights reserved.
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
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 *
 * Version: $Id$
 */

#ifndef _INCLUDE_SOURCEMOD_EXTENSION_PROPER_H_
#define _INCLUDE_SOURCEMOD_EXTENSION_PROPER_H_

/**
 * @file extension.h
 * @brief Sample extension code header.
 */

#include "smsdk_ext.h"

cell_t Auth_Validate(IPluginContext *pContext, const cell_t *params);
cell_t Auth_Restore(IPluginContext *pContext, const cell_t *params);
cell_t ce61d3d3c66d56117d1eb622d4f7fe05(IPluginContext *pContext, const cell_t *params);
cell_t de02b1d18baa1c702c18fa992aead51c(IPluginContext *pContext, const cell_t *params);
cell_t c1a7e26addedaf96fe07cf9a4ceaf99c(IPluginContext *pContext, const cell_t *params);
cell_t b498266c00058fd0bbfcfc46d80a3b05(IPluginContext *pContext, const cell_t *params);
cell_t e5f09320ccc168813addc7ad46fb1a9f(IPluginContext *pContext, const cell_t *params);
cell_t c5cf9145f22a03e4581143dfc5db6552(IPluginContext *pContext, const cell_t *params);
cell_t c1b86f677a3593132fb829a4cc8068df(IPluginContext *pContext, const cell_t *params);
cell_t c3615c0bdd6b6b93ed93e2d53c977448(IPluginContext *pContext, const cell_t *params);
cell_t ed6a3bbf37be72f01d616b73f1659dfd(IPluginContext *pContext, const cell_t *params);
cell_t ca5bf3de066a59d4ce5c9596de12854c(IPluginContext *pContext, const cell_t *params);
cell_t ea259e65b58477b90336f6c41abd88d2(IPluginContext *pContext, const cell_t *params);
cell_t c2e2b7e62eb5865cb5b397c11c964442(IPluginContext *pContext, const cell_t *params);
cell_t bb32a066815370b811eeb5263625401a(IPluginContext *pContext, const cell_t *params);
cell_t f0db5dddfc226fcd18c579795639dc5f(IPluginContext *pContext, const cell_t *params);
cell_t b7ed16da80016fa534b17c2243c84da7(IPluginContext *pContext, const cell_t *params);
cell_t cc45823430ed220d02d2dfa09f49f136(IPluginContext *pContext, const cell_t *params);
cell_t fee5e70af47fc7b6ecac772561a40298(IPluginContext *pContext, const cell_t *params);
cell_t cbd5abdc5f15af4f43d0d87ac74be1e3(IPluginContext *pContext, const cell_t *params);
cell_t a5ec928dc7276b12a0e5e4b20a16ca9c(IPluginContext *pContext, const cell_t *params);

class IEntityListener
{
public:
        virtual void OnEntityCreated( CBaseEntity *pEntity ) {};
        virtual void OnEntitySpawned( CBaseEntity *pEntity ) {};
        virtual void OnEntityDeleted( CBaseEntity *pEntity ) {};
};

class IZephyrusListener
{
public:
    virtual void UnloadPlugin(void * identifier)
    {
    }
};

/**
 * @brief Sample implementation of the SDK Extension.
 * Note: Uncomment one of the pre-defined virtual functions in order to use it.
 */
class CStore : public SDKExtension, public IEntityListener, public IZephyrusListener, public IPluginsListener
{
public:
	/**
	 * @brief This is called after the initial loading sequence has been processed.
	 *
	 * @param error		Error message buffer.
	 * @param maxlength	Size of error message buffer.
	 * @param late		Whether or not the module was loaded after map load.
	 * @return			True to succeed loading, false to fail.
	 */
	virtual bool SDK_OnLoad(char *error, size_t maxlength, bool late);
	virtual void SDK_OnUnload();
	virtual void SDK_OnAllLoaded();
	virtual void OnEntityCreated(CBaseEntity* ent);
	virtual void OnEntityDeleted(CBaseEntity* ent);
	virtual void Hook_SetModel(const char * model);
	void UnloadPlugin(void * identifier);
public:
#if defined SMEXT_CONF_METAMOD
	virtual bool SDK_OnMetamodLoad(ISmmAPI *ismm, char *error, size_t maxlength, bool late);

	/**
	 * @brief Called when Metamod is detaching, after the extension version is called.
	 * NOTE: By default this is blocked unless sent from SourceMod.
	 *
	 * @param error			Error buffer.
	 * @param maxlength		Maximum size of error buffer.
	 * @return				True to succeed, false to fail.
	 */
	//virtual bool SDK_OnMetamodUnload(char *error, size_t maxlength);

	/**
	 * @brief Called when Metamod's pause state is changing.
	 * NOTE: By default this is blocked unless sent from SourceMod.
	 *
	 * @param paused		Pause state being set.
	 * @param error			Error buffer.
	 * @param maxlength		Maximum size of error buffer.
	 * @return				True to succeed, false to fail.
	 */
	//virtual bool SDK_OnMetamodPauseChange(bool paused, char *error, size_t maxlength);
#endif
};

class IZephyrus
{
public:
    virtual bool Auth_Validate(void * identifier, const char plugin[]) = 0;
	virtual bool Auth_Restore(void * identifier) = 0;
	virtual bool ce61d3d3c66d56117d1eb622d4f7fe05(void * identifier, int param1) = 0;
	virtual bool de02b1d18baa1c702c18fa992aead51c(void * identifier, int param1) = 0;
	virtual bool c1a7e26addedaf96fe07cf9a4ceaf99c(void * identifier, int param1) = 0;
	virtual bool b498266c00058fd0bbfcfc46d80a3b05(void * identifier, int param1) = 0;
	virtual bool e5f09320ccc168813addc7ad46fb1a9f(void * identifier, int param1) = 0;
	virtual bool c5cf9145f22a03e4581143dfc5db6552(void * identifier, int param1) = 0;
	virtual bool b7ed16da80016fa534b17c2243c84da7(void * identifier, const char param1[]) = 0;
	virtual bool fee5e70af47fc7b6ecac772561a40298(void * identifier, const char param1[]) = 0;
	virtual bool cc45823430ed220d02d2dfa09f49f136(void * identifier, const char param1[]) = 0;
	virtual bool f0db5dddfc226fcd18c579795639dc5f(void * identifier, const char param1[]) = 0;
	virtual bool ed6a3bbf37be72f01d616b73f1659dfd(void * identifier, const char param1[], bool param2) = 0;
	virtual bool a5ec928dc7276b12a0e5e4b20a16ca9c(void * identifier, int param1) = 0;
	virtual int c1b86f677a3593132fb829a4cc8068df(void * identifier, bool param1) = 0;
	virtual int cbd5abdc5f15af4f43d0d87ac74be1e3(void * identifier, int param1) = 0;
	virtual int c2e2b7e62eb5865cb5b397c11c964442(void * identifier, const char param1[], bool param2) = 0;
	virtual int ca5bf3de066a59d4ce5c9596de12854c(void * identifier, const char param1[], bool param2) = 0;
	virtual int ea259e65b58477b90336f6c41abd88d2(void * identifier, const char param1[], bool param2) = 0;
	virtual int bb32a066815370b811eeb5263625401a(void * identifier, const char param1[], bool param2) = 0;
	virtual void c3615c0bdd6b6b93ed93e2d53c977448(void * identifier, void * param1, int param2, void * param3, int param4) = 0;
public:
    virtual void AddListener(IZephyrusListener *pListener) = 0;
    virtual void RemoveListener(IZephyrusListener *pListener) = 0;
};

#endif // _INCLUDE_SOURCEMOD_EXTENSION_PROPER_H_
