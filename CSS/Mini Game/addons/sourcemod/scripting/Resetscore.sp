#include <sourcemod>
#include <sdktools>

#define PLUGIN_AUTHOR	"tuty"
#define PLUGIN_VERSION	"1.1"
#pragma semicolon 1

new Handle:gPluginEnabled = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "Resetscore",
	author = "Mester Skunk",
	description = "Type !resetscore in chat to reset your score.",
	version = "PLUGIN VERSION",
	url = "www.ligs.us"
};
public OnPluginStart()
{
	RegConsoleCmd( "say", CommandSay );
	RegConsoleCmd( "say_team", CommandSay );
	
	gPluginEnabled = CreateConVar( "sm_resetscore", "1" );
	CreateConVar( "resetscore_version", PLUGIN_VERSION, "Reset Score", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY );
}
public Action:CommandSay( id, args )
{
	decl String:Said[ 128 ];
	GetCmdArgString( Said, sizeof( Said ) - 1 );
	StripQuotes( Said );
	TrimString( Said );
	
	if( StrEqual( Said, "!resetscore" ) || StrEqual( Said, "!rs" ) || StrEqual( Said, "/rs" ) || StrEqual( Said, "/resetscore" ) )
	{
		if( GetConVarInt( gPluginEnabled ) == 0 )
		{
			PrintToChat( id, "\x03[Superskurkene ResetScore] The plugin is disabled." );
			PrintToConsole( id, "[Superskurkene ResetScore] You can't use this command when plugin is disabled!" );
		
			return Plugin_Continue;
		}

		if( GetClientDeaths( id ) == 0 && GetClientFrags( id ) == 0 )
		{
			PrintToChat( id, "\x03[Superskurkene ResetScore] Your score is already 0!" );
			PrintToConsole( id, "[Superskurkene ResetScore] You can't reset your score right now." );
			
			return Plugin_Continue;
		}
				
		SetClientFrags( id, 0 );
		SetClientDeaths( id, 0 );
	
		decl String:Name[ 32 ];
		GetClientName( id, Name, sizeof( Name ) - 1 );
	
		PrintToChat( id, "\x03[Superskurkene ResetScore] You have successfully reseted your score!" );
		PrintToChatAll( "\x03[Superskurkene ResetScore] %s has just reseted his score.", Name );
		PrintToConsole( id, "[Superskurkene ResetScore] You have successfully reseted your score." );
	}
	
	return Plugin_Continue;
}	 
stock SetClientFrags( index, frags )
{
	SetEntProp( index, Prop_Data, "m_iFrags", frags );
	return 1;
}
stock SetClientDeaths( index, deaths )
{
	SetEntProp( index, Prop_Data, "m_iDeaths", deaths );
	return 1;
}
