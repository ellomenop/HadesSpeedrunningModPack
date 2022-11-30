ModUtil.Mod.Register("QuickRestart")

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
    if ModUtil.Path.Get("CurrentDeathAreaRoom") then return false end

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

ModUtil.Path.Wrap("HandleDeath", function(baseFunc, currentRun, killer, killingUnitWeapon)
    if QuickRestart.UsedQuickRestart then
        RemoveInputBlock({ Name = "QuickRestart" })
    end
    QuickRestart.QuickDeathApplicable = config.QuickDeathEnabled and not currentRun.Cleared
    return baseFunc(currentRun, killer, killingUnitWeapon)
end, QuickRestart)

ModUtil.Path.Context.Wrap("HandleDeath", function ()
    ModUtil.Path.Wrap("LoadMap", function(baseFunc, argTable)
        if QuickRestart.UsedQuickRestart or QuickRestart.QuickDeathApplicable then
            argTable.Name = "RoomPreRun"

            if QuickRestart.KeepStartingKeepsake and GameState.QuickRestartStartingKeepsake then
              GameState.LastAwardTrait = GameState.QuickRestartStartingKeepsake
            end
          end

          -- Set UsedQuickRestart Flag so Keepsake and InputBlock are appropriately set.
          if quickDeathApplicable then
              QuickRestart.UsedQuickRestart = true
          end
    end, QuickRestart)
end, QuickRestart)

ModUtil.Path.Wrap("WindowDropEntrance", function( baseFunc, ... )
    local val = baseFunc(...)
    -- Get starting keepsake
    GameState.QuickRestartStartingKeepsake = GameState.LastAwardTrait
    return val
end, QuickRestart)

ModUtil.Path.Wrap("PlayerLastStandPresentationStart", function( baseFunc, ... )
    QuickRestart.LastStanding = true
    return baseFunc( ... )
end, QuickRestart)

ModUtil.Path.Wrap("PlayerLastStandPresentationEnd", function( baseFunc, ... )
    local val = baseFunc( ... )
    QuickRestart.LastStanding = false
    return val
end, QuickRestart)

ModUtil.Path.Wrap("StartDevotionTestPresentation", function( baseFunc, ... )
    QuickRestart.MidDevotion = true
    baseFunc(...)
    QuickRestart.MidDevotion = false
end, QuickRestart)

