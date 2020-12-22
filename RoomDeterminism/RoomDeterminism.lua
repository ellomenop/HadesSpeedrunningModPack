ModUtil.RegisterMod("RoomDeterminism")

local config = {
  -- TODO: these configs can yield infinite loops.  Needs addressing before exposing to player via a UI
  PlanRoomsOnNewRun = true,
  MidShopMinDepth = {
    Tartarus = 5,
    Asphodel = 18,
    Elysium = 28
  },
  MidShopMaxDepth = {
    Tartarus = 8,
    Asphodel = 20,
    Elysium = 31
  },
  MinibossMinDepth = {
    Tartarus = 6,
    Asphodel = 19,
    Elysium = 29
  },
  MinibossMaxDepth = {
    Tartarus = 10,
    Asphodel = 21,
    Elysium = 32
  },
  FountainMinDepth = {
    Tartarus = 2,
    Asphodel = 18,
    Elysium = 28
  },
  FountainMaxDepth = {
    Tartarus = 12,
    Asphodel = 22,
    Elysium = 34
  },
  StoryMinDepth = {
    Tartarus = 5,
    Asphodel = 17,
    Elysium = 28
  },
  StoryMaxDepth = {
    Tartarus = 12,
    Asphodel = 22,
    Elysium = 34
  },
  FountainChance = {
    Tartarus = 0.3,
    Asphodel = 0.25,
    Elysium = 0.25
  },
  StoryChance = {
    Tartarus = 0.3,
    Asphodel = 0.25,
    Elysium = 0.25
  }
}
RoomDeterminism.config = config

BIOME_DEPTH = {
  Tartarus = {
    Min = 1,
    Max = 15
  },
  Asphodel = {
    Min = 16,
    Max = 25
  },
  Elysium = {
    Min = 26,
    Max = 37
  },
  Styx = {
    Min = 38,
    Max = 100 -- Big Number, ignoring surface for now
  },
}
MAX_EXITS = {
  Tartarus = 2,
  Asphodel = 3,
  Elysium = 2
}
BIOMES = { "Tartarus", "Asphodel", "Elysium", "Styx" }
BIOME_ABBREVIATION = {
  Tartarus = "A",
  Asphodel = "B",
  Elysium = "C",
  Styx = "D"
}

-- Counts exit doors (since room creation for an exit door do not know which door they belong to)
CurrentExitForDepth = 1

-- Global Variable that tracks what overrides we will apply to the run
OverridesByDepth = {}

-- Global variable that tracks which rooms have already been placed
SelectedRoomsCache = {}

