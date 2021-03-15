ModUtil.RegisterMod("QuickRestart")

local config = {
  Enabled = false
}
QuickRestart.config = config

OnControlPressed{ "Assist",
  function(triggerArgs)
    if config.Enabled and not ModUtil.PathGet("CurrentDeathAreaRoom") then
      if IsControlDown({ Name = "Assist" })
          and IsControlDown({ Name = "Use" })
          and IsControlDown({ Name = "Shout" })
          and IsControlDown({ Name = "Reload" }) then
        KillHero(CurrentRun.Hero, triggerArgs)
      end
    end
end}

OnControlPressed{ "Use",
  function(triggerArgs)
    if config.Enabled and not ModUtil.PathGet("CurrentDeathAreaRoom") then
      if IsControlDown({ Name = "Assist" })
          and IsControlDown({ Name = "Use" })
          and IsControlDown({ Name = "Shout" })
          and IsControlDown({ Name = "Reload" }) then
        KillHero(CurrentRun.Hero, triggerArgs)
      end
    end
end}

OnControlPressed{ "Shout",
  function(triggerArgs)
    if config.Enabled and not ModUtil.PathGet("CurrentDeathAreaRoom") then
      if IsControlDown({ Name = "Assist" })
          and IsControlDown({ Name = "Use" })
          and IsControlDown({ Name = "Shout" })
          and IsControlDown({ Name = "Reload" }) then
        KillHero(CurrentRun.Hero, triggerArgs)
      end
    end
end}

OnControlPressed{ "Reload",
  function(triggerArgs)
    if config.Enabled and not ModUtil.PathGet("CurrentDeathAreaRoom") then
      if IsControlDown({ Name = "Assist" })
          and IsControlDown({ Name = "Use" })
          and IsControlDown({ Name = "Shout" })
          and IsControlDown({ Name = "Reload" }) then
        KillHero(CurrentRun.Hero, triggerArgs)
      end
    end
end}
