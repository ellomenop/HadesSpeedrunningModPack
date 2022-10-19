ModUtil.Mod.Register("CodexTechPrevention")

local config = {
    ModName = "Codex Tech Prevention",
    Enabled = true,
}

CodexTechPrevention.config = config

-- Scripts/CodexScripts.lua : 1056
-- Prevents the use of CodexTech by preventing the codex opening while the timer is running in a run
ModUtil.Path.Wrap("CanOpenCodex", function ( baseFunc )
    if CodexTechPrevention.config.Enabled then
        if not CurrentRun.Hero.IsDead then
            timerRunningAndOutOfCombat = not HasTimerBlock( CurrentRun ) and not IsCombatEncounterActive ( CurrentRun )

            if timerRunningAndOutOfCombat then
                ModUtil.Hades.PrintOverhead("Can't open the codex now!", 2)
                return false
            end
        end
    end

    return baseFunc()
end, CodexTechPrevention)