function populateRoomOverrides()
  rng = GetGlobalRng()
  RandomSynchronize(3110)

  OverridesByDepth = {}
  SelectedRoomsCache = {}

  -- For each biome
  for _, biome in ipairs(BIOMES) do

    -- Don't pre-select styx
    if biome == "Styx" then
      return
    end

    local placed_rooms = {}

    -- Place midshop
    local midshop_depth = rng:Random(config.MidShopMinDepth[biome], config.MidShopMaxDepth[biome])
    placed_rooms[midshop_depth] = placed_rooms[midshop_depth] or {} -- Create if nil
    table.insert(placed_rooms[midshop_depth], BIOME_ABBREVIATION[biome] .. "_Shop01")

    -- Place minibosses
    minibosses = GetEligibleMiniBossRoomNames(biome)
    local miniboss_depth = nil
    for _, miniboss in ipairs(minibosses) do
      repeat
        miniboss_depth = rng:Random(config.MinibossMinDepth[biome], config.MinibossMaxDepth[biome])
      until #(placed_rooms[miniboss_depth] or {}) < ((placed_rooms[miniboss_depth] or {NumExits = MAX_EXITS[biome]}).NumExits or MAX_EXITS[biome]) -- Previous room has enough exits for this room
            and #(placed_rooms[miniboss_depth + 1] or {}) <= RoomSetData[biome][miniboss].NumExits -- This room can support the number of needed exits for next room
      placed_rooms[miniboss_depth] = placed_rooms[miniboss_depth] or {} -- Create if nil
      table.insert(placed_rooms[miniboss_depth], miniboss)
    end

    -- Roll Fountain
    local hasFountain = RandomChance(config.FountainChance[biome])

    -- Place Fountain
    if hasFountain then
      local fountain_room_name = BIOME_ABBREVIATION[biome] .. "_Reprieve01"
      repeat
        fountain_depth = rng:Random(config.FountainMinDepth[biome], config.FountainMaxDepth[biome])
      until #(placed_rooms[fountain_depth] or {}) < ((placed_rooms[fountain_depth] or {NumExits = MAX_EXITS[biome]}).NumExits or MAX_EXITS[biome]) -- Previous room has enough exits for this room
            and #(placed_rooms[fountain_depth + 1] or {}) <= RoomSetData[biome][fountain_room_name].NumExits -- This room can support the number of needed exits for next room
      placed_rooms[fountain_depth] = placed_rooms[fountain_depth] or {} -- Create if nil
      table.insert(placed_rooms[fountain_depth], fountain_room_name)
    end

    -- Roll Story
    local has_story = RandomChance(config.StoryChance[biome])

    -- Place Story
    if has_story then
      local story_room_name = BIOME_ABBREVIATION[biome] .. "_Story01"
      repeat
        story_depth = rng:Random(config.StoryMinDepth[biome], config.StoryMaxDepth[biome])
      until #(placed_rooms[story_depth] or {}) < ((placed_rooms[story_depth] or {NumExits = MAX_EXITS[biome]}).NumExits or MAX_EXITS[biome]) -- Previous room has enough exits for this room
            and #(placed_rooms[story_depth + 1] or {}) <= RoomSetData[biome][story_room_name].NumExits -- This room can support the number of needed exits for next room
      placed_rooms[story_depth] = placed_rooms[story_depth] or {} -- Create if nil
      table.insert(placed_rooms[story_depth], story_room_name)
    end

    -- For each depth, excluding the end shop, end boss and midbiome
    for depth = BIOME_DEPTH[biome].Min, BIOME_DEPTH[biome].Max - 3 do
      local minimum_exits = #(placed_rooms[depth + 1] or {1})
      local eligible_room_data = GetEligibleCombatRoomData(biome, depth, minimum_exits)

      -- Select room from eligible rooms
      local selected_room_name = GetRandomKey(eligible_room_data)
      OverridesByDepth[depth] = OverridesByDepth[depth] or {} -- Create if nil
      OverridesByDepth[depth].Room = selected_room_name
      SelectedRoomsCache[selected_room_name] = true
      DebugPrint({Text = depth .. ": Selected " .. selected_room_name})

      -- Generate a table of options based on number of exits of selected room
      local exit_options = {}
      for i = 1, eligible_room_data[selected_room_name].NumExits do
        table.insert(exit_options, i)
      end

      -- Assign exits to any placed rooms at the next depth
      if #(placed_rooms[depth + 1] or {}) > 0 then
        for _, placed_room in ipairs(placed_rooms[depth + 1]) do
          local exit = RemoveRandomValue(exit_options)
          OverridesByDepth[depth]["Exit" .. exit] = placed_room
          DebugPrint({Text = depth .. ": Placed " .. placed_room .. " at " .. "Exit" .. exit})
        end
      end
    end
  end
end

-- TODO: How to handle RequiredFalseRooms / Combat08A in tartarus?
function GetEligibleCombatRoomData(biome, depth, minimum_exits)
  local eligible_room_data = {}
  local biome_letter = BIOME_ABBREVIATION[biome]
  -- Handle intro room case
  if depth == BIOME_DEPTH[biome].Min then
    local intro_room_name = biome_letter .. "_Intro"
    if depth == 1 then
      intro_room_name = "RoomOpening"
    end
    eligible_room_data[intro_room_name] = RoomSetData[biome][intro_room_name]
    return eligible_room_data
  end

  -- Look through all room data to find the eligible ones
  for roomName, roomData in pairs(RoomSetData[biome]) do
    -- Filter down to only combat chambers that aren't debug rooms
    if string.find(roomName, "Combat") and not roomData.DebugOnly then
      -- Check all other conditions (e.g. biome depth and num exits)
      if roomData.NumExits >= minimum_exits
          and depth >= (roomData.RequiredMinBiomeDepth or -1)
          and depth <= (roomData.RequiredMaxBiomeDepth or 99999)
          and not SelectedRoomsCache[roomName] then

        -- If all conditions succeeded, room is eligible
        eligible_room_data[roomName] = roomData
      end
    end
  end

  table.sort(eligible_room_data, cmp_multitype)
  return eligible_room_data
