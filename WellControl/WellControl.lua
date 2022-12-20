--[[
    WellControl
    Authors:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Change the eligible offerings from wells, allowing items to be removed.
]]
ModUtil.Mod.Register("WellControl")

local config = {
    WellSetting = "Vanilla"
}
WellControl.config = config

WellControl.Presets = { -- Any fields not defined will just use vanilla options; Fields defined as empty will be treated as such
    Vanilla = {},
    Hypermodded = {
        Traits = {
            TroveTracker = false,
            SkeletalLure = false,
        },
        Consumables = {
            TingeOfErebus = false,
            GaeasTreasure = false,
        },
        TwistTraits = {
            TroveTracker = false,
            SkeletalLure = false,
        },
    },
    OnlyIxions = {
        Traits = {
            LightOfIxion = true,
        },
        Consumables = {
            FatefulTwist = true,
        },
        TwistTraits = {
            LightOfIxion = true,
        },
        TwistConsumables = {},
    },
    OnlyIchors = {
        Traits = {
            IgnitedIchor = true,
        },
        Consumables = {
            FatefulTwist = true,
        },
        TwistTraits = {
            IgnitedIchor = true,
        },
        TwistConsumables = {},
    }
}

WellControl.InheritVanilla = { -- Fields set to true will inherit the vanilla set and only remove those set to false, fields set to false will start from 0 and only add those set to true. If unspecified, assumes false
    Hypermodded = {
        Traits = true,
        Consumables = true,
        TwistTraits = true,
    },
}

WellControl.EligibleHealingItems = {}
WellControl.VanillaHealingItems = {}
WellControl.EligibleOptions = {
    Traits = {},
    Consumables = {},
    TwistTraits = {},
    TwistConsumables = {},
}
WellControl.VanillaOptions = {
    Traits = {},
    Consumables = {},
    TwistTraits = {},
    TwistConsumables = {},
}

function WellControl.ReadPreset() -- Read current preset and create tables of items marked eligible.
    WellControl.EligibleHealingItems = {}
    WellControl.EligibleOptions = {
        Traits = {},
        Consumables = {},
        TwistTraits = {},
        TwistConsumables = {},
    }
    local Preset = {}
    local InheritVanilla = {}
    if WellControl.Presets[config.WellSetting] ~= nil then
        Preset = WellControl.Presets[config.WellSetting]
    end
    if WellControl.InheritVanilla[config.WellSetting] ~= nil then
        InheritVanilla = WellControl.InheritVanilla[config.WellSetting]
    end

    if Preset.HealingItems ~= nil then
        local eligible = {}
        for itemNum, data in ipairs(Preset.HealingItems) do
            local item = {}
            local isValid = true

            item.Name = RCLib.EncodeWellItem(data.Name)
            if TraitData[item.Name] then
                item.Type = "Trait"
            elseif ConsumableData[item.Name] then
                item.Type = "Consumable"
            else
                isValid = false -- Do not add item if its name does not resolve into Trait/ConsumableData
            end
            item.Weight = data.Weight or 1

            if isValid then
                table.insert(eligible, item)
            end
        end
        WellControl.EligibleHealingItems = eligible
    else
        WellControl.EligibleHealingItems = WellControl.VanillaHealingItems
    end

    for itemType, data in pairs(WellControl.EligibleOptions) do
        WellControl.EligibleOptions[itemType] = RCLib.BuildList( Preset[itemType], WellControl.VanillaOptions[itemType], InheritVanilla[itemType], RCLib.NameToCode.WellItems )
    end
end

function WellControl.UpdateOfferings() --Inject eligible items into table of well options in StoreData
    DebugPrint({Text = "Well preset: "..WellControl.config.WellSetting})
    ModUtil.Table.MergeKeyed(StoreData.RoomShop.HealingOffers, {
        Min = WellControl.Presets[WellControl.config.WellSetting].MinHeals or Min,
        Max = WellControl.Presets[WellControl.config.WellSetting].MaxHeals or Max,
        WeightedList = WellControl.EligibleHealingItems,
    })
    ModUtil.Table.MergeKeyed(StoreData, {
        RoomShop = {
            Traits = WellControl.EligibleOptions.Traits,
            Consumables = WellControl.EligibleOptions.Consumables,
        }
    })
    ModUtil.Table.MergeKeyed(ConsumableData.RandomStoreItem, {
        UseFunctionArgs = {
            Traits = WellControl.EligibleOptions.TwistTraits,
            Consumables = WellControl.EligibleOptions.TwistConsumables,
        }
    })
    DebugPrint({Text = "Updated well offerings"})
end

ModUtil.LoadOnce( function()
    WellControl.VanillaOptions = {
        Traits = ModUtil.Table.Copy(StoreData.RoomShop.Traits),
        Consumables = ModUtil.Table.Copy(StoreData.RoomShop.Consumables),
        TwistTraits = ModUtil.Table.Copy(ConsumableData.RandomStoreItem.UseFunctionArgs.Traits),
        TwistConsumables = ModUtil.Table.Copy(ConsumableData.RandomStoreItem.UseFunctionArgs.Consumables),
    }
    WellControl.VanillaHealingItems = ModUtil.Table.Copy(StoreData.RoomShop.HealingOffers.WeightedList)
    WellControl.ReadPreset()
    WellControl.UpdateOfferings()
end)

-- When a new run is started, make sure to apply the offering settings
ModUtil.Path.Wrap("StartNewRun", function ( baseFunc, currentRun )
    WellControl.ReadPreset()
    WellControl.UpdateOfferings()
    return baseFunc(currentRun)
end, WellControl)

ModUtil.Path.Context.Wrap("FillInShopOptions", function ( )
    ModUtil.Path.Wrap("GetRandomValueFromWeightedList", function ( baseFunc, weightedList )
        local results = baseFunc(weightedList)
        if results ~= nil then
            return results
        end

        DebugPrint({Text = "No options in weighted list, rebuilding with excluded options..."})
        -- Handling for if not enough eligible healing items are in preset. Can result in illegal offerings but prevents crashes
        local locals = ModUtil.Locals.Stacked()
        local storeData = locals.storeData
        local options = DeepCopyTable(storeData.HealingOffers.WeightedList)
        local newList = {}

        for i, itemData in pairs(options) do
            newList[i] = itemData.Weight
        end
        return baseFunc(newList)
    end, WellControl)
end, WellControl)
