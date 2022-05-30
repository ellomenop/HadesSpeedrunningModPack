ModUtil.RegisterMod("RunHistoryWipe")

local config = {
    Enabled = true
}
RunHistoryWipe.Config = config

RunHistoryWipe.AspectRecords = {}
RunHistoryWipe.ConfirmButtonCount = 0

function RunHistoryWipe.PressWipeRunHistoryButton()
    if ModUtil.PathGet("CurrentDeathAreaRoom") then
        if RunHistoryWipe.ConfirmButtonCount < 4 and RunHistoryWipe.Config.Enabled then
            RunHistoryWipe.ConfirmButtonCount = RunHistoryWipe.ConfirmButtonCount + 1
        else
            RunHistoryWipe.WipeRunHistory()
            ModUtil.Hades.PrintOverhead("Run History Wiped!", 5)
        end
    else
        ModUtil.Hades.PrintOverhead("Can't Wipe History Here...", 2)
    end
end

function RunHistoryWipe.WipeRunHistory()
    GameState.ConsecutiveClears = 0
    RunHistoryWipe.AspectRecords = {}
    local NewRunHistory = {}

    for k, run in ipairs( GameState.RunHistory ) do
        if run.Cleared then
            local clear_time = run.GameplayTime or 99999
            local clear_heat = run.ShrinePointsCache or 0

            local aspect = nil
            if run.TraitCache ~= nil then
                for trait_name, count in pairs(run.TraitCache) do
                    if PassesTraitFilter("GameStats_Aspects", trait_name) then
                        aspect = trait_name
                    end
                end
            end
            if aspect then
                RunHistoryWipe.AspectRecords[aspect] = RunHistoryWipe.AspectRecords[aspect] or {Speed = {GameplayTime = 99999}, Heat = {ShrinePointsCache = -1}}
                if clear_time < RunHistoryWipe.AspectRecords[aspect].Speed.GameplayTime then
                    RunHistoryWipe.AspectRecords[aspect].Speed = run
                end
                if clear_heat > RunHistoryWipe.AspectRecords[aspect].Heat.ShrinePointsCache then
                    RunHistoryWipe.AspectRecords[aspect].Heat = run
                end
            end
        end
    end

    for aspect, records in pairs(RunHistoryWipe.AspectRecords) do
       if records.Speed.Cleared then
            table.insert(NewRunHistory, records.Speed)
           --DebugPrint({Text="Inserting: "..aspect.." Time: "..records.Speed.GameplayTime})
       end
       if records.Heat.Cleared then
            table.insert(NewRunHistory, records.Heat)
            --DebugPrint({Text="Inserting: "..aspect.." Heat: "..records.Heat.ShrinePointsCache})
       end
    end
    --local blank_runs = {{Cleared = true, RunDepthCache = 0, ActivationRecord = {}}}
    while TableLength(NewRunHistory) < 50 do
        table.insert(NewRunHistory, 1, {Cleared = true, RunDepthCache = 0})
    end

    --NewRunHistory = ConcatTableValues(blank_runs, NewRunHistory)
    GameState.RunHistory = DeepCopyTable(NewRunHistory)
    if not GameState.RunHistory[#GameState.RunHistory].ActivationRecord then
        GameState.RunHistory[#GameState.RunHistory].ActivationRecord = {}
    end
    GameState.LastRemembranceCompletedRunCount = 0
    GameState.LastEmployeeOfTheMonthChange = 0
    RunHistoryWipe.ConfirmButtonCount = 0
end