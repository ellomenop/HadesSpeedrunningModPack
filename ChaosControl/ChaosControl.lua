--[[
    ChaosControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
        Museus (Discord: Museus#7777)
    Change the eligible offerings from Chaos, allowing certain curses or blessings to be removed.
]]
ModUtil.Mod.Register("ChaosControl")

local config = {
  ChaosSetting = "Vanilla"
}
ChaosControl.config = config --TODO add config option in menu
ChaosControl.EligibleBlessings = {}
ChaosControl.EligibleCurses = {}

ChaosControl.Presets = { --Define rulesets
    Vanilla = {
        Blessings = {
            ChaosBlessingMeleeTrait = true,
            ChaosBlessingRangedTrait = true,
            ChaosBlessingAmmoTrait = true,
            ChaosBlessingMaxHealthTrait = true,
            ChaosBlessingBoonRarityTrait = true,
            ChaosBlessingMoneyTrait = true,
            ChaosBlessingMetapointTrait = true,
            ChaosBlessingSecondaryTrait = true,
            ChaosBlessingDashAttackTrait = true,
            ChaosBlessingExtraChanceTrait = true,
            ChaosBlessingBackstabTrait = true,
            ChaosBlessingAlphaStrikeTrait = true,
        },
        Curses = {
            ChaosCurseNoMoneyTrait = true,
            ChaosCurseAmmoUseDelayTrait = true,
            ChaosCursePrimaryAttackTrait = true,
            ChaosCurseSecondaryAttackTrait = true,
            ChaosCurseCastAttackTrait = true,
            ChaosCurseDeathWeaponTrait = true,
            ChaosCurseHiddenRoomReward = true,
            ChaosCurseDamageTrait = true,
            ChaosCurseTrapDamageTrait = true,
            ChaosCurseHealthTrait = true,
            ChaosCurseMoveSpeedTrait = true,
            ChaosCurseSpawnTrait = true,
            ChaosCurseDashRangeTrait = true,
        }
    },
    Hypermodded = {
        Blessings = {
            ChaosBlessingMeleeTrait = true,
            ChaosBlessingRangedTrait = true,
            ChaosBlessingAmmoTrait = true,
            ChaosBlessingMaxHealthTrait = true,
            ChaosBlessingBoonRarityTrait = true,
            ChaosBlessingMoneyTrait = true,
            ChaosBlessingSecondaryTrait = true,
            ChaosBlessingDashAttackTrait = true,
            ChaosBlessingExtraChanceTrait = true,
            ChaosBlessingBackstabTrait = true,
            ChaosBlessingAlphaStrikeTrait = true,
        },
        Curses = {
            ChaosCurseNoMoneyTrait = true,
            ChaosCurseAmmoUseDelayTrait = true,
            ChaosCursePrimaryAttackTrait = true,
            ChaosCurseSecondaryAttackTrait = true,
            ChaosCurseCastAttackTrait = true,
            ChaosCurseDeathWeaponTrait = true,
            ChaosCurseHiddenRoomReward = true,
            ChaosCurseDamageTrait = true,
            ChaosCurseTrapDamageTrait = true,
            ChaosCurseHealthTrait = true,
            ChaosCurseMoveSpeedTrait = true,
            ChaosCurseDashRangeTrait = true,
        }
    },
    Debug = {
        Blessings = {
            ChaosBlessingRangedTrait = true,
        },
        Curses = {
            ChaosCurseTrapDamageTrait = true,
        }
    }
}

function ChaosControl.PopulateMinLength(targetTable, inputTable, minLength) --Populates a target table with the contents of an input table, repeatedly inserting until a minimum length is reached.
    local i = 0
    while i < minLength do
        for _, name in pairs(inputTable) do
            table.insert(targetTable, name)
            i = i + 1
        end
    end
end

function ChaosControl.GetEligibleTraits(inputTable)
    local eligibleTraits = {}
    for name, bool in pairs(inputTable) do
        if ( bool ) then
            table.insert(eligibleTraits, name)
        end
    end
    return eligibleTraits
end

function ChaosControl.RegisterPreset(name, preset)
    ChaosControl.Presets[name] = preset
end

function ChaosControl.ReadPreset() --Read current preset and create table of blessings and curses marked to eligible, including failsafe for presets with <3 traits, which otherwise cause crash
    ChaosControl.EligibleBlessings = {}
    ChaosControl.EligibleCurses = {}
    ChaosControl.PopulateMinLength(
        ChaosControl.EligibleBlessings,
        ChaosControl.GetEligibleTraits(ChaosControl.Presets[config.ChaosSetting].Blessings),
        3
    )
    ChaosControl.PopulateMinLength(
        ChaosControl.EligibleCurses,
        ChaosControl.GetEligibleTraits(ChaosControl.Presets[config.ChaosSetting].Curses),
        3
    )
end

function ChaosControl.UpdateOfferings() --Inject eligible blessings/curses into table of Chaos' offerings in LootData
    ModUtil.Table.MergeKeyed(LootData, {
        TrialUpgrade = {
            PermanentTraits = ChaosControl.EligibleBlessings,
            TemporaryTraits = ChaosControl.EligibleCurses,
        }
    })
    DebugPrint({Text = "Chaos Offerings: "..config.ChaosSetting})
end

ModUtil.LoadOnce( function()
    ChaosControl.ReadPreset()
    ChaosControl.UpdateOfferings()
end)

-- When a new run is started, make sure to apply the offering settings
ModUtil.Path.Wrap("StartNewRun", function ( baseFunc, currentRun )
    ChaosControl.ReadPreset()
    ChaosControl.UpdateOfferings()
    return baseFunc(currentRun)
end, ChaosControl)
