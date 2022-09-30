ModUtil.RegisterMod("QuickRestart")

local config = {
    Enabled = true,
    KeepStartingKeepsake = true,
    QuickDeathEnabled = true,
}

QuickRestart.config = config

function QuickRestart.CanReset()
    -- QuickRestart must be Enabled
    if not config.Enabled then return false end

    -- Short delay to handle edge cases
    wait(0.1)

    -- Zag must not be in the House
    if ModUtil.PathGet("CurrentDeathAreaRoom") then return false end

    -- Zag must not be frozen
    if not IsEmpty( CurrentRun.Hero.FreezeInputKeys ) then return false end

    -- Combat UI must be visible
    if not (ShowingCombatUI or false) then return false end

    -- We can't be LastStand-ing
    if QuickRestart.LastStanding then return false end

    -- We can't be QuickRestart-ing
    if QuickRestart.UsedQuickRestart then return false end

    -- We can't be mid-trial god selection
    if QuickRestart.MidDevotion then return false end

    -- If we're in a Thanatos Room, enemies must have already spawned
    if (CurrentRun ~= nil and CurrentRun.CurrentRoom ~= nil and
            CurrentRun.CurrentRoom.Encounter ~= nil and
            CurrentRun.CurrentRoom.Encounter.ThanatosId ~= nil
            and GetActiveEnemyCount() == 0) then
        return false
    end

    return true
end

function QuickRestart.ResetRun(triggerArgs)
    if not QuickRestart.CanReset() then
        ModUtil.Hades.PrintOverhead("Can't reset now!", 2)
        return
    end

    if RtaTimer then
        RtaTimer__ResetRtaTimer()
    end

    QuickRestart.UsedQuickRestart = true
    AddInputBlock({ Name = "QuickRestart" })

    wait(0.1)

    Kill( CurrentRun.Hero, triggerArgs )
end

OnControlPressed{ "Assist",
    function(triggerArgs)
        if config.Enabled then
            if IsControlDown({ Name = "Assist" })
                    and IsControlDown({ Name = "Use" })
                    and IsControlDown({ Name = "Shout" })
                    and IsControlDown({ Name = "Reload" }) then
                QuickRestart.ResetRun(triggerArgs)
            end
        end
end}

OnControlPressed{ "Use",
    function(triggerArgs)
        if config.Enabled then
            if IsControlDown({ Name = "Assist" })
                    and IsControlDown({ Name = "Use" })
                    and IsControlDown({ Name = "Shout" })
                    and IsControlDown({ Name = "Reload" }) then
                QuickRestart.ResetRun(triggerArgs)
            end
        end
end}

OnControlPressed{ "Shout",
    function(triggerArgs)
        if config.Enabled then
            if IsControlDown({ Name = "Assist" })
                    and IsControlDown({ Name = "Use" })
                    and IsControlDown({ Name = "Shout" })
                    and IsControlDown({ Name = "Reload" }) then
                QuickRestart.ResetRun(triggerArgs)
            end
        end
end}

OnControlPressed{ "Reload",
    function(triggerArgs)
        if config.Enabled then
            if IsControlDown({ Name = "Assist" })
                    and IsControlDown({ Name = "Use" })
                    and IsControlDown({ Name = "Shout" })
                    and IsControlDown({ Name = "Reload" }) then
                QuickRestart.ResetRun(triggerArgs)
            end
        end
end}

OnAnyLoad{ "RoomPreRun",
    function ( triggerArgs )
        if QuickRestart.UsedQuickRestart then
            thread( PlayVoiceLines, GlobalVoiceLines.EnteredDeathAreaVoiceLines )
            QuickRestart.UsedQuickRestart = false

            RemoveLastAwardTrait()
            UnequipWeaponUpgrade()
            RemoveLastAssistTrait()

            -- Reset Starting Keepsake
            if QuickRestart.config.KeepStartingKeepsake then
                DebugPrint({ Text="Setting keepsake trigger" })
                GameState.LastAwardTrait = GameState.QuickRestartStartingKeepsake or GameState.LastAwardTrait
            end
        end
    end
}

