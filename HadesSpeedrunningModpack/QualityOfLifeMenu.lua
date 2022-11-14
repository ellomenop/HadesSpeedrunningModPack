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
  ModpackMenu.Label(
      "EnableShowChamberNumber",
      "Show Chamber Number: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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
  ModpackMenu.Label(
      "DisableIntroCutscene",
      "Disable Intro Cutscene: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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

  ModpackMenu.Label(
      "DisableOutroCutscene",
      "DisableOutroCutscene: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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
  ModpackMenu.Label(
      "EnableQuickRestart",
      "Quick Restart: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
  ModpackMenu.Label(
      "QuickRestartKeyBindings",
      "(Interact + Reload + Call + Summon)",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
          FontSize = 10,
          OffsetY = 22,
      }
  )

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


  ModpackMenu.Label(
      "QuickRestartStartingKeepsake",
      " - Re-equip Starting Keepsake: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
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
  -- Quick Restart on Death
  -----------------------------

  ModpackMenu.Label(
      "QuickRestartQuickDeath",
      " - Enable Quick Death ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
  screen.Components["QuickDeathCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["QuickDeathCheckBox"].Config = "QuickRestart.config.QuickDeathEnabled"
  screen.Components["QuickDeathCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["QuickDeathCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  -----------------------------
  -- Charon Sack Control
  -----------------------------
  ModpackMenu.Label(
      "EnableCharonSackControl",
      "Force Charon Sack Spawn: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
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
  ModpackMenu.Label(
    "EnableRtaTimer",
    "Show RTA Timer: ",
    {
        ItemLocationX = itemLocationX,
        ItemLocationY = itemLocationY,
    }
  )
  screen.Components["RtaTimerCheckBox"].Config = "RtaTimer.config.DisplayTimer"
  screen.Components["RtaTimerCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleGenericConfigCheckBox"
  HSMConfigMenu__UpdateGenericConfigCheckbox(screen, screen.Components["RtaTimerCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY

  ModpackMenu.Label(
    "RtaTimerMultiRun",
    " - Use Multi-Run Mode: ",
    {
        ItemLocationX = itemLocationX,
        ItemLocationY = itemLocationY,
    }
  )
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
  -- Hell Mode Toggle
  -----------------------------
  ModpackMenu.Label(
    "EnableHellModeToggle",
    "Turn Hell Mode On/Off: ",
    {
        ItemLocationX = itemLocationX,
        ItemLocationY = itemLocationY,
    }
  )
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
