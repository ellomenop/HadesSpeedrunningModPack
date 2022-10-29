ModUtil.Mod.Register("EmoteMod")

local config = {
  ModName = "EmoteMod",
  Enabled = false,
}
EmoteMod.config = config
EmoteMod.RadialMenuOpen = false
EmoteMod.SelectedButton = nil
EmoteMod.Screen = {
  Components = {},
  MenuComponents = {},
  Name = "EmoteRadialMenu"
}

function ToBits(num, bits)
    -- returns a table of bits, most significant first.
    bits = bits or math.max(1, select(2, math.frexp(num)))
    local t = {} -- will contain the bits
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
    end
    return t
end

-- Wait for any input to select a radial button. If times out, call this again until menu is closed
function EmoteMod__ButtonListener()
    while config.Enabled and EmoteMod.RadialMenuOpen do
      NotifyOnControlPressed({ Names = { "MoveUp", "MoveDown", "MoveLeft", "MoveRight" }, Notify = "RadialButtonSelected" })
      waitUntil("RadialButtonSelected")
      if config.Enabled and EmoteMod.RadialMenuOpen and EmoteMod.SelectedButton ~= nil then
          ErumiUILibRadialMenuClickRadialButton(EmoteMod.Screen, EmoteMod.SelectedButton)
      end
    end
end

OnControlPressed{ "Shout",
  function(triggerArgs)
    if config.Enabled then
      if IsControlDown({ Name = "Shout" })
          and IsControlDown({ Name = "Assist" })
          and not EmoteMod.RadialMenuOpen then
            EmoteMod.OpenRadialMenu()
      end
    end
end}

OnControlPressed{ "Assist",
  function(triggerArgs)
    if config.Enabled then
      if IsControlDown({ Name = "Shout" })
          and IsControlDown({ Name = "Assist" })
          and not EmoteMod.RadialMenuOpen then
            EmoteMod.OpenRadialMenu()
      end
    end
end}

OnControlPressed{ "MoveUp",
  function(triggerArgs)
    if config.Enabled and EmoteMod.RadialMenuOpen then
      EmoteMod.UpdateSelected(1)
    end
end}

OnControlPressed{ "MoveRight",
  function(triggerArgs)
    if config.Enabled and EmoteMod.RadialMenuOpen then
      EmoteMod.UpdateSelected(2)
    end
end}

OnControlPressed{ "MoveLeft",
  function(triggerArgs)
    if config.Enabled and EmoteMod.RadialMenuOpen then
      EmoteMod.UpdateSelected(4)
    end
end}

OnControlPressed{ "MoveDown",
  function(triggerArgs)
    if config.Enabled and EmoteMod.RadialMenuOpen then
      EmoteMod.UpdateSelected(3)
    end
end}

function EmoteMod.UpdateSelected(componentNumber)
  SetColor({ Id = EmoteMod.Screen.Components["EmoteMenuButtonImageBack1"].Id, Color = Color.Black })
  SetColor({ Id = EmoteMod.Screen.Components["EmoteMenuButtonImageBack2"].Id, Color = Color.Black })
  SetColor({ Id = EmoteMod.Screen.Components["EmoteMenuButtonImageBack3"].Id, Color = Color.Black })
  --SetColor({ Id = EmoteMod.Screen.Components["EmoteMenuButtonImageBack1"].Id, Color = Color.Black })
  SetColor({ Id = EmoteMod.Screen.Components["EmoteMenuButtonImageBack" .. componentNumber].Id, Color = Color.White })
  EmoteMod.SelectedButton = EmoteMod.Screen.Components["EmoteMenuButton" .. componentNumber]
end

function EmoteMod.CloseRadialMenu(screen)
  DisableShopGamepadCursor()
  SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
  SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 16 })
  SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8})
  CloseScreen( GetAllIds( screen.Components ), 0.1)
  UnfreezePlayerUnit()
  screen.KeepOpen = false
  OnScreenClosed({ Flag = screen.Name })
  EmoteMod.RadialMenuOpen = false
  EmoteMod.SelectedButton = nil
end

function EmoteMod.OpenRadialMenu()
  local screen = EmoteMod.Screen
  local components = screen.Components

  OnScreenOpened({ Flag = screen.Name, PersistCombatUI = true})
  FreezePlayerUnit()
  EnableShopGamepadCursor()
  SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
  SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 8 })

  components["EmoteMenu"] = ErumiUILib.RadialMenu.CreateMenu(screen,
    { Name = "EmoteMenu",
    Group = "Combat_Menu",
    StartingAngle = 0,
    MaxAngle = 360,
    Radius = 200,
    Scale = {X = 1, Y = 1},
    X = ScreenCenterX,
    Y = ScreenCenterY,
    TooltipStyle = {Name = "Hidden", args = {}},
    CreationTime = 0.2,
    GeneralColor = Color.Black,
    TextStyle = {
      FontSize = 20,
      OffsetX = -220,
      TitleOffsetY = -30,
      DescOffsetY = 0,
      TextWidth = 600,
    },
    Items = {
      {
        Image = "Tilesets\\Gameplay\\Gameplay_StackUpgrade_01",
        Scale = {X = 0.5, Y = 0.5},
        Title = "Pom of Power",
        Desc = "A Pom of Power",
        Event = function(menu)
          DebugPrint({Text = "Pom of Power selected"})
          EmoteMod.CloseRadialMenu(screen)
        end
      },
      {
        Image = "Tilesets\\Gameplay\\Gameplay_Gemstones_01",
        Scale = {X = 0.5, Y = 0.5},
        Title = "Shiny Gems",
        Desc = "Some Shiny Gems",
        Event = function(menu)
          DebugPrint({Text = "Shiny Gems selected"})
          EmoteMod.CloseRadialMenu(screen)
        end
      },
      {
        Image = "Tilesets\\Gameplay\\Gameplay_MaxHealthUp_01",
        Scale = {X = 0.5, Y = 0.5},
        Title = "Centaur Heart",
        Desc = "A Centaur Heart",
        Event = function(menu)
          DebugPrint({Text = "Centaur Heart selected"})
          EmoteMod.CloseRadialMenu(screen)
        end
      },
      {
        Image = "GUI\\Shell\\UpArrow_Base",
        Scale = {X = 0.5, Y = 0.5},
        Title = "Arrow",
        Desc = "Arrow",
        Event = function(menu)
          DebugPrint({Text = "Arrow selected"})
          EmoteMod.CloseRadialMenu(screen)
        end
      },
    }})
  ErumiUILib.RadialMenu.Expand(components["EmoteMenu"])
  EmoteMod.RadialMenu = components["EmoteMenu"]

  screen.KeepOpen = true
  EmoteMod.RadialMenuOpen = true
  thread(EmoteMod__ButtonListener)

  thread( HandleWASDInput, screen )
  HandleScreenInput( screen )
end
