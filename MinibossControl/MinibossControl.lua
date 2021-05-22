--[[
    MinibossControl
    Author:
        Museus (Discord: Museus#7777)

    Change the proportions of miniboss chambers, allowing minibosses
    to be removed or replaced with others.
]]
ModUtil.RegisterMod("MinibossControl")

local config = {
    MinibossSetting = "Leaderboards"
}
MinibossControl.config = config

-- Preset setting profiles. "Vanilla" should always reflect the unedited game (each miniboss set to 1)
MinibossControl.Presets = {
  Vanilla = {
    -- Tartarus_Bombers
    A_MiniBoss01 = 1,
    -- Tartarus_Doomstone TODO: Handle middle management?
    A_MiniBoss04 = 1,
    -- Tartarus_Sneak
    A_MiniBoss03 = 1,

    -- Asphodel_Barge
    B_Wrapping01 = 1,
    -- Asphodel_PowerCouple,
    B_MiniBoss01 = 1,
    -- Asphodel_Witches
    B_MiniBoss02 = 1,

    -- Elysium_ButterflyBall
    C_MiniBoss02 = 1,
    -- Elysium_Asterius
    C_MiniBoss01 = 1,

    -- If true, Tiny Vermin will not spawn
    RemoveTinyVermin = false,
  },
  HyperDelivery1 = {
    -- Tartarus_Bombers
    A_MiniBoss01 = 1,
    -- Tartarus_Doomstone TODO: Handle middle management?
    A_MiniBoss04 = 1,
    -- Tartarus_Sneak
    A_MiniBoss03 = 1,

    -- Asphodel_Barge
    B_Wrapping01 = 0,
    -- Asphodel_PowerCouple,
    B_MiniBoss01 = 1,
    -- Asphodel_Witches
    B_MiniBoss02 = 2,

    -- Elysium_ButterflyBall
    C_MiniBoss02 = 1,
    -- Elysium_Asterius
    C_MiniBoss01 = 1,

    -- If true, Tiny Vermin will not spawn
    RemoveTinyVermin = true,
  },
  HyperDelivery = {
    -- Tartarus_Bombers
    A_MiniBoss01 = 1,
    -- Tartarus_Doomstone TODO: Handle middle management?
    A_MiniBoss04 = 1,
    -- Tartarus_Sneak
    A_MiniBoss03 = 1,

    -- Asphodel_Barge
    B_Wrapping01 = 0,
    -- Asphodel_PowerCouple,
    B_MiniBoss01 = 1,
    -- Asphodel_Witches
    B_MiniBoss02 = 2,

    -- Elysium_ButterflyBall
    C_MiniBoss02 = 0,
    -- Elysium_Asterius
    C_MiniBoss01 = 2,

    -- If true, Tiny Vermin will not spawn
    RemoveTinyVermin = true,
  },
  Leaderboard = {
    -- Tartarus_Bombers
    A_MiniBoss01 = 1,
    -- Tartarus_Doomstone TODO: Handle middle management?
    A_MiniBoss04 = 1,
    -- Tartarus_Sneak
    A_MiniBoss03 = 1,

    -- Asphodel_Barge
    B_Wrapping01 = 0,
    -- Asphodel_PowerCouple,
    B_MiniBoss01 = 1,
    -- Asphodel_Witches
    B_MiniBoss02 = 2,

    -- Elysium_ButterflyBall
    C_MiniBoss02 = 1,
    -- Elysium_Asterius
    C_MiniBoss01 = 1,

    -- If true, Tiny Vermin will not spawn
    RemoveTinyVermin = true,
  }
}

-- Register a new miniboss control preset
function MinibossControl.RegisterPreset(name, preset)
  MinibossControl.Presets[name] = preset
end

-- Apply the configured miniboss settings to the game data
function updateMinibossControl()
    ModUtil.MapSetTable(RoomSetData, {
        -- [[ Tartarus Miniboss Counts ]]
        Tartarus = {
            A_MiniBoss01 = {
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].A_MiniBoss01,
            },
            A_MiniBoss02 = {
                -- Middle Management Doomstone
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].A_MiniBoss04,
            },
            A_MiniBoss03 = {
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].A_MiniBoss03,
            },
            A_MiniBoss04 = {
                -- Vanilla Doomstone
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].A_MiniBoss04,
            },
        },
        -- [[ Asphodel Miniboss Counts ]]
        Asphodel = {
            B_MiniBoss01 = {
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].Asphodel_PowerCouple,
            },
            B_MiniBoss02 = {
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].Asphodel_Witches,
            },
            B_Wrapping01 = {
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].B_Wrapping01,
            },
        },
        -- [[ Elysium Miniboss Counts ]]
        Elysium = {
            C_MiniBoss01 = {
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].C_MiniBoss01,
            },
            C_MiniBoss02 = {
                MaxCreationsThisRun = MinibossControl.Presets[config.MinibossSetting].C_MiniBoss02,
            },
        },
    })

    -- Remove Tiny Vermin
    if MinibossControl.Presets[config.MinibossSetting].RemoveTinyVermin then
        ModUtil.MapSetTable(RoomSetData.Styx.D_MiniBoss03, {
            LegalEncounters = { "MiniBossHeavyRangedForked" },
        })
    else
      ModUtil.MapSetTable(RoomSetData.Styx.D_MiniBoss03, {
          LegalEncounters = { "MiniBossCrawler", "MiniBossHeavyRangedForked" },
      })
    end
end

-- Scripts/RunManager.lua : 515
ModUtil.WrapBaseFunction("ChooseNextRoomData", function( baseFunc, currentRun, args )
    -- IsRoomEligible looks at RoomCreations and ignores it if it's nil. Make sure it's not nil
    -- Easier and cleaner than overriding the IsRoomEligible function to fix nil behavior
    ModUtil.MapSetTable(CurrentRun.RoomCreations, {
        A_MiniBoss01 = currentRun.RoomCreations.A_MiniBoss01 or 0,
        A_MiniBoss02 = currentRun.RoomCreations.A_MiniBoss02 or 0,
        A_MiniBoss03 = currentRun.RoomCreations.A_MiniBoss03 or 0,
        A_MiniBoss04 = currentRun.RoomCreations.A_MiniBoss04 or 0,
        B_MiniBoss01 = currentRun.RoomCreations.B_MiniBoss01 or 0,
        B_MiniBoss02 = currentRun.RoomCreations.B_MiniBoss02 or 0,
        B_Wrapping01 = currentRun.RoomCreations.B_Wrapping01 or 0,
        C_MiniBoss01 = currentRun.RoomCreations.C_MiniBoss01 or 0,
        C_MiniBoss02 = currentRun.RoomCreations.C_MiniBoss02 or 0,
    })

    return baseFunc(currentRun, args)
end, MinibossControl)

-- When a new run is started, make sure to apply the miniboss modifications
ModUtil.WrapBaseFunction("StartNewRun", function ( baseFunc, currentRun )
  updateMinibossControl()
  return baseFunc(currentRun)
end, MinibossControl)
