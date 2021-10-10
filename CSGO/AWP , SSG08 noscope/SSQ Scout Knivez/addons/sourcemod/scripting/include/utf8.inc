#if !defined _UTF8_included
#define _UTF8_included

stock UTF8_Encode(const String:in[], len, String:out[], maxlen)
{
	new idx = 0;
	decl m_unBytes;

	for(new i=0;i<len;++i)
	{
		m_unBytes = UTF8_GetContinuationBytes(in[i]);

		if(m_unBytes == -1)
			return idx;

		if(m_unBytes == 0)
		{
			if(in[i]<32)
				idx += Format(out[idx], maxlen-idx, "\\u%04X", in[i]);
			else
				out[idx++]=in[i];
		}
		else
		{
			new m_unSum = 0;

			for(new a=m_unBytes;a>=0;--a)
			{
				m_unSum += in[i+a]<<((m_unBytes-a)*8);
			}

			idx += Format(out[idx], maxlen-idx, "\\u%04X", UTF8_GetCodePoint(m_unSum, m_unBytes));
			i+=m_unBytes;
		}
	}

	out[idx]=0;

	return idx;
}

stock UTF8_GetContinuationBytes(byte)
{
	new ret = 0;
	for(new i=7;i>=0;--i)
	{
		if(UTF8_GetBitAt(byte, i)==0)
			break;
		else
			++ret;
	}

	// Malformed UTF-8 byte
	if(ret == 1 || ret == 8)
		return -1;
	else if(ret > 0)
		--ret;

	return ret;
}

stock UTF8_GetCodePoint(num, cont)
{
	new ret = 0;
	for(new i=0;i<cont;++i)
	{
		new n = UTF8_GetNum(num, 6);
		ret += n<<(i*6);
		num=num>>8;
	}

	ret += UTF8_GetNum(num, 8-(cont+2))<<(cont*6);
	return ret;
}

public UTF8_GetNum(byte, bits)
{
	new ret = 0;
	for(new i=bits;i>=0;--i)
	{
		if(UTF8_GetBitAt(byte, i))
			ret = UTF8_SetBitAt(ret, i);
	}
	return ret;
}

public UTF8_GetBitAt(byte, pos)
{
	return (byte >> pos) & 1;
}

public UTF8_SetBitAt(byte, pos)
{
	return byte | (1<<pos);
}

#endif