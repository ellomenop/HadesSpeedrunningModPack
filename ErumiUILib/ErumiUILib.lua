ModUtil.Mod.Register("ErumiUILib")
ErumiUILib = {
    Slider = {},
    Dropdown = {},
    RadialMenu = {},
    Keyboard = {},
    Textbox = {},
    Misc = {}
}
--[[TODO:
On-screen Keyboard for text fields:
Modifibale size
Able to disable input when opened or not (and then reenable if it disabled it)
Magic's Double Click Lib (will be added very soon)
With OSK an entire lua side debug menu ex: a cheat menu, text-based commands for dialogue???? custom viewing (Very iffy)
Radial Menus (Menu only, overlays later as that could be confusing with input handling)
Slider dragging: Sliding turned on when clicked, follows mouse until mouse clicked again to turn mouse follow off
Creating Sub-menus that dont re-enable input on close, effectively making in menu pop-up systems
]]--
--#region Sliders

SliderFunctionValues = {
    --[[Example item
    [sliderId] = {
        lastIndex = any int,
        ["AlwaysUpdate"] = {
            {
                eventIndex = blah, --Not needed
                FunctionName ="Blah Blah always 1"
                args = {}
            }
            {
                eventIndex = blah, --Not needed
                FunctionName ="Blah Blah always 2 now with args"
                args = {Blah = Blah Blah}
            }
        }
        ["onPass"] = {
            {
                eventIndex = "2",
                FunctionName ="Blah Blah when going past 2"
                args = {}
            }
        }
        ["exactResting"] = {
            {
                eventIndex = "57",
                FunctionName = "Blah Blah at exactly 57"
                args = {}
            }
            {
                eventIndex = "50:60",
                FunctionName = "Blah Blah inbetween 50 and 60"
                args = {Blah = Blah Blah}
            }
        }
    }
    All entries are optional:
        "AlwaysUpdate" option will run the function everytime the slider is updated
        "onPass" option is if the slider would go past it, instead of resting on it
        eventIndex is when slider goes on that value do something
        Not having something in onPass means that the option would have to be specifically selected
        X:Y is if the resting point is greater then or equal to X and less then or equal to Y (cant be put in onPass).
            X must ALWAYS be less then then Y
        Functions are always passed the sliders currentValue and the args of the event, only valid function sytax is:
            function myFunction(currentValue, args)
            currentValue is the buttonIndex, not the percentage
        The variables can be named differently, of course
    ]]--
}

SaveIgnores["SliderFunctionValues"] = true
function ErumiUILib.Slider.CreateNew(screen, args)
  	local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedSlider")

    for buttonIndex = 1, (args.ItemAmount or 1) do
		components[Name .. "Button" .. buttonIndex] = CreateScreenComponent({ Name = "BoonSlot1", Group = args.Group, Scale = 6, X = xPos, Y = yPos })
        components[Name .. "Button" .. buttonIndex].OnPressedFunctionName = "ErumiUILibUpdateSliderPercentage"
        local a = ((buttonIndex - 0.5) / (args.ItemAmount or 1))
        local c = ((args.ItemWidth or 1) / 2)
        local d = ((args.ItemWidth or 1) * (args.ItemAmount or 1))
        components[Name .. "Button" .. buttonIndex].pressedArgs = {sliderPercent = a + ( c / d), name = Name, buttonIndex = buttonIndex, Image = args.Image}

        SetScaleX({ Id = components[Name .. "Button" .. buttonIndex].Id , Fraction = (args.Scale.ButtonsX or 1) * 1.2 })
    		SetScaleY({ Id = components[Name .. "Button" .. buttonIndex].Id , Fraction = (args.Scale.ButtonsY or 1) * 0.8 })
        xPos = xPos + args.ItemWidth
    end
    if args.ShowSlider then
        components[Name .. "SliderImage"] = CreateScreenComponent({ Name = args.Image, Group = args.Group, Scale = 1, X = (args.X or 0) + 65 + (args.SliderOffsetX or 0), Y = (args.Y or 0) })
        --SetAnimation({ Name = "KeepsakeBarFill", DestinationId = components[Name .. "SliderImage"].Id, Scale = 1 })
        SetAnimationFrameTarget({ Name = args.Image, Fraction = args.StartingFraction or 1, DestinationId = components[Name .. "SliderImage"].Id, Instant = true})
        SetScaleX({ Id = components[Name .. "SliderImage"].Id , Fraction = (args.Scale.ImageX or 1)  })
        SetScaleY({ Id = components[Name .. "SliderImage"].Id , Fraction = (args.Scale.ImageY or 1) })
        if args.Color then
          SetColor({ Id = components[Name .. "SliderImage"].Id , Color = args.Color })
        end
        SliderFunctionValues[components[Name .. "SliderImage"].Id] = {lastIndex = args.StartingFraction * args.ItemAmount}
        return components[Name .. "SliderImage"]
    end
    return -1
end

