--[[
    DontGetVorimed v1.0
    Authors:
        ellomenop (Discord: ellomenop#2254)
        cgull (Discord: cgull#4469)
    Makes the first boon reward offer all 4 core boons
]]
ModUtil.RegisterMod("DontGetVorimed")

local config = {
    ModName = "Dont Get Vorimed",
    Enabled = true
}
DontGetVorimed.config = config
DontGetVorimed.BoonTakenFlag = nil

-- When the first room is created, set the number of loot choices to 4
-- This will persist until the first boon reward is received or rolled over
ModUtil.WrapBaseFunction("ChooseStartingRoom", function ( baseFunc, currentRun, roomSetName )
  if config.Enabled then
    LootChoiceExt.Choices = 4
    DontGetVorimed.BoonTakenFlag = false
  end
  return baseFunc(currentRun, roomSetName)
end, DontGetVorimed)

ModUtil.WrapBaseFunction("CreateLoot", function( baseFunc, args ) 

  local lootData = args.LootData or LootData[args.Name]
  if config.Enabled and not lootData.GodLoot and not DontGetVorimed.BoonTakenFlag then
    LootChoiceExt.Choices = 3
    LootChoiceExt.LastLootChoices = 3
    local loot = baseFunc(args)
    return loot
  else
    return baseFunc(args)
  end
end, DontGetVorimed)

-- After first boon reward has been selected, return to normal number of choices
ModUtil.WrapBaseFunction("HandleUpgradeChoiceSelection", function ( baseFunc, screen, button )
  if config.Enabled and not DontGetVorimed.BoonTakenFlag then
    if button.Data.God ~= nil then
      LootChoiceExt.Choices = 3
      LootChoiceExt.LastLootChoices = 3
      DontGetVorimed.BoonTakenFlag = true
    else
      -- reset to 4 options after selecting a hammer/chaos before first boon has been taken
      LootChoiceExt.Choices = 4
      LootChoiceExt.LastLootChoices = 4

    end
  end
  
  baseFunc(screen, button)
end, DontGetVorimed)

-- If the player ever rerolls, reduce to 3 options
ModUtil.WrapBaseFunction("DestroyBoonLootButtons", function ( baseFunc, lootData )
  baseFunc(lootData)
  if config.Enabled and lootData.GodLoot and not DontGetVorimed.BoonTakenFlag then
    LootChoiceExt.Choices = 3
    LootChoiceExt.LastLootChoices = 3
    DontGetVorimed.BoonTakenFlag = true
  end

end, DontGetVorimed)