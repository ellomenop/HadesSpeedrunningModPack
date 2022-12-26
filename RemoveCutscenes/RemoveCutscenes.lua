--[[
    RemoveCutscenes
    Author:
        Museus (Discord: Museus#7777)

    Optionally removes intro and outro cutscenes to runs
]]
ModUtil.Mod.Register("RemoveCutscenes")

local config = {
    ModName = "RemoveCutscenes",
    RemoveIntro = true,
    RemoveOutro = true,
}
RemoveCutscenes.config = config

-- Remove starting cutscene
ModUtil.Path.Wrap("ShowRunIntro", function( baseFunc )
    if config.RemoveIntro then
        return
    end

    baseFunc()
end, RemoveCutscenes)


ModUtil.Path.Wrap("EndEarlyAccessPresentation", function ( baseFunc )
    if config.RemoveOutro then
        CurrentRun.ActiveBiomeTimer = false

        thread( Kill, CurrentRun.Hero )
        wait( 0.15 )

        FadeIn({ Duration = 0.5 })
        return
    end

    baseFunc()
end, RemoveCutscenes)
