ModUtil.RegisterMod("FixedHammers")

local config = {
  ModName = "Fixed Hammers",
  UseFixedHammers = true
}

if ModConfigMenu then
  ModConfigMenu.Register(config)
end

local function GetEligibleHammers()

  local loot = DeepCopyTable( LootData["WeaponUpgrade"] )
  loot.RarityChances = {}
  loot.ForceCommon = true
  return GetEligibleUpgrades({}, loot, LootData["WeaponUpgrade"])
end

ModUtil.WrapBaseFunction("StartNewRun", function(baseFunc, ...)
  -- initialize everything else first
  local run = baseFunc(...)

  -- reset the mod
  FixedHammers.Hammers = {}
  FixedHammers.NextHammer = 1

  -- determine eligible hammers (for the current weapon)
  local eligibleHammers = GetEligibleHammers()

  -- shuffle the hammers, creating two permutations
  FixedHammers.Hammers[1] = FYShuffle(eligibleHammers)
  FixedHammers.Hammers[2] = FYShuffle(eligibleHammers)

  return run
end, FixedHammers)

ModUtil.WrapBaseFunction("SetTraitsOnLoot", function(baseFunc, lootData, args)
  if config.UseFixedHammers and FixedHammers.Hammers then
    local hammersInOrder = FixedHammers.Hammers[FixedHammers.NextHammer]
    FixedHammers.NextHammer = 2

    local eligibleHammers = GetEligibleHammers()
    local upgradeOptions = {}
    local upgradesSelected = 0

    -- pick the first three hammers from the fixed permutation
    for _, currentHammer in pairs(hammersInOrder) do
      for _, eligibleHammer in pairs(eligibleHammers) do
        if currentHammer.ItemName == eligibleHammer.ItemName then
          eligibleHammer.Rarity = "Common"
          table.insert(upgradeOptions, eligibleHammer)
          upgradesSelected = upgradesSelected + 1
          break
        end
      end
      if upgradesSelected == 3 then break end
    end
    lootData.UpgradeOptions = upgradeOptions
  else
    return baseFunc(lootData, args)
  end
end, FixedHammers)
