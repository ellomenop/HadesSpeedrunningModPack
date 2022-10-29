ModUtil.Mod.Register("ModConfigMenu")

ModConfigMenu.Menus = {}
ModConfigMenu.CurrentMenuIdx = 1
ModConfigMenu.MenuOverride = {}

function ModConfigMenu.Register(config)
  table.insert(ModConfigMenu.Menus, config)
end

function ModConfigMenu.RegisterMenuOverride(configObject, createMenuFunction)
  table.insert(ModConfigMenu.Menus, configObject)
  local menuIdx = #ModConfigMenu.Menus
  ModConfigMenu.MenuOverride[menuIdx] = {createMenu = createMenuFunction}
end

ModUtil.LoadOnce(function()
  -- this table is intentionally not excluded from saves, so
  -- that mod config settings can be persisted in the save file
  if not ModConfigMenuSavedSettings then
    ModConfigMenuSavedSettings = {
      Version = "1.0",
      Menus = {}
    }
  end
  if ModConfigMenuSavedSettings.Version == "1.0" then
    for i, config in pairs(ModConfigMenu.Menus) do
      local savedMenu = ModConfigMenuSavedSettings[config.ModName]
      if savedMenu then
        for k,v in pairs(savedMenu) do
          if config[k] ~= nil then
            config[k] = v
          end
        end
      end
      ModConfigMenuSavedSettings[config.ModName] = config
    end
  end
end)

local function PrettifyName( name )
  local first = true
  local prettyName = name:gsub("%u", function(c)
    if first then
      first = false
      return c
    else
      return ' ' .. c
    end
  end)
  return prettyName
end

local function UpdateCheckBox( button, value )
  local radioButtonValue = "RadioButton_Unselected"
  if value then
    radioButtonValue = "RadioButton_Selected"
  end
  SetThingProperty({
    DestinationId = button.Id,
    Property = "Graphic",
    Value = radioButtonValue
  })
end

local function ClearPreviousMenu( screen )
  local ids = {}
  for name, component in pairs(screen.Components) do
    if screen.EvergreenComponents[name] == nil then
      screen.Components[name] = nil
      table.insert(ids, component.Id)
    end
  end
  CloseScreen( ids )
end

local function ShowCurrentMenu( screen )
  -- Update Menu title if menu exists
  local currentMenu = ModConfigMenu.Menus[ModConfigMenu.CurrentMenuIdx]
  if not currentMenu then
    return
  end

  ModifyTextBox({
    Id = screen.Components["SelectedMenu"].Id,
    Text = currentMenu.ModName or "Unknown Mod"
  })

  -- If menu is a custom menu, call the creation callback
  if ModConfigMenu.MenuOverride[ModConfigMenu.CurrentMenuIdx] ~= nil then
    ModConfigMenu.MenuOverride[ModConfigMenu.CurrentMenuIdx].createMenu( screen )
    return
  end

  -- Otherwise create a standardized menu based on config content
  local rowStartX = 350
  local columnSpacingX = 600
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 250
  local itemSpacingY = 50
  local itemsPerRow = 3

  local itemsInRow = 0
  for name, value in orderedPairs( currentMenu ) do
    if value == true or value == false then
      itemsInRow = itemsInRow + 1
      if itemsInRow > itemsPerRow then
        itemLocationX = rowStartX
        itemLocationY = itemLocationY + itemSpacingY
        itemsInRow = itemsInRow - itemsPerRow
      end
      screen.Components[name .. "TextBox"] = CreateScreenComponent({
        Name = "BlankObstacle",
        Scale = 1,
        X = itemLocationX,
        Y = itemLocationY,
        Group = "Combat_Menu" })
      CreateTextBox({
        Id = screen.Components[name .. "TextBox"].Id,
        Text = PrettifyName(name),
        Color = Color.BoonPatchCommon,
        FontSize = 16,
        OffsetX = 0, OffsetY = 0,
        Font = "AlegrayaSansSCRegular",
        ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0,  2 },
        Justification = "Center"
      })
      local previousItemLocationX = itemLocationX
      itemLocationX = itemLocationX + itemSpacingX
      screen.Components[name .. "CheckBox"] = CreateScreenComponent({
        Name = "RadioButton",
        Scale = 1,
        X = itemLocationX,
        Y = itemLocationY,
        Group = "CombatMenu"
      })
      UpdateCheckBox(screen.Components[name .. "CheckBox"], value)
      screen.Components[name .. "CheckBox"].MenuItemName = name
      screen.Components[name .. "CheckBox"].OnPressedFunctionName = "ModConfigMenu__ToggleBoolean"
      CreateTextBox({
        Id = screen.Components[name .. "CheckBox"].Id,
        FontSize = 16,
        OffsetX = 0, OffsetY = 0,
        Font = "AlegrayaSansSCRegular",
        Justification = "Center"
      })
      itemLocationX = previousItemLocationX + columnSpacingX
    end
  end
end

function ModConfigMenu__MenuLeft( screen, button )
  ModConfigMenu.CurrentMenuIdx = ModConfigMenu.CurrentMenuIdx - 1
  if ModConfigMenu.CurrentMenuIdx < 1 then
    ModConfigMenu.CurrentMenuIdx = #ModConfigMenu.Menus
  end
  ClearPreviousMenu( screen )
  ShowCurrentMenu( screen )
end