function ErumiUILibUpdateSliderPercentage(screen, button)
    local components = screen.Components
    SetAnimationFrameTarget({ Name = button.pressedArgs.Image, Fraction = button.pressedArgs.sliderPercent, DestinationId = components[button.pressedArgs.name .. "SliderImage"].Id, Instant = true})
    local sliderId = components[button.pressedArgs.name .. "SliderImage"].Id
    if SliderFunctionValues[sliderId]["AlwaysUpdate"] ~= nil then
        for k,v in ipairs(SliderFunctionValues[sliderId]["AlwaysUpdate"]) do
            thread(v.Function,{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args, v.Slider)
        end
    end
    if SliderFunctionValues[sliderId]["onPass"] ~= nil then
        local lastIndex = SliderFunctionValues[sliderId].lastIndex
        for k,v in ipairs(SliderFunctionValues[sliderId]["onPass"]) do
            if lastIndex > button.pressedArgs.buttonIndex then
                if tonumber(v.eventIndex) >= button.pressedArgs.buttonIndex and tonumber(v.eventIndex) <= lastIndex then
                    thread(v.Function,{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args, v.Slider)
                end
            elseif lastIndex < button.pressedArgs.buttonIndex then
                if tonumber(v.eventIndex) <= button.pressedArgs.buttonIndex and tonumber(v.eventIndex) >= lastIndex then
                    thread(v.Function,{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args, v.Slider)
                end
            end
        end
    end
    if SliderFunctionValues[sliderId]["exactResting"] ~= nil then
        for k,v in ipairs(SliderFunctionValues[sliderId]["exactResting"]) do
            if string.find(v.eventIndex, ":") then
                local splitStr = ErumiUILib.mysplit(v.eventIndex, ":")
                if button.pressedArgs.buttonIndex > tonumber(splitStr[1]) and button.pressedArgs.buttonIndex < tonumber(splitStr[2]) then
                    thread(v.Function,{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args, v.Slider)
                end
            elseif button.pressedArgs.buttonIndex == tonumber(v.eventIndex) then
                thread(v.Function,{index = button.pressedArgs.buttonIndex, percentage =  button.pressedArgs.sliderPercent}, v.args, v.Slider)
            end
        end
    end
    SliderFunctionValues[sliderId].lastIndex = button.pressedArgs.buttonIndex

end

--[[Args should be
{
    AlwaysUpdate = true/false (default f)
    onPass = true/false (If both onPass and AlwaysUpdate are true, AlwaysUpdate will take priority) (default f)
    eventIndex = any string (this is when the event should occur) (default -1)
    sliderEvent = any string (the Function Name) (if nil this func will not do anything and imemdiatly stop )
    sliderEventArgs = any table (default empty Table)
}
]]
function ErumiUILib.Slider.CreateListener(slider, args)
    if args.sliderEvent == nil then
        return
    end
    local sliderId = slider.Id
    local isAlways = args.AlwaysUpdate
    local isOnPass = args.onPass
    local eventIndex = args.eventIndex
    local sliderEvent = args.sliderEvent
    local sliderEventArgs = args.sliderEventArgs
    local eventTable = {
        eventIndex = eventIndex,
        Function = sliderEvent,
        args = sliderEventArgs,
        slider = slider
    }

    if isAlways then
        if SliderFunctionValues[sliderId]["AlwaysUpdate"] == nil then
            SliderFunctionValues[sliderId]["AlwaysUpdate"] = {}
        end
        table.insert(SliderFunctionValues[sliderId]["AlwaysUpdate"], eventTable)
    elseif isOnPass then
        if SliderFunctionValues[sliderId]["onPass"] == nil then
            SliderFunctionValues[sliderId]["onPass"] = {}
        end
        table.insert(SliderFunctionValues[sliderId]["onPass"], eventTable)
    else
        if SliderFunctionValues[sliderId]["exactResting"] == nil then
            SliderFunctionValues[sliderId]["exactResting"] = {}
        end
        table.insert(SliderFunctionValues[sliderId]["exactResting"], eventTable)
        --SliderFunctionValues[sliderId][eventIndex] = eventTable
    end
end

function ErumiUILib.Slider.mysplit (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end
--#endregion

--#region Dropdowns
function ErumiUILib.Dropdown.CreateDropdown(screen, args)
  	local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedDropdown")
    --Create base default text and backingKey
    local dropDownTopBackingKey = Name .. "BaseBacking"
    components[dropDownTopBackingKey] = CreateScreenComponent({ Name = "MarketSlot", Group = args.Group, Scale = 1, X = xPos, Y = yPos })

    SetScaleY({ Id = components[dropDownTopBackingKey].Id , Fraction = args.Scale.Y or 1 })
    SetScaleX({ Id = components[dropDownTopBackingKey].Id , Fraction = args.Scale.X or 1 })

    components[dropDownTopBackingKey].OnPressedFunctionName = "ErumiUILibToggleDropdown"
    components[dropDownTopBackingKey].dropDownPressedArgs = args
    components[dropDownTopBackingKey].isExpanded = false
    components[dropDownTopBackingKey].isEnabled = true
    components[dropDownTopBackingKey].setEnabled = function( isEnabled )
      components[dropDownTopBackingKey].isEnabled = isEnabled
      if isEnabled then
        ModifyTextBox({ Id = components[args.Name .. "BaseTextbox"].Id, Color = {1, 1, 1, 1}})
      else
        ModifyTextBox({ Id = components[args.Name .. "BaseTextbox"].Id, Color = {1, 1, 1, .2}})
      end
    end
    components[dropDownTopBackingKey].currentItem = args.Items.Default
    components[dropDownTopBackingKey].screen = screen

    ErumiUILib.Dropdown.UpdateBaseText(screen, components[dropDownTopBackingKey])

    if args.Items.Default.event ~= nil then
        args.Items.Default.event(components[dropDownTopBackingKey])
    end
    return components[dropDownTopBackingKey]
end

function ErumiUILibToggleDropdown(screen, button)
    if not button.isEnabled then
      return
    end
    button.isExpanded = not button.isExpanded
    if button.isExpanded then
        ErumiUILib.Dropdown.Expand(screen, button)
    else
        ErumiUILib.Dropdown.Collapse(screen, button)
    end
end
function ErumiUILib.Dropdown.Expand(screen, button)
    local args = button.dropDownPressedArgs
    local components = screen.Components
    ModifyTextBox({Id = components[args.Name .. "BaseTextbox"].Id, Color = {1, 1, 1, 0.2}})
    for k,v in pairs(args.Items) do
        if k ~= "Default" then
            local dropDownItemBackingKey = args.Name .. "DropdownBacking" .. k
            local ySpaceAmount = 102* k * args.Scale.Y + (args.Padding.Y * k)
            components[dropDownItemBackingKey] = CreateScreenComponent({ Name = "MarketSlot", Group = args.Group .. "Dropdown", Scale = 1, X = (args.X or 0), Y = (args.Y or 0) + ySpaceAmount})
            components[dropDownItemBackingKey].dropDownPressedArgs = {Args = args, parent = button, Index = k}
            components[dropDownItemBackingKey].OnPressedFunctionName = "ErumiUILibDropdownButtonPressed"

            SetScaleY({ Id = components[dropDownItemBackingKey].Id , Fraction = args.Scale.Y or 1 })
            SetScaleX({ Id = components[dropDownItemBackingKey].Id , Fraction = args.Scale.X or 1 })
            local offsetX = (args.GeneralOffset or {X = 0}).X
            if v.Offset ~= nil then
                offsetX = v.Offset.X
            end
            local offsetY = (args.GeneralOffset or {Y = 0}).Y
            if v.Offset ~= nil then
                offsetY = v.Offset.Y
            end
            local textColor = Color.White
            if v.IsEnabled == false then
                --SetAlpha({ Id = components[dropDownItemBackingKey].Id, Fraction = 0.2, Duration = 0 })
                components[dropDownItemBackingKey].OnPressedFunctionName = nil
                textColor = {1, 1, 1, 0.2}
            end
            CreateTextBox({ Id = components[dropDownItemBackingKey].Id, Text = v.Text,
            FontSize = v.FontSize or args.GeneralFontSize,
            OffsetX = offsetX, OffsetY = offsetY,
            Width = 665,
            Justification = (v.Justification or args.Justification) or "Center",
            VerticalJustification = (v.VerticalJustification or args.VerticalJustification) or "Center",
            LineSpacingBottom = 8,
            Font = (v.Font or args.Font) or "AlegreyaSansSCBold",
            Color = textColor,
            ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
            TextSymbolScale = 0.8,
        })
        end
    end
end
function ErumiUILibDropdownButtonPressed(screen, button)
    local args = button.dropDownPressedArgs.Args
    local components = screen.Components
    local itemToSwapTo = args.Items[button.dropDownPressedArgs.Index]
    local parentButton = button.dropDownPressedArgs.parent

    parentButton.isExpanded = not parentButton.isExpanded
    parentButton.currentItem = itemToSwapTo

    ErumiUILib.Dropdown.UpdateBaseText(screen, parentButton)
    ErumiUILib.Dropdown.Collapse(screen, parentButton)

    if itemToSwapTo.event ~= nil then
        itemToSwapTo.event(parentButton, itemToSwapTo)
    elseif args.GeneralEvent ~= nil then
        args.GeneralEvent(parentButton, itemToSwapTo)
    end
end
function ErumiUILib.Dropdown.Collapse(screen, button)
    local components = screen.Components
    for k,v in pairs(components) do
        if string.find(k, button.dropDownPressedArgs.Name .. "DropdownBacking") then
            Destroy({Id = v.Id})
        end
    end
    ModifyTextBox({ Id = components[button.dropDownPressedArgs.Name .. "BaseTextbox"].Id, Color = {1, 1, 1, 1}})
end
function ErumiUILib.Dropdown.UpdateBaseText(screen, dropdown)
    local args = dropdown.dropDownPressedArgs
    local components = screen.Components
    local itemToSwapTo = dropdown.currentItem

    local offsetX = (args.GeneralOffset or {X = 0}).X
    if itemToSwapTo.Offset ~= nil then
        offsetX = itemToSwapTo.Offset.X
    end
    local offsetY = (args.GeneralOffset or {Y = 0}).Y
    if itemToSwapTo.Offset ~= nil then
        offsetY = itemToSwapTo.Offset.Y
    end

    local textboxContainerName = args.Name .. "BaseTextbox"
    local textboxContainer = components[textboxContainerName]
    if textboxContainer == nil then
      textboxContainer = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = args.X or 0, Y = args.Y or 0})
      SetScaleY({ Id = textboxContainer.Id , Fraction = args.Scale.Y or 1 })
      SetScaleX({ Id = textboxContainer.Id , Fraction = args.Scale.X or 1 })
      CreateTextBox({ Id = textboxContainer.Id, Text = itemToSwapTo.Text,
          FontSize = itemToSwapTo.FontSize or args.GeneralFontSize,
          OffsetX = offsetX, OffsetY = offsetY,
          Width = 665,
          Justification = (itemToSwapTo.Justification or args.Justification) or "Center",
          VerticalJustification = (itemToSwapTo.VerticalJustification or args.VerticalJustification) or "Center",
          LineSpacingBottom = 8,
          Font = (itemToSwapTo.Font or args.Font) or "AlegreyaSansSCBold",
          ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
          TextSymbolScale = 0.8,
      })
    else
      ModifyTextBox({ Id = textboxContainer.Id, Text = itemToSwapTo.Text, Color = {1, 1, 1, 1}})
    end
    components[textboxContainerName] = textboxContainer
end
function ErumiUILib.Dropdown.GetValue(dropdown)
    return dropdown.currentItem
end
function ErumiUILib.Dropdown.SetValue(dropdown, value)
    local itemToSet = nil
    local items = dropdown.dropDownPressedArgs.Items
    if type(value) == "number" then
        if value ~= -1 then
            itemToSet = items[value]
        else
            itemToSet = items.Default
        end
    elseif type(value) == "string" then
        for k,v in pairs(items) do
            if v.Text == value then
                itemToSet = v
                break
            end
        end
    end
    if itemToSet ~= nil then
        dropdown.currentItem = itemToSet
        ErumiUILib.Dropdown.UpdateBaseText(dropdown.screen, dropdown)
    end
end
function ErumiUILib.Dropdown.GetEntries(dropdown)
    local returnItems = {}
    for k,v in pairs(dropdown.dropDownPressedArgs.Items)do
        if v.IsEnabled == true or v.IsEnabled == nil then
            table.insert(returnItems, v)
        end
    end
    return returnItems
end
function ErumiUILib.Dropdown.NewEntry(dropdown, value)
    table.insert(dropdown.dropDownPressedArgs.Items, value)
    local screen = dropdown.screen
    if dropdown.isExpanded then
        ErumiUILib.Dropdown.Collapse(screen, dropdown)
        ErumiUILib.Dropdown.Expand(screen, dropdown)
    end
end
function ErumiUILib.Dropdown.DelEntry(dropdown, value)
    local itemToRemove = nil
    local itemToRemoveIndex = nil
    local items = dropdown.dropDownPressedArgs.Items
    if type(value) == "number" then
        if value > 0 then
            itemToRemove = items[value]
            itemToRemoveIndex = value
        end
    elseif type(value) == "string" then
        for k,v in pairs(items) do
            if v.Text == value then
                itemToRemove = v
                itemToRemoveIndex = k
                break
            end
        end
    end
    if itemToRemove ~= nil and itemToRemove ~= dropdown.currentItem then
        table.remove(dropdown.dropDownPressedArgs.Items, itemToRemoveIndex)
        local screen = dropdown.screen
        if dropdown.isExpanded then
            ErumiUILib.Dropdown.Collapse(screen, dropdown)
            ErumiUILib.Dropdown.Expand(screen, dropdown)
        end
    end
end
function ErumiUILib.Dropdown.DisableEntry(dropdown, value)
    local itemToDisable = nil
    local itemToDisableIndex = nil
    local items = dropdown.dropDownPressedArgs.Items
    if type(value) == "number" then
        if value > 0 then
            itemToDisable = items[value]
            itemToDisableIndex = value
        end
    elseif type(value) == "string" then
        for k,v in pairs(items) do
            if v.Text == value then
                itemToDisable = v
                itemToDisableIndex = k
                break
            end
        end
    end
    if itemToDisable ~= nil and itemToDisable ~= dropdown.currentItem then
        items[itemToDisableIndex].IsEnabled = false
        local screen = dropdown.screen
        if dropdown.isExpanded then
            ErumiUILib.Dropdown.Collapse(screen, dropdown)
            ErumiUILib.Dropdown.Expand(screen, dropdown)
        end
    end
end
function ErumiUILib.Dropdown.EnableEntry(dropdown, value)
    local itemToDisable = nil
    local itemToDisableIndex = nil
    local items = dropdown.dropDownPressedArgs.Items
    if type(value) == "number" then
        if value > 0 then
            itemToDisable = items[value]
            itemToDisableIndex = value
        end
    elseif type(value) == "string" then
        for k,v in pairs(items) do
            if v.Text == value then
                itemToDisable = v
                itemToDisableIndex = k
                break
            end
        end
    end
    if itemToDisable ~= nil and itemToDisable ~= dropdown.currentItem then
        items[itemToDisableIndex].IsEnabled = true
        local screen = dropdown.screen
        if dropdown.isExpanded then
            ErumiUILib.Dropdown.Collapse(screen, dropdown)
            ErumiUILib.Dropdown.Expand(screen, dropdown)
        end
    end
end
--#endregion

--#region Radial Menus

function ErumiUILib.RadialMenu.CreateMenu(screen, args)
	local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedRadialMenu")
    components[Name .. "RadialCenter"] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = xPos, Y = yPos })
    components[Name .. "RadialCenter"].args = args
    components[Name .. "RadialCenter"].screen = screen
    components[Name .. "RadialCenter"].IsExpanded = false
    return components[Name .. "RadialCenter"]
end
function ErumiUILibRadialMenuClickRadialButton(screen, button)
    if button.RadialMenuPressedArgs.buttonData.Event ~= nil then
        button.RadialMenuPressedArgs.buttonData.Event(button.RadialMenuPressedArgs.parent, button.RadialMenuPressedArgs.buttonData)
    elseif button.RadialMenuPressedArgs.parent.args.GeneralEvent ~= nil then
        button.RadialMenuPressedArgs.parent.args.GeneralEvent(button.RadialMenuPressedArgs.parent, button.RadialMenuPressedArgs.buttonData)
    end
end
function ErumiUILib.RadialMenu.Expand(radialMenu, ignoreTime)
    if radialMenu.IsExpanded == true then
        return
    end
    radialMenu.IsExpanded = true
    local args = radialMenu.args
    local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local Name = (args.Name or "UnnamedRadialMenu")
    local currentAngle = args.StartingAngle
    local angleIncrement = (args.MaxAngle - args.StartingAngle) / #args.Items
    local args = radialMenu.args
    local components = radialMenu.screen.Components
    for k,v in ipairs(args.Items)do
        local a = (currentAngle - 90) * (math.pi / 180)
        local curXPos = xPos + args.Radius * math.cos(a)
        local curYPos = yPos + args.Radius * math.sin(a)
        if ignoreTime then
            components[Name .. "Button" .. k] = CreateScreenComponent({ Name = "ButtonClose", Scale = 0.7, Group = args.Group,  X = curXPos, Y = curYPos})
            components[Name .. "ButtonImageBack" .. k] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = curXPos, Y = curYPos })
            components[Name .. "ButtonImage" .. k] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = curXPos, Y = curYPos })
        else
            components[Name .. "Button" .. k] = CreateScreenComponent({ Name = "ButtonClose", Scale = 0.7, Group = args.Group,  X = xPos, Y = yPos})
            components[Name .. "ButtonImageBack" .. k] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = xPos, Y = yPos })
            components[Name .. "ButtonImage" .. k] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = xPos, Y = yPos })
        end

        components[Name .. "Button" .. k].OnPressedFunctionName = "ErumiUILibRadialMenuClickRadialButton"
        components[Name .. "Button" .. k].RadialMenuPressedArgs = {parent = components[Name .. "RadialCenter"], buttonData = v, Button = components[Name .. "Button" .. k]}
        AttachLua({ Id = components[Name .. "Button" .. k].Id, Table = components[Name .. "Button" .. k] })

        SetAnimation({ Name = "GUI\\Grey_Node", DestinationId = components[Name .. "ButtonImageBack" .. k].Id, Scale = 1 })
        if v.Color ~= nil or args.GeneralColor ~= nil then
            SetColor({ Id = components[Name .. "ButtonImageBack" .. k].Id, Color = v.Color or args.GeneralColor })
        end

        SetAnimation({ Name = v.Image, DestinationId = components[Name .. "ButtonImage" .. k].Id, Scale = 1 })

        SetScaleY({ Id = components[Name .. "Button" .. k].Id , Fraction = args.Scale.Y or 1 })
        SetScaleX({ Id = components[Name .. "Button" .. k].Id , Fraction = args.Scale.X or 1 })

        SetScaleY({ Id = components[Name .. "ButtonImage" .. k].Id , Fraction = v.Scale.Y or 1 })
        SetScaleX({ Id = components[Name .. "ButtonImage" .. k].Id , Fraction = v.Scale.X or 1 })
        if v.IsEnabled == false then
            SetAlpha({ Id = components[Name .. "Button" .. k].Id, Fraction = 0, Duration = 0 })
            SetAlpha({ Id = components[Name .. "ButtonImageBack" .. k].Id, Fraction = 0.2, Duration = 0 })
            SetAlpha({ Id = components[Name .. "ButtonImage" .. k].Id, Fraction = 0.2, Duration = 0 })
            components[Name .. "Button" .. k].OnPressedFunctionName = nil
        end
        if ignoreTime ~= true then
            thread(function ()
                Move({ Ids = { components[Name .. "Button" .. k].Id, components[Name .. "ButtonImageBack" .. k].Id, components[Name .. "ButtonImage" .. k].Id}, OffsetX = curXPos, OffsetY = curYPos, Duration = args.CreationTime })
            end)
        end
        currentAngle = k * angleIncrement
    end
