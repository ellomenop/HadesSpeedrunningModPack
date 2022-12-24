ModUtil.Mod.Register("ModdedWarning")

local config = {
  WarningMessage = "MODDED GAME",
  Color = Color.White
}
ModdedWarning.config = config

-- Show a warning below IGT that the game has been modded
function ModdedWarning.showModdedWarning()
    local text_config_table = DeepCopyTable(UIData.CurrentRunDepth.TextFormat)

    PrintUtil.createOverlayLine(
        "ModdedGame",
        config.WarningMessage,
        MergeTables(
            text_config_table,
            {
                x_pos = 1905,
                y_pos = 124,
                color = ModdedWarning.config.Color
            }
        )
    )
end

OnAnyLoad{ function()
  ModdedWarning.showModdedWarning()
end}
