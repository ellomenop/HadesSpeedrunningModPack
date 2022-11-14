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
  What a comfy change though:

  ModpackMenu.Label(
      "EnableColorblindTartarus",
      "Tartarus: ",
      {
          ItemLocationX = itemLocationX + itemSpacingX,
          ItemLocationY = itemLocationY,
      }
  )
  ModpackMenu.Label(
      "EnableColorblindAsphodel",
      "Tartarus: ",
      {
          ItemLocationX = itemLocationX + 2 * itemSpacingX,
          ItemLocationY = itemLocationY,
      }
  )
  ModpackMenu.Label(
      "EnableColorblindElysium",
      "Tartarus: ",
      {
          ItemLocationX = itemLocationX + 3 * itemSpacingX,
          ItemLocationY = itemLocationY,
      }
  )
  ModpackMenu.Label(
      "EnableColorblindStyx",
      "Tartarus: ",
      {
          ItemLocationX = itemLocationX + 4 * itemSpacingX,
          ItemLocationY = itemLocationY,
      }
  )

  itemLocationY = itemLocationY + 40
  itemLocationX = rowStartX

  -- General prompt
  ModpackMenu.Label(
      "EnableColorblind",
      "Enable Color Blind Mode: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

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
  ModpackMenu.Label(
      "AccessibilityNote",
      "Accessiblity options missing something you need? Reach out to ellomenop#2254 on discord and I will see what I can do",
      {
          FontSize = 14,
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )
end

ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "Accessibility"}, HSMConfigMenu.CreateAccessibilityMenu)
end)
