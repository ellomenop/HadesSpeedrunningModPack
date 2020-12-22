ModUtil.RegisterMod("DoorVisualIndicators")

local config = {
  ShowFountainDoorIndictor = true,
  ShowMinibossDoorIndicator = true
}
DoorVisualIndicators.config = config

DoorVisualIndicators.MiniBossLabels = {
  A_MiniBoss01 = "Bombers",
  A_MiniBoss02 = "Doomstone",
  A_MiniBoss03 = "Sneak",
  A_MiniBoss04 = "Doomstone",
  B_Wrapping01 = "Barge",
  B_MiniBoss01 = "Power Couple",
  B_MiniBoss02 = "4 Witches",
  C_MiniBoss01 = "Asterius",
  C_MiniBoss02 = "Soul Catcher",
  D_MiniBoss01 = "Satyr Cultist",
  D_MiniBoss02 = "Rat Thug",
  -- TODO: Find out how to individually identify (Probably not possible without breaking modularity with RoomDeterminism)
  D_MiniBoss03 = "Tiny Vermin / Snakestone",
  D_MiniBoss04 = "Bother",
}

DoorVisualIndicators.MiniBossAnimations = {
  A_MiniBoss01 = {"Enemy_BloodlessGrenadierIdle"},
  A_MiniBoss02 = {"HeavyRangedSplitterCrystal"},
  A_MiniBoss03 = {"EnemyWretchAssassin_Idle"},
  A_MiniBoss04 = {"HeavyRangedSplitterCrystal"},
  -- "AsphodelWrappingTile01", "AsphodelBoat01", "AsphodelBoatSunkUnlocked",
  B_Wrapping01 = {"HealRangedCrystal4"},
  B_MiniBoss01 = {"CrusherUnitIdle", "EnemyMedusaHeadIdle"},
  B_MiniBoss02 = {"EnemyWretchCasterIdle_SpreadShot"}, -- x4 and make closer together?
  C_MiniBoss01 = {"Minotaur_Idle"},
  C_MiniBoss02 = {"SoulSpawnerIdle"},
  D_MiniBoss01 = {"SatyrMinibossIdle"},
  D_MiniBoss02 = {"EnemyRatThugIdle"},
  -- TODO: Find out how to individually identify (Probably not possible without breaking modularity with RoomDeterminism)
  D_MiniBoss03 = {"EnemyCrawlerIdle", "HeavyRangedForkedCrystal4"},
  D_MiniBoss04 = {"EnemyStyxThiefIdle"},
}

ModUtil.WrapBaseFunction("CreateDoorPreviewIcon", function ( baseFunc, exitDoor, args )
  baseFunc(exitDoor, args)

  local room_name = ModUtil.PathGet('RoomData.Name', args) or ""
  local is_miniboss = RoomData[room_name].IsMiniBossRoom or false

  -- If the room is a fountain, add a visual effect to the door icon
  if string.match(room_name, "[ABC]_Reprieve") and config.ShowFountainDoorIndictor then
    CreateAnimation({
      Name = "ConsecrationBuffedFront",
      DestinationId = exitDoor.DoorIconFront,
      Color = Color.Turquoise,
      Loop = true})

  -- If the room is a miniboss, add a text label of the miniboss name above the door and a ghostly preview
elseif is_miniboss and DoorVisualIndicators.MiniBossLabels[room_name] ~= nil and config.ShowMinibossDoorIndicator then
    -- Attach an obstacle to the door that subsequent UI elements can be attached to
    local test = SpawnObstacle({ Name = "BlankGeoObstacle", Group = "Test" })
    table.insert( exitDoor.AdditionalAttractIds, test )
    Attach({ Id = test, DestinationId = exitDoor.DoorIconId, DynamicScaleOffset = true })

    -- Dynamically place the ghosts based on how many will be shown (e.g. power couple have two ghosts)
    local number_of_ghosts = #DoorVisualIndicators.MiniBossAnimations[room_name]
    local angle = -120

    local base_offset = (number_of_ghosts - 1) * -50
    local isometric_adjust_angle = 63
    if IsHorizontallyFlipped({ Id = exitDoor.ObjectId }) then
      angle = -30
      isometric_adjust_angle = -60
    end
    -- For each ghost, draw it above the door
    for num, ghost in ipairs(DoorVisualIndicators.MiniBossAnimations[room_name]) do
      CreateAnimation({ -- TODO: Opacity?
        Name = ghost,
        DestinationId = test,
        Color = Color.Gray,
        OffsetY = (base_offset + (num - 1) * 100) * math.cos(math.rad(isometric_adjust_angle)),
        OffsetX = (base_offset + (num - 1) * 100) * math.sin(math.rad(isometric_adjust_angle)),
        OffsetZ = 100,
        Loop = true})
      SetAngle({ Id = test, Angle = angle })
    end

    -- Add one text label of the miniboss name
    CreateTextBox({
      Id = test,
      Text = DoorVisualIndicators.MiniBossLabels[room_name],
      OffsetY = -20,
      FontSize = 14,
      Font = "AlegreyaSansSCBold",
      ShadowOffset = {0, 2},
      ShadowBlur = 0,
      ShadowColor = {0,0,0,1},
      ShadowOffset = {0, 4},
      OutlineThickness = 2,
      OutlineColor = {0.0, 0.0, 0.0,1}})
  end
end, DoorVisualIndicators)
