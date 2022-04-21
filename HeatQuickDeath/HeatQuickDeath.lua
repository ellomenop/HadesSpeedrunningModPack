--[[
    HellModeToggle
    Author:
        Zyruvias (Discord: Zyruvias#3283)

    Allows quick-reset to apply on death as well. Requires Quick Restart to be enabled.
]]

ModUtil.RegisterMod("HeatQuickDeath")

local config = {
    Enabled = true,
}

HeatQuickDeath.config = config;

ModUtil.WrapBaseFunction("HandleDeath", function( baseFunc, currentRun, killer, killingUnitWeapon)
    -- require both HeatQuickDeath and QuickRestart
    if config.Enabled and QuickRestart.config.Enabled and not QuickRestart.UsedQuickRestart and not currentRun.Cleared then
        QuickRestart.UsedQuickRestart = true;
    end

    return baseFunc(currentRun, killer, killingUnitWeapon);
end, HeatQuickDeath)
