ModUtil.RegisterMod("FixedHammers")

local config = {
  ModName = "Fixed Hammers",
  Enabled = true,
  AchillesRebalance = true,
  NemesisRebalance = true,
}
FixedHammers.config = config

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
  CurrentRun.Hammers = {}

  -- determine eligible hammers (for the current weapon)
  local eligibleHammers = GetEligibleHammers()

  -- shuffle the hammers, creating two permutations
  CurrentRun.Hammers[1] = FYShuffle(eligibleHammers)
  CurrentRun.Hammers[2] = FYShuffle(eligibleHammers)

  if config.AchillesRebalance and HeroHasTrait( "SpearTeleportTrait" ) then
    RemoveValueAndCollapse(CurrentRun.Hammers[1], {Type = "Trait", ItemName = "SpearAutoAttack"})
    table.insert(CurrentRun.Hammers[1], 1, {Type = "Trait", ItemName = "SpearAutoAttack"})
  end

  if config.NemesisRebalance and HeroHasTrait( "SwordCriticalParryTrait" ) then
    RemoveValueAndCollapse(CurrentRun.Hammers[1], {Type = "Trait", ItemName = "SwordDoubleDashAttackTrait"})
    table.insert(CurrentRun.Hammers[1], 1, {Type = "Trait", ItemName = "SwordDoubleDashAttackTrait"})
  end

  return run
end, FixedHammers)

ModUtil.WrapBaseFunction("SetTraitsOnLoot", function(baseFunc, lootData, args)
  if lootData.Name == "WeaponUpgrade" and config.Enabled and CurrentRun.Hammers then
    local previousHammers = CurrentRun.PreviousHammers or 0
    local hammersInOrder = CurrentRun.Hammers[previousHammers + 1]

    if hammersInOrder == nil then
      DebugPrint({Text = "Something went wrong with Fixed Hammers and there are no preset hammers"})
      FixedHammers.Busted = lootData
      return baseFunc(lootData, args)
    end

    local eligibleHammers = GetEligibleHammers()

    for idx, hammer in pairs(hammersInOrder) do
      DebugPrint({Text = idx .. ": " .. hammer.ItemName})
    end
    for _, hammer in pairs(eligibleHammers) do
      DebugPrint({Text = "-- : " .. hammer.ItemName})
    end
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
    baseFunc(lootData, args)
    lootData.UpgradeOptions = upgradeOptions
    FixedHammers.After = lootData
    return
  else
    return baseFunc(lootData, args)
  end
end, FixedHammers)

ModUtil.WrapBaseFunction("AddTraitToHero", function(baseFunc, trait)
  -- Track previous hammers manually because sometimes the SetTraitsOnLoot gets called multiple times
  -- both before AND after the LootHistory gets incremented.  First room hammer does not do this.
  if ModUtil.SafeGet(trait, ModUtil.PathArray("TraitData.Frame")) == "Hammer" then
    CurrentRun.PreviousHammers = (CurrentRun.PreviousHammers or 0) + 1
  end
  baseFunc(trait)
end, FixedHammers)
