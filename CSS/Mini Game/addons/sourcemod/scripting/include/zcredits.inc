#define MSG_LENGTH 192

native Credits_Give(client, amount);
native Credits_Take(client, amount);
native Credits_Get(client);
native Credits_GetMax();

public CPrintToChat(client, String:format[], any:...)
{
	new String:msg[MSG_LENGTH];
	new String:fformat[MSG_LENGTH];
	Format(fformat, sizeof(fformat), "\x04[Equinox]\x01 %s", format);
	VFormat(msg, MSG_LENGTH, fformat, 3);
	
	new Handle:bf = StartMessageOne("SayText2", client);
	BfWriteByte(bf, client);
	BfWriteByte(bf, 0);
	BfWriteString(bf, msg);
	EndMessage();
}

public CPrintToChatAll(String:format[], any:...)
{
	new String:msg[MSG_LENGTH];
	new String:fformat[MSG_LENGTH];
	Format(fformat, sizeof(fformat), "\x04[Equinox]\x01 %s", format);
	VFormat(msg, MSG_LENGTH, format, 2);
	
	for(new i=0;i<=MaxClients;++i)
	{
		if(!IsClientInGame(i))
			continue;
		new Handle:bf = StartMessageOne("SayText2", i);
		BfWriteByte(bf, i);
		BfWriteByte(bf, 0);
		BfWriteString(bf, msg);
		EndMessage();
	}
}