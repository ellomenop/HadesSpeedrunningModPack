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
  ModpackMenu.Label(
      "EnableSatyrSackControl",
      "Use Modded Saytr Sack:",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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

  -- Minimum Satyr Sack
  itemLocationY = itemLocationY + itemSpacingY
  ModpackMenu.Label(
      "MinimumSatyrSack",
      " - Min Tunnel for Sack: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
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
  ModpackMenu.Label(
      "MaximumSatyrSack",
      " - Max Tunnel for Sack: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
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
  ModpackMenu.Label(
      "EnableDontGetVorimed",
      "Remove Getting Vorime'd: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

  ModpackMenu.CheckBox(
    "EnableDontGetVorimed",
    DontGetVorimed.config,
    "Enabled",
    {
      ItemLocationX = itemLocationX + itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

  itemLocationY = itemLocationY + itemSpacingY

  -----------------
  -- Than settings
  -----------------
  ModpackMenu.Label(
      "EnableRemoveThanatos",
      "Thanatos: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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
  ModpackMenu.Label(
      "SelectChaosType",
      "Chaos: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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
  ModpackMenu.Label(
      "SelectMinibossControl",
      "Minibosses: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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
  ModpackMenu.Label(
      "EnableMinibossVisualIndicator",
      "Miniboss Door Preview: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

  ModpackMenu.CheckBox(
    "EnableMinibossVisualIndicator",
    DoorVisualIndicators.config,
    "ShowMinibossDoorIndicator",
    {
      ItemLocationX = itemLocationX + itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

  itemLocationY = itemLocationY + itemSpacingY

  ModpackMenu.Label(
      "EnableFountainVisualIndicator",
      "Fountain Door Preview: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

  ModpackMenu.CheckBox(
    "EnableFountainVisualIndicator",
    DoorVisualIndicators.config,
    "ShowFountainDoorIndicator",
    {
      ItemLocationX = itemLocationX + itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

  itemLocationY = itemLocationY + itemSpacingY

  ModpackMenu.Label(
      "EnableBoonSelectorPreview",
      "Show Boon Selector Preview: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

  ModpackMenu.CheckBox(
    "EnableBoonSelectorPreview",
    EllosBoonSelectorMod.config,
    "ShowPreview",
    {
      ItemLocationX = itemLocationX + itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

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
  ModpackMenu.Label(
      "EnableRoomDeterminism",
      "Deterministic Rooms by Seed: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
  ModpackMenu.Label(
    "RoomDeterminismDisclaimer",
    "(Only Tartarus through Elysium) ",
    {
      FontSize = 10,
      ItemLocationX = itemLocationX,
      ItemLocationY = itemLocationY,
      OffsetY = 22,
    }
  )

  ModpackMenu.CheckBox(
    "EnableRoomDeterminism",
    RoomDeterminism.config,
    "Enabled",
    {
      ItemLocationX = itemLocationX + itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

  itemLocationY = itemLocationY + itemSpacingY

  -- Enemies
  ModpackMenu.Label(
      "EnableEnemyDeterminism",
      "Deterministic Enemies by Seed: ",
      {
          Color = {1, 0, 0, 0.4},
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
  screen.Components["EnemyDeterminismCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  ModpackMenu.Label(
      "WarningEnemyDeterminismNotImplemented",
      "(Not Yet Implemented)",
      {
          Color = {1, 0, 0, 0.4},
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
  itemLocationY = itemLocationY + itemSpacingY

  -- Hammers
  ModpackMenu.Label(
      "EnableHammerControl",
      "Set Hammers by Aspect: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
  ModpackMenu.CheckBox(
    "EnableHammerControl",
    RunStartControl.config,
    "Enabled",
    {
      ItemLocationX = itemLocationX + itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )
  itemLocationY = itemLocationY + itemSpacingY
end

ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "RNG Balance"}, HSMConfigMenu.CreateRNGMenu)
end)
