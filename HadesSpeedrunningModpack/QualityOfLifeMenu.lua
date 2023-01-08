function HSMConfigMenu.CreateQolMenu(screen)
  local rowStartX = 250
  local columnSpacingX = 800
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 500
  local itemSpacingY = 65
  local itemsPerRow = 3

  -----------------------------
  -- Show Chamber Number
  -----------------------------
  screen.Components["ChamberNumberTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ChamberNumberTextBox"].Id,
    Text = "Show Chamber Number: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["ChamberNumberCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["ChamberNumberCheckBox"].Config = "ShowChamberNumber.config.ShowDepth"
  screen.Components["ChamberNumberCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["ChamberNumberCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------------------
  -- Intro and outro cutscenes
  -----------------------------
  screen.Components["DisableIntroTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["DisableIntroTextBox"].Id,
    Text = "Disable Intro Cutscene: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["DisableIntroCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["DisableIntroCheckBox"].Config = "RemoveCutscenes.config.RemoveIntro"
  screen.Components["DisableIntroCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["DisableIntroCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["DisableOuttroTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["DisableOuttroTextBox"].Id,
    Text = "Disable Outro Cutscene: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["DisableOutroCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["DisableOutroCheckBox"].Config = "RemoveCutscenes.config.RemoveOutro"
  screen.Components["DisableOutroCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["DisableOutroCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------------------
  -- Quick Restart
  -----------------------------
  screen.Components["RestartTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["RestartTextBox"].Id,
    Text = "Quick Restart: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  CreateTextBox({
    Id = screen.Components["RestartTextBox"].Id,
    Text = "(Interact + Reload + Call + Summon) ",
    Color = Color.BoonPatchCommon,
    FontSize = 10,
    OffsetX = 0, OffsetY = 22,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  screen.Components["RestartCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["RestartCheckBox"].Config = "QuickRestart.config.Enabled"
  screen.Components["RestartCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["RestartCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY


  screen.Components["StartingKeepsakeTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["StartingKeepsakeTextBox"].Id,
    Text = " - Re-equip Starting Keepsake: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  screen.Components["StartingKeepsakeCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["StartingKeepsakeCheckBox"].Config = "QuickRestart.config.KeepStartingKeepsake"
  screen.Components["StartingKeepsakeCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["StartingKeepsakeCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------------------
  -- Charon Sack Control
  -----------------------------

  screen.Components["CharonSackControlTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["CharonSackControlTextBox"].Id,
    Text = "Force Charon Sack Spawn: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left",
  })
  screen.Components["CharonSackControlCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["CharonSackControlCheckBox"].Config = "CharonSackControl.config.SpawnSack"
  screen.Components["CharonSackControlCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["CharonSackControlCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------------------
  -- Right Column
  -----------------------------
  itemLocationY = 250
  itemLocationX = itemLocationX + columnSpacingX

  -----------------------------
  -- Show RTA Timer
  -----------------------------
  screen.Components["RtaTimerTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["RtaTimerTextBox"].Id,
    Text = "Show RTA Timer: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["RtaTimerCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["RtaTimerCheckBox"].Config = "RtaTimer.config.DisplayTimer"
  screen.Components["RtaTimerCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["RtaTimerCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["RtaTimerMultiRunTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["RtaTimerMultiRunTextBox"].Id,
    Text = " - Use Multi-Run Mode: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["RtaTimerMultiRunCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["RtaTimerMultiRunCheckBox"].Config = "RtaTimer.config.MultiWeapon"
  screen.Components["RtaTimerMultiRunCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["RtaTimerMultiRunCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["RtaTimerResetButton"] = CreateScreenComponent({
    Name = "MarketSlot",
    Scale = 1,
    X = itemLocationX + itemSpacingX / 2 - 50,
    Y = itemLocationY,
    Group = "Combat_Menu" })
	SetScaleX({ Id = screen.Components["RtaTimerResetButton"].Id, Fraction =  .375})
	SetScaleY({ Id = screen.Components["RtaTimerResetButton"].Id, Fraction = .5 })

  CreateTextBox({
    Id = screen.Components["RtaTimerResetButton"].Id,
    Text = "Reset Timer\\n(for MultiRun)",
    Color = Color.BoonPatchCommon,
    FontSize = 12,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })
  screen.Components["RtaTimerResetButton"].OnPressedFunctionName = "RtaTimer__ResetRtaTimer"
  itemLocationY = itemLocationY + itemSpacingY
  -----------------------------
  -- Victory Screen Split Display Toggle
  -----------------------------
  screen.Components["SplitDisplayTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["SplitDisplayTextBox"].Id,
    Text = "Splits on Victory Screen: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["SplitDisplayCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["SplitDisplayCheckBox"].Config = "SplitDisplay.config.Enabled"
  screen.Components["SplitDisplayCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["SplitDisplayCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["SplitDisplaySegmentTimeTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["SplitDisplaySegmentTimeTextBox"].Id,
    Text = " - Segment Length instead of Split Time: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  screen.Components["SplitDisplaySegmentTimeCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["SplitDisplaySegmentTimeCheckBox"].Config = "SplitDisplay.config.ShowSegments"
  screen.Components["SplitDisplaySegmentTimeCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["SplitDisplaySegmentTimeCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY
  -----------------------------
  -- Hell Mode Toggle
  -----------------------------
  screen.Components["HellModeToggleTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["HellModeToggleTextBox"].Id,
    Text = "Turn Hell Mode On/Off:",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
  itemLocationY = itemLocationY + itemSpacingY

  screen.Components["HellModeToggleButton"] = CreateScreenComponent({
    Name = "MarketSlot",
    Scale = 1,
    X = itemLocationX + itemSpacingX / 2 - 50,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  SetScaleX({ Id = screen.Components["HellModeToggleButton"].Id, Fraction =  .375})
  SetScaleY({ Id = screen.Components["HellModeToggleButton"].Id, Fraction = .5 })

  CreateTextBox({
    Id = screen.Components["HellModeToggleButton"].Id,
    Text = "Toggle Hell Mode",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })
  screen.Components["HellModeToggleButton"].OnPressedFunctionName = "HellModeToggle.ToggleHellMode"
  itemLocationY = itemLocationY + itemSpacingY
end


ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "QoL"}, HSMConfigMenu.CreateQolMenu)
end)
