ModUtil.RegisterMod("QuickRestart")

local config = {
  Enabled = false
}
QuickRestart.config = config

function QuickRestart.CanReset()
  -- QuickRestart must be Enabled
  if not config.Enabled then return false end

  -- Zag must not be in the House
  if ModUtil.PathGet("CurrentDeathAreaRoom") then return false end

  -- Zag must not be frozen
  if not IsEmpty( CurrentRun.Hero.FreezeInputKeys ) then return false end

  -- Combat UI must be visible
	if not (ShowingCombatUI or false) then return false end

  return true
end

function QuickRestart.ResetRun(triggerArgs)
  if not QuickRestart.CanReset() then
    ModUtil.Hades.PrintOverhead("Can't reset now!", 2)
    return
  end

  KillHero( CurrentRun.Hero, triggerArgs )
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
