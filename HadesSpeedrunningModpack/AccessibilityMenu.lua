local updateColorblindCheckbox = function(screen, button)
  local enabled = ColorblindMod.config[button.Biome .. "Enabled"]
  local radioButtonValue = "RadioButton_Unselected"
  if enabled then
    radioButtonValue = "RadioButton_Selected"
  end
  SetThingProperty({
    DestinationId = button.Id,
    Property = "Graphic",
    Value = radioButtonValue
  })
end

function HSMConfigMenu__ToggleColorblindCheckBox(screen, button)
  ColorblindMod.config[button.Biome .. "Enabled"] = not ColorblindMod.config[button.Biome .. "Enabled"]
  updateColorblindCheckbox(screen, button)
end

function HSMConfigMenu.CreateAccessibilityMenu( screen )
  local rowStartX = 250
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 250
  local itemSpacingY = 65

  -- Biome Headers
  itemLocationX = itemLocationX + 250
  screen.Components["ColorblindTartarusTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ColorblindTartarusTextBox"].Id,
    Text = "Tartarus",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })
  screen.Components["ColorblindAsphodelTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX + 2 * itemSpacingX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ColorblindAsphodelTextBox"].Id,
    Text = "Asphodel",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })
  screen.Components["ColorblindElysiumTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX + 3 * itemSpacingX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ColorblindElysiumTextBox"].Id,
    Text = "Elysium",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })
  screen.Components["ColorblindStyxTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX + 4 * itemSpacingX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ColorblindStyxTextBox"].Id,
    Text = "Styx",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Center"
  })
  itemLocationY = itemLocationY + 40
  itemLocationX = rowStartX

  -- General prompt
  screen.Components["ColorblindPromptTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["ColorblindPromptTextBox"].Id,
    Text = "Enable Color Blind Mode: ",
    Color = Color.BoonPatchCommon,
    FontSize = 16,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })

  -- Biome Checkboxes
  itemLocationX = itemLocationX + 250
  screen.Components["ColorblindTartarusCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["ColorblindTartarusCheckBox"].Biome = "Tartarus"
  screen.Components["ColorblindTartarusCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleColorblindCheckBox"
  updateColorblindCheckbox(screen, screen.Components["ColorblindTartarusCheckBox"])

  screen.Components["ColorblindAsphodelCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + 2 * itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["ColorblindAsphodelCheckBox"].Biome = "Asphodel"
  screen.Components["ColorblindAsphodelCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleColorblindCheckBox"
  updateColorblindCheckbox(screen, screen.Components["ColorblindAsphodelCheckBox"])

  screen.Components["ColorblindElysiumCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + 3 * itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["ColorblindElysiumCheckBox"].Biome = "Elysium"
  screen.Components["ColorblindElysiumCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleColorblindCheckBox"
  updateColorblindCheckbox(screen, screen.Components["ColorblindElysiumCheckBox"])

  screen.Components["ColorblindStyxCheckBox"] = CreateScreenComponent({
    Name = "RadioButton",
    Scale = 1,
    X = itemLocationX + 4 * itemSpacingX,
    Y = itemLocationY,
    Group = "CombatMenu"
  })
  screen.Components["ColorblindStyxCheckBox"].Biome = "Styx"
  screen.Components["ColorblindStyxCheckBox"].OnPressedFunctionName = "HSMConfigMenu__ToggleColorblindCheckBox"
  updateColorblindCheckbox(screen, screen.Components["ColorblindStyxCheckBox"])
  itemLocationY = itemLocationY + itemSpacingY
  itemLocationX = rowStartX

  ---------------------
  -- Accessibilty Note
  ---------------------
  screen.Components["AccessibilityNoteTextBox"] = CreateScreenComponent({
    Name = "BlankObstacle",
    Scale = 1,
    X = itemLocationX,
    Y = itemLocationY,
    Group = "Combat_Menu" })
  CreateTextBox({
    Id = screen.Components["AccessibilityNoteTextBox"].Id,
    Text = "Accessiblity options missing something you need? Reach out to ellomenop#2254 on discord and I will see what I can do",
    Color = Color.Gray,
    FontSize = 14,
    OffsetX = 0, OffsetY = 0,
    Font = "AlegrayaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
    Justification = "Left"
  })
end

ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "Accessibility"}, HSMConfigMenu.CreateAccessibilityMenu)
end)
