#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <colorvariables>

// CVAR to change the timer's time;
ConVar g_time_float;

// Bool to check if he hooks a trigger_teleport when the "God Mode"'s timer is already activated.
bool PlayerIsAlreadyInGodMode[MAXPLAYERS+1] = false;


public Plugin myinfo =
{
    name = "Telekill Protection",
    author = "Hallucinogenic Troll",
    description = "A Simple Teleport Protection, to prevent kills right after going through a teleport",
    version = "1.2",
    url = "http://steamcommunity.com/id/HallucinogenicTroll/"
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
	if(!PlayerIsAlreadyInGodMode[activator])
	{
		float time = GetConVarFloat(g_time_float);
		PlayerIsAlreadyInGodMode[activator] = true;
		SetEntProp(activator, Prop_Data, "m_takedamage", 0, 1);
		CPrintToChat(activator, "[\x0EAnti-Telekill\x01] %t", "Protected Message", RoundToNearest(time));
		CreateTimer(1.0, Timer_GodMode, activator);
	}
}

public Action Timer_GodMode(Handle timer, int client)
{
	if(PlayerIsAlreadyInGodMode[client])
	{
		PlayerIsAlreadyInGodMode[client] = false;
		CPrintToChat(client, "[\x0EAnti-Telekill\x01] %t", "Unprotected Message");
		SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
	}
    	else
    	{
    		KillTimer(timer);
   	}
}