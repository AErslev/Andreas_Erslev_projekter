#if defined _database_included
 #endinput
#endif
#define _database_included
#define MYSQL_NONE 0
#define MYSQL_DRIVER 1
#define SQLITE_DRIVER 2
#define MAXQUERYLENGTH 512
new SQL_DRIVERIDENT=MYSQL_NONE;
new Handle:SQL_Hnd = INVALID_HANDLE;
new String:g_szTablePrefix[128];

stock Init_SQL(Timer:data=INVALID_FUNCTION, String:entry[], String:prefix[]="")
{
    Format(g_szTablePrefix, sizeof(g_szTablePrefix), "%s", prefix);
    if(SQL_Hnd == INVALID_HANDLE)
    {
        if(SQL_CheckConfig(entry))
        {
            SQL_TConnect(SqlConnect, entry, data);
        }else{
            PrintToServer("[ERROR] SQL: '%s' config parameter not found!", entry);
LogToFile(g_debug, "SQL Error Config not found %s", entry);
        }
    }else{
        PrintToServer("[ERROR] SQL: '%s' handle is started up already!", entry);
LogToFile(g_debug, "SQL Error Handle Exist %s", entry);
    }
}

public SqlConnect(Handle:owner, Handle:hndl, const String:error[], any:func)
{
    if(CheckHandle(owner) && CheckHandle(hndl))
    {
        SQL_Hnd = hndl;
        decl String:ident[32];
        SQL_GetDriverIdent(owner, ident, 32);
        if(StrEqual(ident, "mysql"))
        {
            SQL_DRIVERIDENT = MYSQL_DRIVER;
        }else{
            SQL_DRIVERIDENT = SQLITE_DRIVER;
		}
        if(Timer:func!=INVALID_FUNCTION && SQL_DRIVERIDENT!=MYSQL_NONE)
		{
			CreateTimer(0.0, func);
		}
    }else{
        PrintToServer("[ERROR] SQL: connection failed! error: %s", error);
LogToFile(g_debug, "SQL Connection error %s", error);
        return;
    }
}

stock CheckHandle(Handle:handle)
{
    return (handle != INVALID_HANDLE);
}

stock SQL_TQueryEx(SQLTCallback:callback, String:format[], any:...)
{
	new String:Query[MAXQUERYLENGTH];
	VFormat(Query, MAXQUERYLENGTH, format, 3);
	ReplaceString(Query, sizeof(Query), "{PREFIX}", g_szTablePrefix);
LogToFile(g_debug, Query);
	SQL_TQuery(SQL_Hnd, callback, Query);
}

stock SQL_TQueryEx2(SQLTCallback:callback, any:data, String:format[], any:...)
{
	new String:Query[MAXQUERYLENGTH];
	VFormat(Query, MAXQUERYLENGTH, format, 4);
	ReplaceString(Query, sizeof(Query), "{PREFIX}", g_szTablePrefix);
LogToFile(g_debug, Query);
	SQL_TQuery(SQL_Hnd, callback, Query, data);
}
stock SQL_Escape(String:Data[], maxlength)
{
	SQL_EscapeString(SQL_Hnd, Data, Data, maxlength);
}
stock SQL_VoidQuery(String:format[], any:...)
{
	new String:Query[MAXQUERYLENGTH];
	VFormat(Query, MAXQUERYLENGTH, format, 2);
	ReplaceString(Query, sizeof(Query), "{PREFIX}", g_szTablePrefix);
LogToFile(g_debug, Query);
	SQL_TQuery(SQL_Hnd, SQLCallback_Void, Query);
}
