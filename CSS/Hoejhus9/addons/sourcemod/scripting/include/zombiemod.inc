#if defined _zm_included
 #endinput
#endif
#define _zm_included

native ZM_IsClientHuman(client);
native ZM_IsClientZombie(client);
native ZM_InfectClient(client, attacker=-1, bool:mother=false);

forward ZM_OnClientInfected(client, attacker, bool:mother);