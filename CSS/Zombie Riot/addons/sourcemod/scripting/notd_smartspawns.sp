//Unique_Compile_String: v2a//

//Created by: [NotD] l0calh0st
//Website: www.notdelite.com

#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define SAFEDISTANCE 700
#define MAXDISTANCE 2000
#define SAMPLETIME 10.0
#define MAXSPAWNS 200

new maxPlayers;
new Float:spawnVecArray[MAXSPAWNS][3];
new spawnCount;
new bool:canRandomSpawn = false;
new Handle:repeatTimer;

public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);
	HookEvent("round_end", RoundEnd);
	HookEvent("round_start", RoundStart);
}

public OnPluginEnd()
{
	UnhookEvent("player_spawn", PlayerSpawn);
	UnhookEvent("round_end", RoundEnd);
	UnhookEvent("round_start", RoundStart);
}

public OnMapStart()
{
	maxPlayers = GetMaxClients();
	for (new x = 0; x < MAXSPAWNS; x++)
	{
		spawnVecArray[x][0] = -1.0;
		spawnVecArray[x][1] = -1.0;
		spawnVecArray[x][2] = -1.0;
	}
}

public Action:FindSpawns(Handle:timer)
{
	if (canRandomSpawn)
	{
		if (spawnCount != MAXSPAWNS)
		{
			for (new x = 1; x < maxPlayers; x++)
			{
				if (!IsValidEdict(x))
					continue;
			
				if (GetClientTeam(x) == 3 && IsPlayerAlive(x) && spawnCount != MAXSPAWNS)
				{
					GetClientAbsOrigin(x, spawnVecArray[spawnCount]);
					spawnCount++;
				}
			}
		}
		if (spawnCount == MAXSPAWNS)
		{
			//Get spawns first
			for (new spawnIndex = 0; spawnIndex < MAXSPAWNS; spawnIndex++)
			{
				for (new client = 1; client <= maxPlayers; client++)
				{
					if (!IsClientConnected(client))
						continue;
				
					if (!IsClientInGame(client))
						continue;
							
					if (GetClientTeam(client) == 1)
						continue;

				
					new Float:playerVec[3];
					
					GetClientAbsOrigin(client, playerVec);
					if (GetVectorDistance(playerVec, spawnVecArray[spawnIndex]) > MAXDISTANCE)
					{
						//Assign the far player to the list, so he gets some trouble ;)
						spawnVecArray[spawnIndex][0] = playerVec[0];
						spawnVecArray[spawnIndex][1] = playerVec[1];
						spawnVecArray[spawnIndex][2] = playerVec[2];
					}
				}
			}
		}
	}
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (GetClientTeam(client) == 2 && canRandomSpawn)
	{
		new spawnNum;
		if (SpawnChecker(spawnNum))
		{
			if (spawnNum != MAXSPAWNS)
			{
				if (spawnVecArray[spawnNum][0] != -1.0 && spawnNum < MAXSPAWNS)
					TeleportEntity(client, spawnVecArray[spawnNum], NULL_VECTOR, NULL_VECTOR);
			}
		}
	}
}

public Action:RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	for (new x = 0; x < MAXSPAWNS; x++)
	{
		spawnVecArray[x][0] = -1.0;
		spawnVecArray[x][1] = -1.0;
		spawnVecArray[x][2] = -1.0;
	}
	spawnCount = 0;
	CreateTimer(20.0, RandomSpawn, _, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:RandomSpawn(Handle:timer)
{
	canRandomSpawn = true;
	new String:currentMap[10];
	GetCurrentMap(currentMap, sizeof(currentMap));
	if (currentMap[0] == 'z' && currentMap[1] == 'h' && currentMap[2] == 'c')
	{
		repeatTimer = CreateTimer(10.0, FindSpawns, _, TIMER_REPEAT);
	}
	else if (currentMap[0] == 'z' && currentMap[1] == 'e')
	{
		repeatTimer = CreateTimer(10.0, FindSpawns, _, TIMER_REPEAT);
	}
	else if (currentMap[0] == 'z' && currentMap[1] == 'h')
	{
		repeatTimer = CreateTimer(10.0, FindSpawns, _, TIMER_REPEAT);
	}
	else
	{
		repeatTimer = CreateTimer(SAMPLETIME, FindSpawns, _, TIMER_REPEAT);
	}
		
}

public Action:RoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	canRandomSpawn = false;
	if (repeatTimer != INVALID_HANDLE)
	{
		KillTimer(repeatTimer);
		repeatTimer = INVALID_HANDLE;
	}
}

public bool:SpawnChecker(&spawnNum)
{
	new Float:playerVec[3];
	spawnNum = GetRandomInt(0, spawnCount);
	
	for (new x = 1; x < maxPlayers; x++)
	{
		if (!IsValidEdict(x))
			continue;
		
		GetClientAbsOrigin(x, playerVec);
		
		//Check if player is alive and if so check if safe distance for this spawn.
		if (GetClientTeam(x) == 3 && IsPlayerAlive(x) && spawnNum != MAXSPAWNS)
		{
			new Float:distance = GetVectorDistance(spawnVecArray[spawnNum], playerVec);
			if (distance < SAFEDISTANCE)
			{
				x = 1;
				if (spawnNum != spawnCount)
					spawnNum++;
				else
					return false;
			}
		}
	}
	return true;
}