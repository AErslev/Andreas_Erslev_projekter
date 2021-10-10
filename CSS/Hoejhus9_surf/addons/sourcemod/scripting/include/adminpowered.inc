#if defined _adminpowered_included
	#endinput
#endif
#define _adminpowered_included


enum SendType
{
	SendType_Text=0,
	SendType_Binary
}

functag AdminPoweredCommand public(Handle:socket, String:command[], args);
functag AdminPoweredWebsocketConnected Action:public(Handle:socket, Handle:client, const String:remoteAddr[], const remotePort);
functag AdminPoweredWebsocketDisconnected public(Handle:socket, Handle:client);
functag AdminPoweredWebsocketError public(Handle:socket, Handle:client);
functag AdminPoweredWebsocketReceive public(Handle:socket, Handle:client, SendType:type, const String:data[], const len);

forward AdminPowered_OnBroadcastVoice(client, const String:data[], bytes);

// Commands

native AdminPowered_AddCommand(const String:command[], AdminPoweredCommand:callback);
native AdminPowered_GetCmdArg(num, String:buf[], maxlen);
native AdminPowered_Print(const String:format[], any:...);

// Websocket
native Handle:AdminPowered_OpenWebSocket(const String:interface[], port,  AdminPoweredWebsocketConnected:cbConnect, 
																	AdminPoweredWebsocketDisconnected:cbDisconnect,
																	AdminPoweredWebsocketError:cbError,
																	AdminPoweredWebsocketReceive:cbReceive);

native AdminPowered_SendMessage(Handle:client, SendType:type, String:data[], len=0);

public Extension:__ext_adminpowered = 
{
	name = "AdminPowered",
	file = "adminpowered.ext",
#if defined AUTOLOAD_EXTENSIONS
	autoload = 1,
#else
	autoload = 0,
#endif
#if defined REQUIRE_EXTENSIONS
	required = 1,
#else
	required = 0,
#endif
};