end
OnMouseOver{"ButtonClose", function (triggerArgs)
    testGlobal = triggerArgs
    if triggerArgs.TriggeredByTable ~= nil then
        local pressedArgs = triggerArgs.TriggeredByTable.RadialMenuPressedArgs
        if pressedArgs ~= nil then
            local parentArgs = pressedArgs.parent.args
            local hoveredItemData = pressedArgs.buttonData
            local components = pressedArgs.parent.screen.Components
            local button = pressedArgs.Button
            for k,v in pairs(components) do
                if string.find(k, "CenterTooltipDisplay") or string.find(k, "IndepTooltipDisplay")then
                    Destroy({Id = v.Id})
                end
            end
            if parentArgs.TooltipStyle ~= nil and parentArgs.TooltipStyle.Name == "Independent" and button.IsEnabled ~= true then
                local independentDisplayName = (parentArgs.Name or "UnnamedRadialMenu") .. "IndepTooltipDisplay"
                components[independentDisplayName] = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu", Scale = 1, X = parentArgs.TooltipStyle.args.X or 0, Y = parentArgs.TooltipStyle.args.Y or 0 })
                SetScaleY({ Id = components[independentDisplayName].Id , Fraction = parentArgs.Scale.Y or 1 })
                SetScaleX({ Id = components[independentDisplayName].Id , Fraction = parentArgs.Scale.X or 1  })

                CreateTextBox({
                    Id = components[independentDisplayName].Id,
                    Text = hoveredItemData.Desc,
                    FontSize =  (parentArgs.TextStyle.FontSize or 20),
                    OffsetX =  (parentArgs.TextStyle.OffsetX or 0), OffsetY =  (parentArgs.TextStyle.DescOffsetY or 0),
                    Width = parentArgs.TextStyle.TextWidth or 1,
                    Color = Color.White,
                    Font = "AlegreyaSansSCBold",
                    ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                    Justification = "Left",
                })
                CreateTextBox({ Id = components[independentDisplayName].Id, Text = hoveredItemData.Title,
                    FontSize = (parentArgs.TextStyle.FontSize or 20),
                    OffsetX =  (parentArgs.TextStyle.OffsetX or 0), OffsetY =  (parentArgs.TextStyle.TitleOffsetY or 0),
                    Width = parentArgs.TextStyle.TextWidth or 1,
                    Color = {0.988, 0.792, 0.247, 1},
                    Font = "AlegreyaSansSCBold",
                    ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                    Justification = "Left",
                })
            elseif parentArgs.TooltipStyle ~= nil and parentArgs.TooltipStyle.Name == "Center" and button.IsEnabled ~= true then --Center
                local centerDisplayKey = (parentArgs.Name or "UnnamedRadialMenu") .. "CenterTooltipDisplay"
                components[centerDisplayKey] = CreateScreenComponent({ Name = "MarketSlot", Group = "Combat_Menu", Scale = 1, X = parentArgs.X or 0, Y = parentArgs.Y or 0 })

                SetScaleY({ Id = components[centerDisplayKey].Id , Fraction = parentArgs.Scale.Y or 1 })
                SetScaleX({ Id = components[centerDisplayKey].Id , Fraction = parentArgs.Scale.X or 1  })

                CreateTextBox({
                    Id = components[centerDisplayKey].Id,
                    Text = hoveredItemData.Desc,
                    FontSize =  (parentArgs.TextStyle.FontSize or 20),
                    OffsetX =  (parentArgs.TextStyle.OffsetX or 0), OffsetY =  (parentArgs.TextStyle.DescOffsetY or 0),
                    Width = parentArgs.TextStyle.TextWidth or 1,
                    Color = Color.White,
                    Font = "AlegreyaSansSCBold",
                    ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                    Justification = "Left",
                })
                CreateTextBox({ Id = components[centerDisplayKey].Id, Text = hoveredItemData.Title,
                    FontSize = (parentArgs.TextStyle.FontSize or 20),
                    OffsetX =  (parentArgs.TextStyle.OffsetX or 0), OffsetY =  (parentArgs.TextStyle.TitleOffsetY or 0),
                    Width = parentArgs.TextStyle.TextWidth or 1,
                    Color = {0.988, 0.792, 0.247, 1},
                    Font = "AlegreyaSansSCBold",
                    ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                    Justification = "Left",
                })
            end
        end
    end
end}
function ErumiUILib.RadialMenu.Collapse( radialMenu, ignoreTime)
    radialMenu.IsExpanded = false
    local args = radialMenu.args
    local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local Name = (args.Name or "UnnamedRadialMenu")
    local components = radialMenu.screen.Components
    local waitTime = args.CreationTime
    if ignoreTime then
        waitTime = 0
    end
    for k,v in ipairs(args.Items)do
        if ignoreTime then
            if components[Name .. "Button" .. k] ~= nil then
                Destroy({Ids = { components[Name .. "Button" .. k].Id, components[Name .. "ButtonImageBack" .. k].Id, components[Name .. "ButtonImage" .. k].Id}})
            end
            if components[Name  .. "IndepTooltipDisplay"] ~= nil then
                Destroy({Ids = { components[Name  .. "IndepTooltipDisplay"].Id}})
            end
            if components[Name  .. "CenterTooltipDisplay"] ~= nil then
                Destroy({Ids = { components[Name  .. "CenterTooltipDisplay"].Id}})
            end
        else
            thread(function ()
                if components[Name .. "Button" .. k] ~= nil then
                    if components[Name  .. "IndepTooltipDisplay"] ~= nil then
                        Destroy({Ids = { components[Name  .. "IndepTooltipDisplay"].Id}})
                    end
                    if components[Name  .. "CenterTooltipDisplay"] ~= nil then
                        Destroy({Ids = { components[Name  .. "CenterTooltipDisplay"].Id}})
                    end
                    Move({ Ids = { components[Name .. "Button" .. k].Id, components[Name .. "ButtonImageBack" .. k].Id, components[Name .. "ButtonImage" .. k].Id}, OffsetX = xPos, OffsetY = yPos, Duration = waitTime })
                    wait(waitTime)
                    Destroy({Ids = { components[Name .. "Button" .. k].Id, components[Name .. "ButtonImageBack" .. k].Id, components[Name .. "ButtonImage" .. k].Id}})
                end
            end)
        end
    end
