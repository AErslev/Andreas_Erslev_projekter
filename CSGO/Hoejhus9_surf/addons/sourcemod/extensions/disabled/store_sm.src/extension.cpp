#include <sourcemod_version.h>
#include "extension.h"

#define ZEPHYRUS_INTERFACE_VERSION "ZEPHYRUS_INTERFACE_001"

CStore g_CStore;
SMEXT_LINK(&g_CStore);

IGameConfig *g_pGameConf = NULL;
IForward *g_pClientModel = NULL;

IZephyrus *g_pZephyrus = NULL;

int g_iSetModelOffset = 0;

SH_DECL_MANUALHOOK1_void(SetModel, 0, 0, 0, const char *);

const sp_nativeinfo_t MyNatives[] = 
{
	{"Auth_Validate", Auth_Validate},
	{"Auth_Restore", Auth_Restore},
	{"ce61d3d3c66d56117d1eb622d4f7fe05", ce61d3d3c66d56117d1eb622d4f7fe05},
	{"de02b1d18baa1c702c18fa992aead51c", de02b1d18baa1c702c18fa992aead51c},
	{"c1a7e26addedaf96fe07cf9a4ceaf99c", c1a7e26addedaf96fe07cf9a4ceaf99c},
	{"b498266c00058fd0bbfcfc46d80a3b05", b498266c00058fd0bbfcfc46d80a3b05},
	{"e5f09320ccc168813addc7ad46fb1a9f", e5f09320ccc168813addc7ad46fb1a9f},
	{"c5cf9145f22a03e4581143dfc5db6552", c5cf9145f22a03e4581143dfc5db6552},
	{"c1b86f677a3593132fb829a4cc8068df", c1b86f677a3593132fb829a4cc8068df},
	{"cbd5abdc5f15af4f43d0d87ac74be1e3", cbd5abdc5f15af4f43d0d87ac74be1e3},
	{"c2e2b7e62eb5865cb5b397c11c964442", c2e2b7e62eb5865cb5b397c11c964442},
	{"ca5bf3de066a59d4ce5c9596de12854c", ca5bf3de066a59d4ce5c9596de12854c},
	{"ea259e65b58477b90336f6c41abd88d2", ea259e65b58477b90336f6c41abd88d2},
	{"ed6a3bbf37be72f01d616b73f1659dfd", ed6a3bbf37be72f01d616b73f1659dfd},
	{"bb32a066815370b811eeb5263625401a", bb32a066815370b811eeb5263625401a},
	{"b7ed16da80016fa534b17c2243c84da7", b7ed16da80016fa534b17c2243c84da7},
	{"f0db5dddfc226fcd18c579795639dc5f", f0db5dddfc226fcd18c579795639dc5f},
	{"fee5e70af47fc7b6ecac772561a40298", fee5e70af47fc7b6ecac772561a40298},
	{"cc45823430ed220d02d2dfa09f49f136", cc45823430ed220d02d2dfa09f49f136},
	{"a5ec928dc7276b12a0e5e4b20a16ca9c", a5ec928dc7276b12a0e5e4b20a16ca9c},
	{"c3615c0bdd6b6b93ed93e2d53c977448", c3615c0bdd6b6b93ed93e2d53c977448},
	{NULL,			NULL},
};

bool CStore::SDK_OnLoad(char *error, size_t maxlength, bool late)
{
	int ifaceerror;
	g_pZephyrus = (IZephyrus *)g_SMAPI->MetaFactory(ZEPHYRUS_INTERFACE_VERSION, &ifaceerror, NULL);
	if (!g_pZephyrus)
	{
		snprintf(error, maxlength, "Metamod Plugin is not running. (Error: %d)", ifaceerror);
		return false;
	}

	g_pZephyrus->AddListener(this);
	plsys->AddPluginsListener(this);

	char conf_error[255];
	if(gameconfs->LoadGameConfigFile("store.gamedata", &g_pGameConf, conf_error, sizeof(conf_error)))
	{
		g_pGameConf->GetOffset("SetModel", &g_iSetModelOffset);
		if (g_iSetModelOffset > 0)
			SH_MANUALHOOK_RECONFIGURE(SetModel, g_iSetModelOffset, 0, 0);
	}

	void *gEntList = gamehelpers->GetGlobalEntityList();
    if (!gEntList)
    {
            g_pSM->Format(error, maxlength, "Cannot find gEntList pointer");
            return false;
    }

	int offset = -1;
    if (!g_pGameConf->GetOffset("EntityListeners", &offset))
    {
            g_pSM->Format(error, maxlength, "Cannot find EntityListeners offset");
            return false;
    }

    CUtlVector<IEntityListener *> *pListeners = (CUtlVector<IEntityListener *> *)((intptr_t)gEntList + offset);
    pListeners->AddToTail(this);

	g_pClientModel = forwards->CreateForward("Store_OnClientModelChanged", ET_Event, 2, NULL, Param_Cell, Param_String);
	return true;
}

void CStore::SDK_OnUnload()
{
	forwards->ReleaseForward(g_pClientModel);

	plsys->RemovePluginsListener(this);
	g_pZephyrus->RemoveListener(this);
}

void CStore::SDK_OnAllLoaded()
{
	sharesys->AddNatives(myself, MyNatives);
}

void CStore::UnloadPlugin(void * identifier)
{
	IPlugin * plugin = plsys->FindPluginByContext(((IPluginContext *)identifier)->GetContext());
	g_SMAPI->ConPrintf("Unauthorized use of plugin detected, unloading plugin...(%s)\n", plugin->GetFilename());
	plsys->UnloadPlugin(plugin);
}

