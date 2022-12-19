local config = {
    Enabled = true,
    AllowOlympianControl = false,
    AllowHermesControl = true,
	AllowedHammerControl = 2, -- If 0, don't force hammer, 1, only force first hammer, 2, force both
	AllowRarityForce = false, -- If false, ForcedRarity will not be applied
	AllowOverrides = false, -- If false, boons cannot be forced to appear if ineligible

	FirstBoonAlwaysEpic = false,
	FirstBoonEpicOnPride = true,

	UseSpareWealth = false, -- Use spare wealth as a fallback instead of using the vanilla boon screen
	
	AspectSettings = {
		-- Swords
		ZagreusSword = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "DoubleEdge"}},
					{{Name = "PiercingWave"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		NemesisSword = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "DoubleEdge"}},
					{{Name = "PiercingWave"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		PoseidonSword = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "DoubleEdge"}},
					{{Name = "PiercingWave"}},
				}
			},
			BoonSetting = "CastWeapon"
		},
		ArthurSword = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "DoubleEdge"}},
					{{Name = "PiercingWave"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		-- Spears
		ZagreusSpear = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "FlurryJab"}},
					{{Name = "TripleJab"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		AchillesSpear = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "FlurryJab"}},
					{{Name = "TripleJab"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		HadesSpear = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "ExplosiveLauncher"}},
					{{Name = "ChargedSkewer"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		GuanYuSpear = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "ChargedSkewer"}},
					{{Name = "BreachingSkewer"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		ZagreusShield = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "ChargedShot"}},
					{{Name = "FerociousGuard"}}
				}
			},
			BoonSetting = "FlatDamage"
		},
		ZeusShield = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "ExplosiveReturn"}},
					{{Name = "FerociousGuard"}}
				}
			},
			BoonSetting = "FlatDamage"
		},
		ChaosShield = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "ChargedShot"}},
					{{Name = "FerociousGuard"}}
				}
			},
			BoonSetting = "FlatDamage"
		},
		BeowulfShield = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "ChargedShot"}},
					{{Name = "FerociousGuard"}}
				}
			},
			BoonSetting = "CastWeapon"
		},
		ZagreusBow = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "TwinShot"}},
					{{Name = "FlurryShot"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		HeraBow = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "FlurryShot"}},
					{{Name = "TripleShot"}},
				}
			},
			BoonSetting = "CastWeapon"
		},
		ChironBow = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "ConcentratedVolley"}},
					{{Name = "RelentlessVolley"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		RamaBow = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "TwinShot"}},
					{{Name = "PerfectShot"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		ZagreusFists = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "BreachingCross"}},
					{{Name = "ExplosiveUpper"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		TalosFists = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "BreachingCross"}},
					{{Name = "ExplosiveUpper"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		DemeterFists = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "BreachingCross"}},
					{{Name = "ExplosiveUpper"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		GilgameshFists = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "BreachingCross"}},
					{{Name = "RendingClaws"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		ZagreusRail = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "RocketBomb"}},
					{{Name = "ClusterBomb"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		HestiaRail = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "RocketBomb"}},
					{{Name = "ClusterBomb"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		ErisRail = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "RocketBomb"}},
					{{Name = "ClusterBomb"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
		LuciferRail = {
			HammerSetting = {
				ForceOnAppearanceNum = {
					{{Name = "TripleBomb"}},
					{{Name = "PiercingFire"}},
				}
			},
			BoonSetting = "FlatDamage"
		},
	}
}
BoonControl.config = config --TODO add config option in menu

BoonControl.BoonPresets = {
	Vanilla = {},
	FlatDamage = {
		Hermes = {
			ForceOnAppearanceNum = {
				{
					{Name = "HyperSprint", ForcedRarity = "Epic"},
					{Name = "RushDelivery", ForcedRarity = "Epic"},
					{Name = "GreatestReflex", ForcedRarity = "Epic"},
				},
				{
					{Name = "HyperSprint", ForcedRarity = "Epic"},
					{Name = "RushDelivery", ForcedRarity = "Epic"},
					{Name = "GreatestReflex", ForcedRarity = "Epic"},
				},
				{}
			},
		}
	},
	CastWeapon = {
		Hermes = {
			ForceOnAppearanceNum = {
				{
					{Name = "HyperSprint", ForcedRarity = "Epic"},
					{Name = "RushDelivery", ForcedRarity = "Epic"},
					{Name = "QuickReload", ForcedRarity = "Epic"},
					{Name = "AutoReload", ForcedRarity = "Epic"},
					{Name = "GreatestReflex", ForcedRarity = "Epic"},
				},
				{
					{Name = "HyperSprint", ForcedRarity = "Epic"},
					{Name = "RushDelivery", ForcedRarity = "Epic"},
					{Name = "QuickReload", ForcedRarity = "Epic"},
					{Name = "AutoReload", ForcedRarity = "Epic"},
					{Name = "GreatestReflex", ForcedRarity = "Epic"},
				},
				{}
			},
		}
	}
}