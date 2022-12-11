--[[
    EnemyControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
        Museus (Discord: Museus#7777)
    Dependencies: ModUtil, RCLib
    Change the pool of enemies eligible in each room, allowing certain enemy types to be removed.
]]
ModUtil.Mod.Register("EnemyControl")

local config = {
    EnemySetting = "Vanilla"
}
EnemyControl.config = config --TODO add config option in menu
EnemyControl.EligibleEnemies = {}
EnemyControl.VanillaSets = {}

EnemyControl.Presets = { -- Define rulesets
    Vanilla = {},
    Hypermodded1 = {
        StyxSmallRoom = {
            TinyRat = false,
        }
    },
    Hypermodded2 = {
        Tartarus = {
            Numbskull = false,
            Witch = false,
        },
        Asphodel = {
            Bloodless = false,
            Gorgon = false,
        },
        Elysium = {
            Spearman = false,
            Bowman = false,
            Shieldsman = false,
            Swordsman = false,
            Flamewheel = false,
        },
        StyxSmallRoom = {
            TinyRat = false,
        }
    },
    RatsOClock = {
        Tartarus = {
            TinyRat = true,
        },
        TartarusElite = {
            TinyRat = true,
        },
        TartarusSurvival = {
            TinyRat = true,
        },
        Asphodel = {
            TinyRat = true,
        },
        AsphodelElite = {
            TinyRat = true,
        },
        Elysium = {
            TinyRat = true,
        },
        ElysiumElite = {
            TinyRat = true,
        },
        StyxSmallRoom = {
            TinyRat = true,
        },
        StyxSmallRoomElite = {
            TinyRat = true,
        },
        StyxSmallRoomSingle = {
            TinyRat = true,
        },
    },
    Neuron = {
        Tartarus = {
            ArmoredSplitter = true,
        },
        TartarusElite = {
            ArmoredSplitter = true,
        },
        TartarusSurvival = {
            ArmoredSplitter = true,
        },
        Asphodel = {
            ArmoredSplitter = true,
        },
        AsphodelElite = {
            ArmoredSplitter = true,
        },
        Elysium = {
            ArmoredSplitter = true,
        },
        ElysiumElite = {
            ArmoredSplitter = true,
        },
        StyxSmallRoom = {
            ArmoredSplitter = true,
        },
        StyxSmallRoomElite = {
            ArmoredSplitter = true,
        },
        StyxSmallRoomSingle = {
            ArmoredSplitter = true,
        },
    },
}

EnemyControl.InheritVanilla = { -- Biomes set to true will inherit the vanilla enemy set and only remove those set to false, biomes set to false will start from 0 and only add those set to true.
    Hypermodded1 = {
        StyxSmallRoom = true,
    },
    Hypermodded2 = {
        Tartarus = true,
        Asphodel = true,
        Elysium = true,
        StyxSmallRoom = true,
    }
}

EnemyControl.RuleOverrides = { -- Any overrides to enemy eligibility are made here. Only option currently supported is HardForce, which will make the enemy always eligible to appear. TODO add overrides for minimum and maximum biome depth per biome
    Neuron = {
        ArmoredSplitter = {
            HardForce = true,
        },
    },
}

function EnemyControl.ReadPreset() --Read current preset and create table of enemies marked as eligible
    local Preset = EnemyControl.Presets[config.EnemySetting]
    local InheritVanilla = {}
    if EnemyControl.InheritVanilla[config.EnemySetting] ~= nil then
        InheritVanilla = EnemyControl.InheritVanilla[config.EnemySetting]
    end
    for biome, _ in pairs(Preset) do
        EnemyControl.EligibleEnemies[biome] = {}
        if InheritVanilla[biome] == true then
            RCLib.PopulateMinLength(
                EnemyControl.EligibleEnemies[biome],
                RCLib.RemoveIneligibleStrings(Preset[biome],EnemyControl.VanillaSets[RCLib.EncodeEnemySet(biome)],RCLib.NameToCode.Enemies),
                1
            )
        else
            RCLib.PopulateMinLength(
                EnemyControl.EligibleEnemies[biome],
                RCLib.GetEligible(Preset[biome],RCLib.NameToCode.Enemies),
                1
            )
        end
    end
end

function EnemyControl.UpdatePools() -- Inject every non-empty biome of the current preset into the relevant biomes in EnemySets.lua
    DebugPrint({Text = "Enemy preset: "..EnemyControl.config.EnemySetting})
    if EnemyControl.InheritVanilla[config.EnemySetting] ~= nil then
        InheritVanilla = EnemyControl.InheritVanilla[config.EnemySetting]
    end
    for biome, pool in pairs(EnemyControl.EligibleEnemies) do
        EnemyControl.Target = RCLib.EncodeEnemySet(biome)
        EnemyControl.Pool = pool
        ModUtil.Table.Replace(EnemySets[EnemyControl.Target], EnemyControl.Pool)
        DebugPrint({Text = "Updated enemy pool for "..biome})
    end
end

ModUtil.LoadOnce( function()
    EnemyControl.VanillaSets = ModUtil.Table.Copy(EnemySets)
    EnemyControl.ReadPreset()
    EnemyControl.UpdatePools()
end)

-- When a new run is started, make sure to apply the pool settings
ModUtil.Path.Wrap("StartNewRun", function ( baseFunc, currentRun )
    EnemyControl.ReadPreset()
    EnemyControl.UpdatePools()
    return baseFunc(currentRun)
end, EnemyControl)

ModUtil.Path.Wrap("IsEnemyEligible", function ( baseFunc, enemyName, encounter, wave )
    local Preset = EnemyControl.config.EnemySetting
    local EnemyRef = RCLib.DecodeEnemy(enemyName)
    local Overrides = {}
    if EnemyControl.RuleOverrides[Preset] ~= nil and EnemyControl.RuleOverrides[Preset][EnemyRef] ~= nil then
        Overrides = EnemyControl.RuleOverrides[Preset][EnemyRef]
    end
    if Overrides.HardForce then
        return true
    end
    return baseFunc( enemyName, encounter, wave )
end, EnemyControl)

