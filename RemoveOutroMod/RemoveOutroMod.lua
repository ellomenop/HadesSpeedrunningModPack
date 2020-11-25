ModUtil.RegisterMod("RemoveOutroMod")

ModUtil.BaseOverride("EndEarlyAccessPresentation", function ()
	CurrentRun.ActiveBiomeTimer = false
	
	thread( Kill, CurrentRun.Hero )
	wait( 0.15 )

	FadeIn({ Duration = 0.5 })
end, RemoveOutroMod)