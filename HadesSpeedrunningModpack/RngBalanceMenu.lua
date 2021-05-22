HSMConfigMenu__UpdateGenericConfigCheckbox = function(screen, button)
  local radioButtonValue = "RadioButton_Unselected"
  if ModUtil.SafeGet(_G, ModUtil.PathArray(button.Config)) then
    radioButtonValue = "RadioButton_Selected"
  end
  SetThingProperty({
    DestinationId = button.Id,
    Property = "Graphic",
    Value = radioButtonValue
  })

  if radioButtonValue == "RadioButton_Unselected" and button.Children ~= nil then
    for _, child in pairs(button.Children) do
      HSMConfigMenu__ToggleGenericConfigCheckBox(screen, screen.Components[child.Checkbox], false)
      ModifyTextBox({ Id = screen.Components[child.Textbox].Id, Color = {1, 1, 1, .2}})
      screen.Components[child.Checkbox].Enabled = false
    end
  elseif button.Children ~= nil then
    for _, child in pairs(button.Children) do
      ModifyTextBox({ Id = screen.Components[child.Textbox].Id, Color = {1, 1, 1, 1}})
      screen.Components[child.Checkbox].Enabled = true
    end
  end
end

function HSMConfigMenu__ToggleGenericConfigCheckBox(screen, button, overrideValue)
  if button.Enabled == false then
    return
  end
  local configPathArray = ModUtil.PathArray(button.Config)
  local configValue = ModUtil.SafeGet(_G, configPathArray)
  if configValue ~= nil then
    if overrideValue ~= nil then
      ModUtil.SafeSet(_G, configPathArray, overrideValue)
    else
      ModUtil.SafeSet(_G, configPathArray, not configValue)
    end
    HSMConfigMenu__UpdateGenericConfigCheckbox(screen, button)
  end
end

local updateSackCheckbox = function(screen, button)
  local radioButtonValue = "RadioButton_Unselected"
  if SatyrSackControl.config.Enabled then
    radioButtonValue = "RadioButton_Selected"
  end
  SetThingProperty({
    DestinationId = button.Id,
    Property = "Graphic",
    Value = radioButtonValue
  })

  screen.Components["SackMinDropDownBaseBacking"].setEnabled(SatyrSackControl.config.Enabled)
  screen.Components["SackMaxDropDownBaseBacking"].setEnabled(SatyrSackControl.config.Enabled)
  if SatyrSackControl.config.Enabled then
    ModifyTextBox({ Id = screen.Components["SackMinTextBox"].Id, Color = {1, 1, 1, 1}})
    ModifyTextBox({ Id = screen.Components["SackMaxTextBox"].Id, Color = {1, 1, 1, 1}})
  else
    ModifyTextBox({ Id = screen.Components["SackMinTextBox"].Id, Color = {1, 1, 1, .2}})
    ModifyTextBox({ Id = screen.Components["SackMaxTextBox"].Id, Color = {1, 1, 1, .2}})
  end
end

function HSMConfigMenu__ToggleSackCheckBox(screen, button)
  SatyrSackControl.config.Enabled = not SatyrSackControl.config.Enabled
  updateSackCheckbox(screen, button)
end

