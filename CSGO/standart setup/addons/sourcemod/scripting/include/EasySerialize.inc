#if defined _easyserialize_included
 #endinput
#endif
#define _easyserialize_included

enum SerializeType {
	k_Float,
	k_Integer,
	k_String,
	k_Array
}

stock Handle:EasyUnserialize(const String:data[], &skip=0)
{
	new Handle:m_hValue = INVALID_HANDLE;

	switch(data[0])
	{
		case 'a':
		{
			skip += DeserializeArray(data[2], m_hValue)+2;
		}

		case 's':
		{
			skip += DeserializeString(data[2], m_hValue)+3;
		}

		case 'i':
		{
			skip += DeserializeInt(data[2], m_hValue)+3;
		}

		case 'd':
		{
			skip += DeserializeFloat(data[2], m_hValue)+3;
		}
	}

	return m_hValue;
}

stock DeserializeInt(const String:data[], &Handle:out)
{
	out = CreateTrie();
	SetTrieValue(out, "type", k_Integer);
	SetTrieValue(out, "value", StringToInt(data));

	new skip = 0;
	while('0' <= data[skip] <= '9' || data[skip]=='-') ++skip;

	return skip;
}

stock DeserializeFloat(const String:data[], &Handle:out)
{
	out = CreateTrie();
	SetTrieValue(out, "type", k_Float);
	SetTrieValue(out, "value", StringToFloat(data));

	new skip = 0;
	while('0' <= data[skip] <= '9' || data[skip]=='-' || data[skip]=='.') ++skip;

	return skip;
}

stock DeserializeString(const String:data[], &Handle:out)
{
	new m_unLength = StringToInt(data);

	new skip = 0;
	while(data[skip]!=':') ++skip;
	++skip;

	if(data[skip]!='"')
		return 0;
	++skip;

	new String:m_szValue[m_unLength+1];
	strcopy(m_szValue, m_unLength+1, data[skip]);

	skip += m_unLength;
	if(data[skip]!='"')
		return 0;
	++skip;

	out = CreateTrie();
	SetTrieValue(out, "type", k_String);
	SetTrieString(out, "value", m_szValue);
	SetTrieValue(out, "length", m_unLength);

	return skip;
}

stock DeserializeArray(const String:data[], &Handle:out)
{
	new m_unLength = StringToInt(data);

	new skip = 0;
	while(data[skip]!=':') ++skip;
	++skip;

	if(data[skip]!='{')
		return 0;
	++skip;

	out = CreateTrie();
	new Handle:m_hArray = CreateArray();
	SetTrieValue(out, "type", k_Array);
	SetTrieValue(out, "value", m_hArray);
	
	for(new i=0;i<m_unLength*2;++i)
	{
		new Handle:m_hValue = EasyUnserialize(data[skip], skip);
		if(m_hValue == INVALID_HANDLE)
		{
			DestroySerialized(out);
			out = INVALID_HANDLE;
			return 0;
		}

		PushArrayCell(m_hArray, m_hValue);
	}

	if(data[skip]!='}')
	{
		DestroySerialized(out);
		out = INVALID_HANDLE;
		return 0;
	}
	++skip;

	return skip;
}

stock GetSerializedInt(const Handle:ser, &out)
{
	new SerializeType:type;
	if(!GetTrieValue(ser, "type", type))
		return false;

	if(type == k_Integer)
	{
		if(GetTrieValue(ser, "value", out))
			return true;
	}
	else if(type == k_String)
	{
		decl m_unLength;
		if(!GetTrieValue(ser, "length", m_unLength))
			return false;
		new String:m_szValue[m_unLength+1];
		if(!GetTrieString(ser, "value", m_szValue, m_unLength+1))
			return false;
		out = StringToInt(m_szValue);
		return true;
	}
	return false;
}

stock GetSerializedFloat(const Handle:ser, &Float:out)
{
	new SerializeType:type;
	if(!GetTrieValue(ser, "type", type) || type != k_Float)
		return false;
	if(GetTrieValue(ser, "value", out))
		return true;
	return false;
}

stock GetSerializedString(const Handle:ser, String:out[], maxlen)
{
	new SerializeType:type;
	if(!GetTrieValue(ser, "type", type) || type != k_String)
		return false;
	if(GetTrieString(ser, "value", out, maxlen))
		return true;
	return false;
}

stock GetSerializedStringLength(const Handle:ser)
{
	new ret;
	GetTrieValue(ser, "length", ret);
	return ret;
}

stock Handle:GetSerializedMemberByString(const Handle:arr, const String:name[])
{
	new Handle:m_hArray;
	GetTrieValue(arr, "value", m_hArray);

	for(new i=0;i<GetArraySize(m_hArray);i+=2)
	{
		new Handle:m_hSer = GetArrayCell(m_hArray, i);
		new maxlen = GetSerializedStringLength(m_hSer)+1;
		new String:key[maxlen];
		GetSerializedString(m_hSer, key, maxlen);

		if(strcmp(key, name) == 0)
			return GetArrayCell(m_hArray, i+1);
	}

	return INVALID_HANDLE;
}

stock Handle:GetSerializedMemberByInt(const Handle:arr, name)
{
	new Handle:m_hArray;
	GetTrieValue(arr, "value", m_hArray);

	for(new i=0;i<GetArraySize(m_hArray);i+=2)
	{
		new Handle:m_hSer = GetArrayCell(m_hArray, i);

		if(GetSerializedInt(m_hSer) == name)
			return GetArrayCell(m_hArray, i+1);
	}

	return INVALID_HANDLE;
}

stock DestroySerialized(Handle:ser)
{
	if(ser == INVALID_HANDLE)
		return;

	new SerializeType:type;
	if(!GetTrieValue(ser, "type", _:type))
		return;

	if(type == k_Array)
	{
		new Handle:m_hArray;
		if(!GetTrieValue(ser, "value", m_hArray))
			return;
		for(new i=0;i<GetArraySize(m_hArray);++i)
		{
			new Handle:m_hValue = GetArrayCell(m_hArray, i);
			DestroySerialized(m_hValue);
		}
		CloseHandle(m_hArray);
	}
	
	CloseHandle(ser);
}