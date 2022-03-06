--[[
    RTA Timer
    Author:
        Museus (Discord: Museus#7777)

    Track RTA time and display it below the IGT timer
]]
ModUtil.RegisterMod("RtaTimer")

local config = {
    ModName = "RtaTimer",
    DisplayTimer = true,
    MultiWeapon = false,
}
RtaTimer.config = config

function RtaTimer.FormatElapsedTime(start_time, current_epoch)
    -- Accept a "start" time and "current" time and output it in the format Xh Xm Xs
    -- Can change the "string.format" line to change the output
    local time_since_launch = current_epoch - start_time
    local minutes = 0
    local hours = 0

    local centiseconds = (time_since_launch % 1) * 100
    local seconds = time_since_launch % 60

    -- If it hasn't been over a minute, no reason to do this calculation
    if time_since_launch > 60 then
        minutes = math.floor((time_since_launch % 3600) / 60)
    end

    -- If it hasn't been over an hour, no reason to do this calculation
    if time_since_launch > 3600 then
        hours = math.floor(time_since_launch / 3600)
    end

    -- If it hasn't been over an hour, only display minutes:seconds.centiseconds
    if hours == 0 then
        return string.format("%02d:%02d.%02d", minutes, seconds, centiseconds)
    end

    return string.format("%02d:%02d:%02d.%02d", hours, minutes, seconds, centiseconds)
end


function RtaTimer.UpdateRtaTimer()
    -- If Timer should not be displayed, make sure it's gone but don't kill thread
    -- in case it's enabled in the middle of a run
    if not config.DisplayTimer then
        PrintUtil.destroyScreenAnchor("RtaTimer")
        return
    end

    local current_time = "00:00.00"
    -- If the timer has been reset, it should stay at 00:00.00 until it "starts" again
    if not RtaTimer.TimerWasReset then
        -- Use _worldTime to prevent overusing system calls
        current_time = RtaTimer.FormatElapsedTime(RtaTimer.StartWorldTime, _worldTime + RtaTimer.Offset)
        RtaTimer.Cycle = RtaTimer.Cycle + 1

        -- Update offset every 15 cycles to prevent drift during pauses
        if RtaTimer.Cycle == 15 then
            RtaTimer.Offset = (GetTime({ }) - RtaTimer.StartTime) - (_worldTime - RtaTimer.StartWorldTime)
            current_time = RtaTimer.FormatElapsedTime(RtaTimer.StartTime, GetTime({ }))
            RtaTimer.Cycle = 0
        end
    end

    PrintUtil.createOverlayLine(
        "RtaTimer",
        current_time,
        MergeTables(
            UIData.CurrentRunDepth.TextFormat,
            {
                justification = "left",
                x_pos = 1820,
                y_pos = 90,
            }
        )
    )
end

function RtaTimer.StartRtaTimer()
    RtaTimer.Running = true
    RtaTimer.Cycle = 0
    RtaTimer.Offset = 0.0

    while RtaTimer.Running do
        RtaTimer.UpdateRtaTimer()
        -- Update once per frame
        wait(0.016)
    end
end

function RtaTimer__ResetRtaTimer()
    RtaTimer.TimerWasReset = true
    RtaTimer.UpdateRtaTimer()
end

ModUtil.WrapBaseFunction("WindowDropEntrance", function( baseFunc, ... )
    local val = baseFunc(...)

    -- If single run, timer should always restart
    -- If multiweapon, only restart if timer was reset
    if not config.MultiWeapon or RtaTimer.TimerWasReset then
        RtaTimer.StartTime = GetTime({ })
        RtaTimer.StartWorldTime = _worldTime
        RtaTimer.TimerWasReset = false
    end

    thread(RtaTimer.StartRtaTimer)

    return val
end, RtaTimer)

-- Stop timer when Hades dies (but leave it on screen)
ModUtil.WrapBaseFunction("HadesKillPresentation", function( baseFunc, ...)
   RtaTimer.Running = false
   baseFunc(...)
end, RtaTimer)

ModUtil.LoadOnce(
    function()
        -- If not in a run, reset timer and prepare for run start
        if ModUtil.PathGet("CurrentDeathAreaRoom") then
            RtaTimer.TimerWasReset = true

        -- If in a run, just start the timer from the time the mod was loaded
        else
            RtaTimer.TimerWasReset = false
            RtaTimer.StartTime = GetTime({ })
            RtaTimer.StartWorldTime = _worldTime
            thread(RtaTimer.StartRtaTimer)
        end
    end
)
