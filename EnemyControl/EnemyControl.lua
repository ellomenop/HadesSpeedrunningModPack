--[[
    EnemyControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
        Museus (Discord: Museus#7777)
    Change the pool of enemies eligible in each room, allowing certain enemy types to be removed.
]]
ModUtil.Mod.Register("EnemyControl")

local config = {
  EnemySetting = "Vanilla"
}
EnemyControl.config = config --TODO add config option in menu

EnemyControl.Presets = { --Define rulesets
    Vanilla = {},
    Debug = {
        Tartarus = {
            Lout = true,
        }
    },
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
        },
        StyxSmallRoom = {
            TinyRat = false,
        }
    }
}

EnemyControl.PresetTypes = {
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

function EnemyControl.PopulateMinLength(targetTable, inputTable, minLength) --Populates a target table with the contents of an input table, repeatedly inserting until a minimum length is reached.
    local i = 0
    while i < minLength do
        for _, name in pairs(inputTable) do
            table.insert(targetTable, name)
            i = i + 1
        end
    end
end

function EnemyControl.GetEligible(inputTable)
    local eligible = {}
    for name, bool in pairs(inputTable) do
        if ( bool ) then
            table.insert(eligible, EnemyControl.NameToCode.Enemies[name])
            DebugPrint({Text = EnemyControl.NameToCode.Enemies[name]})
        end
    end
    return eligible
end

function EnemyControl.RemoveIneligibleFromBools(inputTable,baseTable)
    local eligible = {}
    local check = ""
    local match = false
    for name, bool in pairs(baseTable) do
        match = false
        check = name
        DebugPrint({Text = check})
        if ( bool ) then
            if ( next(inputTable) == nil ) then
                table.insert(eligible,check)
            else
                for name2, bool2 in pairs(inputTable) do
                    if ( EnemyControl.NameToCode.Enemies[name2] == check and bool2 == false ) then
                        match = true
                    end
                end
                if ( match == false ) then
                    table.insert(eligible,check)
                end
            end
        end
    end
    return eligible
end

function EnemyControl.RemoveIneligibleFromStrings(inputTable,baseTable)
    local eligible = {}
    local check = ""
    local match = false
    for _, name in ipairs(baseTable) do
        match = false
        check = name
        if ( next(inputTable) == nil ) then
            table.insert(eligible,name)
        else
            for name2, bool in pairs(inputTable) do
                DebugPrint({Text = name2})
                if ( EnemyControl.NameToCode.Enemies[name2] == check and bool == false ) then
                    match = true
                end
            end
            if ( match == false ) then
                table.insert(eligible,name)
            end
        end
    end
    return eligible
end

function EnemyControl.RegisterPreset(name, preset)
    EnemyControl.Presets[name] = preset
end

function EnemyControl.ReadPreset() --Read current preset and create table of enemies marked as eligible
    EnemyControl.EligibleEnemies = {}
    local Preset = EnemyControl.Presets[config.EnemySetting]
    local PresetType = EnemyControl.PresetTypes[config.EnemySetting]
    for biome, _ in pairs(Preset) do
        EnemyControl.EligibleEnemies[biome] = {}
        if ( PresetType[biome] == true ) then
            EnemyControl.PopulateMinLength(
                EnemyControl.EligibleEnemies[biome],
                EnemyControl.RemoveIneligibleFromStrings(Preset[biome],EnemyControl.VanillaSets[EnemyControl.NameToCode.Biomes[biome]]),
                1
            )
        else
            EnemyControl.PopulateMinLength(
                EnemyControl.EligibleEnemies[biome],
                EnemyControl.GetEligible(Preset[biome]),
                1
            )
        end
    end
end

function EnemyControl.UpdatePools()
    for biome, pool in pairs(EnemyControl.EligibleEnemies) do
        EnemyControl.Target = EnemyControl.NameToCode.Biomes[biome]
        EnemyControl.Pool = pool
        DebugPrint({Text = EnemyControl.Target})
        DebugPrint({Text = EnemyControl.Pool})
        ModUtil.Table.Replace(EnemySets[EnemyControl.Target], EnemyControl.Pool)
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
