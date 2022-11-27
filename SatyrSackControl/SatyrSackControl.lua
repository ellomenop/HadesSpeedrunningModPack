--[[
    SatyrSackControl v1.0
    Author:
        Museus (Discord: Museus#7777)

    Forces the Styx satyr sack to appear in a specified range.
]]
ModUtil.Mod.Register("SatyrSackControl")

local config = {
    Enabled = true, -- If true, sack wil fall between MinSack and MaxSack
    ForceShortTunnels = false, -- If true, all tunnels will be short
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

-- Scripts/RunManager.lua : 652
ModUtil.Path.Override("IsRoomEligible", function(currentRun, currentRoom, nextRoomData, args)
    if args == nil then
        args = {}
    end

    if nextRoomData == nil then
        return false
    end

    local excludedNames = args.ExcludedNames
    local excludedTypes = args.ExcludedTypes
    local excludedRewards = args.ExcludedRewards
    local roomsSkipped = args.DepthSkip or 0

    if nextRoomData.DebugOnly then
        return false
    end

    if excludedNames ~= nil and excludedNames[nextRoomData.Name] then
        return false
    end

    if excludedTypes ~= nil and excludedTypes[nextRoomData.Type] then
        return false
    end

    if excludedRewards ~= nil and not IsEmpty(nextRoomData.RewardTypes) and ContainsAll(excludedRewards, nextRoomData.RewardTypes) then
        return false
    end

    if nextRoomData.ForceAtBiomeDepth ~= nil and currentRun.BiomeDepthCache ~= nextRoomData.ForceAtBiomeDepth then
        return false
    end
    if nextRoomData.ForceAtBiomeDepthMin ~= nil and currentRun.BiomeDepthCache < nextRoomData.ForceAtBiomeDepthMin then
        return false
    end

    if currentRoom ~= nil then
        if nextRoomData.Name == currentRoom.Name then
            return false
        end
        if nextRoomData.Starting and not currentRoom.AllowNextRoomStarting then
            return false
        end
        if nextRoomData.RequiresLinked then
            if currentRoom.LinkedRoom ~= nextRoomData.Name and ( currentRoom.LinkedRooms == nil or not Contains( currentRoom.LinkedRooms, nextRoomData.Name ) ) then
                return false
            end
        end

        -- If in a MiniBoss wing and we are not a MiniBoss, we are ineligible (except Reprieve)
        if currentRoom.RequireWingEndMiniBoss and nextRoomData.WingEndRoom and not nextRoomData.WingEndMiniBoss and not nextRoomData.AllowAsAnyWingEnd then
            return false
        end

        -- If in a regular wing and we are a MiniBoss room, we are ineligible (except Reprieve)
        if not currentRoom.RequireWingEndMiniBoss and nextRoomData.WingEndRoom and nextRoomData.WingEndMiniBoss and not nextRoomData.AllowAsAnyWingEnd then
            return false
        end
        
        -- [[ CHANGES MADE HERE ]]
        if SatyrSackControl.config.ForceShortTunnels and currentRun.WingDepth >= 3 and not nextRoomData.WingEndRoom then
            return false
        end
        -- [[ END OF CHANGES ]]
    end

    if nextRoomData.MaxAppearancesThisRun ~= nil and currentRun.RoomCountCache[nextRoomData.Name] ~= nil and currentRun.RoomCountCache[nextRoomData.Name] >= nextRoomData.MaxAppearancesThisRun then
        return false
    end
    if nextRoomData.MaxAppearancesThisBiome ~= nil and currentRun.BiomeRoomCountCache[nextRoomData.Name] ~= nil and currentRun.BiomeRoomCountCache[nextRoomData.Name] >= nextRoomData.MaxAppearancesThisBiome then
        return false
    end

    if nextRoomData.MaxCreationsThisRun ~= nil and currentRun.RoomCreations[nextRoomData.Name] ~= nil and currentRun.RoomCreations[nextRoomData.Name] >= nextRoomData.MaxCreationsThisRun then
        return false
    end

    if not IsGameStateEligible( currentRun, nextRoomData , nextRoomData.GameStateRequirements, args) then
        return false
    end
    return true
end)