ModUtil.BaseOverride( "HandleDeath", function( currentRun, killer, killingUnitWeapon )
    if GetConfigOptionValue({ Name = "EditingMode" }) then
        SetAnimation({ Name = "ZagreusDeadStartBlood", DestinationId = currentRun.Hero.ObjectId })
        return
    end

    if QuickRestart.UsedQuickRestart then
        RemoveInputBlock({ Name = "QuickRestart" })
    end

    SendSaveFileEmail({ })

    AddTimerBlock( currentRun, "HandleDeath" )
    if ScreenAnchors.TraitTrayScreen ~= nil then
        CloseAdvancedTooltipScreen()
    end
    ClearHealthShroud()
    CurrentRun.Hero.HandlingDeath = true
    CurrentRun.Hero.IsDead = true
    CurrentRun.ActiveBiomeTimer = false
    if ConfigOptionCache.EasyMode and not currentRun.Cleared then
        GameState.EasyModeLevel = GameState.EasyModeLevel + 1
    end
    if not CurrentRun.Cleared then -- Already recorded if cleared
        RecordRunStats()
    end

    InvalidateCheckpoint()

    ZeroSuperMeter()
    FinishTargetMarker( killer )

    local deathPresentationName = currentRun.DeathPresentationFunctionName or "DeathPresentation"
    local deathPresentationFunction = _G[deathPresentationName]
    deathPresentationFunction( currentRun, killer, killingUnitWeapon )
    AddInputBlock({ Name = "MapLoad" })

    currentRun.CurrentRoom.EndingHealth = currentRun.Hero.Health
    currentRun.EndingMoney = currentRun.Money
    table.insert( currentRun.RoomHistory, currentRun.CurrentRoom )
    UpdateRunHistoryCache( currentRun, currentRun.CurrentRoom )

    currentRun.Money = 0
    currentRun.NumRerolls = GetNumMetaUpgrades( "RerollMetaUpgrade" ) + GetNumMetaUpgrades("RerollPanelMetaUpgrade")

    ResetObjectives()
    ActiveScreens = {}

    CurrentRun.Hero.HandlingDeath = false
    CurrentRun.Hero.Health = CurrentRun.Hero.MaxHealth

    local currentRoom = currentRun.CurrentRoom
    local deathMap = "DeathArea"

    -- Changes Here
    local quickDeathApplicable = config.QuickDeathEnabled and not currentRun.Cleared
    if QuickRestart.UsedQuickRestart or quickDeathApplicable then
      deathMap = "RoomPreRun"
      
      if QuickRestart.KeepStartingKeepsake and GameState.QuickRestartStartingKeepsake then
        GameState.LastAwardTrait = GameState.QuickRestartStartingKeepsake
      end
    end

    -- Set UsedQuickRestart Flag so Keepsake and InputBlock are appropriately set.
    if quickDeathApplicable then
        QuickRestart.UsedQuickRestart = true
    end
    -- End Changes

    GameState.LocationName = "Location_Home"
    RandomSetNextInitSeed()
    SaveCheckpoint({ StartNextMap = deathMap, DevSaveName = CreateDevSaveName( currentRun, { StartNextMap = deathMap } ) })
    ClearUpgrades()

    SetConfigOption({ Name = "FlipMapThings", Value = false })

    local runNumber = ( GetCompletedRuns() + 1 )
    local runDepth = GetRunDepth( currentRun )

    LoadMap({ Name = deathMap, ResetBinks = true, ResetWeaponBinks = true })
end, QuickRestart)

ModUtil.WrapBaseFunction("WindowDropEntrance", function( baseFunc, ... )
    local val = baseFunc(...)
    -- Get starting keepsake
    GameState.QuickRestartStartingKeepsake = GameState.LastAwardTrait
    return val
end, QuickRestart)

ModUtil.WrapBaseFunction("PlayerLastStandPresentationStart", function( baseFunc, ... )
    QuickRestart.LastStanding = true
    return baseFunc( ... )
end, QuickRestart)

ModUtil.WrapBaseFunction("PlayerLastStandPresentationEnd", function( baseFunc, ... )
    local val = baseFunc( ... )
    QuickRestart.LastStanding = false
    return val
end, QuickRestart)

ModUtil.WrapBaseFunction("StartDevotionTestPresentation", function( baseFunc, ... )
    QuickRestart.MidDevotion = true
    baseFunc(...)
    QuickRestart.MidDevotion = false
end, QuickRestart)

