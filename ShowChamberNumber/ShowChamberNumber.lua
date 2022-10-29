--[[
    ShowChamberNumber
    Authors:
        Museus (Discord: Museus#7777)
        Ellomenop (Discord: ellomenop#2254)

    Shows the current Chamber Number immediately upon starting a room. If that
    fails for some reason, fall back to showing the Depth during ShowCombatUI.
]]
ModUtil.Mod.Register("ShowChamberNumber")

local config = {
    ShowDepth = true,
}
ShowChamberNumber.config = config

-- Scripts/RoomManager.lua : 1874
ModUtil.Path.Wrap("StartRoom", function ( baseFunc, currentRun, currentRoom )
    if config.ShowDepth then
        ShowDepthCounter()
    end

    baseFunc(currentRun, currentRoom)
end, ShowChamberNumber)

-- Scripts/UIScripts.lua : 145
ModUtil.Path.Wrap("ShowCombatUI", function ( baseFunc, flag )
    if config.ShowDepth then
        ShowDepthCounter()
    end

    baseFunc(flag)
end, ShowChamberNumber)

-- Hiding Depth Counter doesn't actually do anything
ModUtil.Path.Wrap("HideDepthCounter", function ( baseFunc )
    if config.ShowDepth then
        return
    end

    baseFunc()
end, ShowChamberNumber)
