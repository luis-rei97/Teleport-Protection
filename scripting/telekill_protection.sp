#include <sourcemod>
#include <sdktools>
#include <colorvariables>

// CVAR to change the timer's time;
ConVar g_time_float;



public Plugin myinfo =
{
    name = "Telekill Protection",
    author = "Hallucinogenic Troll",
    description = "A Simple Teleport Protection, to prevent kills right after going through a teleport",
    version = "1.3",
    url = "http://ptfun.net/newsite/"
};

public void OnPluginStart()
{
	g_time_float = CreateConVar("sm_telekill_protection_time", "1.0", "Amount of time (in seconds) to disable damage in a player after touching the trigger", _, true, 0.0, false);
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	
	LoadTranslations("sm_telekill_protection.phrases");
	
	AutoExecConfig(true, "sm_telekill_protection");
}

public Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	HookEntityOutput("trigger_teleport", "OnStartTouch", Output_TeleStartTouch);
}

public Action Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	UnhookEntityOutput("trigger_teleport", "OnStartTouch", Output_TeleStartTouch);
}

public Output_TeleStartTouch(const char[] output, int caller, int activator, float delay)
{
	// If the player isn't in god mode, it will proceed;
	if(GetEntProp(activator, Prop_Data, "m_takeDamage") == 2)
	{
		SetEntProp(activator, Prop_Data, "m_takedamage", 0, 1);
		CPrintToChat(activator, "[\x0EAnti-Telekill\x01] %t", "Protected Message", RoundToNearest(GetConVarFloat(g_time_float)));
		CreateTimer(1.0, Timer_GodMode, activator);
	}
}

public Action Timer_GodMode(Handle timer, int client)
{
	if(IsPlayerAlive(client))
	{
		// If the player is with god mode, it will disable it;
		if(GetEntProp(client, Prop_Data, "m_takeDamage") == 0)
		{
			CPrintToChat(client, "[\x0EAnti-Telekill\x01] %t", "Unprotected Message");
			SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
		}
	}
	
	return Plugin_Stop;
}