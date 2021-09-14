--[[
    RemoveCutscenes
    Author:
        Museus (Discord: Museus#7777)

    Optionally removes intro and outro cutscenes to runs
]]
ModUtil.RegisterMod("RemoveCutscenes")

local config = {
    ModName = "RemoveCutscenes",
    RemoveIntro = true,
    RemoveOutro = true,
}
RemoveCutscenes.config = config

-- Remove starting cutscene
ModUtil.WrapBaseFunction("ShowRunIntro", function( baseFunc )
    if RemoveCutscenes.config.RemoveIntro then
        return
    end

    baseFunc()
end, RemoveCutscenes)


ModUtil.WrapBaseFunction("EndEarlyAccessPresentation", function ( baseFunc )
    if Removeconfig.RemoveOutro then
        CurrentRun.ActiveBiomeTimer = false

        thread( Kill, CurrentRun.Hero )
        wait( 0.15 )

        FadeIn({ Duration = 0.5 })
        return
    end

    baseFunc()
end, RemoveCutscenes)
