--[[
    BoonControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Force Olympians and Hammers to provide certain options, either based on how many times they've appeared thus far, or overall.
]]
ModUtil.Mod.Register("BoonControl")

BoonControl.OlympianBoonSets = { -- For our purposes, Hermes is not an Olympian
	"ZeusUpgrade",
	"AthenaUpgrade",
	"PoseidonUpgrade",
	"AresUpgrade",
	"AphroditeUpgrade",
	"ArtemisUpgrade",
	"DionysusUpgrade",
	"DemeterUpgrade",
}

BoonControl.FirstBoonRarityOverride = {
    Rare = 0,
    Epic = 1.0,
    Heroic = 0,
    Legendary = 0,
}

BoonControl.EpicGivenFlag = false

function BoonControl.CreateTraitList(forced, eligible, rarityTable, lookupTable)
	local traitOptions = {}
	local currentTrait = ""
	for trait, _ in pairs( forced ) do
		local currentTrait = forced[trait].Name
		local isValid = false
		if Contains(eligible, currentTrait) or ( BoonControl.config.AllowOverrides and forced[trait].OverridePrereqs ) then
			isValid = true
		end
		if isValid and TableLength( traitOptions ) <= GetTotalLootChoices() then
			local rarityToUse = "Common" 
			if forced[trait].ForcedRarity ~= nil and BoonControl.config.AllowRarityForce then
				rarityToUse = forced[trait].ForcedRarity
			else
				rarityToUse = BoonControl.RollRarityForBoon(currentTrait, rarityTable, lookupTable)
			end
			table.insert(traitOptions, 
				{
					ItemName = lookupTable[currentTrait],
					Type = "Trait",
					Rarity = rarityToUse,
				}
			)
		end
	end
	return traitOptions
end

function BoonControl.RollRarityForBoon(boon, rarityChances, lookupTable)
	local boonName = lookupTable[boon]
	local validRarities =
	{
		Common = false,
		Rare = false,
		Epic = false,
		Heroic = false,
		Legendary = false,
	}
	local rarityLevels = nil

	if TraitData[boonName] ~= nil and TraitData[boonName].RarityLevels ~= nil then
		rarityLevels = TraitData[boonName].RarityLevels
	end
	if ConsumableData[boonName] ~= nil and ConsumableData[boonName].RarityLevels ~= nil then
		rarityLevels = ConsumableData[boonName].RarityLevels
	end

	if rarityLevels == nil then
		rarityLevels = { Common = true }
	end
	BoonControl.RarityLevelDisplay = rarityLevels

	for key, value in pairs( rarityLevels ) do
		if value ~= nil then
			validRarities[key] = true
		end
	end

	local chosenRarity = "Common"
	if validRarities.Legendary and rarityChances.Legendary and RandomChance( rarityChances.Legendary ) then
		chosenRarity = "Legendary"
	elseif validRarities.Heroic and rarityChances.Heroic and RandomChance( rarityChances.Heroic ) then
		chosenRarity = "Heroic"
	elseif validRarities.Epic and rarityChances.Epic and RandomChance( rarityChances.Epic ) then
		chosenRarity = "Epic"
	elseif validRarities.Rare and rarityChances.Rare and RandomChance( rarityChances.Rare ) then
		chosenRarity = "Rare"
	end
	return chosenRarity
end

ModUtil.Path.Wrap("StartNewRun", function ( baseFunc, currentRun )
	BoonControl.EpicGivenFlag = false
    return baseFunc(currentRun)
end, BoonControl)

