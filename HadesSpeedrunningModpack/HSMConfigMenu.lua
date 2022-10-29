HSMConfigMenu.CurrentRulesetHash = {}

ModUtil.LoadOnce(function()
  if HSMConfigMenu_SavedRuleset == nil then
    HSMConfigMenu.LoadSettings("RulesetSettings")
  else
    HSMConfigMenu.LoadSettings("RulesetSettings", HSMConfigMenu_SavedRuleset.HashInt)
  end

  if HSMConfigMenu_SavedNonRuleset == nil then
    HSMConfigMenu.LoadSettings("NonRulesetSettings")
  else
    HSMConfigMenu.LoadSettings("NonRulesetSettings", HSMConfigMenu_SavedNonRuleset.HashInt)
  end

  if HSMConfigMenu_SavedPersonalization ~= nil then
    ModdedWarning.config.WarningMessage = (HSMConfigMenu_SavedPersonalization.ModdedWarningWarningMessage or ModdedWarning.config.WarningMessage)
    ModdedWarning.config.Color = (HSMConfigMenu_SavedPersonalization.ModdedWarningColor or ModdedWarning.config.Color)
    ModdedWarning.showModdedWarning()
  else
    HSMConfigMenu_SavedPersonalization = {}
  end

  local hashInt = CalculateHash(HSMConfigMenu.RulesetSettings, _G)
  HSMConfigMenu_SavedRuleset = {HashInt = hashInt}
  HSMConfigMenu.CurrentRulesetHash =  HSMConfigMenu.ConvertIntToBase25(HSMConfigMenu_SavedRuleset.HashInt, 5)
  HSMConfigMenu.updateRulesetHashDisplay()

  local hashInt = CalculateHash(HSMConfigMenu.NonRulesetSettings, _G)
  HSMConfigMenu_SavedNonRuleset = {HashInt = hashInt}
end)

function HSMConfigMenu.SaveSettingsToGlobal()
  -- Save Ruleset to global
  local hashInt = CalculateHash(HSMConfigMenu.RulesetSettings, _G)
  HSMConfigMenu_SavedRuleset = {HashInt = hashInt}
  HSMConfigMenu.CurrentRulesetHash = HSMConfigMenu.ConvertIntToBase25(HSMConfigMenu_SavedRuleset.HashInt, 5)
  HSMConfigMenu.updateRulesetHashDisplay()

  -- Save QoL / Accessibility to global
  local hashInt = CalculateHash(HSMConfigMenu.NonRulesetSettings, _G)
  HSMConfigMenu_SavedNonRuleset = {HashInt = hashInt}

  -- Save personalization to global
  HSMConfigMenu_SavedPersonalization.ModdedWarningWarningMessage = ModdedWarning.config.WarningMessage
  HSMConfigMenu_SavedPersonalization.ModdedWarningWarningColor = nil
  HSMConfigMenu_SavedPersonalization.ModdedWarningColor = ModdedWarning.config.Color
end

ModUtil.Path.Wrap("UnfreezePlayerUnit", function ( baseFunc, flag )
  DebugPrint({Text="This is in the wrapper"})
  HSMConfigMenu.SaveSettingsToGlobal()
  baseFunc(flag)
end, HSMConfigMenu)

OnAnyLoad{function()
  if ModUtil.Path.Get("CurrentDeathAreaRoom") then
    HSMConfigMenu.updateRulesetHashDisplay()
  end
end}

-- Show the hash
function HSMConfigMenu.updateRulesetHashDisplay()
  if HSMConfigMenu.CurrentRulesetHash == nil then
    return
  end

  --[[
  local width = 5 * 75 + 40
  local height = 70
  if ScreenAnchors["TopRightRulesetHashBacker"] ~= nil then
    Destroy({Id = ScreenAnchors["TopRightRulesetHashBacker"].Id})
  end
  ScreenAnchors["TopRightRulesetHashBacker"] = CreateScreenComponent({
    Name = "rectangle01",
    Scale = 1,
    X = 1880 - 2.5 * 75  + width / 2 - 172,
    Y = 145 + height / 2 - 35,
    Group = "RulesetHashBacker",
    Color = {33, 33, 55, 255}
  })
  SetScaleX({ Id = ScreenAnchors["TopRightRulesetHashBacker"].Id, Fraction = width / 480 })
  SetScaleY({ Id = ScreenAnchors["TopRightRulesetHashBacker"].Id, Fraction = height / 267 })
  SetColor({ Id = ScreenAnchors["TopRightRulesetHashBacker"].Id, Color = {33, 33, 55, 255} })]]

  for i = 1, #HSMConfigMenu.CurrentRulesetHash do
    if ScreenAnchors["TopRightRulesetHashImage" .. i] ~= nil then
      Destroy({Id = ScreenAnchors["TopRightRulesetHashImage" .. i].Id})
    end
    ScreenAnchors["TopRightRulesetHashImage" .. i] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = .3,
      X = 1880 - (#HSMConfigMenu.CurrentRulesetHash - i) * 75,
      Y = 170,
      Group = "RulesetHash" })
    SetAnimation({ Name = HSMConfigMenu.HashImages[HSMConfigMenu.CurrentRulesetHash[i]], DestinationId = ScreenAnchors["TopRightRulesetHashImage" .. i].Id, OffsetX = 0, OffsetY = 0})
  end
  CreateTextBox({
    Id = ScreenAnchors["TopRightRulesetHashImage3"].Id,
    Text = HadesSpeedrunningModpack.config.Version,
    Color = Color.BoonPatchCommon,
    FontSize = 12,
    OffsetX = 0, OffsetY = 45,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center",
    VerticalJustification = "Center"
  })
end
