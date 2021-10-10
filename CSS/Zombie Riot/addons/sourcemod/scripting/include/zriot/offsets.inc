//Unique_Compile_String: v2//

/**
 * ====================
 *	 Zombie Riot
 *   File: offsets.inc
 *   Author: Greyscale
 * ====================
 */

new offsBaseVelocity;
new offsGetVelocity2;
new offsSpeed;
new offsCollision;
new offsMoney;
new offsFOV;
new offsBuyZone;
new offsFadeMin;
new offsFadeMax;

FindOffsets()
{
	offsBaseVelocity = FindSendPropInfo("CBasePlayer", "m_vecBaseVelocity");
	if (offsBaseVelocity == -1)
	{
		SetFailState("Couldn't find \"m_vecBaseVelocity\"!");
	}
	
	offsGetVelocity2 = FindSendPropInfo("CBasePlayer", "m_vecVelocity[2]");
	if (offsGetVelocity2 == -1)
	{
		SetFailState("Couldn't find \"m_vecVelocity[2]\"!");
	}
	
	offsSpeed = FindSendPropInfo("CCSPlayer", "m_flLaggedMovementValue");
	if (offsSpeed == -1)
	{
		SetFailState("Couldn't find \"m_flLaggedMovementValue\"!");
	}
	
	offsCollision = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	if (offsCollision == -1)
	{
		SetFailState("Couldn't find \"m_CollisionGroup\"!");
	}
	
	offsMoney = FindSendPropInfo("CCSPlayer", "m_iAccount");
	if (offsMoney == -1)
	{
		SetFailState("Couldn't find \"m_iAccount\"!");
	}
	
	offsFOV = FindSendPropInfo("CBasePlayer", "m_iDefaultFOV");
	if (offsFOV == -1)
	{
		SetFailState("Couldn't find \"m_iDefaultFOV\"!");
	}
	
	offsBuyZone = FindSendPropInfo("CCSPlayer", "m_bInBuyZone");
	if (offsBuyZone == -1)
	{
		SetFailState("Couldn't find \"m_bInBuyZone\"!");
	}
	
	offsFadeMin = FindSendPropInfo("CCSPlayer", "m_fadeMinDist");
	if (offsFadeMin == -1)
	{
		SetFailState("Couldn't find \"m_fadeMinDist\"!");
	}
	
	offsFadeMax = FindSendPropInfo("CCSPlayer", "m_fadeMaxDist");
	if (offsFadeMax == -1)
	{
		SetFailState("Couldn't find \"m_fadeMaxDist\"!");
	}
}

SetPlayerVelocity(client, const Float:vec[3])
{
	SetEntDataVector(client, offsBaseVelocity, vec, true);
}

SetPlayerSpeed(client, Float:speed)
{
	new Float:newspeed = speed / 300.0;
	SetEntDataFloat(client, offsSpeed, newspeed, true);
}

NoCollide(client, bool:nocollide)
{
	if (nocollide)
	{
		SetEntData(client, offsCollision, 2, 1, true);
	}
	else
	{
		SetEntData(client, offsCollision, 5, 1, true);
	}
}

SetPlayerMoney(client, amount)
{
	SetEntData(client, offsMoney, amount, 4, true);
}

SetPlayerFOV(client, fov)
{
	SetEntData(client, offsFOV, fov, 1, true);
}

bool:IsClientInBuyZone(client)
{
	return bool:GetEntData(client, offsBuyZone);
}

SetPlayerMinDist(client, Float:mindist)
{
	SetEntDataFloat(client, offsFadeMin, mindist);
}

SetPlayerMaxDist(client, Float:maxdist)
{
	SetEntDataFloat(client, offsFadeMax, maxdist);
}

RemoveAllPlayersWeapons(client)
{
	new _iTemp;
	for(new i = 0; i < 6; i++)
	{
		while((_iTemp = GetPlayerWeaponSlot(client, i)) != -1)
		{
			RemovePlayerItem(client, _iTemp);
			AcceptEntityInput(_iTemp, "Kill");
		}
	}
}

TerminateRound(Float:delay, CSRoundEndReason:reason)
{
	if (tHUD == INVALID_HANDLE)
		return;
	
	CS_TerminateRound(delay, reason);
}