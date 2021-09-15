-- Table of all hashed config and their defaults.  Accessibility and Personalization config is not hashed.
-- TODO: Maybe populate some of this from the other mods themselves? To have a central menu, we already need to break modularity, so :shrug:
HSMConfigMenu.RulesetSettings = {
  {Key = "DontGetVorimed.config.Enabled", Values = {false, true}, Default = true},

  {Key = "DoorVisualIndicators.config.ShowMinibossDoorIndicator", Values = {false, true}, Default = false},
  {Key = "DoorVisualIndicators.config.ShowFountainDoorIndictor", Values = {false, true}, Default = true},

  {Key = "EllosBoonSelectorMod.config.ShowPreview", Values = {false, true}, Default = false},

  {Key = "RunStartControl.config.Enabled", Values = {false, true}, Default = true},

  {Key = "InteractableChaos.config.Enabled", Values = {false, true}, Default = false},

  {Key = "MinibossControl.config.MinibossSetting", Values = {"Vanilla", "HyperDelivery1", "HyperDelivery", "Leaderboard"}, Default = "Leaderboard"},

  {Key = "RemoveCutscenes.config.RemoveIntro", Values = {false, true}, Default = true},
  {Key = "RemoveCutscenes.config.RemoveOutro", Values = {false, true}, Default = true},

  {Key = "RoomDeterminism.config.Enabled", Values = {false, true}, Default = false},
  {Key = "RoomDeterminism.config.RoomGenerationAlgorithm", Values = {"Vanilla"}, Default = "Vanilla"},

  {Key = "SatyrSackControl.config.Enabled", Values = {false, true}, Default = true},
  {Key = "SatyrSackControl.config.MinSack", Values = {1, 2, 3, 4, 5}, Default = 2},
  {Key = "SatyrSackControl.config.MaxSack", Values = {1, 2, 3, 4, 5}, Default = 2},

  {Key = "ShowChamberNumber.config.ShowDepth", Values = {false, true}, Default = true},

  {Key = "ThanatosControl.config.ThanatosSetting", Values = {"Vanilla", "Removed"}, Default = "Removed"},
}

HSMConfigMenu.MultiRunSettings = DeepCopyTable(HSMConfigMenu.RulesetSettings)
HSMConfigMenu.SingleRunSettings = DeepCopyTable(HSMConfigMenu.RulesetSettings)
for i, setting in ipairs(HSMConfigMenu.SingleRunSettings) do
  if setting.Key == "ThanatosControl.config.ThanatosSetting" then
    setting.Default = "Vanilla"
    break
  end
end

HSMConfigMenu.FirstRunSettings = DeepCopyTable(HSMConfigMenu.RulesetSettings)
for i, setting in ipairs(HSMConfigMenu.FirstRunSettings) do
  setting.Values = {}
  if setting.Key == "DontGetVorimed.config.Enabled" then
    setting.Default = false
  elseif setting.Key == "RemoveCutscenes.config.RemoveIntro" then
    setting.Default = false --maybe not lol
  elseif setting.Key == "RunStartControl.config.Enabled" then
    setting.Default = false
  elseif setting.Key == "MinibossControl.config.MinibossSetting" then
    setting.Default = "FirstRun"
  end
end
table.insert(HSMConfigMenu.FirstRunSettings, {Key = "RtaTimer.config.MultiWeapon", Values={}, Default = true})
table.insert(HSMConfigMenu.FirstRunSettings, {Key = "RtaTimer.config.DisplayTimer", Values={}, Default = true})

HSMConfigMenu.NonRulesetSettings = {
  {Key = "QuickRestart.config.Enabled", Values = {false, true}, Default = false},

  {Key = "ColorblindMod.config.TartarusEnabled", Values = {false, true}, Default = false},
  {Key = "ColorblindMod.config.AsphodelEnabled", Values = {false, true}, Default = false},
  {Key = "ColorblindMod.config.ElysiumEnabled", Values = {false, true}, Default = false},
  {Key = "ColorblindMod.config.StyxEnabled", Values = {false, true}, Default = false},

  {Key = "RtaTimer.config.DisplayTimer", Values = {false, true}, Default = false},
  {Key = "RtaTimer.config.MultiWeapon", Values = {false, true}, Default = false},

  {Key = "EmoteMod.config.Enabled", Values = {false, true}, Default = false},
}

HSMConfigMenu.SettingsDefaults = {
  RulesetSettings = 769319,
  MultiRunSettings = 769319,
  SingleRunSettings = 769318,
  FirstRunSettings = 589095,
  NonRulesetSettings = 0
}