end
--[[
function ErumiUILib.RadialMenu.UpdateTooltipText(screen, RadialMenu)
    local args = RadialMenu.RadialMenuPressedArgs
    local components = screen.Components
    local itemToSwapTo = RadialMenu.currentItem

    local textboxContainerName = args.Name .. "BaseTextbox"
    if components[textboxContainerName] ~= nil then
        Destroy({Id = components[textboxContainerName].Id})
    end
    components[textboxContainerName] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = args.X or 0, Y = args.Y or 0})

    SetScaleY({ Id = components[textboxContainerName].Id , Fraction = args.Scale.Y or 1 })
    SetScaleX({ Id = components[textboxContainerName].Id , Fraction = args.Scale.X or 1 })


    local offsetX = args.GeneralOffset.X
    if itemToSwapTo.Offset ~= nil then
        offsetX = itemToSwapTo.Offset.X
    end
    local offsetY = args.GeneralOffset.Y
    if itemToSwapTo.Offset ~= nil then
        offsetY = itemToSwapTo.Offset.Y
    end


    CreateTextBox({ Id = components[textboxContainerName].Id, Text = itemToSwapTo.Text,
        FontSize = itemToSwapTo.FontSize or args.GeneralFontSize,
        OffsetX = offsetX, OffsetY = offsetY,
        Width = 665,
        Justification = "Left",
        VerticalJustification = "Top",
        LineSpacingBottom = 8,
        Font = "AlegreyaSansSCBold",
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
        TextSymbolScale = 0.8,
    })
