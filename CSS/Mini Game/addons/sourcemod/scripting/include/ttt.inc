#if defined _ttt_included
	#endinput
#endif
#define _ttt_included

enum Role
{
	k_None=0,
	k_Innocent,
	k_Traitor,
	k_Detective
}

native Role:TTT_GetPlayerRole(client);