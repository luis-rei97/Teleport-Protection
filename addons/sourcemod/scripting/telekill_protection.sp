/* [CS:GO] Telekill Protection
 *
 *  Copyright (C) 2019 Hallucinogenic Troll
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include <sourcemod>
#include <sdktools>
#include <colorvariables>

// Plugin's ConVars;
ConVar g_telekill_time_float;
ConVar g_telekill_spawnprotection;
ConVar g_telekill_weaponfire;

Handle timer_handle[MAXPLAYERS + 1] = {INVALID_HANDLE, ...};
bool SpawnProtection = false;
bool AlreadyUnprotected[MAXPLAYERS+1] = {false, ...};


public Plugin myinfo =
{
    name = "Telekill Protection",
    author = "Hallucinogenic Troll",
    description = "A Simple Teleport Protection, to prevent kills right after going through a teleport",
    version = "1.4fix",
    url = "http://ptfun.net/newsite/"
};

public void OnPluginStart()
{
	g_telekill_time_float = CreateConVar("sm_telekill_protection_time", "1.0", "Time to give protection to a player when he touches the trigger", _, true, 0.0, false);
	g_telekill_spawnprotection = CreateConVar("sm_telekill_spawnprotection", "5.0", "Time to enable this plugin after the round starts (If you use spawn protection, use this)", _, true, 0.0, false);
	g_telekill_weaponfire = CreateConVar("sm_telekill_weaponfire", "1", "Removes player's protection right after he fires his weapons", _, true, 0.0, true, 0.0);
	HookEvent("round_start", Event_RoundStart);
	HookEvent("weapon_fire", Event_WeaponFire);
	
	LoadTranslations("sm_telekill_protection.phrases");
	
	AutoExecConfig(true, "sm_telekill_protection");
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
	SpawnProtection = true;
	int ent = -1;
	CreateTimer(GetConVarFloat(g_telekill_spawnprotection), Timer_DisableSpawn);
	while((ent = FindEntityByClassname(ent, "trigger_teleport")) != -1)
	{
		HookSingleEntityOutput(ent, "OnStartTouch", Output_TeleStartTouch)
   	}
}

public Action Event_WeaponFire(Event event, const char[] name, bool dontBroadcast)
{
	if(!SpawnProtection)
	{
		if(g_telekill_weaponfire)
		{
			int client = GetClientOfUserId(GetEventInt(event, "userid"));
			if(timer_handle[client] != INVALID_HANDLE)
			{
				timer_handle[client] = INVALID_HANDLE;
				CPrintToChat(client, "[\x0EAnti-Telekill\x01] %t", "WeaponFire Message");
				SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
				AlreadyUnprotected[client] = true;
			}
		}
	}
}

public Output_TeleStartTouch(const char[] output, int caller, int activator, float delay)
{
	if(!SpawnProtection)
	{		
			// If the player isn't in god mode, it will proceed;
			if(timer_handle[activator] == INVALID_HANDLE && GetEntProp(activator, Prop_Data, "m_takedamage") == 2)
			{
				SetEntProp(activator, Prop_Data, "m_takedamage", 0, 1);
				CPrintToChat(activator, "[\x0EPT'Fun \x04Anti-Telekill\x01] %t", "Protected Message", RoundToNearest(GetConVarFloat(g_telekill_time_float)));
				timer_handle[activator] = CreateTimer(GetConVarFloat(g_telekill_time_float), Timer_GodMode, GetClientUserId(activator));
			}
	}
}

public Action Timer_DisableSpawn(Handle timer, int client)
{
	SpawnProtection = false;
}

public Action Timer_GodMode(Handle timer, int client)
{
	if(IsClientInGame(client))
	{
		
		if(AlreadyUnprotected[client])
		{
			AlreadyUnprotected[client] = false;
		}
		else
		{
			// If the player is with god mode, it will disable it;
			if(timer != INVALID_HANDLE)
			{
				timer_handle[client] = INVALID_HANDLE;
				CPrintToChat(client, "[\x0EPT'Fun \x04Anti-Telekill\x01] %t", "Unprotected Message");
				SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
				KillTimer(timer);
			}
		}
	}
	return Plugin_Stop;
}