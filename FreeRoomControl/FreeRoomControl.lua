--[[
    FreeRoomControl
    Author:
        SleepSoul (Discord: SleepSoul#6006)

    Allow limits on which, if any, free rooms can be offered together.
]]
ModUtil.Mod.Register("FreeRoomControl")

local config = {
    Enabled = true, -- If enabled, remove conflicts
}
FreeRoomControl.config = config
FreeRoomControl.CurrentDoors = {}
FreeRoomControl.FoundPriority = false

FreeRoomControl.IsPriorityRoom = { -- Priority rooms are to be kept in conflicts
    A_Shop01 = true,
    B_Shop01 = true,
    C_Shop01 = true,
}

FreeRoomControl.IsFreeRoom = {
    A_Shop01 = true,
    A_Reprieve01 = true,
    A_Story01 = true,
    B_Shop01 = true,
    B_Reprieve01 = true,
    B_Story01 = true,
    C_Shop01 = true,
    C_Reprieve01 = true,
    C_Story01 = true,
}

function FreeRoomControl.CheckDoors( doors ) -- Check a table of offered doors, storing which are free/priority and returning how many free rooms are found
    local freeRoomsFound = 0
    FreeRoomControl.FoundPriority = false

    for index, door in ipairs( doors ) do
        local name = door.Room.Name
        local doorData = {}
        doorData.IsFree = FreeRoomControl.IsFreeRoom[name] or false
        doorData.IsPriority = FreeRoomControl.IsPriorityRoom[name] or false

        if doorData.IsFree then
            DebugPrint({Text = name.." is free"})
            freeRoomsFound = freeRoomsFound + 1
        end
        if doorData.IsPriority then
            DebugPrint({Text = name.." is priority"})
            FreeRoomControl.FoundPriority = true
        end
        FreeRoomControl.CurrentDoors[index] = doorData
    end
    return freeRoomsFound
end

function FreeRoomControl.ResolveConflicts( doors )
    local nonPriorityChosen = false

    for index, door in ipairs( doors ) do
        local name = door.Room.Name
        local doorData = FreeRoomControl.CurrentDoors[index]
        local needsRerolling = true
        
        local rewardsChosen = {}
        for index, offeredDoor in pairs( OfferedExitDoors ) do
            if offeredDoor.Room ~= nil then
                table.insert( rewardsChosen, { RewardType = offeredDoor.Room.ChosenRewardType, ForceLootName = offeredDoor.Room.ForceLootName })
            end
        end

        if not doorData.IsFree then
            needsRerolling = false
        end
        if doorData.IsPriority then
            needsRerolling = false
        end
        if doorData.IsFree and not FreeRoomControl.FoundPriority and not nonPriorityChosen then -- If there aren't any priority rooms to keep, we need to keep at least one non-priority free room
            nonPriorityChosen = true
            needsRerolling = false
        end
        if needsRerolling then
            DebugPrint({Text = "Rerolling "..name})
            CurrentRun.RoomCreations[name] = CurrentRun.RoomCreations[name] - 1 -- Mark the room as having not been seen, so it can appear again
            local rollReward = true
            local storedReward = nil
            if door.Room.ChosenRewardType ~= nil and door.Room.ChosenRewardType ~= "Story" then
                storedReward = door.Room.ChosenRewardType
                rollReward = false
                DebugPrint({Text = "No new reward needed"}) -- If room already has a reward attached- i.e., it's a fountain- there's no need to pick a new one
            end

            local roomForDoorData = ChooseNextRoomData( CurrentRun, { BanFreeRooms = true } )
            local roomForDoor = CreateRoom( roomForDoorData, { SkipChooseReward = not rollReward, PreviouslyChosenRewards = rewardsChosen } )
            door.Room = roomForDoor
            door.Room.ChosenRewardType = storedReward or door.Room.ChosenRewardType
            
            if rollReward then
                FreeRoomControl.RefreshDoor( door )
            end

            StopAnimation({ DestinationId = door.DoorIconFront, Names = { "ConsecrationBuffedFront" }, PreventChain = true }) -- Fountain visual from DoorVisualIndicators
        end
    end
end

function FreeRoomControl.RefreshDoor( door ) -- Remove and replace a door's icon without playing a breaking animation
    if door.DoorIconId ~= nil then
        SetAlpha({ Id = door.DoorIconId, Fraction = 0, Duration = 0.1 })
        RemoveFromGroup({ Name = "Standing", Id =  door.DoorIconFront })
        AddToGroup({ Name = "FX_Standing", Id = door.DoorIconFront, DrawGroup = true })
        StopAnimation({ Names = { "RoomRewardAvailableRareSparkles", "RoomRewardAvailableGlow", "RoomRewardStreaks" }, DestinationId = door.DoorIconFront })
    end
    if door.AdditionalIcons ~= nil and not IsEmpty( door.AdditionalIcons ) then
        SetAlpha({ Ids = door.AdditionalIcons, Fraction = 0, Duration = 0.1 })
        door.AdditionalIcons = nil
    end
    CreateDoorRewardPreview( door )
end

ModUtil.Path.Wrap("DoUnlockRoomExits", function( baseFunc, run, room )
    baseFunc( run, room )
    if FreeRoomControl.config.Enabled then
        FreeRoomControl.CurrentDoors = {}
        FreeRoomControl.FoundPriority = false
        local freeRoomsNum = 0
        local exitDoorsIPairs = CollapseTableOrdered( OfferedExitDoors )

        freeRoomsNum = FreeRoomControl.CheckDoors( exitDoorsIPairs )
        if freeRoomsNum > 1 then
            DebugPrint({Text = "Free room conflict! Resolving..."})
            FreeRoomControl.ResolveConflicts( exitDoorsIPairs )
        end
    end
end, FreeRoomControl)

ModUtil.Path.Wrap( "IsRoomEligible", function( baseFunc, currentRun, currentRoom, nextRoomData, args )
    args = args or {}
    if args.BanFreeRooms and FreeRoomControl.IsFreeRoom[nextRoomData.Name] then
        return false
    end
    return baseFunc( currentRun, currentRoom, nextRoomData, args )
end, FreeRoomControl)
