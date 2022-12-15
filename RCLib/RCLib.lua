--[[
    RCLib/RunControlLib
    Author:
        SleepSoul (Discord: SleepSoul#6006)

    A set of common utility functions used to modify run events and game content in mods like ChaosControl, EnemyControl, etc.
]]
ModUtil.Mod.Register("RCLib")

function RCLib.GetEligible(inputTable,lookupTable) -- Read a table of bools, returning a table of the names of all that are true. Optionally use a lookup table to convert the names in inputTable.
    local eligible = {}
    for name, bool in pairs(inputTable) do
        if bool then
            if lookupTable ~= nil then
                table.insert(eligible, lookupTable[name])
            else
                table.insert(eligible, name)
            end
        end
    end
    return eligible
end

function RCLib.RemoveIneligibleBools(inputTable, baseTable, lookupTable) -- Read two tables of bools, returning a table with all the values set to true in baseTable minus all the values set to false in inputTable. Optionally use a lookup table to convert the names in inputTable.
    local eligible = {}
    local match = false
    for name, bool in pairs(baseTable) do
        match = false
        if bool then
            if next(inputTable) == nil then
                table.insert(eligible,name)
            else
                for name2, bool2 in pairs(inputTable) do
                    if lookupTable ~= nil and lookupTable[name2] == name and not bool2 then
                        match = true
                    elseif name2 == name and not bool2 then
                        match = true
                    end
                end
                if match == false then
                    table.insert(eligible, name)
                end
            end
        end
    end
    return eligible
end

function RCLib.RemoveIneligibleStrings(inputTable, baseTable, lookupTable) -- Read a table of bools and a table of strings, returning a table with all the strings in baseTable minus all the values set to false in inputTable. Optionally use a lookup table to convert the names in inputTable.
    local eligible = {}
    local match = false
    for _, name in ipairs(baseTable) do
        match = false
        if next(inputTable) == nil then
            table.insert(eligible,name)
        else
            for name2, bool in pairs(inputTable) do
                if lookupTable ~= nil and lookupTable[name2] == name and not bool then
                    match = true
                elseif name2 == name and not bool then
                    match = true
                end
            end
            if match == false then
                table.insert(eligible, name)
            end
        end
    end
    return eligible
end

function RCLib.PopulateMinLength(targetTable, inputTable, minLength) -- Populates a target table with the contents of an input table, repeatedly inserting until a minimum length is reached.
    local i = 0
    while i < minLength do
        for _, name in pairs(inputTable) do
            table.insert(targetTable, name)
            i = i + 1
        end
    end
end

function RCLib.GetAspectName()
    for aspect, name in pairs(RCLib.CodeToName.Aspects) do
		if HeroHasTrait(aspect) then
            return name
        end
    end
end

function RCLib.GetAspectCode()
    for aspect, name in pairs(RCLib.CodeToName.Aspects) do
		if HeroHasTrait(aspect) then
            return aspect
        end
    end
end