end
]]--
function ErumiUILib.RadialMenu.GetEntries(radialMenu)
    local returnItems = {}
    for k,v in pairs(radialMenu.args.Items)do
        if v.IsEnabled ~= false then
            table.insert(returnItems, v)
        end
    end
    return returnItems
end
function ErumiUILib.RadialMenu.NewEntry(radialMenu, value)
    local screen = radialMenu.screen
    table.insert(radialMenu.args.Items, value)
    if radialMenu.IsExpanded then
        ErumiUILib.RadialMenu.Collapse(radialMenu, true)
        ErumiUILib.RadialMenu.Expand(radialMenu, true)
    end
end
function ErumiUILib.RadialMenu.DelEntry(radialMenu, value)
    local itemToRemove = nil
    local itemToRemoveIndex = nil
    local items = radialMenu.args.Items
    if type(value) == "number" then
        if value > 0 then
            itemToRemove = items[value]
            itemToRemoveIndex = value
        end
    elseif type(value) == "string" then
        for k,v in pairs(items) do
            if v.Title == value then
                itemToRemove = v
                itemToRemoveIndex = k
                break
            end
        end
    end
    if itemToRemove ~= nil then
        local shouldExpand = false
        if radialMenu.IsExpanded then
            ErumiUILib.RadialMenu.Collapse(radialMenu, true)
            shouldExpand = true
        end
        table.remove(radialMenu.args.Items, itemToRemoveIndex)
        if shouldExpand then
            ErumiUILib.RadialMenu.Expand(radialMenu, true)
        end
    end
end
function ErumiUILib.RadialMenu.DisableEntry(radialMenu, value)
    local itemToDisable = nil
    local itemToDisableIndex = nil
    local items = radialMenu.args.Items
    if type(value) == "number" then
        if value > 0 then
            itemToDisable = items[value]
            itemToDisableIndex = value
        end
    elseif type(value) == "string" then
        for k,v in pairs(items) do
            if v.Text == value then
                itemToDisable = v
                itemToDisableIndex = k
                break
            end
        end
    end
    if itemToDisable ~= nil then
        items[itemToDisableIndex].IsEnabled = false
        local screen = radialMenu.screen
        if radialMenu.IsExpanded then
            ErumiUILib.RadialMenu.Collapse(radialMenu, true)
            ErumiUILib.RadialMenu.Expand(radialMenu, true)
        end
    end