-- Register Room Override
ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "Ruleset Profiles"}, HSMConfigMenu.CreateSettingsHashMenu)
end)

-- Prepopulate the map of hash value -> icon
HSMConfigMenu.HashImages = {}
ModUtil.LoadOnce(function()
  -- Convert the base 25 digits to stickers
  local idx = 0
  for _, kvp in ipairs(CollapseTableAsOrderedKeyValuePairs(GiftData)) do
    local giftData = kvp.Value
    if giftData.MaxedSticker then
      HSMConfigMenu.HashImages[idx] = giftData.MaxedSticker
      idx = idx + 1
    end
  end

  -- Make DusaEyes 0
  local temp = HSMConfigMenu.HashImages[0]
  HSMConfigMenu.HashImages[0] = HSMConfigMenu.HashImages[10]
  HSMConfigMenu.HashImages[10] = temp
end)

function HSMConfigMenu.CreateSettingsHashMenu( screen )
  ------------------
  -- Ruleset Hash
  ------------------
  local rulesetHashInt = CalculateHash(HSMConfigMenu.RulesetSettings, _G)
  local rulesetHash =  HSMConfigMenu.ConvertIntToBase25(rulesetHashInt, 5)

  local rowStartX = 380
  local itemLocationX = rowStartX
  local itemLocationY = 420
  local itemSpacingX = 250
  local itemSpacingY = 65

  screen.Components["RulesetText"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = ScreenCenterX,
    Y = itemLocationY - 135,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["RulesetText"].Id,
    Text = "Ruleset Hash (" .. HadesSpeedrunningModpack.config.Version .. "): ",
    Color = Color.BoonPatchCommon,
    FontSize = 28,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })

  local baseXOffset = (#rulesetHash - 1) * itemSpacingX / 2
  for i = 1, #rulesetHash do
    screen.Components["RulesetHashImage" .. i] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = 1,
      X = ScreenCenterX - baseXOffset + (i-1) * itemSpacingX,
      Y = itemLocationY,
      Group = "Combat_Menu" })
    SetAnimation({ Name = HSMConfigMenu.HashImages[rulesetHash[i]], DestinationId = screen.Components["RulesetHashImage" .. i].Id, OffsetX = 0, OffsetY = 0})
  end
  itemLocationY = itemLocationY + 275 - 115

  --------------------------
  -- Load Ruleset Preset
  --------------------------
  screen.Components["SettingsProfileTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = ScreenCenterX - itemSpacingX * .65 - 8,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["SettingsProfileTextBox"].Id,
    Text = "Load Ruleset: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })
  ErumiUILib.Dropdown.CreateDropdown(
    screen, {
      Name = "SettingsProfileDropdown",
      Group = "SettingsProfileGroup",
      Scale = {X = .5, Y = .5},
      Padding = {X = 0, Y = 2},
      X = ScreenCenterX + itemSpacingX * .65, Y = itemLocationY,
      GeneralFontSize = 16,
      Font = "AlegrayaSansSCRegular",
      Items = {
        ["Default"] = {Text = "Select a Preset", event = function() end},
        {Text = "Real Time (RTA) Ruleset", event = function()
          HSMConfigMenu.LoadSettings("MultiRunSettings")
          local rulesetHashInt = CalculateHash(HSMConfigMenu.MultiRunSettings, _G)
          local rulesetHash =  HSMConfigMenu.ConvertIntToBase25(rulesetHashInt, 5)
          HSMConfigMenu.CurrentRulesetHash = rulesetHash

          for i = 1, #rulesetHash do
            SetAnimation({ Name = HSMConfigMenu.HashImages[rulesetHash[i]], DestinationId = screen.Components["RulesetHashImage" .. i].Id, OffsetX = 0, OffsetY = 0})
          end

          HSMConfigMenu.updateRulesetHashDisplay()
          HSMConfigMenu.SaveSettingsToGlobal()
        end},
        {Text = "In-Game Time (IGT) Ruleset",  event = function() 
          HSMConfigMenu.LoadSettings("SingleRunSettings")
          local rulesetHashInt = CalculateHash(HSMConfigMenu.SingleRunSettings, _G)
          local rulesetHash =  HSMConfigMenu.ConvertIntToBase25(rulesetHashInt, 5)
          HSMConfigMenu.CurrentRulesetHash = rulesetHash

          for i = 1, #rulesetHash do
            SetAnimation({ Name = HSMConfigMenu.HashImages[rulesetHash[i]], DestinationId = screen.Components["RulesetHashImage" .. i].Id, OffsetX = 0, OffsetY = 0})
          end

          HSMConfigMenu.updateRulesetHashDisplay()
          HSMConfigMenu.SaveSettingsToGlobal()
        end},
      },
    })
  itemLocationY = itemLocationY + 100

  ------------------
  -- NonRuleset Hash
  ------------------
  local nonRulesetHashInt = CalculateHash(HSMConfigMenu.NonRulesetSettings, _G)
  local nonRulesetHash =  HSMConfigMenu.ConvertIntToBase25(nonRulesetHashInt)

  screen.Components["NonRulesetHashText"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = ScreenCenterX - 1.5 * itemSpacingX - 47,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["NonRulesetHashText"].Id,
    Text = "QoL / Accessibilty Hash: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  local baseXOffset = 15
  for i = 1, #nonRulesetHash do
    screen.Components["NonRulesetHashImage" .. i] = CreateScreenComponent({
      Name = "BlankObstacle",
      Scale = .5,
      X = ScreenCenterX - baseXOffset + (i-1) * itemSpacingX / 2,
      Y = itemLocationY,
      Group = "Combat_Menu" })
    SetAnimation({ Name = HSMConfigMenu.HashImages[nonRulesetHash[i]], DestinationId = screen.Components["NonRulesetHashImage" .. i].Id, OffsetX = 0, OffsetY = 0})
  end
  itemLocationY = itemLocationY + 100
end

function ToBits(num, numBits)
    -- returns a string of bits, most significant first.
    numBits = numBits or select(2, math.frexp(num  - 1))
    local t = "" -- will contain the bits
    for b = numBits, 1, -1 do
        local val = math.fmod(num, 2)
        t = val .. t
        num = math.floor((num - val) / 2)
    end
    return t
end

function GetConfigBits(parentTable, config)
  for i, val in ipairs(config.Values) do
    local currentConfigVal = ModUtil.SafeGet(parentTable, ModUtil.PathToIndexArray(config.Key))
    if currentConfigVal == nil then
      currentConfigVal = config.Default -- One liner will not work for boolean values as it will be interpreted as a logical or
    end
    if currentConfigVal == val then
      return ToBits(i - 1, select(2, math.frexp(#config.Values  - 1)))
    end
  end
  return ""
end

function SetConfigBits(parentTable, config, configBits)
  local curConfigIndex = tonumber(configBits, 2)

  local setValue = config.Values[curConfigIndex + 1]

  if setValue == nil then
    setValue = config.Default -- One liner will not work for boolean values as it will be interpreted as a logical or
  end

  ModUtil.SafeSet(parentTable, ModUtil.PathToIndexArray(config.Key), setValue)
end

function CalculateHash(settings, parentTable)
  local hash = ""

  -- Calculate hash by converting all config to bits
  for _, config in ipairs(settings) do
    local configBits = GetConfigBits(parentTable, config)
    hash = hash .. configBits
  end
  -- Convert to decimal
  local hashInt = tonumber(hash, 2)
  DebugPrint({Text = "hashInt: " .. hashInt})
  return hashInt
end

function HSMConfigMenu.ConvertIntToBase25(intVal, length)
  -- Convert to base 25
  local hashBase25 = {}
  local digits = length
  if digits == nil then
    local temp = intVal
    digits = 0
    while temp > 0 do
      temp = math.floor(temp / 25)
      digits = digits + 1
    end
  end
  for i = digits, 1, -1 do
    hashBase25[i] = math.fmod(intVal, 25)
    intVal = math.floor((intVal - hashBase25[i]) / 25)
  end
  return hashBase25
end

function HSMConfigMenu.GetTotalConfigBits(settings)
  local sum = 0
  for _, config in ipairs(settings) do
    sum = sum + select(2, math.frexp(#config.Values  - 1))
  end
  return sum
end

function HSMConfigMenu.LoadSettings(settingsName, hashedSettingsInt)
  local settings = HSMConfigMenu[settingsName]
  if hashedSettingsInt == nil then
    hashedSettingsInt = HSMConfigMenu.SettingsDefaults[settingsName]
  end
  local hashBits = ToBits(hashedSettingsInt, HSMConfigMenu.GetTotalConfigBits(settings))

  -- Calculate hash by converting all config to bits
  for _, config in ipairs(settings) do
    local curConfigNumBits = select(2, math.frexp(#config.Values  - 1))
    if curConfigNumBits > 0 then
      local configBits = hashBits:sub(1, curConfigNumBits)
      SetConfigBits(_G, config, configBits)
      hashBits = hashBits:sub(curConfigNumBits + 1)
    else
      SetConfigBits(_G, config, "0")
    end
  end

end