function ModConfigMenu__MenuRight( screen, button )
  ModConfigMenu.CurrentMenuIdx = ModConfigMenu.CurrentMenuIdx + 1
  if ModConfigMenu.CurrentMenuIdx > #ModConfigMenu.Menus then
    ModConfigMenu.CurrentMenuIdx = 1
  end
  ClearPreviousMenu( screen )
  ShowCurrentMenu( screen )
end

function ModConfigMenu__ToggleBoolean(screen, button)
  local menu = ModConfigMenu.Menus[ModConfigMenu.CurrentMenuIdx]
  local name = button.MenuItemName
  menu[name] = not menu[name]
  UpdateCheckBox(button, menu[name])
end

function ModConfigMenu__OpenFromAdvancedTooltipScreen()
  CloseAdvancedTooltipScreen()
  ModConfigMenu__Open()
end

function ModConfigMenu__Open()
  local components = {}
  local screen = {
    Components = components,
    MenuComponents = {},
    CloseAnimation  = "QuestLogBackground_Out"
  }
  OnScreenOpened({ Flag = screen.Name, PersistCombatUI = true})
  FreezePlayerUnit()
  EnableShopGamepadCursor()
  SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
  SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 8 })

  components.ShopBackgroundDim = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_Menu"})
  components.ShopBackgroundSplatter = CreateScreenComponent({ Name = "LevelUpBackground", Group = "Combat_Menu"})
  components.ShopBackground = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_Menu"})

  SetAnimation({ DestinationId = components.ShopBackground.Id, Name = "QuestLogBackgroun_In", OffsetY = 30 })

  SetScale({ Id = components.ShopBackgroundDim.Id, Fraction = 4})
  SetColor({ Id = components.ShopBackgroundDim.Id, Color = { 0.090, 0.055, 0.157, 0.8 } })

  PlaySound({ Name = "/SFX/Menu Sounds/FatedListOpen" })

  wait(0.2)

  -- Title
  CreateTextBox({ Id = components.ShopBackground.Id, Text = "Configure your Mods", FontSize = 34, OffsetX = 0, OffsetY = -460,
    Color = Color.White, Font = "SpectralSCLightTitling", ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0, 2 },
    Justification = "Center" })

  -- Close Button
  components.CloseButton = CreateScreenComponent({ Name = "ButtonClose", Scale = 0.7, Group = "Combat_Menu"})
  Attach({ Id = components.CloseButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = -6, OffsetY = 456 })
  components.CloseButton.OnPressedFunctionName = "ModConfigMenu__Close"
  components.CloseButton.ControlHotkey = "Cancel"

  components["MenuLeft"] = CreateScreenComponent({
    Name = "ButtonCodexLeft",
    X = 650,
    Y = 175,
    Scale = 1.0,
    Group = "Combat_Menu"
  })

  components["MenuLeft"].OnPressedFunctionName = "ModConfigMenu__MenuLeft"

  components["MenuRight"] = CreateScreenComponent({
    Name = "ButtonCodexRight",
    X = 1300,
    Y = 175,
    Scale = 1.0,
    Group = "Combat_Menu"
  })

  components["MenuRight"].OnPressedFunctionName = "ModConfigMenu__MenuRight"

  components["SelectedMenu"] = CreateScreenComponent({
    Name = "BlankObstacle",
    X = 975,
    Y = 175,
    Scale = 0.5,
    Group = "Combat_Menu"
  })

  components["MenuRight"].OnPressedFunctionName = "ModConfigMenu__MenuRight"

  CreateTextBox({
    Id = components["SelectedMenu"].Id,
    Text = "No Mods To Configure",
    OffsetX = 0, OffsetY = 0,
    Color = Color.White,
    Font = "AlegreyaSansSCRegular",
    ShadowBlur = 0, ShadowColor = { 0, 0, 0, 1 }, ShadowOffset = { 0, 2 },
    Justification = "Center"
  })

  screen.EvergreenComponents = DeepCopyTable(components)

  ClearPreviousMenu( screen )
  ShowCurrentMenu( screen )
  screen.KeepOpen = true
  thread( HandleWASDInput, screen )
  HandleScreenInput( screen )
end

function ModConfigMenu__Close( screen, button )
  DisableShopGamepadCursor()
  SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
  SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 16 })
  SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8})
  SetAnimation({ DestinationId = screen.Components.ShopBackground.Id, Name = screen.CloseAnimation })
  PlaySound({ Name = "/SFX/Menu Sounds/FatedListClose" })
  CloseScreen( GetAllIds( screen.Components ), 0.1)
  UnfreezePlayerUnit()
  screen.KeepOpen = false
  OnScreenClosed({ Flag = screen.Name })
end

ModUtil.Path.Wrap("CreatePrimaryBacking", function ( baseFunc )
  -- Only show menu between runs
  if not ModUtil.Path.Get("CurrentDeathAreaRoom") then
    return baseFunc()
  end

  local components = ScreenAnchors.TraitTrayScreen.Components
  components.ModConfigButton = CreateScreenComponent({
    Name = "ButtonDefault",
    Scale = 0.8,
    Group = "Combat_Menu_TraitTray",
    X = CombatUI.TraitUIStart + 135,
    Y = 185 })
  components.ModConfigButton.OnPressedFunctionName = "ModConfigMenu__OpenFromAdvancedTooltipScreen"
  CreateTextBox({ Id = components.ModConfigButton.Id,
      Text = "Configure Mods",
      OffsetX = 0, OffsetY = 0,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })
  Attach({ Id = components.ModConfigButton.Id, DestinationId = components.ModConfigButton, OffsetX = 500, OffsetY = 500 })
  baseFunc()
end, ModConfigMenu)
