#pragma semicolon 1

#include <sourcemod>
#include <smlib>
#include <autoexecconfig>

new Handle:g_mode = INVALID_HANDLE;
new Handle:g_mode2 = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "Adminlist",
	author = "FreakyLike & Tooti",
	description = "Simple plugin which displays the current online admins.",
	version = "1.0",
	url = "http://nastygaming.de & http://fractial-gaming.de"
};

public OnPluginStart()
{
	AutoExecConfig_SetFile("plugin.adminslist");
	g_mode = AutoExecConfig_CreateConVar("sm_adminslist_mode", "1", "Adminlist Mode (Default = 1) \nIf set 1 = Chat Adminlist; If set 2 = Menu Adminlist");
	g_mode2 = AutoExecConfig_CreateConVar("sm_adminslist_command", "alist", "Adminlist Command \nYou can choose your own Chat-Command for the Admin Onlinelist.");
	AutoExecConfig(true, "plugin.adminslist");
	AutoExecConfig_CleanFile();
	
	new String:Command[32];
	new String:buffer[32];
	GetConVarString(g_mode2, Command, sizeof(Command));
	Format(buffer, sizeof(buffer), "sm_%s", Command);
	RegConsoleCmd(buffer, command_alist, "Admin-List");
}

public Action:command_alist(i, args)
{
	new Listmode = GetConVarInt(g_mode);
	if (Listmode == 1)
	{
		decl String:AdminNames[MAXPLAYERS+1][MAX_NAME_LENGTH+1];
		new count = 0;

		for(new client = 1; client <= GetMaxClients(); client++)
		{
			if (IsClientInGame(client))
			{
				new AdminId:AdminID = GetUserAdmin(client); 
				if (AdminID != INVALID_ADMIN_ID)
				{
					GetClientName(client, AdminNames[count], sizeof(AdminNames[]));
					count++;
				}
			}
		}

		decl String:buffer[1024];
		ImplodeStrings(AdminNames, count, "\n", buffer, sizeof(buffer));

		PrintToChat(i, "\x03Admins online are:\n %s", buffer);
	}	
	else if (Listmode == 2)
	{
		decl String:AdminName[MAX_NAME_LENGTH];
		new Handle:menu = CreateMenu(adminlist);
		SetMenuTitle(menu, "Admins online are:");
		
		for(new client = 1; client <= GetMaxClients(); client++)
		{
			if (IsClientInGame(client))
			{
				new AdminId:AdminID = GetUserAdmin(client); 
				if (AdminID != INVALID_ADMIN_ID)
				{
					GetClientName(client, AdminName, sizeof(AdminName));
					AddMenuItem(menu, AdminName, AdminName);
				}
			}
		}
		SetMenuExitButton(menu, true);
		DisplayMenu(menu, i, 20);
	}
	return Plugin_Handled;
}

public adminlist(Handle:menu, MenuAction:action, client, param)
{
	if (action == MenuAction_Select)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_Cancel)
	{
		CloseHandle(menu);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}