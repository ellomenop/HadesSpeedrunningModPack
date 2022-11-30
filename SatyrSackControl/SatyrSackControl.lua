--[[
    SatyrSackControl v1.0
    Author:
        Museus (Discord: Museus#7777)
        SleepSoul (Discord: SleepSoul#6006)
        Zyruvias (Discord: Zyruvias#3283)
    Forces the Styx satyr sack to appear in a specified range.
]]
ModUtil.Mod.Register("SatyrSackControl")

local config = {
    Enabled = true, -- If true, sack wil fall between MinSack and MaxSack
    ForceShortTunnels = true, -- If true, all tunnels will be short
    MinSack = 2, -- Lowest tunnel count to see Sack
    MaxSack = 2 -- Highest tunnel count to see Sack
}
SatyrSackControl.config = config

-- Scripts/RoomManager.lua : 1874
ModUtil.Path.Wrap("StartRoom", function ( baseFunc, currentRun, currentRoom )
    baseFunc(currentRun, currentRoom)
end, SatyrSackControl)

-- Scripts/UIScripts.lua : 145
ModUtil.Path.Wrap("ShowCombatUI", function ( baseFunc, flag )
    baseFunc(flag)
end, SatyrSackControl)

-- Scripts/RunManager.lua : 591
ModUtil.Path.Wrap("IsRoomForced", function ( baseFunction, currentRun, currentRoom, nextRoomData, args )
    if nextRoomData.ForceChanceByRemainingWings then
            if SatyrSackControl.config.Enabled then
                if (currentRun.CompletedStyxWings + 1) < SatyrSackControl.config.MinSack then
                    return false
                end

                if (currentRun.CompletedStyxWings + 1) >= SatyrSackControl.config.MaxSack then
                    return true
                end
            end
        end
        return baseFunction( currentRun, currentRoom, nextRoomData, args )
    end)

-- Scripts/RunManager.lua : 652
ModUtil.Path.Wrap("IsRoomEligible", function ( baseFunction, currentRun, currentRoom, nextRoomData, args )
    if currentRoom ~= nil then
         if SatyrSackControl.config.ForceShortTunnels and currentRun.WingDepth >= 3 and not nextRoomData.WingEndRoom then
            return false
        end
    end
    return baseFunction( currentRun, currentRoom, nextRoomData, args )
end)