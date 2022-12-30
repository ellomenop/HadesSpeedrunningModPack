--[[
    WaveControl
    Authors:
        pseudo (Discord: paulos#6237)
    Change the possible wave counts of various encounters
]]
ModUtil.Mod.Register("WaveControl")

local config = {WaveSettings = "NoTart3Wave"}

WaveControl.config = config

WaveControl.Presets = { 
    Vanilla = {
        GeneratedTartarus = {
            MinWaves = 1,
            MaxWaves = 3,
        },
            GeneratedAsphodel = {
            MinWaves = 2,
            MaxWaves = 3,
        },
            GeneratedElysium = {
            MinWaves = 2,
            MaxWaves = 3,
        },
    },
    Only1Wave = {
        GeneratedTartarus = {
            MinWaves = 1,
            MaxWaves = 1,
        },
            GeneratedAsphodel = {
            MinWaves = 1,
            MaxWaves = 1,
        },
            GeneratedElysium = {
            MinWaves = 1,
            MaxWaves = 1,
        },
    },
    NoTart3Wave = {
        GeneratedTartarus = {
            MinWaves = 1,
            MaxWaves = 2,
        },
            GeneratedAsphodel = {
            MinWaves = 2,
            MaxWaves = 3,
        },
            GeneratedElysium = {
            MinWaves = 2,
            MaxWaves = 3,
        },

    },
    No3Wave = {
        GeneratedTartarus = {
            MinWaves = 1,
            MaxWaves = 2,
        },
            GeneratedAsphodel = {
            MinWaves = 2,
            MaxWaves = 2,
        },
            GeneratedElysium = {
            MinWaves = 2,
            MaxWaves = 2,
        },
    }
}

function WaveControl.SetWaves()
    ModUtil.MapSetTable(EncounterData, WaveControl.Presets[WaveControl.config.WaveSettings])
end

ModUtil.LoadOnce( function()
  WaveControl.SetWaves()
end)

ModUtil.Path.Wrap("StartNewRun", function ( baseFunc, currentRun )
    WaveControl.SetWaves()
    return baseFunc(currentRun)
end, WaveControl)