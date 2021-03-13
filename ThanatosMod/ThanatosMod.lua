--[[
    ThanatosMod v1.0
    Author:
        Museus (Discord: Museus#7777)
        ellomenop (Discord: ellomenop#2254)

    Gives options to modify or remove Thanatos
]]

ModUtil.RegisterMod("ThanatosMod")

local config = {
    ThanatosSetting = "Rebalanced"
}
ThanatosMod.config = config

ThanatosMod.Presets = {
    Removed = {},
    Rebalanced = {
        Tartarus = {
            BaseDifficulty = 94, -- Vanilla 200
            EliteScaling = 12, -- Vanilla 16
            MinWaves = 2, -- Vanilla 3
            MaxWaves = 2, -- Vanilla 3
        },
        Asphodel = {
            BaseDifficulty = 325, -- Vanilla 400
            EliteScaling = 30, -- Vanilla 40
            MinWaves = 2, -- Vanilla 3
            MaxWaves = 2, -- Vanilla 3
        },
        Elysium = {
            BaseDifficulty = 514, -- Vanilla 575
            EliteScaling = 80, -- Vanilla 110
            MinWaves = 2, -- Vanilla 3
            MaxWaves = 2, -- Vanilla 3
        }
    },
    Vanilla = {
        Tartarus = {
            BaseDifficulty = 200,
            EliteScaling = 16,
            MinWaves = 3,
            MaxWaves = 3,
        },
        Asphodel = {
            BaseDifficulty = 400,
            EliteScaling = 40,
            MinWaves = 3,
            MaxWaves = 3,
        },
        Elysium = {
            BaseDifficulty = 575,
            EliteScaling = 110,
            MinWaves = 3,
            MaxWaves = 3,
        }
    },
}

OnAnyLoad{ function()
    local maxThans = 1
    if config.ThanatosSetting == "Removed" then
      maxThans = 0
    end
    ModUtil.MapSetTable(EncounterData, {
        BaseThanatos = {
            MaxThanatosSpawnsThisRun = maxThans,
        },
    })
end}

function updateThanatosValues(data)
    local biome = string.sub(data.Name, 9, #data.Name)
    data.BaseDifficulty = ThanatosMod.Presets[config.ThanatosSetting][biome].BaseDifficulty
    data.HardEncounterOverrideValues = {
        DepthDifficultyRamp = ThanatosMod.Presets[config.ThanatosSetting][biome].EliteScaling
    }
    data.MinWaves = ThanatosMod.Presets[config.ThanatosSetting][biome].MinWaves
    data.MaxWaves = ThanatosMod.Presets[config.ThanatosSetting][biome].MaxWaves
end

ModUtil.WrapBaseFunction("SetupEncounter", function( baseFunc, encounterData, room )
    if config.ThanatosSetting ~= "Vanilla" and config.ThanatosSetting ~= "Removed" then
      local moddedEncounter = DeepCopyTable( encounterData )
      if string.match(moddedEncounter.Name, "Thanatos") then
  			updateThanatosValues(moddedEncounter)
  		end
      return baseFunc( moddedEncounter, room )
    end

    return baseFunc( encounterData, room )
end, ThanatosMod)
