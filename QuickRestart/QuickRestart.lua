ModUtil.RegisterMod("QuickRestart")

local config = {
  Enabled = false
}
QuickRestart.config = config

OnControlPressed{ "Codex",
  function(triggerArgs)
    if config.Enabled and not ModUtil.PathGet("CurrentDeathAreaRoom") then
      if IsControlDown({ Name = "Codex" })
          and IsControlDown({ Name = "Reload" }) then
        KillHero(CurrentRun.Hero, triggerArgs)
      end
    end
end}
