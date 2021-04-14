--[[
    DontGetVorimed v1.0
    Authors:
        ellomenop (Discord: ellomenop#2254)
    Makes the first boon reward offer all 4 core boons
]]
ModUtil.RegisterMod("DontGetVorimed")

local config = {
    ModName = "Dont Get Vorimed",
    Enabled = true
}
DontGetVorimed.config = config

-- When the first room is created, set the number of loot choices to 4
-- This will persist until the first boon reward is received or rolled over
ModUtil.WrapBaseFunction("ChooseStartingRoom", function ( baseFunc, currentRun, roomSetName )
  if config.Enabled then
    LootChoiceExt.Choices = 4
  end
  return baseFunc(currentRun, roomSetName)
end, DontGetVorimed)

-- After first boon reward has been selected, return to normal number of choices
ModUtil.WrapBaseFunction("HandleUpgradeChoiceSelection", function ( baseFunc, screen, button )
  if config.Enabled and button.Data.God ~= nil then
    LootChoiceExt.Choices = 3
  end
  baseFunc(screen, button)
end, DontGetVorimed)

-- If the player ever rerolls, reduce to 3 options
ModUtil.WrapBaseFunction("DestroyBoonLootButtons", function ( baseFunc, lootData )
  baseFunc(lootData)
  if config.Enabled and lootData.GodLoot then
    LootChoiceExt.Choices = 3
    LootChoiceExt.LastLootChoices = 3
  end
end, DontGetVorimed)