end

-- TODO: Update to pull from RoomData and evaluate conditions like alt doomstone
function GetEligibleMiniBossRoomNames(biome)
  if biome == "Tartarus" then
    -- A_MiniBoss01 - bombers
    -- A_MiniBoss02 - MM doomstone
    -- A_MiniBoss03 - sneak
    -- A_MiniBoss04 - normal doomstone
    return {"A_MiniBoss01", "A_MiniBoss03", "A_MiniBoss04"} -- MiniBoss2 is the MiddleManagement version of doomstone
  elseif biome == "Asphodel" then
    -- B_Wrapping01 - Barge
    -- B_MiniBoss01 - Power Couple
    -- B_MiniBoss02 - Witches
    return {"B_Wrapping01", "B_MiniBoss01", "B_MiniBoss02"}
  elseif biome == "Elysium" then
    -- C_MiniBoss01 - Asterius
    -- C_MiniBoss02 - Soul Catcher
    return {"C_MiniBoss01", "C_MiniBoss02"}
  elseif biome == "Styx" then
    -- D_MiniBoss01 - Satyr
    -- D_MiniBoss02 - Rat Thug
    -- D_MiniBoss03 - Tiny vermin / Snakestone
    -- D_MiniBoss04 - Bother
    return {"D_MiniBoss01", "D_MiniBoss02", "D_MiniBoss03", "D_MiniBoss04"}
  end
  error("Invalid biome passed to GetEligibleMiniBossRoomNames: " .. (biome or "nil"))
end

function HasSeenMiniboss(biome)
  for _, miniboss in ipairs(GetEligibleMiniBossRoomNames(biome)) do
    if HasSeenRoomInRun(CurrentRun, miniboss) then
      return true
    end
  end
  return false
end

-- Search the room set data for a matching room name
function GetBiome(room_name_to_find)
  for biome_name, biome_data in pairs(RoomSetData) do
    for room_name, room_data in pairs(biome_data) do
      if room_name == room_name_to_find then
        return biome_name
      end
    end
  end
  error("Invalid room name passed to GetBiome: " .. (room_name_to_find or "nil"))
end

ModUtil.WrapBaseFunction("ChooseNextRoomData", function ( baseFunc, run )
	local next_room_data = baseFunc( run )
  local next_room_name = nil
  local depth = GetRunDepth(CurrentRun)

  -- Override the room with the room planned at the next depth
  if OverridesByDepth[depth + 1] ~= nil then
    if OverridesByDepth[depth + 1].Room ~= nil then
      DebugPrint({Text = "Override at depth " .. depth + 1 .. " for room is " .. OverridesByDepth[depth + 1].Room})
      next_room_name = OverridesByDepth[depth + 1].Room
    end
  end

  -- if there is a door-specific override, use that instead of the room depth override
  if OverridesByDepth[depth] ~= nil then
    if OverridesByDepth[depth]["Exit" .. CurrentExitForDepth] ~= nil then
      local temp_room_name = OverridesByDepth[depth]["Exit" .. CurrentExitForDepth]
      local biome = GetBiome(temp_room_name)

      -- Only override exits with miniboss rooms if we haven't yet seen a miniboss this biome
      if not (HasSeenMiniboss(biome) and RoomSetData[biome][temp_room_name].IsMiniBossRoom) then
        DebugPrint({Text = "Override at depth " .. depth .. " and exit " .. CurrentExitForDepth .. " is " .. OverridesByDepth[depth]["Exit" .. CurrentExitForDepth]})
        next_room_name = temp_room_name
      end
    end
  end

  if next_room_name ~= nil then
    local biome = GetBiome(next_room_name)
    next_room_data = RoomSetData[biome][next_room_name]
  end

  CurrentExitForDepth = CurrentExitForDepth + 1
	return next_room_data
end, RoomDeterminism)

ModUtil.WrapBaseFunction("LeaveRoom", function ( baseFunc, currentRun, door )
  -- Reset our naive exit door counter
  CurrentExitForDepth = 1

  baseFunc(currentRun, door)
end, RoomDeterminism)

ModUtil.WrapBaseFunction("StartNewRun", function ( baseFunc, currentRun )
  if config.PlanRoomsOnNewRun then
    populateRoomOverrides()
  end
  return baseFunc(currentRun)
end, RoomDeterminism)
