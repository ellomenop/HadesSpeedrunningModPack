--[[
    ChaosControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
        Museus (Discord: Museus#7777)
    Dependencies: ModUtil, RCLib
    Change the eligible offerings from Chaos, allowing certain curses or blessings to be removed.
]]
ModUtil.Mod.Register("ChaosControl")

local config = {
  ChaosSetting = "Vanilla"
}
ChaosControl.config = config --TODO add config option in menu
ChaosControl.EligibleBlessings = {}
ChaosControl.EligibleCurses = {}
ChaosControl.VanillaBlessings = {}
ChaosControl.VanillaCurses = {}

ChaosControl.Presets = { --Define rulesets
    Vanilla = {},
    Hypermodded = {
        Blessings = {
            Eclipse = false,
        },
        Curses = {
            Roiling = false,
        },
    },
    Debug = {
        Blessings = {
            Shot = true,
        },
        Curses = {
            Abyssal = true,
        },
    }
}

ChaosControl.InheritVanilla = { -- Presets set to true will inherit the vanilla traits and only remove those set to false, Presets set to false will start from 0 and only add those set to true.
    Hypermodded = {
        Blessings = true,
        Curses = true,
    },
}

function ChaosControl.ReadPreset() -- Read current preset and create table of blessings and curses marked to eligible, including failsafe for presets with <3 traits
    ChaosControl.EligibleBlessings = {}
    ChaosControl.EligibleCurses = {}
    local Preset = {
        Blessings = {},
        Curses = {},
    }
    local InheritVanilla = {}
    if ChaosControl.Presets[config.ChaosSetting] ~= nil then
        Preset = ChaosControl.Presets[config.ChaosSetting]
    end
    if ChaosControl.InheritVanilla[config.ChaosSetting] ~= nil then
        InheritVanilla = ChaosControl.InheritVanilla[config.ChaosSetting]
    end
    if Preset.Blessings ~= nil then
        if InheritVanilla.Blessings then
            RCLib.PopulateMinLength(
                ChaosControl.EligibleBlessings,
                RCLib.RemoveIneligibleStrings(Preset.Blessings,ChaosControl.VanillaBlessings,RCLib.NameToCode.ChaosBlessings),
                3
            )
        else
            RCLib.PopulateMinLength(
                ChaosControl.EligibleBlessings,
                RCLib.GetEligible(Preset.Blessings,RCLib.NameToCode.ChaosBlessings),
                3
            )
        end
    else
        ChaosControl.EligibleBlessings = ChaosControl.VanillaBlessings
    end
    if Preset.Curses ~= nil then
        if InheritVanilla.Curses then
            RCLib.PopulateMinLength(
                ChaosControl.EligibleCurses,
                RCLib.RemoveIneligibleStrings(Preset.Curses,ChaosControl.VanillaCurses,RCLib.NameToCode.ChaosCurses),
                3
            )
        else
            RCLib.PopulateMinLength(
                ChaosControl.EligibleCurses,
                RCLib.GetEligible(Preset.Curses,RCLib.NameToCode.ChaosCurses),
                3
            )
        end
    else
        ChaosControl.EligibleCurses = ChaosControl.VanillaCurses
    end
end

function ChaosControl.UpdateOfferings() --Inject eligible blessings/curses into table of Chaos' offerings in LootData
    DebugPrint({Text = "Chaos preset: "..ChaosControl.config.ChaosSetting})
    ModUtil.Table.MergeKeyed(LootData, {
        TrialUpgrade = {
            PermanentTraits = ChaosControl.EligibleBlessings,
            TemporaryTraits = ChaosControl.EligibleCurses,
        }
    })
    DebugPrint({Text = "Updated Chaos offerings"})
end

ModUtil.LoadOnce( function()
    ChaosControl.VanillaBlessings = ModUtil.Table.Copy(LootData.TrialUpgrade.PermanentTraits)
    ChaosControl.VanillaCurses = ModUtil.Table.Copy(LootData.TrialUpgrade.TemporaryTraits)
    ChaosControl.ReadPreset()
    ChaosControl.UpdateOfferings()
end)

-- When a new run is started, make sure to apply the offering settings
ModUtil.Path.Wrap("StartNewRun", function ( baseFunc, currentRun )
    ChaosControl.ReadPreset()
    ChaosControl.UpdateOfferings()
    return baseFunc(currentRun)
end, ChaosControl)
