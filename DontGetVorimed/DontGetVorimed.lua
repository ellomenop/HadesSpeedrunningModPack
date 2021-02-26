--[[
    DontGetVorimed
    Authors:
    Ellomenop (Discord: ellomenop#2254)
    Makes the first boon reward offer all 4 core boons
]]
ModUtil.RegisterMod("DontGetVorimed")

local config = {
    ModName = "Dont Get Vorimed",
    Enabled = true
}
DontGetVorimed.config = config

-- When the first room is created, set the number of loot choices to 4
ModUtil.WrapBaseFunction("ChooseStartingRoom", function ( baseFunc, currentRun, roomSetName )
  LootChoiceExt.Choices = 4
  return baseFunc(currentRun, roomSetName)
end, DontGetVorimed)

-- After first boon reward has been selected, return to normal number of choices
ModUtil.WrapBaseFunction("HandleUpgradeChoiceSelection", function ( baseFunc, screen, button )
  LootChoiceExt.Choices = 3
  baseFunc(screen, button)
end, DontGetVorimed)

-- If the player ever rerolls, reduce to 3 options
ModUtil.WrapBaseFunction("DestroyBoonLootButtons", function ( baseFunc, lootData )
  baseFunc(lootData)
  LootChoiceExt.Choices = 3
  LootChoiceExt.LastLootChoices = 3
end, DontGetVorimed)