bool CStore::SDK_OnMetamodLoad(ISmmAPI *ismm, char *error, size_t maxlen, bool late)
{
	return true;
}

void CStore::OnEntityCreated(CBaseEntity *pEntity)
{
	if(!g_iSetModelOffset)
			return;

	int entity = gamehelpers->ReferenceToIndex(gamehelpers->EntityToBCompatRef(pEntity));
	if(entity > 0 && entity <= playerhelpers->GetMaxClients())
		SH_ADD_MANUALHOOK_MEMFUNC(SetModel, pEntity, &g_CStore, &CStore::Hook_SetModel, false);
}

void CStore::OnEntityDeleted(CBaseEntity *pEntity)
{
	if(!g_iSetModelOffset)
		return;
	int entity = gamehelpers->ReferenceToIndex(gamehelpers->EntityToBCompatRef(pEntity));
	if(entity > 0 && entity <= playerhelpers->GetMaxClients())
		SH_REMOVE_MANUALHOOK_MEMFUNC(SetModel, pEntity, &g_CStore, &CStore::Hook_SetModel, false);
}

void CStore::Hook_SetModel(const char * model)
{
	CBaseEntity *pEntity = META_IFACEPTR(CBaseEntity);
	int entity = gamehelpers->ReferenceToIndex(gamehelpers->EntityToBCompatRef(pEntity));
	
	g_pClientModel->PushCell(entity);
	g_pClientModel->PushString(model);
	g_pClientModel->Execute(0);
}

cell_t Auth_Validate(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	bool result = g_pZephyrus->Auth_Validate(pContext, str);

	if(!result)
		g_CStore.UnloadPlugin(pContext);

	return result;
}

cell_t Auth_Restore(IPluginContext *pContext, const cell_t *params)
{
	g_pZephyrus->Auth_Restore(pContext);
	return 0;
}

cell_t ce61d3d3c66d56117d1eb622d4f7fe05(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->ce61d3d3c66d56117d1eb622d4f7fe05(pContext, params[1]);
}

cell_t c1a7e26addedaf96fe07cf9a4ceaf99c(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->c1a7e26addedaf96fe07cf9a4ceaf99c(pContext, params[1]);
}

cell_t de02b1d18baa1c702c18fa992aead51c(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->de02b1d18baa1c702c18fa992aead51c(pContext, params[1]);
}

cell_t b498266c00058fd0bbfcfc46d80a3b05(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->b498266c00058fd0bbfcfc46d80a3b05(pContext, params[1]);
}

cell_t e5f09320ccc168813addc7ad46fb1a9f(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->e5f09320ccc168813addc7ad46fb1a9f(pContext, params[1]);
}

cell_t c5cf9145f22a03e4581143dfc5db6552(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->c5cf9145f22a03e4581143dfc5db6552(pContext, params[1]);
}

cell_t c1b86f677a3593132fb829a4cc8068df(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->c1b86f677a3593132fb829a4cc8068df(pContext, params[1]);
}

cell_t cbd5abdc5f15af4f43d0d87ac74be1e3(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->cbd5abdc5f15af4f43d0d87ac74be1e3(pContext, params[1]);
}


cell_t c3615c0bdd6b6b93ed93e2d53c977448(IPluginContext *pContext, const cell_t *params)
{
	cell_t * param1 = 0;
	cell_t * param2 = 0;
	pContext->LocalToPhysAddr(params[1], &param1);
	pContext->LocalToPhysAddr(params[3], &param2);

	g_pZephyrus->c3615c0bdd6b6b93ed93e2d53c977448(pContext, param1, params[2], param2, params[4]);
	return 1;
}

cell_t ed6a3bbf37be72f01d616b73f1659dfd(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->ed6a3bbf37be72f01d616b73f1659dfd(pContext, str, params[2]);
}

cell_t c2e2b7e62eb5865cb5b397c11c964442(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->c2e2b7e62eb5865cb5b397c11c964442(pContext, str, params[2]);
}

cell_t bb32a066815370b811eeb5263625401a(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->bb32a066815370b811eeb5263625401a(pContext, str, params[2]);
}

cell_t ca5bf3de066a59d4ce5c9596de12854c(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->ca5bf3de066a59d4ce5c9596de12854c(pContext, str, params[2]);
}

cell_t ea259e65b58477b90336f6c41abd88d2(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->ea259e65b58477b90336f6c41abd88d2(pContext, str, params[2]);
}

cell_t cc45823430ed220d02d2dfa09f49f136(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->cc45823430ed220d02d2dfa09f49f136(pContext, str);
}

cell_t b7ed16da80016fa534b17c2243c84da7(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->b7ed16da80016fa534b17c2243c84da7(pContext, str);
}

cell_t fee5e70af47fc7b6ecac772561a40298(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->fee5e70af47fc7b6ecac772561a40298(pContext, str);
}

cell_t f0db5dddfc226fcd18c579795639dc5f(IPluginContext *pContext, const cell_t *params)
{
	char *str;
	pContext->LocalToString(params[1], &str);
	return g_pZephyrus->f0db5dddfc226fcd18c579795639dc5f(pContext, str);
}

cell_t a5ec928dc7276b12a0e5e4b20a16ca9c(IPluginContext *pContext, const cell_t *params)
{
	return g_pZephyrus->a5ec928dc7276b12a0e5e4b20a16ca9c(pContext, params[1]);
}