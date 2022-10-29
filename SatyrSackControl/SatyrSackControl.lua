--[[
    SatyrSackControl v1.0
    Author:
        Museus (Discord: Museus#7777)

    Forces the Styx satyr sack to appear in a specified range.
]]
ModUtil.Mod.Register("SatyrSackControl")

local config = {
    Enabled = true, -- If true, sack wil fall between MinSack and MaxSack
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
ModUtil.Path.Override("IsRoomForced", function(currentRun, currentRoom, nextRoomData, args)
    if nextRoomData.AlwaysForce then
        return true
    end

    if
        nextRoomData.ForceIfEncounterNotCompleted ~= nil and
            not HasEncounterBeenCompleted(nextRoomData.ForceIfEncounterNotCompleted)
        then
        return true
    end

    if
        nextRoomData.ForceIfUnseenForRuns ~= nil and
            not HasSeenRoomInNumRuns(nextRoomData.Name, nextRoomData.ForceIfUnseenForRuns)
        then
        DebugPrint({Text = "Forcing = " .. nextRoomData.Name})
        return true
    end

    args = args or {}

    local depthSkip = args.RoomsSkipped or 0
    local currentRunDepth = currentRun.RunDepthCache + depthSkip
    if nextRoomData.ForceAtRunDepth ~= nil and currentRunDepth == nextRoomData.ForceAtRunDepth then
        return true
    end
    if nextRoomData.ForceAtRunDepthMin ~= nil and currentRunDepth >= nextRoomData.ForceAtRunDepthMin then
        if currentRunDepth >= nextRoomData.ForceAtRunDepthMax then
            return true
        else
            local forcedChance = 1 / (nextRoomData.ForceAtRunDepthMax - currentRunDepth)
            if RandomChance(forcedChance) then
                return true
            end
        end
    end
    local currentBiomeDepth = currentRun.BiomeDepthCache + depthSkip
    if nextRoomData.ForceAtBiomeDepth ~= nil and currentBiomeDepth == nextRoomData.ForceAtBiomeDepth then
        return true
    end
    if nextRoomData.ForceAtBiomeDepthMin ~= nil and currentBiomeDepth >= nextRoomData.ForceAtBiomeDepthMin then
        if currentBiomeDepth >= nextRoomData.ForceAtBiomeDepthMax then
            return true
        else
            local forcedChance = 1 / (nextRoomData.ForceAtBiomeDepthMax - currentBiomeDepth)
            if RandomChance(forcedChance) then
                return true
            end
        end
    end

    if
        currentRoom ~= nil and currentRoom.ForceWingEndMiniBoss and nextRoomData.WingEndMiniBoss and
            (currentRun.CompletedStyxWings < 4 or HasSeenRoomInRun(currentRun, "D_Reprieve01"))
        then
        return true
    end

    if nextRoomData.ForceChanceByRemainingWings then
        -- [[ CHANGES MADE HERE ]]
        if SatyrSackControl.config.Enabled then
            if (currentRun.CompletedStyxWings + 1) < SatyrSackControl.config.MinSack then
                return false
            end

            if (currentRun.CompletedStyxWings + 1) >= SatyrSackControl.config.MaxSack then
                return true
            end
        end
        -- [[ END OF CHANGES ]]

        local chance = 1 / (5 - currentRun.CompletedStyxWings)
        if RandomChance(chance) then
            return true
        end
    end

    return false
end)
