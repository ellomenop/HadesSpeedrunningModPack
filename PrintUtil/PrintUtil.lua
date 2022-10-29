--[[
  PrintUtil v1.0
  Authors:
    Ellomenop#2254 | https://twitch.tv/Ellomenop
    Museus#7777 | https://twitch.tv/Museus7

  Contains functions to print to the screen in an efficient and customizable
  manner, and to get the current stack trace, to determine who is calling a
  function and from where.
]]
ModUtil.Mod.Register("PrintUtil")

--- Util method to draw text to the screen
-- @param obstacleName Name of textbox
-- @param text String to display
-- @param kwargs Format values (defaults to Chamber Number format)
    -- font, font_size, color, outline_color, justification, shadow_color
function PrintUtil.createOverlayLine(obstacleName, text, kwargs)
    -- Use Chamber Number as default font style
    local text_config_table = DeepCopyTable(UIData.CurrentRunDepth.TextFormat)
    -- Throw the text somewhere in the middle of the screen, if not specified
    local x_pos = 500
    local y_pos = 500

    if kwargs ~= nil then
        text_config_table.Font = kwargs.font or text_config_table.Font
        text_config_table.FontSize = kwargs.font_size or text_config_table.FontSize
        text_config_table.Color = kwargs.color or text_config_table.Color
        text_config_table.OutlineColor = kwargs.outline_color or text_config_table.OutlineColor
        text_config_table.Justification = kwargs.justification or text_config_table.Justification
        text_config_table.ShadowColor = kwargs.shadow_color or {0, 0, 0, 0}
        x_pos = kwargs.x_pos or 500
        y_pos = kwargs.y_pos or 500
    end

    -- If this anchor was already created, just modify the existing textbox
    if ScreenAnchors[obstacleName] ~= nil then
        ModifyTextBox({
            Id = ScreenAnchors[obstacleName],
            Text = text,
            Color = (kwargs or {color = Color.White}).color or text_config_table.Color
        })
    else -- create a new anchor/textbox and fade it in
        ScreenAnchors[obstacleName] = CreateScreenObstacle({
            Name = "BlankObstacle",
            X = x_pos,
            Y = y_pos,
            Group = "Combat_Menu_Overlay"
        })

        CreateTextBox(
            MergeTables(
                text_config_table,
                {
                    Id = ScreenAnchors[obstacleName],
                    Text = text
                }
            )
        )

        ModifyTextBox({
            Id = ScreenAnchors[obstacleName],
            FadeTarget = 1,
            FadeDuration = 0.0
        })
    end
end

function PrintUtil.destroyScreenAnchor(obstacleName)
    if ScreenAnchors[obstacleName] ~= nil then
		Destroy({ Id = ScreenAnchors[obstacleName] })
		ScreenAnchors[obstacleName] = nil
    end
end

--- Grab the relevant part of the stack trace
function PrintUtil.traceback()
    local level = 3
    local output = ""

    while true do
        local info = debug.getinfo(level, "nSl")
        if not info or level > 6 then
            return output
        end

        if info.what == "C" then   -- is a C function?
            output = output .. string.format("%s C function |", level)
        else   -- a Lua function
            if info.name == "func" then
                output = output .. string.format("%s : %s | ", info.source or "", info.currentline or "")
            else
                output = output .. string.format("%s : %s | ", info.name or "", info.currentline or "")
            end
        end
        level = level + 1
    end

    return output
end
