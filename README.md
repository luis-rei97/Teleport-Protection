# Teleport-Protection

A Simple Teleport Protection, meant to be for CS:S and CS:GO servers, using the Source Mod Addon;

This plugin just protects you from any damage from a time (defined by the server owner) since you touched a teleport entity (called trigger_teleport).
It doesn't need any zones plugin, but only works with teleports that is caused by touching a trigger_teleport!

This plugin was meant to be private (just for my community), but some m*********** decided to share it with everyone (because I gave to a friend and he decided to configure), so it's totally my fault.
But the problem is that he tried to sell many times, so I decided to publish here on github, with some differences.

Changelog since the "leaked" version:

<ul>
<li>Added Translations, to be easy to configure to server owners.</li>
<li>Added colors to the translations, if you want a colorfull text.</li>
<li>Added a CVAR to change the time you want to be fully god mode.</li>
<li>Converted everything to the new Syntax.</li>
</ul>


Installation:

Drag the file named telekill_protect.smx to sourcemod/plugins.
Drag the file named sm_telekill_protection.phrases.txt to sourcemod/translations.
Load the plugin using the command "sm_rcon sm plugins load telekill_protect.smx" in the console, or just wait for the next map.

For the developers:

To compile, you need the ColorVariables include (to add the colors) - https://forums.alliedmods.net/showthread.php?t=267743

Known bugs:

The trigger_push entity can also triggers this, which I didn't fix yet for private reasons (I will release a new version ASAP).

I hope you enjoyed!

My Steam Profile if you have any questions -> http://steamcommunity.com/id/HallucinogenicTroll/
