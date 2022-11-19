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

  ModpackMenu.CheckBox(
    "ColorblindTartarusCheckBox",
    ColorblindMod.config,
    "TartarusEnabled",
    {
      ItemLocationX = itemLocationX + itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

  -- Biome Checkboxes
  itemLocationX = itemLocationX + 250
  ModpackMenu.CheckBox(
    "ColorblindAsphodelCheckBox",
    ColorblindMod.config,
    "AsphodelEnabled",
    {
      ItemLocationX = itemLocationX + 2 * itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

  ModpackMenu.CheckBox(
    "ColorblindElysiumCheckBox",
    ColorblindMod.config,
    "ElysiumEnabled",
    {
      ItemLocationX = itemLocationX + 3 * itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

  ModpackMenu.CheckBox(
    "ColorblindStyxCheckBox",
    ColorblindMod.config,
    "StyxEnabled",
    {
      ItemLocationX = itemLocationX + 4 * itemSpacingX,
      ItemLocationY = itemLocationY,
    }
  )

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
