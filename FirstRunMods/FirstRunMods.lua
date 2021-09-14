ModUtil.RegisterMod("FirstRunMods")

local config = {
    Enabled = true,

}
FirstRunMods.config = config
FirstRunMods.FirstRunTartarus = false

FirstRunMods.MiniBossPreset = {
    -- Tartarus_Bombers
    A_MiniBoss01 = 1,
    -- Tartarus_Doomstone TODO: Handle middle management?
    A_MiniBoss04 = 0,
    -- Tartarus_Sneak
    A_MiniBoss03 = 0,

    -- Asphodel_Barge
    B_Wrapping01 = 1,
    -- Asphodel_PowerCouple,
    B_MiniBoss01 = 1,
    -- Asphodel_Witches
    B_MiniBoss02 = 0,

    -- Elysium_ButterflyBall
    C_MiniBoss02 = 1,
    -- Elysium_Asterius
    C_MiniBoss01 = 1,

    -- If true, Tiny Vermin will not spawn
    RemoveTinyVermin = true,
  }

  MinibossControl.RegisterPreset("FirstRun", FirstRunMods.MiniBossPreset)

ModUtil.WrapBaseFunction("StartNewGame", function( baseFunc )
    baseFunc()

    HSMConfigMenu.LoadSettings("FirstRunSettings")

    local rulesetHashInt = CalculateHash(HSMConfigMenu.SingleRunSettings, _G)
    local rulesetHash =  HSMConfigMenu.ConvertIntToBase25(rulesetHashInt, 5)
    HSMConfigMenu.CurrentRulesetHash = rulesetHash

    HSMConfigMenu.updateRulesetHashDisplay()
    HSMConfigMenu.SaveSettingsToGlobal()

    FirstRunMods.FirstRunTartarus = true

    RtaTimer.config.DisplayTimer = true
    RtaTimer.config.MultiWeapon = true
    RtaTimer.TimerWasReset = false
    thread(RtaTimer.StartRtaTimer)

end, FirstRunMods)

ModUtil.WrapBaseFunction("GetEligibleLootNames", function( baseFunc, excludeLootNames )
    if FirstRunMods.config.Enabled and FirstRunMods.FirstRunTartarus then
        if excludeLootNames == nil then
            excludeLootNames = {}
        end
        table.insert(excludeLootNames, "DionysusUpgrade")
        table.insert(excludeLootNames, "ArtemisUpgrade")

    end
    return baseFunc(excludeLootNames)
end, FirstRunMods)

ModUtil.WrapBaseFunction("HarpyKillPresentation", function( baseFunc, unit, args )
    FirstRunMods.FirstRunTartarus = false
    baseFunc(unit, args)
end, FirstRunMods)