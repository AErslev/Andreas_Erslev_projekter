#if defined _vip_included
 #endinput
#endif
#define _vip_included

enum VipFlag
{
	Vip_None = 0,
	Vip_Generic,
	Vip_Name,
	Vip_Clan,
	Vip_Money,
	Vip_Skins,
	Vip_Reserve1,
	Vip_Reserve2,
	Vip_Reserve3,
  Vip_Manager,
  Vip_Root,
	Vip_Custom1,
	Vip_Custom2,
	Vip_Custom3,
	Vip_Custom4,
	Vip_Custom5,
	Vip_Custom6,
	Vip_Custom7,
	Vip_Custom8,
	Vip_Custom9,
}

native GetVipID(client);
native DoMedKit(client);
native GetNumKits(client);
native bool:GetVipFlag(client, VipFlag:flag);

forward OnClientPostVipCheck(client);


stock VipFlag:FindVipFlagByChar(c)
{	
	switch(c)
	{
	case 'a':
		return Vip_Generic;
	case 'b':
		return Vip_Name;
	case 'c':
		return Vip_Clan;
	case 'd':
		return Vip_Money;
	case 'e':
		return Vip_Skins;
	case 'f':
		return Vip_Reserve1;
	case 'g':
		return Vip_Reserve2;
	case 'h':
		return Vip_Reserve3;
	case 'j':
		return Vip_Custom1;
	case 'k':
		return Vip_Custom2;
	case 'l':
		return Vip_Custom3;
	case 'm':
		return Vip_Custom4;
	case 'n':
		return Vip_Custom5;
	case 'o':
		return Vip_Custom6;
	case 'p':
		return Vip_Custom7;
	case 'q':
		return Vip_Custom8;
	case 'r':
		return Vip_Custom9;
	case 'y':
		return Vip_Manager;
	case 'z':
		return Vip_Root;
	}
	
	return Vip_None;
}