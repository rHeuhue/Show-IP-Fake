#include <amxmodx>
#include <fvault>

new g_iMaxPlayers, szFakeIP[MAX_PLAYERS + 1][MAX_IP_LENGTH]
new const szVaultFile[] = "Players_IPs"

public plugin_init()
{
	register_plugin("Show IP", "1.0", "Huehue, TheRedShoko")
	
	register_concmd("amx_showip", "ShowIPs")
	register_concmd("amx_checkip", "CheckIP", .info="<Nick> - shows last IP connected to the nick")
	
	g_iMaxPlayers = get_maxplayers()
}

public client_putinserver(id)
{
	GenerateFakeIP(id)
}

public ShowIPs(id)
{
	new szName[MAX_NAME_LENGTH], szIP[MAX_IP_LENGTH], szAuthID[MAX_AUTHID_LENGTH]
	
	console_print(id, "< ----------------------- < IP Shower > ----------------------- >^n")
	for (new i = 1; i <= g_iMaxPlayers; i++)
	{
		if (!is_user_connected(i))
		{
			continue
		}
		
		get_user_name(i, szName, charsmax(szName))
		get_user_ip(i, szIP, charsmax(szIP), 1)
		get_user_authid(i, szAuthID, charsmax(szAuthID))
		
		SaveUserIP(szName, szIP)
		
		if (get_user_flags(id) & ADMIN_RCON || i == id)
		{
			console_print(id, "^t^t^t^t^t%s - [ %s ] [ %s ]", szName, szIP, szAuthID)
		}
		else
		{
			console_print(id, "^t^t^t^t^t%s - [ %s ] [ %s ]", szName, szFakeIP[i], szAuthID)
		}
	}
	console_print(id, "^n< ----------------------- < IP Shower > ----------------------- >^n")
	
	return PLUGIN_HANDLED;
}

public CheckIP(id)
{
	if (!(get_user_flags(id) & ADMIN_RCON))
		return PLUGIN_HANDLED
	
	new szName[MAX_NAME_LENGTH]
	read_argv(1, szName, charsmax(szName))
	
	FindIP(id, szName)
	
	return PLUGIN_HANDLED
}

GenerateFakeIP( id )
{
	for (new i = 0; i < 4; i++)
	{
		if (i != 0 && i < 3)
		{
			format(szFakeIP[id], charsmax(szFakeIP[]), "%s.%i", szFakeIP[id], random(256))
		}
		else
		{
			format(szFakeIP[id], charsmax (szFakeIP[]), "%s.%i", szFakeIP[id], random_num(1, 256))
		}
	}
}

SaveUserIP(szName[], szIP[])
{
	fvault_set_data(szVaultFile, szName, szIP)
}

FindIP(id, szName[])
{
	new szIP[MAX_IP_LENGTH]
	
	if (fvault_get_data(szVaultFile, szName, szIP, charsmax (szIP)))
	{
		console_print(id, "%s lastly has been connected from %s", szName, szIP)
	}
	else
	{
		console_print(id, "%s couldn't be found in the database!", szName)
	}
} 
