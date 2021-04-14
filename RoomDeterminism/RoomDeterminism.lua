ModUtil.RegisterMod("RoomDeterminism")

local config = {
  -- TODO: these configs can yield infinite loops.  Needs addressing before exposing to player via a UI
  Enabled = false,
  RoomGenerationAlgorithm = "Vanilla",
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
    Asphodel = 0.2,
    Elysium = 0.25
  },
  StoryChance = {
    Tartarus = 0.4,
    Asphodel = 0.4,
    Elysium = 0.5
  }
}
RoomDeterminism.config = config
RoomDeterminism.BIOME_DEPTH = {
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
RoomDeterminism.MAX_EXITS = {
  Tartarus = 2,
  Asphodel = 3,
  Elysium = 2
}
RoomDeterminism.BIOMES = { "Tartarus", "Asphodel", "Elysium", "Styx" }
RoomDeterminism.BIOME_ABBREVIATION = {
  Tartarus = "A",
  Asphodel = "B",
  Elysium = "C",
  Styx = "D"
}
RoomDeterminism.ABBREVIATION_TO_BIOME = {
  A = "Tartarus",
  B = "Asphodel",
  C = "Elysium",
  D = "Styx"
}

-- Counts exit doors (since room creation for an exit door do not know which door they belong to)
RoomDeterminism.CurrentExitForDepth = 1

-- Global Variable that tracks what overrides we will apply to the run
RoomDeterminism.RoomOverridesByDepth = {}

-- Global variables that tracks algorithm name to algorithm function
RoomDeterminism.RoomGenerationAlgorithms = {}

-- Populate out of the box generation algorithms
ModUtil.LoadOnce(function()
  RoomDeterminism.RoomGenerationAlgorithms["Vanilla"] = populateVanillaRoomOverrides
end)

function populateVanillaRoomOverrides()
  RoomDeterminism.RoomOverridesByDepth = {}

  -- Variable that tracks which rooms have already been placed
  local selected_rooms_cache = {}

  -- For each biome
  for _, biome in ipairs(RoomDeterminism.BIOMES) do

    -- Don't pre-select styx
    if biome == "Styx" then
      return
    end

    local placed_rooms = {}

    -- Place midshop
    local midshop_depth = RandomInt(config.MidShopMinDepth[biome], config.MidShopMaxDepth[biome])
    placed_rooms[midshop_depth] = placed_rooms[midshop_depth] or {} -- Create if nil
    table.insert(placed_rooms[midshop_depth], RoomDeterminism.BIOME_ABBREVIATION[biome] .. "_Shop01")

    -- Place minibosses
    miniboss_room_names = GetEligibleMiniBossRoomNames(biome)
    local miniboss_depth = nil
    for _, miniboss_room_name in ipairs(miniboss_room_names) do
      repeat
        miniboss_depth = RandomInt(config.MinibossMinDepth[biome], config.MinibossMaxDepth[biome])
      until #(placed_rooms[miniboss_depth] or {}) < GetMinExitsOfPlacedRoomsAtDepth(biome, placed_rooms, miniboss_depth - 1) -- Previous placed rooms have enough exits for all placed rooms at this depth
            and #(placed_rooms[miniboss_depth + 1] or {}) <= GetAdjustedNumRoomExits(miniboss_room_name, RoomSetData[biome][miniboss_room_name]) -- This room can support the number of needed exits for next room
      placed_rooms[miniboss_depth] = placed_rooms[miniboss_depth] or {} -- Create if nil
      table.insert(placed_rooms[miniboss_depth], miniboss_room_name)
    end

    -- Roll Fountain
    local hasFountain = RandomChance(config.FountainChance[biome])

    -- Place Fountain
    if hasFountain then
      local fountain_room_name = RoomDeterminism.BIOME_ABBREVIATION[biome] .. "_Reprieve01"
      repeat
        fountain_depth = RandomInt(config.FountainMinDepth[biome], config.FountainMaxDepth[biome])
      until #(placed_rooms[fountain_depth] or {}) < GetMinExitsOfPlacedRoomsAtDepth(biome, placed_rooms, fountain_depth - 1) -- Previous placed rooms have enough exits for all placed rooms at this depth
            and #(placed_rooms[fountain_depth + 1] or {}) <= GetAdjustedNumRoomExits(fountain_room_name, RoomSetData[biome][fountain_room_name]) -- This room can support the number of needed exits for next room
      placed_rooms[fountain_depth] = placed_rooms[fountain_depth] or {} -- Create if nil
      table.insert(placed_rooms[fountain_depth], fountain_room_name)
    end

    -- Roll Story
    local has_story = RandomChance(config.StoryChance[biome])

    -- Place Story
    if has_story then
      local story_room_name = RoomDeterminism.BIOME_ABBREVIATION[biome] .. "_Story01"
      repeat
        story_depth = RandomInt(config.StoryMinDepth[biome], config.StoryMaxDepth[biome])
      until #(placed_rooms[story_depth] or {}) < GetMinExitsOfPlacedRoomsAtDepth(biome, placed_rooms, story_depth - 1) -- Previous placed rooms have enough exits for all placed rooms at this depth
            and #(placed_rooms[story_depth + 1] or {}) <= GetAdjustedNumRoomExits(story_room_name, RoomSetData[biome][story_room_name]) -- This room can support the number of needed exits for next room
      placed_rooms[story_depth] = placed_rooms[story_depth] or {} -- Create if nil
      table.insert(placed_rooms[story_depth], story_room_name)
    end

    -- For each depth, excluding the end shop, end boss and midbiome
    for depth = RoomDeterminism.BIOME_DEPTH[biome].Min, RoomDeterminism.BIOME_DEPTH[biome].Max - 3 do
      local minimum_exits = #(placed_rooms[depth + 1] or {1})
      local eligible_room_data = GetEligibleCombatRoomData(biome, depth, minimum_exits, selected_rooms_cache)

      -- Select room from eligible rooms
      local selected_room_name = GetRandomKey(eligible_room_data)
      RoomDeterminism.RoomOverridesByDepth[depth] = RoomDeterminism.RoomOverridesByDepth[depth] or {} -- Create if nil
      RoomDeterminism.RoomOverridesByDepth[depth].Room = selected_room_name
      selected_rooms_cache[selected_room_name] = true
      DebugPrint({Text = depth .. ": Selected " .. selected_room_name})

      -- Generate a table of options based on number of exits of selected room
      local exit_options = {}
      for i = 1, GetAdjustedNumRoomExits(selected_room_name, eligible_room_data[selected_room_name]) do
        table.insert(exit_options, i)
      end

      -- Assign exits to any placed rooms at the next depth
      if #(placed_rooms[depth + 1] or {}) > 0 then
        for _, placed_room in ipairs(placed_rooms[depth + 1]) do
          local exit = RemoveRandomValue(exit_options)
          RoomDeterminism.RoomOverridesByDepth[depth]["Exit" .. exit] = placed_room
          DebugPrint({Text = depth .. ": Placed " .. placed_room .. " at " .. "Exit" .. exit})
        end
      end
    end
  end
end

-- Specific rooms have different NumExits than actual exits, adjust accordingly
function GetAdjustedNumRoomExits(room_name, room_data)
  local num_exits = room_data.NumExits
  if room_name == "B_Combat10" or room_name == "C_MiniBoss02" or room_name == "C_Reprieve01" then
    num_exits = 2
  end
  return num_exits
end

-- TODO: How to handle RequiredFalseRooms / Combat08A in tartarus?
function GetEligibleCombatRoomData(biome, depth, minimum_exits, selected_rooms_cache)
  local eligible_room_data = {}
  local biome_letter = RoomDeterminism.BIOME_ABBREVIATION[biome]
  local biome_depth = depth - RoomDeterminism.BIOME_DEPTH[biome].Min + 1

  -- Handle intro room case
  if depth == RoomDeterminism.BIOME_DEPTH[biome].Min then
    local intro_room_name = biome_letter .. "_Intro"
    if depth == 1 then
      intro_room_name = "RoomOpening"
    end
    eligible_room_data[intro_room_name] = RoomSetData[biome][intro_room_name]
    return eligible_room_data
  end

  -- Look through all room data to find the eligible ones
  for room_name, room_data in pairs(RoomSetData[biome]) do
    -- Filter down to only combat chambers that aren't debug rooms
    if (string.find(room_name, "Combat") or room_name == "RoomSimple01") and not room_data.DebugOnly then
      -- Check all other conditions (e.g. biome depth and num exits)
      if GetAdjustedNumRoomExits(room_name, room_data) >= minimum_exits
          and biome_depth >= (room_data.GameStateRequirements.RequiredMinBiomeDepth or -1)
          and biome_depth <= (room_data.GameStateRequirements.RequiredMaxBiomeDepth or 99999)
          and not selected_rooms_cache[room_name] then

        -- If all conditions succeeded, room is eligible
        eligible_room_data[room_name] = room_data
      end
    end
  end

  table.sort(eligible_room_data, cmp_multitype)
  return eligible_room_data
end

-- TODO: Update to pull from RoomData and evaluate conditions like alt doomstone
function GetEligibleMiniBossRoomNames(biome)
  local minibosses = {}

  -- If using Miniboss Control Mod, only place the configured minibosses and quantities
  if MinibossControl.config.MinibossSetting ~= "Vanilla" then
    for miniboss, count in pairs(MinibossControl.Presets[MinibossControl.config.MinibossSetting]) do
      if RoomDeterminism.ABBREVIATION_TO_BIOME[miniboss:sub(1,1)] == biome then
        for i = 1, count do
          table.insert(minibosses, miniboss)
        end
      end
    end
    return CollapseTableOrdered(minibosses)
  end

  -- Otherwise assume vanilla
  if biome == "Tartarus" then
    -- A_MiniBoss01 - bombers
    -- A_MiniBoss02 - MM doomstone
    -- A_MiniBoss03 - sneak
    -- A_MiniBoss04 - normal doomstone
    minibosses = {"A_MiniBoss01", "A_MiniBoss03", "A_MiniBoss04"} -- MiniBoss2 is the MiddleManagement version of doomstone
  elseif biome == "Asphodel" then
    -- B_Wrapping01 - Barge
    -- B_MiniBoss01 - Power Couple
    -- B_MiniBoss02 - Witches
    minibosses = {"B_Wrapping01", "B_MiniBoss01", "B_MiniBoss02"}
  elseif biome == "Elysium" then
    -- C_MiniBoss01 - Asterius
    -- C_MiniBoss02 - Soul Catcher
    minibosses = {"C_MiniBoss01", "C_MiniBoss02"}
  elseif biome == "Styx" then
    -- D_MiniBoss01 - Satyr
    -- D_MiniBoss02 - Rat Thug
    -- D_MiniBoss03 - Tiny vermin / Snakestone
    -- D_MiniBoss04 - Bother
    minibosses = {"D_MiniBoss01", "D_MiniBoss02", "D_MiniBoss03", "D_MiniBoss04"}
  else
    error("Invalid biome passed to GetEligibleMiniBossRoomNames: " .. (biome or "nil"))
  end

  return CollapseTableOrdered(minibosses)
end

function HasSeenMiniboss(biome)
  for _, miniboss in ipairs(GetEligibleMiniBossRoomNames(biome)) do
    if HasSeenRoomInRun(CurrentRun, miniboss) then
      return true
    end
  end
  return false
end

-- Calculate the maximum number of subsequent rooms a depth can support by finding the min num of exits across all possible rooms placed at that depth
function GetMinExitsOfPlacedRoomsAtDepth(biome, placed_rooms, depth)
  local min_exits = RoomDeterminism.MAX_EXITS[biome]
  if placed_rooms[depth] ~= nil then
    for _, room_name in ipairs(placed_rooms[depth]) do
      min_exits = math.min(min_exits, GetAdjustedNumRoomExits(room_name, RoomSetData[biome][room_name]))
    end
  end
  return min_exits
end

function GetBiomeByDepth(depth, extra_rooms_taken)
  extra_rooms_taken = extra_rooms_taken or 0
  for _, biome_name in ipairs(RoomDeterminism.BIOMES) do
    if depth <= RoomDeterminism.BIOME_DEPTH[biome_name].Max + extra_rooms_taken and depth >= RoomDeterminism.BIOME_DEPTH[biome_name].Min + extra_rooms_taken then
      return biome_name
    end
  end
  error("Invalid depth passed to GetBiomeByDepth: " .. (depth or "nil"))
end

-- Search the room set data for a matching room name
function GetRoomBiome(room_name_to_find)
  for biome_name, biome_data in pairs(RoomSetData) do
    for room_name, room_data in pairs(biome_data) do
      if room_name == room_name_to_find then
        return biome_name
      end
    end
  end
  error("Invalid room name passed to GetRoomBiome: " .. (room_name_to_find or "nil"))
end

ModUtil.WrapBaseFunction("ChooseNextRoomData", function ( baseFunc, run, args )
	local next_room_data = baseFunc( run, args )

  -- If the mod isn't enabled or the next room is a vanilla chaos, then don't override the next room
  if (not config.Enabled) or ModUtil.SafeGet(args, {"RoomDataSet"}) ~= nil then
    return next_room_data
  end

  local next_room_name = nil
  local depth = GetRunDepth(CurrentRun)

  -- Override the room with the room planned at the next depth
  if RoomDeterminism.RoomOverridesByDepth[depth + 1] ~= nil then
    if RoomDeterminism.RoomOverridesByDepth[depth + 1].Room ~= nil then
      DebugPrint({Text = "Override at depth " .. depth + 1 .. " for room is " .. RoomDeterminism.RoomOverridesByDepth[depth + 1].Room})
      next_room_name = RoomDeterminism.RoomOverridesByDepth[depth + 1].Room
    end
  end

  -- if there is a door-specific override, use that instead of the room depth override
  if RoomDeterminism.RoomOverridesByDepth[depth] ~= nil then
    if RoomDeterminism.RoomOverridesByDepth[depth]["Exit" .. RoomDeterminism.CurrentExitForDepth] ~= nil then
      local temp_room_name = RoomDeterminism.RoomOverridesByDepth[depth]["Exit" .. RoomDeterminism.CurrentExitForDepth]
      local biome = GetRoomBiome(temp_room_name)

      -- Only override exits with miniboss rooms if we haven't yet seen a miniboss this biome
      if not (HasSeenMiniboss(biome) and RoomSetData[biome][temp_room_name].IsMiniBossRoom) then
        DebugPrint({Text = "Override at depth " .. depth .. " and exit " .. RoomDeterminism.CurrentExitForDepth .. " is " .. RoomDeterminism.RoomOverridesByDepth[depth]["Exit" .. RoomDeterminism.CurrentExitForDepth]})
        next_room_name = temp_room_name
      end
    end
  end

  if next_room_name ~= nil then
    local biome = GetRoomBiome(next_room_name)
    next_room_data = RoomSetData[biome][next_room_name]
  end

  RoomDeterminism.CurrentExitForDepth = RoomDeterminism.CurrentExitForDepth + 1
	return next_room_data
end, RoomDeterminism)

ModUtil.WrapBaseFunction("LeaveRoom", function ( baseFunc, currentRun, door )
  -- Reset our naive exit door counter
  RoomDeterminism.CurrentExitForDepth = 1

  baseFunc(currentRun, door)
end, RoomDeterminism)

ModUtil.WrapBaseFunction("StartNewRun", function ( baseFunc, currentRun )
  if config.Enabled and config.RoomGenerationAlgorithm ~= nil then
    RandomSynchronize(3110)
    RoomDeterminism.RoomGenerationAlgorithms[config.RoomGenerationAlgorithm]()
    RoomDeterminism.RunStartingSeed = GetGlobalRng().seed
  end
  return baseFunc(currentRun)
end, RoomDeterminism)
