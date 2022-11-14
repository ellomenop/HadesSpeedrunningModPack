function HSMConfigMenu.CreatePersonalizationMenu(screen)
  local rowStartX = 250
  local columnSpacingX = 600
  local itemLocationX = rowStartX
  local itemLocationY = 250
  local itemSpacingX = 500
  local itemSpacingY = 65
  local itemsPerRow = 3

  local moddedWarningKeyboard = {}

  -- Modded Game message customization
  ModpackMenu.Label(
      "CustomizeModdedWarning",
      "Customize your Modded Warning: ",
      {
          ItemLocationX = itemLocationX,
          ItemLocationY = itemLocationY,
      }
  )

  local moddedWarningTextBox = ErumiUILib.Textbox.CreateTextbox(screen, {
		Name = "ModdedWarningTextBox",
		Group = "Combat_Menu",
		X = itemLocationX + itemSpacingX + 50,
		Y = itemLocationY,
		StartingText = ModdedWarning.config.WarningMessage,
    MaxLength = 20,
		Scale = {X = .4, Y = 0.1},
		BackgroundColor = {0.5, 0.5, 0.5, 0},
		TextStyle = {
			FontSize = 10,
			Color = Color.White, --{0.988, 0.792, 0.247, 1},
			Width = 470,
			Justification = "Left",
			Offset = {X = -100, Y = -9},
		},
		CursorColor = Color.Red,
		CursorSpacing = 10,
		OnFocus = function (textbox)
			ErumiUILib.Keyboard.Expand(moddedWarningKeyboard)
		end
	})

  moddedWarningKeyboard = ErumiUILib.Keyboard.CreateKeyboard(screen,{
		Name = "ModdedWarningKeyboard",
		Group = "Combat_Menu",
		Width = {Start = 320, End = 1680},
		Height = {Start = 750, End = 870},
		Layout = {Style = "Alphanumeric", args ={}},
		X = {Start = 960, End = 960},
		Y = {Start = 1430, End = 915},
		BackgroundScale = {X = 0.76, Y = 0.4},
		Colors = {Background = {0.5, 0.5, 0.5, 1}, Text = {1,1,1,1}, ShiftPressed = {0.988, 0.792, 0.247, 1}},
    ExpandCallback = function(keyboard)
      ErumiUILib.Textbox.ShowCursor(moddedWarningTextBox, true)
    end,
    CollapseCallback = function(keyboard)
      ErumiUILib.Textbox.ShowCursor(moddedWarningTextBox, false)
      ModdedWarning.config.WarningMessage = ErumiUILib.Textbox.GetText(moddedWarningTextBox)
      ModdedWarning.showModdedWarning()
    end,
		KeyPressedFunction = function(keyboard, key)
			ErumiUILib.Textbox.Write(moddedWarningTextBox, key)
		end,
		SpecialKeys = {
			Shift = function(keyboard)
				keyboard.IsUpper = not keyboard.IsUpper
				ErumiUILib.Keyboard.Refresh(keyboard)
			end,
			Back = function(keyboard)
				ErumiUILib.Textbox.Delete(moddedWarningTextBox, 1)
			end,
			Enter = function(keyboard)
  			ErumiUILib.Keyboard.Collapse(keyboard)
			end,
			Clear = function(keyboard)
        ErumiUILib.Textbox.SetCursorPosition(moddedWarningTextBox, #moddedWarningTextBox.currentText)
        ErumiUILib.Textbox.Delete(moddedWarningTextBox, #moddedWarningTextBox.currentText)
			end,
			Left = function (keyboard)
				ErumiUILib.Textbox.SetCursorPosition(moddedWarningTextBox, moddedWarningTextBox.cursorPosition - 1)
			end,
			Right = function (keyboard)
				ErumiUILib.Textbox.SetCursorPosition(moddedWarningTextBox, moddedWarningTextBox.cursorPosition + 1)
			end,
		}
	})

  -- Update the item location a custom amount because erumi textbox is a mystery :P
  itemLocationY = itemLocationY + itemSpacingY

  -- Color customization
  -- Modded Game message customization
  local colorR = ModdedWarning.config.Color[1]
  local colorG = ModdedWarning.config.Color[2]
  local colorB = ModdedWarning.config.Color[3]
  local width = 180
  local height = 180
  screen.Components["ColorPickerPreview"] = CreateScreenComponent({
    Name = "rectangle01",
    Scale = 1,
    X = itemLocationX + 350 + width / 2,
    Y = itemLocationY + height / 2 - 28,
    Group = "ColorPickerPreview",
  })
  SetScaleX({ Id = screen.Components["ColorPickerPreview"].Id, Fraction = width / 480 })
  SetScaleY({ Id = screen.Components["ColorPickerPreview"].Id, Fraction = height / 267 })
  SetColor({ Id = screen.Components["ColorPickerPreview"].Id, Color = {colorR, colorG, colorB, 255} })

  local updatePreviewColor = function(sliderProgess, sliderEventArgs, slider)
    SetColor({ Id = screen.Components["ColorPickerPreview"].Id, Color = {colorR, colorG, colorB, 255} })
  end

  local moddedWarningColorRedSlider = ErumiUILib.Slider.CreateNew(screen,
  	{ Name = "ModdedWarningColorRedSlider",
  	Group = "Combat_Menu",
  	ShowSlider = true,
  	ItemAmount = 100,
  	StartingFraction = colorR / 255,
  	ItemWidth = 3,
    Color = Color.OrangeRed,
  	Image = "ShrineMeterBarFill",
  	Scale = {ButtonsX = 0.001, ButtonsY = 0.028, ImageX = 0.75, ImageY = 1.25},
  	X = itemLocationX,
  	Y = itemLocationY,
  	SliderOffsetX = 85})
  itemLocationY = itemLocationY + itemSpacingY

  local moddedWarningColorGreenSlider = ErumiUILib.Slider.CreateNew(screen,
    { Name = "ModdedWarningColorGreenSlider",
    Group = "Combat_Menu",
    ShowSlider = true,
    ItemAmount = 100,
    StartingFraction = colorG / 255,
    ItemWidth = 3,
    Color = Color.LimeGreen,
    Image = "ShrineMeterBarFill",
    Scale = {ButtonsX = 0.001, ButtonsY = 0.028, ImageX = 0.75, ImageY = 1.25},
    X = itemLocationX,
    Y = itemLocationY,
    SliderOffsetX = 85})
  itemLocationY = itemLocationY + itemSpacingY

  local moddedWarningColorBlueSlider = ErumiUILib.Slider.CreateNew(screen,
    { Name = "ModdedWarningColorBlueSlider",
    Group = "Combat_Menu",
    ShowSlider = true,
    ItemAmount = 100,
    StartingFraction = colorB / 255,
    ItemWidth = 3,
    Color = { 50, 50, 255, 255 },
    Image = "ShrineMeterBarFill",
    Scale = {ButtonsX = 0.001, ButtonsY = 0.028, ImageX = 0.75, ImageY = 1.25},
    X = itemLocationX,
    Y = itemLocationY,
    SliderOffsetX = 85})
  itemLocationY = itemLocationY + itemSpacingY
  ErumiUILib.Slider.CreateListener(moddedWarningColorRedSlider, {
  	AlwaysUpdate = true,
  	sliderEvent = function(sliderProgess, sliderEventArgs, slider)
      colorR = 255 * sliderProgess.percentage
  		SetColor({ Id = screen.Components["ColorPickerPreview"].Id, Color = {colorR, colorG, colorB, 255} })
      ModdedWarning.config.Color = {colorR, colorG, colorB, 255}
      ModdedWarning.showModdedWarning()
  	end,
  	sliderEventArgs = {}})
  ErumiUILib.Slider.CreateListener(moddedWarningColorGreenSlider, {
  	AlwaysUpdate = true,
  	sliderEvent = function(sliderProgess, sliderEventArgs, slider)
      colorG = 255 * sliderProgess.percentage
  		SetColor({ Id = screen.Components["ColorPickerPreview"].Id, Color = {colorR, colorG, colorB, 255} })
      ModdedWarning.config.Color = {colorR, colorG, colorB, 255}
      ModdedWarning.showModdedWarning()
  	end,
  	sliderEventArgs = {}})
  ErumiUILib.Slider.CreateListener(moddedWarningColorBlueSlider, {
  	AlwaysUpdate = true,
  	sliderEvent = function(sliderProgess, sliderEventArgs, slider)
      colorB = 255 * sliderProgess.percentage
  		SetColor({ Id = screen.Components["ColorPickerPreview"].Id, Color = {colorR, colorG, colorB, 255} })
      ModdedWarning.config.Color = {colorR, colorG, colorB, 255}
      ModdedWarning.showModdedWarning()
  	end,
  	sliderEventArgs = {}})
end

ModUtil.LoadOnce(function()
  ModConfigMenu.RegisterMenuOverride({ModName = "Personalization"}, HSMConfigMenu.CreatePersonalizationMenu)
end)