ModUtil.Path.Wrap( "SetTraitsOnLoot", function(baseFunc, lootData, args)
	if not BoonControl.config.Enabled then
		return baseFunc(lootData, args)
	end

	local upgradeName = lootData.Name
	if upgradeName == "TrialUpgrade" or upgradeName == "StackUpgrade" then -- Chaos and poms respectively- both have different offering mechanics not accounted for here
		return baseFunc(lootData, args)
	end

	local upgradeChoiceData = LootData[upgradeName]
	local PresetData = {}
	local ForcedBoons = nil
	local BoonOptions = {}
	local AppearanceNum = 1
	local OlympiansSeen = 0
	local TryEpicForce = false
	local isEpicForceValid = true
	
	if CurrentRun.LootTypeHistory[upgradeName] ~= nil then
		AppearanceNum = CurrentRun.LootTypeHistory[upgradeName]
	end
	if lootData.Name == "HermesUpgrade" and not BoonControl.config.AllowHermesControl then
		return baseFunc(lootData, args)
	end
	if upgradeName == "WeaponUpgrade" and BoonControl.config.AllowedHammerControl < AppearanceNum then
		return baseFunc(lootData, args)
	end

	if lootData.GodLoot and BoonControl.config.FirstBoonAlwaysEpic and not BoonControl.EpicGivenFlag then
		TryEpicForce = true
	elseif lootData.GodLoot and BoonControl.config.FirstBoonEpicOnPride and GameState.MetaUpgradesSelected[11] == "EpicBoonDropMetaUpgrade" and not BoonControl.EpicGivenFlag then
		TryEpicForce = true
	end
	if BoonControl.EpicGivenFlag and lootData.OverriddenRarityChances then
		lootData.RarityChances = lootData.OverriddenRarityChances -- Stores the base rarity table; this is restored upon reroll
	end
	if TryEpicForce then
		for god, seen in pairs(CurrentRun.LootTypeHistory) do
			if BoonControl.OlympianBoonSets[god] then
				OlympiansSeen = OlympiansSeen + 1
			end
			if math.min(1,OlympiansSeen) > 1 then
				isEpicForceValid = false -- If we've already interacted with an Olympian so far, this isn't our first boon and doesn't need to be epic.
			end
		end
		if isEpicForceValid then
			lootData.OverriddenRarityChances = lootData.RarityChances
			lootData.RarityChances = BoonControl.FirstBoonRarityOverride
		elseif lootData.OverriddenRarityChances then
			lootData.RarityChances = lootData.OverriddenRarityChances
		end
	end

	if Contains(BoonControl.OlympianBoonSets, lootData.Name) and not BoonControl.config.AllowOlympianControl then
		return baseFunc(lootData, args)
	end

	for aspect, data in pairs(BoonControl.config.AspectSettings) do
		if HeroHasTrait(RCLib.EncodeAspect(aspect)) and data ~= nil then
			if upgradeName == "WeaponUpgrade" and data.HammerSetting ~= nil then
				PresetData = data.HammerSetting -- Hammer settings are stored directly in aspect settings, as eligibility varies a lot btwn aspects
			elseif data.BoonSetting ~= nil then
				PresetData = BoonControl.BoonPresets[data.BoonSetting][RCLib.DecodeBoonSet(upgradeName)] -- Boon settings are standardised into named presets
			end
		end
	end

	if PresetData == nil then
		return baseFunc(lootData, args)
	end
	if PresetData.ForceOnAppearanceNum ~= nil and PresetData.ForceOnAppearanceNum[AppearanceNum] ~= nil then
		ForcedBoons = PresetData.ForceOnAppearanceNum[AppearanceNum] -- Prioritise per-appearance forces over the default, TODO more conditions?
	elseif PresetData.ForceDefault ~= nil then
		ForcedBoons = PresetData.ForceDefault
	end

	if ForcedBoons == nil then
		return baseFunc(lootData, args)
	end

	local EligibleUpgradeSet = GetEligibleUpgrades(upgradeOptions, lootData, upgradeChoiceData)
	local EligibleList = {}
	if upgradeName == "WeaponUpgrade" then
		for key, hammer in pairs(EligibleUpgradeSet) do
			table.insert(EligibleList, RCLib.DecodeHammer(hammer.ItemName))
		end
		BoonOptions = BoonControl.CreateTraitList(ForcedBoons, EligibleList, lootData.RarityChances, RCLib.NameToCode.Hammers)
	else
		for key, boon in pairs(EligibleUpgradeSet) do
			table.insert(EligibleList, RCLib.DecodeBoon(boon.ItemName))
		end
		BoonOptions = BoonControl.CreateTraitList(ForcedBoons, EligibleList, lootData.RarityChances, RCLib.NameToCode.Boons)
	end
	
	if IsEmpty( BoonOptions ) and BoonControl.config.UseSpareWealth then -- Failsafe; can be triggered by errors in presets but also by no forced boons being eligible
		table.insert(BoonOptions, { ItemName = "FallbackMoneyDrop", Type = "Consumable", Rarity = "Common" })
	elseif IsEmpty( BoonOptions ) then
		return baseFunc(lootData, args)
	end

	lootData.UpgradeOptions = BoonOptions
end, RunStartControl)

ModUtil.Path.Wrap("HandleUpgradeChoiceSelection", function ( baseFunc, screen, button )
    if BoonControl.config.Enabled and not BoonControl.EpicGivenFlag and #GetAllUpgradeableGodTraits() == 0 then
        if button.Data.God ~= nil then
			BoonControl.EpicGivenFlag = true -- Upon selecting any boon, set the flag to true
		end
    end

    baseFunc(screen, button)
end, BoonControl)

ModUtil.WrapBaseFunction("DestroyBoonLootButtons", function ( baseFunc, lootData )
    if BoonControl.config.FirstBoonAlwaysEpic or BoonControl.config.FirstBoonEpicOnPride and lootData.GodLoot and not BoonControl.EpicGivenFlag then
        BoonControl.EpicGivenFlag = true -- Upon rerolling any boon, set the flag to true
    end
	if lootData.OverriddenRarityChances then
		lootData.RarityChances = lootData.OverriddenRarityChances -- Restore base rarities if they exist
	end
    baseFunc(lootData)
end, BoonControl)
