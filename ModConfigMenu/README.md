Mod Config Menu
---------------

Utility mod that exposes the configuration of your
other Hades mods via an in-game UI, so you can change
them on the fly.

Features:
 - UI for toggling boolean values
 - Minimal setup

Settings are saved in your save file, so they're only
saved when the game is saved. If you change a setting
during a run, it will be forgotten if you "Give Up".

To use, add config like the following to your mod:

    local config = {
      ModName = "Your Mod's name",
      YourFirstSetting = true,
      YourSecondSetting = false 
    }
    ModConfigMenu.Register(config)

Check out the demo at https://youtu.be/pV1bP38hNxQ
