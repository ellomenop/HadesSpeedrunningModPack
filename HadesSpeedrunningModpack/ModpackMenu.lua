ModpackMenu.config = {
    Default = {
        Scale = 1,
        Group = "Combat_Menu",
        Color = Color.BoonPatchCommon,
        FontSize = 16,
        OffsetX = 0,
        OffsetY = 0,
        Font = "AlegrayaSansSCRegular",
        ShadowBlur = 0,
        ShadowColor = { 0, 0, 0, 1 },
        ShadowOffset = { 0,  2 },
        Justification = "Left",
        ItemSpacingX = 500,
        ItemSpacingY = 65,
    },
}

function ModpackMenu__UpdateCheckBox( screen, button )
    local radioButtonValue = "RadioButton_Unselected"
    if ModUtil.SafeGet(_G, ModUtil.PathToIndexArray(button.Config[button.Option])) then
        radioButtonValue = "RadioButton_Selected"
    end

    SetThingProperty({
        DestinationId = button.Id,
        Property = "Graphic",
        Value = radioButtonValue
    })

    if radioButtonValue == "RadioButton_Unselected" and button.Children ~= nil then
        for _, child in pairs(button.Children) do
            ModpackMenu__ToggleCheckBox(screen, screen.Components[child.Checkbox], false)
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

function ModpackMenu__ToggleCheckBox( screen, button, overrideValue )
    if button.Enabled == false then
        return
    end

    local configPathArray = ModUtil.PathToIndexArray(button.Config[button.Option])
    local configValue = ModUtil.SafeGet(_G, configPathArray)
    if configValue ~= nil then
        if overrideValue ~= nil then
            ModUtil.SafeSet(_G, configPathArray, overrideValue)
        else
            ModUtil.SafeSet(_G, configPathArray, not configValue)
        end
        ModpackMenu__UpdateCheckBox(screen, button)
    end
  end



function ModpackMenu.SetProfile( targetProfile )
    ModpackMenu.ActiveProfile = ModpackMenu.config[targetProfile]
end

function ModpackMenu.Label( settingName, labelText, formatting )
    local config = MergeTables( ModpackMenu.ActiveProfile, formatting or {} )
    screen.Components[settingName .. "Label"] = CreateScreenComponent({
        Name = "BlankObstacle",
        Scale = config.Scale,
        X = itemLocationX,
        Y = itemLocationY,
        Group = config.Group
    })

    CreateTextBox({
        Id = screen.Components[settingName .. "Label"].Id,
        Text = labelText,
        Color = config.Color,
        FontSize = config.FontSize,
        OffsetX = config.OffsetX,
        OffsetY = config.OffsetY,
        Font = config.Font,
        ShadowBlur = config.ShadowBlur,
        ShadowColor = config.ShadowColor,
        ShadowOffset = config.ShadowOffset,
        Justification = config.Justification
    })
end

function ModpackMenu.CheckBox( settingName, modConfigTable, modConfigOptionAsString, formatting )
    local config = MergeTables( ModpackMenu.ActiveProfile, formatting or {} )
    screen.Components[settingName .. "CheckBox"] = CreateScreenComponent({
        Name = "RadioButton",
        Scale = config.Scale,
        X = config.ItemLocationX + config.ItemSpacingX,
        Y = config.ItemLocationY,
        Group = config.Group,
    })

    screen.Components[settingName .. "CheckBox"].Config = modConfigTable
    screen.Components[settingName .. "CheckBox"].Option = modConfigOptionAsString
    screen.Components[settingName .. "CheckBox"].OnPressedFunctionName = "ModpackMenu__ToggleCheckBox"
    ModpackMenu__UpdateCheckBox(screen, screen.Components[settingName .. "CheckBox"])
end

function ModpackMenu.DropDown( settingName, itemLocationX, itemLocationY, config )
    config = MergeTables( ModpackMenu.ActiveProfile, config or {} )
    ErumiUILib.Dropdown.CreateDropdown(
        screen,
        {
            Name = settingName .. "DropDown",
            Group = "SackMinGroup",
            Scale = {
                X = .25,
                Y = .5,
            },
            Padding = {
                X = 0,
                Y = 2,
            },
            X = itemLocationX + config.ItemSpacingX,
            Y = itemLocationY,
            GeneralFontSize = config.FontSize,
            Font = config.Font,
            Items = {
                ["Default"] = {Text = SatyrSackControl.config.MinSack, event = function() end},
                minSack2,
                minSack3,
                minSack4,
                minSack5,
            },
        }
    )
end