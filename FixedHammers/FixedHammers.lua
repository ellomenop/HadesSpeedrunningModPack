ModUtil.RegisterMod("FixedHammers")

local config = {
  ModName = "Fixed Hammers",
  UseFixedHammers = true
}

if ModConfigMenu then
  ModConfigMenu.Register(config)
end

function FixedHammers.GetEligibleHammers()
  local eligibleHammers = {}

  local loot = DeepCopyTable( LootData["WeaponUpgrade"] )
  loot.RarityChances = {}
  loot.ForceCommon = true
  for _, hammer in pairs(GetEligibleUpgrades({}, loot, LootData["WeaponUpgrade"])) do
    table.insert(eligibleHammers, hammer.ItemName)
  end

  return eligibleHammers
end

ModUtil.WrapBaseFunction("StartNewRun", function(baseFunc, ...)
  -- initialize everything else first
  baseFunc(...)

  -- reset the mod
  FixedHammers.Hammers = {}
  FixedHammers.NextHammer = 1

  -- determine eligible hammers (for the current weapon)
  local eligibleHammers = GetEligibleHammers()
  for _, name in pairs(eligibleHammers) do
    print(name)
  end

  -- shuffle the hammers, creating two permutations
  FixedHammers.Hammers[1] = FYShuffle(eligibleHammers)
  FixedHammers.Hammers[2] = FYShuffle(eligibleHammers)
end, FixedHammers)

ModUtil.WrapBaseFunction("SetTraitsOnLoot", function(baseFunc, lootData, args)
  if config.UseFixedHammers and FixedHammers.Hammers then
    local hammersInOrder = FixedHammers.Hammers[FixedHammers.NextHammer]
    local eligibleHammers = GetEligibleHammers()
    local upgradeOptions = {}
    for _, hammer in pairs(hammersInOrder) do
      
    end
    return baseFunc(lootData, args)
  else
    return baseFunc(lootData, args)
  end
end, FixedHammers)
