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
  B_MiniBoss02 = "Witches",
  C_MiniBoss01 = "Asterius",
  C_MiniBoss02 = "Soul Catcher",
  D_MiniBoss01 = "Satyr",
  D_MiniBoss02 = "Rat Thug",
  -- TODO: Find out to individually identify (Probably not possible without breaking modularity with RoomDeterminism)
  D_MiniBoss03 = "Tiny Vermin / Snakestone",
  D_MiniBoss04 = "Bother",
}


ModUtil.WrapBaseFunction("CreateDoorPreviewIcon", function ( baseFunc, exitDoor, args )
  baseFunc(exitDoor, args)

  local room_name = ModUtil.PathGet('RoomData.Name', args) or ""

  -- If the room is a fountain, add a visual effect to the door icon
  if string.match(room_name, "[ABC]_Reprieve") and config.ShowFountainDoorIndictor then
    CreateAnimation({
      Name = "ConsecrationBuffedFront",
      DestinationId = exitDoor.DoorIconFront,
      Color = Color.Turquoise,
      Loop = true})

  -- If the room is a miniboss, add a text label of the miniboss name above the door
  elseif string.find(room_name, "MiniBoss") and DoorVisualIndicators.MiniBossLabels[room_name] ~= nil and config.ShowMinibossDoorIndicator then
    CreateTextBox({
      Id = exitDoor.DoorIconFront,
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
