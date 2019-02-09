<h1>[CS:S?/CS:GO] Teleport-Protection - Changelog</h1>

<p>Just to note every change that was made since the plugin's release.</p>
<p>If you want to see every function that the plugin has, read the [README.md](https://github.com/hallucinogenic/Teleport-Protection/blob/master/README.md)  file;</p>

<h2>Version 1.0 </h2>

- Plugin Release

<h2>Version 1.1 and 1.2</h2>

- Significant changes to the plugin (compared to the "leaked" version).

<h2>Version 1.3</h2>

- Some changes to the plugin, to fix some errors that can appear in logs (thanks Mitchell).

<h2>Version 1.4fix</h2>

- Added a cvar named <b>sm_telekill_spawnprotection</b> (Default: 5.0) - Time to enable this plugin after the round starts. It is highly recommended to set the value equal or bigger than your SpawnProtection plugin (if you have it);
- Added a cvar named <b>sm_telekill_weaponfire</b> (Default: 1) - If a player fires a gun when he has the protection, he will be unprotected (useful for people who abuses the protections and kill people that went to the teleport a bit before);
- Simply a new method to track the trigger_teleport (I believe it doesn't protect with trigger_push anymore, at least it doesn't happen in my server);