end
function ErumiUILib.RadialMenu.EnableEntry(radialMenu, value)
    local itemToDisable = nil
    local itemToDisableIndex = nil
    local items = radialMenu.args.Items
    if type(value) == "number" then
        if value > 0 then
            itemToDisable = items[value]
            itemToDisableIndex = value
        end
    elseif type(value) == "string" then
        for k,v in pairs(items) do
            if v.Text == value then
                itemToDisable = v
                itemToDisableIndex = k
                break
            end
        end
    end
    if itemToDisable ~= nil then
        items[itemToDisableIndex].IsEnabled = true
        local screen = radialMenu.screen
        if radialMenu.IsExpanded then
            ErumiUILib.RadialMenu.Collapse(radialMenu, true)
            ErumiUILib.RadialMenu.Expand(radialMenu, true)
        end
    end
end
--#endregion

--#region OSK

ErumiUILib.Keyboard.Layouts = {
    ["Alphanumeric"] = {
        {Text = [[`~1!2 3#4$5%6^7&8*9(0)-_=+<-]], Offset = -25},
        {Text = [[qQwWeErRtTyYuUiIoOpP| ]], Offset = -17},
        {Text = [[aAsSdDfFgGhHjJkKlL;:'"<|]], Offset = -20},
        {Text = [[||zZxXcCvVbBnNmM,<.>/?]], Offset = -17},
        {Text = [[  |\<<>>]], Offset = 100},
    },
    ["Calculator"] = {
        {Text = [[7 8 9 / ]], Offset = 100},
        {Text = [[4 5 6 X ]], Offset = 100},
        {Text = [[1 2 3 - ]], Offset = 100},
        {Text = [[0 + = <||/]], Offset = 70 },
    },
    ["Numeric"] = {
        {Text = [[7 8 9 ]], Offset = 150},
        {Text = [[4 5 6 ]], Offset = 150},
        {Text = [[1 2 3 ]], Offset = 150},
        {Text = [[0 . <||/]], Offset = 100 },
    },
    ["Alphabetic"] = {
        {Text = [[qQwWeErRtTyYuUiIoOpP| <-]], Offset = -20},
        {Text = [[aAsSdDfFgGhHjJkKlL;:'"<|]], Offset = -20},
        {Text = [[||zZxXcCvVbBnNmM,<.>/?]], Offset = -17},
        {Text = [[  |/<<>>]], Offset = 100},
    },
}

function ErumiUILib.Keyboard.RegisterLayout(name, layout)
  ErumiUILib.Keyboard.Layouts[name] = layout
end

function ErumiUILib.Keyboard.CreateKeyboard(screen, args)
	local xPos = (args.X.Start or 0)
    local yPos = (args.Y.Start or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedKeyboard")

    components[Name .. "KeyboardBase"] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = xPos, Y = yPos})
    components[Name .. "KeyboardBase"].args = args
    components[Name .. "KeyboardBase"].screen = screen

    --[[for buttonIndex = 1, (args.ItemAmount or 1) do
		components[Name .. "Button" .. buttonIndex] = CreateScreenComponent({ Name = "LevelUpPlus", Group = args.Group, Scale = 6, X = xPos, Y = yPos })
        components[Name .. "Button" .. buttonIndex].OnPressedFunctionName = "ErumiUILibUpdateSliderPercentage"
        local a = ((buttonIndex - 0.5) / (args.ItemAmount or 1))
        local c = ((args.ItemWidth or 1) / 2)
        local d = ((args.ItemWidth or 1) * (args.ItemAmount or 1))
        components[Name .. "Button" .. buttonIndex].pressedArgs = {sliderPercent = a + ( c / d), name = Name, buttonIndex = buttonIndex, Image = args.Image}

        SetScaleX({ Id = components[Name .. "Button" .. buttonIndex].Id , Fraction = (args.Scale.ButtonsX or 1) * 1.2 })
		SetScaleY({ Id = components[Name .. "Button" .. buttonIndex].Id , Fraction = (args.Scale.ButtonsY or 1) * 0.8 })
        xPos = xPos + args.ItemWidth
    end
    if args.ShowSlider then
        components[Name .. "SliderImage"] = CreateScreenComponent({ Name = args.Image, Group = args.Group, Scale = 1, X = (args.X or 0) + 65 + (args.SliderOffsetX or 0), Y = (args.Y or 0) })
        --SetAnimation({ Name = "KeepsakeBarFill", DestinationId = components[Name .. "SliderImage"].Id, Scale = 1 })
        SetAnimationFrameTarget({ Name = args.Image, Fraction = args.StartingFraction or 1, DestinationId = components[Name .. "SliderImage"].Id, Instant = true})
        SetScaleX({ Id = components[Name .. "SliderImage"].Id , Fraction = (args.Scale.ImageX or 1)  })
        SetScaleY({ Id = components[Name .. "SliderImage"].Id , Fraction = (args.Scale.ImageY or 1) })
        SliderFunctionValues[components[Name .. "SliderImage"].Id] = {lastIndex = args.StartingFraction * args.ItemAmount}
        return components[Name .. "SliderImage"]
    end]]--
    return components[Name .. "KeyboardBase"]
end
function ErumiUILib.Keyboard.Expand(keyboard, instant, skipCallback)
    if keyboard.IsExpanded then
        return
    end
    keyboard.IsExpanded = true
    local args = keyboard.args
    local screen = keyboard.screen
    local startXPos = (args.X.Start or 0)
    local startYPos = (args.Y.Start or 0)
    local endXPos = (args.X.End or 0)
    local endYPos = (args.Y.End or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedKeyboard")

    --Create Background
    components[Name .. "KeyboardBackground"] = CreateScreenComponent({ Name = "rectangle01", Group = args.Group, Scale = 4, X = startXPos, Y = startYPos })
    Attach({ Id = components[Name .. "KeyboardBackground"].Id, DestinationId = keyboard.Id, OffsetX = 0, OffsetY = 0})

    SetScaleX({ Id = components[Name .. "KeyboardBackground"].Id , Fraction = (args.BackgroundScale.X or 1)  })
    SetScaleY({ Id = components[Name .. "KeyboardBackground"].Id , Fraction = (args.BackgroundScale.Y or 1)  })
  	SetColor({ Id = components[Name .. "KeyboardBackground"].Id, Color = args.Colors.Background or {0,0,0,1} })

    local currentXPos = args.Width.Start
    local currentYPos = args.Height.Start
    local creationTime = args.CreationTime or 0.3
    if instant then
      creationTime = 0
    end
    Move({ Ids = {  keyboard.Id}, OffsetX = endXPos, OffsetY = endYPos, Duration = creationTime })
    wait(creationTime)

    local lines
    if args.Layout.Style ~= nil and args.Layout.Style ~= "Custom" then
        lines = ErumiUILib.Keyboard.Layouts[args.Layout.Style]
    elseif args.Layout.Style == "Custom" then
        lines = args.Layout.Pattern
    end
    local xScalar = (args.Width.End - args.Width.Start) / 170
    local yScalar = (args.Height.End - args.Height.Start) / 34
    local buttonScaleY =  yScalar / #lines
    for _, v in ipairs(lines) do
        local lineScaleX = xScalar / (#v.Text / 2)
        currentXPos = currentXPos + v.Offset
        for i = 1, #v.Text, 2 do
            local lower = v.Text:sub(i,i)
            local upper = v.Text:sub(i+1,i+1)
            local buttonName = Name .. "KeyboardButton(" .. lower .."," .. upper .. ")"
            components[buttonName] = CreateScreenComponent({ Name = "MarketSlot", Group = args.Group, Scale = 0.5, X = currentXPos, Y = currentYPos })
            SetScaleX({ Id = components[buttonName].Id , Fraction = 0.4 * lineScaleX })
            SetScaleY({ Id = components[buttonName].Id , Fraction = 2  * buttonScaleY  })

            components[buttonName].OnPressedFunctionName = "ErumiUILibKeyboardClickKey"
            components[buttonName].Args = {args = args, Keys = {Lower = lower, Upper = upper}, keyboard = keyboard}

            local curText = lower
            local curColor = args.Colors.Text
            if (lower == "<" and upper == "<") or (lower == ">" and upper == ">") then
                local imageName = Name .. "KeyboardImage(" .. lower .."," .. upper .. ")"
                local imagePath = "GUI\\Arrow_Right"
                if (lower ~= ">" and upper ~= ">") then
                    imagePath = "GUI\\Arrow_Left"
                end
                components[imageName] = CreateScreenComponent({ Name = "BlankObstacle", Group = args.Group, Scale = 1, X = currentXPos, Y = currentYPos })
                SetScaleX({ Id = components[imageName].Id , Fraction = 0.4 * lineScaleX })
                SetScaleY({ Id = components[imageName].Id , Fraction = 2  * buttonScaleY  })
                SetAnimation({ Name =imagePath, DestinationId = components[imageName].Id, Scale = 1 })
            else
                if keyboard.IsUpper and upper ~= " " then
                    curText = upper
                end
                if lower == " " and upper == " " then
                    curText = " Space "
                end
                if lower == "<" and upper == "-" then
                    curText = "Back"
                end
                if lower == "<" and upper == "|" then
                    curText = " Enter "
                end
                if lower == "|" and upper == "|" then
                    curText = "Shift"
                    if keyboard.IsUpper then
                        curColor = args.Colors.ShiftPressed
                    end
                end
                if lower == "|" and upper == "/" then
                    curText = "Close"
                end
                if lower == "|" and upper == [[\]] then
                    curText = "Clear"
                end
                CreateTextBox({ Id = components[buttonName].Id, Text = curText,
                    FontSize = 30,
                    OffsetX = 0, OffsetY = -20,
                    Width = 1920,
                    Justification = "Center",
                    VerticalJustification = "Top",
                    LineSpacingBottom = 8,
                    Font = "AlegreyaSansSCBold",
                    Color = curColor,
                    ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                    TextSymbolScale = 0.8,
                })
            end
            currentXPos = currentXPos + (180 * lineScaleX)
        end
        currentYPos = currentYPos + 100 * buttonScaleY
        currentXPos = args.Width.Start
        if not instant then
            wait(0.02)
        end
    end
    if args.ExpandCallback ~= nil and not skipCallback then
      args.ExpandCallback(keyboard)
    end
end
function ErumiUILibKeyboardClickKey(screen, button)
    local args = button.Args
    local keyboardArgs = args.args
    local lower = args.Keys.Lower
    local upper = args.Keys.Upper
    local keyboard = args.keyboard
    local curText = lower
    if keyboard.IsUpper and upper ~= " " then
        curText = upper
    end
    if lower == "<" and upper == "-" then
        keyboardArgs.SpecialKeys.Back(keyboard)
        return
    end
    if lower == "<" and upper == "|" then
        --Enter
        keyboardArgs.SpecialKeys.Enter(keyboard)
        return
    end
    if lower == "|" and upper == "|" then
        --Shift
        keyboardArgs.SpecialKeys.Shift(keyboard)
        return
    end
    if lower == "|" and upper == "/" then
        --Close
        keyboardArgs.SpecialKeys.Close(keyboard)
        return
    end
    if lower == "|" and upper == [[\]] then
        --Close
        keyboardArgs.SpecialKeys.Clear(keyboard)
        return
    end
    if lower == "<" and upper == "<" then
        --Left
        keyboardArgs.SpecialKeys.Left(keyboard)
        return
    end
    if lower == ">" and upper == ">" then
        --Right
        keyboardArgs.SpecialKeys.Right(keyboard)
        return
    end
    keyboardArgs.KeyPressedFunction(keyboard, curText)
end
function ErumiUILib.Keyboard.Collapse(keyboard, instant, skipCallback)
    if keyboard.IsExpanded == false then
        return
    end
    keyboard.IsExpanded = false
    local args = keyboard.args
    local screen = keyboard.screen
    -- Reversed as we are now doing the opposite tween
    local startXPos = (args.X.End or 0)
    local startYPos = (args.Y.End or 0)
    local endXPos = (args.X.Start or 0)
    local endYPos = (args.Y.Start or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedKeyboard")

    local lines
    if args.Layout.Style ~= nil and args.Layout.Style ~= "Custom" then
        lines = ErumiUILib.Keyboard.Layouts[args.Layout.Style]
    elseif args.Layout.Style == "Custom" then
        lines = args.Layout.Pattern
    end
    for i = #lines, 1, -1 do
        local line = lines[i]
        for j = #line.Text, 1, -2 do
            local lower = line.Text:sub(j-1,j-1)
            local upper = line.Text:sub(j,j)
            local buttonName = Name .. "KeyboardButton(" .. lower .."," .. upper .. ")"
            Destroy({Id = components[buttonName].Id})
            if (lower == "<" and upper == "<") or (lower == ">" and upper == ">") then
                local imageName = Name .. "KeyboardImage(" .. lower .."," .. upper .. ")"
                Destroy({Id = components[imageName].Id})
            end
        end

        if not instant then
            wait(0.02)
        end
    end

    local creationTime = args.CreationTime or 0.3
    if instant then
      creationTime = 0
    end
    Move({ Ids = { keyboard.Id }, OffsetX = endXPos, OffsetY = endYPos, Duration = creationTime })
    wait(creationTime)
    Destroy({Id = components[Name .. "KeyboardBackground"].Id})

    if args.CollapseCallback ~= nil and not skipCallback then
      args.CollapseCallback(keyboard)
    end
end

function ErumiUILib.Keyboard.Refresh(keyboard)
    ErumiUILib.Keyboard.Collapse(keyboard, true, true)
    ErumiUILib.Keyboard.Expand(keyboard, true, true)
end
--#endregion

--#region TextBoxes
function ErumiUILib.Textbox.CreateTextbox(screen, args)
  	local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local components = screen.Components
    local Name = (args.Name or "UnnamedTextBox")

    --Create base default text and backingKey
    local textBoxButtonKey = Name .. "Button"
    components[textBoxButtonKey] = CreateScreenComponent({ Name = "MarketSlot", Group = args.Group, Scale = 1, X = xPos, Y = yPos })
    SetScaleY({ Id = components[textBoxButtonKey].Id , Fraction = 2.75 * (args.Scale.Y or 1)})
    SetScaleX({ Id = components[textBoxButtonKey].Id , Fraction = 0.55 * (args.Scale.X or 1)})
    components[textBoxButtonKey].OnPressedFunctionName = "ErumiUILibTextFieldButtonPressed"
    components[textBoxButtonKey].args = args
    components[textBoxButtonKey].screen = screen
    components[textBoxButtonKey].textboxName = Name .. "Backing"

    local textBoxBackingKey = Name .. "Backing"
    components[textBoxBackingKey] = CreateScreenComponent({ Name = "rectangle01", Group = args.Group, Scale = 1, X = xPos, Y = yPos })
    components[textBoxBackingKey].args = args
    components[textBoxBackingKey].screen = screen
    components[textBoxBackingKey].currentText = args.StartingText or ""
    -- Add a space at the start to allow us to clear the text with ModifyText (empty string will not upadte the textbox)
    components[textBoxBackingKey].currentText = " " .. components[textBoxBackingKey].currentText
    components[textBoxBackingKey].cursorPosition = #args.StartingText + 1 or 0
    components[textBoxBackingKey].maxLength = args.MaxLength or 999999 -- big number in place of infinity / disabling the limit :shrug:
    components[textBoxBackingKey].showCursor = args.ShowCursor or false

    SetScaleY({ Id = components[textBoxBackingKey].Id , Fraction = args.Scale.Y or 1 })
    SetScaleX({ Id = components[textBoxBackingKey].Id , Fraction = args.Scale.X or 1 })
  	SetColor({ Id = components[textBoxBackingKey].Id, Color = args.BackgroundColor or {0,0,0,1} })

    local textBoxCursorHolder = Name .. "CursorHolder"
        components[textBoxCursorHolder] = CreateScreenComponent({ Name = "BlankObstacle", X = xPos, Y = yPos, Group = args.Group .. "Cursor" })
        CreateTextBox({ Id = components[textBoxCursorHolder].Id, Text = "",
        FontSize = args.TextStyle.FontSize or 20,
        OffsetX = args.TextStyle.Offset.X or 0, OffsetY = args.TextStyle.Offset.Y or 0,
        Width = args.TextStyle.Width or 780,
        Justification = args.TextStyle.Justification,
        VerticalJustification = "Top",
        LineSpacingBottom = 8,
        Font = "MonospaceTypewriterBold",
        Color = args.CursorColor,
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
        TextSymbolScale = 0.8,})

    local textBoxTextBackingKey = Name .. "TextHolder"
    components[textBoxTextBackingKey] = CreateScreenComponent({ Name = "BlankObstacle", X = xPos, Y = yPos, Group = args.Group .. "Text" })
    CreateTextBox({ Id = components[textBoxTextBackingKey].Id, Text = components[textBoxBackingKey].currentText,
        FontSize = args.TextStyle.FontSize or 20,
        OffsetX = args.TextStyle.Offset.X or 0, OffsetY = args.TextStyle.Offset.Y or 0,
        Width = args.TextStyle.Width or 780,
        Justification = args.TextStyle.Justification,
        VerticalJustification = "Top",
        LineSpacingBottom = 8,
        Font = "MonospaceTypewriterBold",
        Color = args.TextStyle.Color,
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
        TextSymbolScale = 0.8})

    -- Note this also has the important job of calling update textbox
    ErumiUILib.Textbox.ShowCursor(components[textBoxBackingKey], args.showCursor or false)

    return components[textBoxBackingKey]
end
function ErumiUILib.Textbox.Update(textbox, text)
    local lines = {}
    local args = textbox.args
    local screen = textbox.screen
    local components = screen.Components
    local xPos = (args.X or 0)
    local yPos = (args.Y or 0)
    local Name = (args.Name or "UnnamedTextBox")
    local textBoxTextBackingKey = Name .. "TextHolder"
    local textBoxCursorHolder = Name .. "CursorHolder"
    textbox.currentText = text

    -- Add a space at the start of each to allow us to clear the text with ModifyText (empty string will not upadte the textbox)
    ModifyTextBox({ Id = components[textBoxTextBackingKey].Id, Text = " " .. text})
    if textbox.showCursor then
        ModifyTextBox({ Id = components[textBoxCursorHolder].Id, Text = " " .. text:sub(1, textbox.cursorPosition).."|"})
    else
      ModifyTextBox({ Id = components[textBoxCursorHolder].Id, Text = " "})
    end
end
function ErumiUILib.Textbox.Write(textbox, text)
    if #textbox.currentText + #text > textbox.maxLength then
        return
    end
    local newText = textbox.currentText
    local cursorPos = textbox.cursorPosition
    newText = newText:sub(1, cursorPos)..text..newText:sub(cursorPos + 1)
    ErumiUILib.Textbox.Update(textbox, newText)
    ErumiUILib.Textbox.SetCursorPosition(textbox, cursorPos + #text)
end
function ErumiUILib.Textbox.Delete(textbox, size)
    local newText = textbox.currentText
    local cursorPos = textbox.cursorPosition
    newText = newText:sub(1, math.max(0, cursorPos - size)) .. newText:sub(cursorPos + 1)
    ErumiUILib.Textbox.Update(textbox, newText)
    ErumiUILib.Textbox.SetCursorPosition(textbox, cursorPos - size)
end
function ErumiUILib.Textbox.SetCursorPosition(textbox, position)
    local newPosition = math.min(#textbox.currentText, math.max(0, position))
    textbox.cursorPosition = newPosition
    ErumiUILib.Textbox.Update(textbox, textbox.currentText)
end
function ErumiUILib.Textbox.ShowCursor(textbox, showCursor)
    textbox.showCursor = showCursor
    ErumiUILib.Textbox.Update(textbox, textbox.currentText)
end
function ErumiUILib.Textbox.GetText(textbox)
    return "" .. textbox.currentText
end
function ErumiUILib.Textbox.SetText(textbox, text)
    local cursorPos = #text
    ErumiUILib.Textbox.SetCursorPosition(textbox, cursorPos)
    ErumiUILib.Textbox.Update(textbox, text)
end
function ErumiUILibTextFieldButtonPressed(screen, button)
    button.args.OnFocus(button.screen.Components[button.textboxName])
end
--#endregion

--#region Misc

function ErumiUILib.Misc.NewButtonDoublePressedHandler( onPressedFunction, onSinglePressedFunction, onDoublePressedFunction, timeInterval )
    --[[
    DoSomethingFunction = ErumiUILib.Misc.NewButtonDoublePressedHandler( onPressedFunction, onSinglePressedFunction, onDoublePressedFunction, timeInterval )
...
button.onPressedFunction = "DoSomethingFunction"
]]--

    local pressedTime
    local function handler()
      if pressedTime and _screenTime - pressedTime < timeInterval then
        killTaggedThreads( handler )
        pressedTime = nil
        return onDoublePressedFunction() -- button was double clicked
      end
      thread( function( )
        waitScreenTime( timeInterval, handler )
        onSinglePressedFunction() -- button was clicked ( and was never double clicked )
      end, handler )
      pressedTime = _screenTime
      return onPressedFunction() -- button was clicked ( initial )
    end
    return handler
  end
--#endregion
