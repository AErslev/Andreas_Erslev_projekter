#if defined _easyrcon_included
 #endinput
#endif
#define _easyrcon_included

#if defined REQUIRE_EXTENSIONS
#undef REQUIRE_EXTENSIONS
#endif

#include <socket>

#define RCON_AUTH_PACKET 3
#define RCON_AUTH_RESPONSE_PACKET 2
#define RCON_EXECCOMMAND_PACKET 2
#define RCON_RESPONSE_VALUE 0

#define GetSocketData(%1) new m_unID = ReadPackCell(Handle:%1);\
	new bool:m_bAuthorized = bool:ReadPackCell(Handle:%1);\
	new Function:m_fnConnected = Function:ReadPackCell(Handle:%1);\
	new Function:m_fnCommand = Function:ReadPackCell(Handle:%1);\
	new Function:m_fnDisconnected = Function:ReadPackCell(Handle:%1);\
	new m_aData = ReadPackCell(Handle:%1);\
	new Handle:m_hRCON = Handle:ReadPackCell(Handle:%1);\
	ResetPack(Handle:%1);\
	if(m_unID && m_bAuthorized && m_fnConnected && m_fnDisconnected && m_fnCommand && m_aData && m_hRCON) m_bAuthorized=!(!m_bAuthorized) // supress warnings.....

#if !defined _easyhttp_included
new bool:g_bExtensions = false;
new bool:g_bSockets = false;
#endif

stock EasyRCONCheckExtensions()
{
	g_bExtensions = true;
	g_bSockets = (GetExtensionFileStatus("socket.ext")==1?true:false);
}

stock WriteInteger(value, String:output[])
{
	output[0]=(value >> 0) & 0xff;
	output[1]=(value >> 8) & 0xff;
	output[2]=(value >> 16) & 0xff;
	output[3]=(value >> 24) & 0xff;
}

stock ReadInteger(String:input[])
{
	return (input[0] & 0x000000FF) |
		((input[1] << 8) & 0x0000FF00) |
		((input[2] << 16) & 0x00FF0000) |
		((input[3] << 24) & 0xFF000000);
}

stock Handle:EasyRCON(const String:ip[], port, Function:connected=INVALID_FUNCTION, Function:disconnected=INVALID_FUNCTION, Function:command=INVALID_FUNCTION, any:data=0)
{
	if(!g_bExtensions)
		EasyRCONCheckExtensions();

	if(g_bSockets)
	{
		new Handle:m_hData = CreateDataPack();
		WritePackCell(m_hData, 0);
		WritePackCell(m_hData, false);
		WritePackCell(m_hData, _:connected);
		WritePackCell(m_hData, _:command);
		WritePackCell(m_hData, _:disconnected);
		WritePackCell(m_hData, data);
		

		new Handle:m_hSocket = SocketCreate(SOCKET_TCP, EasyRCON_SocketError);
		SocketSetArg(m_hSocket, m_hData);
		SocketConnect(m_hSocket, EasyRCON_SocketConnected, EasyRCON_SocketReceive, EasyRCON_SocketDisconnected, ip, port);

		new Handle:m_hRCON = CreateDataPack();
		WritePackCell(m_hRCON, _:m_hSocket);
		WritePackCell(m_hRCON, _:m_hData);
		ResetPack(m_hRCON);
		WritePackCell(m_hData, _:m_hRCON);
		ResetPack(m_hData);

		return m_hRCON;
	}

	return INVALID_HANDLE;
}

stock EasyRCON_SendCommand(Handle:rcon, type, const String:data[])
{
	new Handle:m_hSocket = Handle:ReadPackCell(rcon);
	new Handle:m_hData = Handle:ReadPackCell(rcon);
	ResetPack(rcon);

	GetSocketData(m_hData);
	++m_unID;
	WritePackCell(m_hData, m_unID);
	ResetPack(m_hData);

	new String:m_sPacket[4096];
	WriteInteger(m_unID, m_sPacket[4]);
	WriteInteger(type, m_sPacket[8]);
	new m_nCells = strcopy(m_sPacket[12], sizeof(m_sPacket)-13, data);
	m_sPacket[12+m_nCells+1]=0;
	WriteInteger(10+m_nCells, m_sPacket);

	SocketSend(m_hSocket, m_sPacket, 14+m_nCells);
	return true;
}

public EasyRCON_Disconnect(Handle:rcon)
{
	new Handle:m_hSocket = Handle:ReadPackCell(rcon);
	new Handle:m_hData = Handle:ReadPackCell(rcon);
	ResetPack(rcon);

	SocketDisconnect(m_hSocket);
	CloseHandle(m_hSocket);
	CloseHandle(m_hData);
	CloseHandle(rcon);
}

public EasyRCON_SocketConnected(Handle:socket, any:data)
{
	GetSocketData(data);

	if(m_fnConnected != INVALID_FUNCTION)
	{
		Call_StartFunction(INVALID_HANDLE, m_fnConnected);
		Call_PushCell(m_hRCON);
		Call_PushCell(true);
		Call_PushCell(m_aData);
		Call_Finish();
	}
}

public EasyRCON_SocketReceive(Handle:socket, String:receiveData[], const dataSize, any:data)
{
	GetSocketData(data);

	new String:m_szData[4086];
	new m_nLength = ReadInteger(receiveData);
	new m_nID = ReadInteger(receiveData[4]);
	new m_nType = ReadInteger(receiveData[8]);

	if(m_nLength > sizeof(m_szData))
		m_nLength = sizeof(m_szData);
	strcopy(m_szData, m_nLength, receiveData[12]);

	if(m_nType == RCON_AUTH_RESPONSE_PACKET && m_nID != -1)
	{
		m_bAuthorized = true;
		ReadPackCell(data);
		WritePackCell(data, true);
		ResetPack(data);
	}

	if(m_fnCommand != INVALID_FUNCTION)
	{
		Call_StartFunction(INVALID_HANDLE, m_fnCommand);
		Call_PushCell(m_hRCON);
		Call_PushCell(m_bAuthorized);
		Call_PushCell(m_nType);
		Call_PushString(m_szData);
		Call_PushCell(m_aData);
		Call_Finish();
	}
}

public EasyRCON_SocketDisconnected(Handle:socket, any:data)
{
	GetSocketData(data);

	if(m_fnDisconnected != INVALID_FUNCTION)
	{
		Call_StartFunction(INVALID_HANDLE, m_fnDisconnected);
		Call_PushCell(m_hRCON);
		Call_PushCell(m_aData);
		Call_Finish();
	}

	CloseHandle(m_hRCON);
	CloseHandle(data);
	CloseHandle(socket);
}

public EasyRCON_SocketError(Handle:socket, const errorType, const errorNum, any:data)
{
	GetSocketData(data);

	if(m_fnConnected != INVALID_FUNCTION)
	{
		Call_StartFunction(INVALID_HANDLE, m_fnConnected);
		Call_PushCell(m_hRCON);
		Call_PushCell(false);
		Call_PushCell(m_aData);
		Call_Finish();
	}

	CloseHandle(m_hRCON);
	CloseHandle(data);
	CloseHandle(socket);
}

stock EasyRCON_IsAuthorized(Handle:rcon)
{
	new Handle:m_hSocket = Handle:ReadPackCell(rcon);
	new Handle:m_hData = Handle:ReadPackCell(rcon);
	ResetPack(rcon);

	GetSocketData(m_hData);
	return m_bAuthorized;
}