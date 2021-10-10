    #if defined _basestock_included
     #endinput
    #endif
    #define _basestock_included
     
    #if !defined CHAT_HIGHLIGHT
    #define CHAT_HIGHLIGHT "\x04"
    #endif
     
    #if !defined CHAT_NORMAL
    #define CHAT_NORMAL "\x01"
    #endif
     
    #if !defined CHAT_TAG
    #define CHAT_TAG "[Chat] "
    #endif
     
    #define MSG_LENGTH 192
    #define CVAR_LENGTH 128
     
    #define MAX_CVARS 32
     
    enum CVAR_TYPE
    {
            TYPE_INT = 0,
            TYPE_FLOAT,
            TYPE_STRING,
            TYPE_FLAG
    }
     
    enum CVAR_CACHE
    {
            Handle:hCvar,
            CVAR_TYPE:eType,
            any:aCache,
            String:sCache[CVAR_LENGTH],
            Function:fnCallback
    }
     
    new g_eCvars[MAX_CVARS][CVAR_CACHE];
     
    new g_iCvars = 0;
     
    #define LoopIngamePlayers(%1) for(new %1=1;%1<=MaxClients;++%1)\
                                                                    if(IsClientInGame(%1) && !IsFakeClient(%1))
                                                                   
    #define LoopAlivePlayers(%1) for(new %1=1;%1<=MaxClients;++%1)\
                                                                    if(IsClientInGame(%1) && IsPlayerAlive(%1))
	
	#define LoopTo(%1, %2) for(new %1=0;%1<%2;++%1)
	
	#define LoopFrom(%1, %2) for(new %1=%2;%1>0;--%1)
                                                                    
     
    stock DebugPrivate(String:format[], any:...)
    {
            new client = GetClientBySteamID("STEAM_0:1:19220707");
            if(client)
            {
                    new String:msg[MSG_LENGTH];
                    new String:msg2[MSG_LENGTH];
                    Format(msg, MSG_LENGTH, "%s%s%s%s", CHAT_HIGHLIGHT, CHAT_TAG, CHAT_NORMAL, format);
                    VFormat(msg2, MSG_LENGTH, msg, 3);
                   
                    new Handle:hBf;
                    hBf = StartMessageOne("SayText2", client);
                    if (hBf != INVALID_HANDLE)
                    {
                            BfWriteByte(hBf, client);
                            BfWriteByte(hBf, 0);
                            BfWriteString(hBf, msg2);
                            EndMessage();
                    }
            }
    }
     
    stock Chat(client, String:format[], any:...)
    {
            new String:msg[MSG_LENGTH];
            new String:msg2[MSG_LENGTH];
            Format(msg, MSG_LENGTH, "%s%s%s%s", CHAT_HIGHLIGHT, CHAT_TAG, CHAT_NORMAL, format);
            VFormat(msg2, MSG_LENGTH, msg, 3);
            ReplaceString(msg2, MSG_LENGTH, "{NORMAL}", CHAT_NORMAL);
            ReplaceString(msg2, MSG_LENGTH, "{HIGHLIGHT}", CHAT_HIGHLIGHT);
           
            new Handle:hBf;
            hBf = StartMessageOne("SayText2", client);
            if (hBf != INVALID_HANDLE)
            {
                    BfWriteByte(hBf, client);
                    BfWriteByte(hBf, 0);
                    BfWriteString(hBf, msg2);
                    EndMessage();
            }
    }
     
    stock ChatAll(String:format[], any:...)
    {
            new String:msg[MSG_LENGTH];
            new String:msg2[MSG_LENGTH];
            Format(msg, MSG_LENGTH, "%s%s%s%s", CHAT_HIGHLIGHT, CHAT_TAG, CHAT_NORMAL, format);
            VFormat(msg2, MSG_LENGTH, msg, 2);
            ReplaceString(msg2, MSG_LENGTH, "{NORMAL}", CHAT_NORMAL);
            ReplaceString(msg2, MSG_LENGTH, "{HIGHLIGHT}", CHAT_HIGHLIGHT);
           
            new Handle:hBf;
            for(new i=1;i<=MaxClients;++i)
            {
                    if(!IsClientInGame(i))
                            continue;
                    hBf = StartMessageOne("SayText2", i);
                    if (hBf != INVALID_HANDLE)
                    {
                            BfWriteByte(hBf, i);
                            BfWriteByte(hBf, 0);
                            BfWriteString(hBf, msg2);
                            EndMessage();
                    }
            }
    }
     
    stock RegisterConVar(String:name[], String:value[], String:description[], CVAR_TYPE:type, Function:callback=INVALID_FUNCTION, flags=0, bool:hasMin=false, Float:min=0.0, bool:hasMax=false, Float:max=0.0)
    {
            new Handle:cvar = CreateConVar(name, value, description, flags, hasMin, min, hasMax, max);
            HookConVarChange(cvar, GlobalConVarChanged);
            g_eCvars[g_iCvars][hCvar] = cvar;
            g_eCvars[g_iCvars][eType] = type;
            g_eCvars[g_iCvars][fnCallback] = callback;
            CacheCvarValue(g_iCvars);
            return g_iCvars++;
    }
     
    public GlobalConVarChanged(Handle:convar, const String:oldValue[], const String:newValue[])
    {
            for(new i=0;i<g_iCvars;++i)
                    if(g_eCvars[i][hCvar]==convar)
                    {
                            CacheCvarValue(i);
                   
                            if(g_eCvars[i][fnCallback]!=INVALID_FUNCTION)
                            {
                                    Call_StartFunction(INVALID_HANDLE, g_eCvars[i][fnCallback]);
                                    Call_PushCell(i);
                                    Call_Finish();
                            }
                   
                            return;
                    }
           
    }
     
    public CacheCvarValue(index)
    {
            if(g_eCvars[index][eType]==TYPE_INT)
                    g_eCvars[index][aCache] = GetConVarInt(g_eCvars[index][hCvar]);
            else if(g_eCvars[index][eType]==TYPE_FLOAT)
                    g_eCvars[index][aCache] = GetConVarFloat(g_eCvars[index][hCvar]);
            else if(g_eCvars[index][eType]==TYPE_STRING)
                    GetConVarString(g_eCvars[index][hCvar], g_eCvars[index][sCache], CVAR_LENGTH);
            else if(g_eCvars[index][eType]==TYPE_FLAG)
            {
                    GetConVarString(g_eCvars[index][hCvar], g_eCvars[index][sCache], CVAR_LENGTH);
                    g_eCvars[index][aCache] = ReadFlagString(g_eCvars[index][sCache]);
            }
    }
     
    public SQLCallback_Void(Handle:owner, Handle:hndl, const String:error[], any:suspend_errors)
    {
            if(hndl==INVALID_HANDLE && !suspend_errors)
                    LogError("SQL error happened. Error: %s", error);
    }
    
	public MenuHandler_Void(Handle:menu, MenuAction:action, client, param2)
	{
		if(action==MenuAction_End)
			CloseHandle(menu);
	}
	
    stock GetClientBySteamID(String:steamid[])
    {
            new String:authid[32];
            for(new i=1;i<=MaxClients;++i)
            {
                    if(!IsClientInGame(i))
                            continue;
                    if(!IsClientAuthorized(i))
                            continue;
                    GetClientAuthString(i, authid, sizeof(authid));
                    if(strcmp(authid, steamid)==0)
                            return i;
            }
            return 0;
    }
     
    stock GetClientByIP(String:ip[])
    {
            decl String:client_ip[16];
            for(new i=1;i<=MaxClients;++i)
            {
                    if(!IsClientInGame(i))
                            continue;
                    GetClientIP(i, client_ip, sizeof(client_ip));
                    if(strcmp(client_ip, ip)==0)
                            return i;
            }
            return 0;
    }
     
    stock GetClientPrivilege(client, flag, flags=-1)
    {
            if(flags==-1)
                    flags = GetUserFlagBits(client);
           
            if(flag == 0 || flags & flag || flags & ADMFLAG_ROOT)
                    return true;
            return false;
    }
     
    stock bool:GetCommunityID(String:AuthID[], String:FriendID[], size)
    {
            if(strlen(AuthID) < 11 || AuthID[0]!='S' || AuthID[6]=='I')
            {
                    FriendID[0] = 0;
                    return false;
            }
            new iUpper = 765611979;
            new iFriendID = StringToInt(AuthID[10])*2 + 60265728 + AuthID[8]-48;
            new iDiv = iFriendID/100000000;
            new iIdx = 9-(iDiv?iDiv/10+1?0);
            iUpper += iDiv;
            IntToString(iFriendID, FriendID[iIdx], size-iIdx);
            iIdx = FriendID[9];
            IntToString(iUpper, FriendID, size);
            FriendID[9] = iIdx;
            return true;
    }
     
    public bool:TraceRayDontHitSelf(entity, mask, any:data)
    {
            if(entity == data)
                    return false;
            return true;
    }
     
    public bool:TraceRayDontHitPlayers(entity, mask, any:data)
    {
            if(0 < entity <= MaxClients)
                    return false;
            return true;
    }
     
    public CreateCountdown(client, seconds, String:format[])
    {
            new Handle:pack = CreateDataPack();
            WritePackCell(pack, GetClientUserId(client));
            WritePackCell(pack, seconds);
            WritePackString(pack, format);
            ResetPack(pack);
     
            CreateTimer(0.0, Timer_Countdown, pack);
    }
     
    public CreateCountdownAll(seconds, String:format[])
    {
            new Handle:pack = CreateDataPack();
            WritePackCell(pack, 0);
            WritePackCell(pack, seconds);
            WritePackString(pack, format);
            ResetPack(pack);
     
            CreateTimer(0.0, Timer_Countdown, pack);
    }
     
    public Action:Timer_Countdown(Handle:timer, any:pack)
    {
            new userid = ReadPackCell(pack);
            decl client;
            if(userid!=0)
            {
                    client = GetClientOfUserId(userid);
                    if(!client)
                    {
                            CloseHandle(pack);
                            return Plugin_Stop;
                    }
            }
     
            new seconds = ReadPackCell(pack);
            decl String:format[192];
            ReadPackString(pack, format, sizeof(format));
     
            if(userid != 0)
                    PrintCenterText(client, "%t", format, seconds);
            else
                    PrintCenterTextAll("%t", format, seconds);
     
            if(seconds != 1)
            {
                    ResetPack(pack);
                    ReadPackCell(pack);
                    WritePackCell(pack, seconds-1);
                    ResetPack(pack);
     
                    CreateTimer(1.0, Timer_Countdown, pack);
            }
            else
                    CloseHandle(pack);
     
            return Plugin_Stop;
    }
     
    stock bool:AddMenuItemEx(Handle:menu, style, String:info[], String:display[], any:...)
    {
            decl String:m_display[256];
            VFormat(m_display, sizeof(m_display), display, 5);
            return (AddMenuItem(menu, info, m_display, style)?true:false);
    }
     
    stock bool:InsertMenuItemEx(Handle:menu, position, style, String:info[], String:display[], any:...)
    {
            decl String:m_display[256];
            VFormat(m_display, sizeof(m_display), display, 6);
            if(GetMenuItemCount(menu)==position)
                    return (AddMenuItem(menu, info, m_display, style)?true:false);
            else
                    return (InsertMenuItem(menu, position, info, m_display, style)?true:false);
    }
     
    stock ClearTimer(&Handle:timer)
    {
            if(timer != INVALID_HANDLE)
            {
                    KillTimer(timer);
                    timer = INVALID_HANDLE;
            }
    }
     
    stock bool:ShouldHappen(chance)
    {
            return (GetRandomInt(1, 100/chance)==1?true:false);
    }