function HSMConfigMenu.CreateRNGMenu( screen )
  local rowStartX = 250
  local columnSpacingX = 800
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 500
  local itemSpacingY = 65
  local itemsPerRow = 3

  -----------------
  -- Sack settings
  -----------------
  -- Enabled
  screen.Components["SackModdedTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["SackModdedTextBox"].Id,
    Text = "Use Modded Saytr Sack: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["SackModdedCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["SackModdedCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleSackCheckBox"

  -- Dropdown options
  local maxSack2 = {}
  local maxSack3 = {}
  local maxSack4 = {}
  local maxSack5 = {}
  local minSack2 = {
    event = function(dropdown)
      SatyrSackControl.config.MinSack = 2
      maxSack2.IsEnabled = true
      maxSack3.IsEnabled = true
      maxSack4.IsEnabled = true
    end,
    Text = "2",
  }
  local minSack3 = {
    event = function(dropdown)
      SatyrSackControl.config.MinSack = 3
      maxSack2.IsEnabled = false
      maxSack3.IsEnabled = true
      maxSack4.IsEnabled = true
    end,
    Text = "3",
  }
  local minSack4 = {
    event = function(dropdown)
      SatyrSackControl.config.MinSack = 4
      maxSack2.IsEnabled = false
      maxSack3.IsEnabled = false
      maxSack4.IsEnabled = true
    end,
    Text = "4",
  }
  local minSack5 = {
    event = function(dropdown)
      SatyrSackControl.config.MinSack = 5
      maxSack2.IsEnabled = false
      maxSack3.IsEnabled = false
      maxSack4.IsEnabled = false
    end,
    Text = "5",
  }
  maxSack2 = {
    event = function(dropdown)
      SatyrSackControl.config.MaxSack = 2
      minSack3.IsEnabled = false
      minSack4.IsEnabled = false
      minSack5.IsEnabled = false
    end,
    Text = "2",
  }
  maxSack3 = {
    event = function(dropdown)
      SatyrSackControl.config.MaxSack = 3
      minSack3.IsEnabled = true
      minSack4.IsEnabled = false
      minSack5.IsEnabled = false
    end,
    Text = "3",
  }
  maxSack4 = {
    event = function(dropdown)
      SatyrSackControl.config.MaxSack = 4
      minSack3.IsEnabled = true
      minSack4.IsEnabled = true
      minSack5.IsEnabled = false
    end,
    Text = "4",
  }
  maxSack5 = {
    event = function(dropdown)
      SatyrSackControl.config.MaxSack = 5
      minSack3.IsEnabled = true
      minSack4.IsEnabled = true
      minSack5.IsEnabled = true
    end,
    Text = "5",
  }

  -- Min
  itemLocationY = itemLocationY + itemSpacingY
  screen.Components["SackMinTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["SackMinTextBox"].Id,
    Text = " - Min Tunnel for Sack: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  ErumiUILib.Dropdown.CreateDropdown(
      	screen, {
      		Name = "SackMinDropDown",
      		Group = "SackMinGroup",
      		Scale = {X = .25, Y = .5},
      		Padding = {X = 0, Y = 2},
      		X = itemLocationX + itemSpacingX, Y = itemLocationY,
      		GeneralFontSize = 16,
          Font = "AlegrayaSansSCRegular",
      		Items = {
      			["Default"] = {Text = SatyrSackControl.config.MinSack, event = function() end},
            minSack2,
            minSack3,
            minSack4,
            minSack5,
      		},
      	})
  itemLocationY = itemLocationY + itemSpacingY

  -- Max
  screen.Components["SackMaxTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["SackMaxTextBox"].Id,
    Text = " - Max Tunnel for Sack: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  ErumiUILib.Dropdown.CreateDropdown(
        screen, {
          Name = "SackMaxDropDown",
          Group = "SackMaxGroup",
          Scale = {X = .25, Y = .5},
          Padding = {X = 0, Y = 2},
          X = itemLocationX + itemSpacingX, Y = itemLocationY,
          GeneralFontSize = 16,
          Font = "AlegrayaSansSCRegular",
          Items = {
            ["Default"] = {Text = SatyrSackControl.config.MaxSack, event = function() end},
            maxSack2,
            maxSack3,
            maxSack4,
            maxSack5,
          },
        })
  itemLocationY = itemLocationY + itemSpacingY
  updateSackCheckbox(screen, screen.Components["SackModdedCheckBox"])

  -----------------
  -- Dont get Vorime'd Settings
  -----------------
  screen.Components["DGVTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["DGVTextBox"].Id,
    Text = "Remove Getting Vorime'd: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["DGVCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["DGVCheckBox"].Config = "DontGetVorimed.config.Enabled"
  screen.Components["DGVCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["DGVCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- Than settings
  -----------------
  screen.Components["ThanTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ThanTextBox"].Id,
    Text = "Thanatos: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  local thanDropdownOptions = {["Default"] = {
    event = function(dropdown) end,
    Text = ThanatosControl.config.ThanatosSetting,
  }}
  for k, v in pairs(ThanatosControl.Presets) do
    table.insert(thanDropdownOptions,
      {
        event = function(dropdown)
          ThanatosControl.config.ThanatosSetting = k
        end,
        Text = k
      })
  end

  ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "ThanDropdown",
    Group = "Combat_Menu",
    Scale = {X = .25, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = thanDropdownOptions
  })
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- Chaos settings
  -----------------
  screen.Components["ChaosTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ChaosTextBox"].Id,
    Text = "Chaos: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  local currentChaosSetting = "Vanilla"
  if InteractableChaos.config.Enabled then
    currentChaosSetting = "Interactable"
  end

  ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "ChaosDropdown",
    Group = "Combat_Menu",
    Scale = {X = .25, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = {
      ["Default"] = {
        event = function(dropdown) end,
        Text = currentChaosSetting,
      },
      {
        event = function(dropdown)
          InteractableChaos.config.Enabled = false
        end,
        Text = "Vanilla"
      },
      {
        event = function(dropdown)
          InteractableChaos.config.Enabled = true
        end,
        Text = "Interactable",
      },
    }
  })
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- Miniboss settings
  -----------------
  screen.Components["MinibossTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["MinibossTextBox"].Id,
    Text = "Minibosses: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  local minibossDropdownOptions = {["Default"] = {
    event = function(dropdown)
      MinibossControl.config.MinibossSetting = "Leaderboard"
    end,
    Text = "Leaderboard",
  }}
  for k, v in pairs(MinibossControl.Presets) do
    table.insert(minibossDropdownOptions,
      {
        event = function(dropdown)
          MinibossControl.config.MinibossSetting = k
        end,
        Text = k
      })
  end

  ErumiUILib.Dropdown.CreateDropdown(screen, {
    Name = "MinibossDropdown",
    Group = "Combat_Menu",
    Scale = {X = .25, Y = .5},
    Padding = {X = 0, Y = 2},
    X = itemLocationX + itemSpacingX, Y = itemLocationY,
    GeneralFontSize = 16,
    Font = "AlegrayaSansSCRegular",
    Items = minibossDropdownOptions
  })
  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- Visual Indicators
  -----------------
  screen.Components["MinibossVisualIndicatorTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["MinibossVisualIndicatorTextBox"].Id,
    Text = "Miniboss Door Preview: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["MinibossVisualIndicatorCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["MinibossVisualIndicatorCheckBox"].Config = "DoorVisualIndicators.config.ShowMinibossDoorIndicator"
  screen.Components["MinibossVisualIndicatorCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["MinibossVisualIndicatorCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["FountainVisualIndicatorTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["FountainVisualIndicatorTextBox"].Id,
    Text = "Fountain Door Preview: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["FountainVisualIndicatorCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["FountainVisualIndicatorCheckBox"].Config = "DoorVisualIndicators.config.ShowFountainDoorIndictor"
  screen.Components["FountainVisualIndicatorCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["FountainVisualIndicatorCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["BoonSelectorTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["BoonSelectorTextBox"].Id,
    Text = "Show Boon Selector Preview: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["BoonSelectorCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["BoonSelectorCheckBox"].Config = "EllosBoonSelectorMod.config.ShowPreview"
  screen.Components["BoonSelectorCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["BoonSelectorCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY


  -----------------
  -- Right Column
  -----------------

  itemLocationY = 250
  itemLocationX = itemLocationX + columnSpacingX

  -----------------
  -- Determinism settings
  -----------------
  -- Rooms
  screen.Components["RoomDeterminismTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["RoomDeterminismTextBox"].Id,
    Text = "Deterministic Rooms by Seed: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["RoomDeterminismCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["RoomDeterminismCheckBox"].Config = "RoomDeterminism.config.Enabled"
  screen.Components["RoomDeterminismCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["RoomDeterminismCheckBox"])
  CreateTextBox({
    Id = screen.Components["RoomDeterminismTextBox"].Id,
    Text = "(Only Tartarus through Elysium) ",
    Color = Color.BoonPatchCommon,
    FontSize = 10,
    OffsetX = 0, OffsetY = 22,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  itemLocationY = itemLocationY + itemSpacingY

  -- Enemies
  screen.Components["EnemyDeterminismTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["EnemyDeterminismTextBox"].Id,
    Text = "Deterministic Enemies by Seed: ",
    Color = {1, 0, 0, 0.4},
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["EnemyDeterminismCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  CreateTextBox({
    Id = screen.Components["EnemyDeterminismTextBox"].Id,
    Text = "(Not Yet Implemented) ",
    Color = {1, 0, 0, 0.4},
    FontSize = 10,
    OffsetX = 0, OffsetY = 22,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  itemLocationY = itemLocationY + itemSpacingY

  -- Hammers
  screen.Components["HammerDeterminismTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["HammerDeterminismTextBox"].Id,
    Text = "Deterministic Hammers by Seed: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["HammerDeterminismCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["HammerDeterminismCheckBox"].Config = "FixedHammers.config.Enabled"
  screen.Components["HammerDeterminismCheckBox"].Children = {{Textbox = "AchillesRebalanceTextBox", Checkbox = "AchillesRebalanceCheckBox"}, {Textbox = "NemesisRebalanceTextBox", Checkbox = "NemesisRebalanceCheckBox"}}
  screen.Components["HammerDeterminismCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["AchillesRebalanceTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["AchillesRebalanceTextBox"].Id,
    Text = " - Achilles Hammer Rebalance: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["AchillesRebalanceCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["AchillesRebalanceCheckBox"].Config = "FixedHammers.config.AchillesRebalance"
  screen.Components["AchillesRebalanceCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  CreateTextBox({
    Id = screen.Components["AchillesRebalanceTextBox"].Id,
    Text = "(First Hammer always includes Flurry Jab) ",
    Color = Color.BoonPatchCommon,
    FontSize = 10,
    OffsetX = 38, OffsetY = 22,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["NemesisRebalanceTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu"
  })
  CreateTextBox({
    Id = screen.Components["NemesisRebalanceTextBox"].Id,
    Text = " - Nemesis Hammer Rebalance: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["NemesisRebalanceCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["NemesisRebalanceCheckBox"].Config = "FixedHammers.config.NemesisRebalance"
  screen.Components["NemesisRebalanceCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  CreateTextBox({
    Id = screen.Components["NemesisRebalanceTextBox"].Id,
    Text = "(First Hammer always includes Double Edge) ",
    Color = Color.BoonPatchCommon,
    FontSize = 10,
    OffsetX = 38, OffsetY = 22,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["HammerDeterminismCheckBox"])
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["AchillesRebalanceCheckBox"])
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["NemesisRebalanceCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY
end

ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "RNG Balance"}, HSMConfigMenu.CreateRNGMenu)
end)
