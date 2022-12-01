RCLib.NameToCode = {
    ChaosBlessings = {
        -- Uses in-game names for blessings and curses.
        -- Several curses and blessings are unused- these are not currently included.
        Strike = "ChaosBlessingMeleeTrait",
        Shot = "ChaosBlessingRangedTrait",
        Grasp = "ChaosBlessingAmmoTrait",
        Soul = "ChaosBlessingMaxHealthTrait",
        Favor = "ChaosBlessingBoonRarityTrait",
        Affluence = "ChaosBlessingMoneyTrait",
        Eclipse = "ChaosBlessingMetapointTrait",
        Flourish = "ChaosBlessingSecondaryTrait",
        Lunge = "ChaosBlessingDashAttackTrait",
        Defiance = "ChaosBlessingExtraChanceTrait",
        Ambush = "ChaosBlessingBackstabTrait",
        Assault = "ChaosBlessingAlphaStrikeTrait",
    },
    ChaosCurses = {
        Paupers = "ChaosCurseNoMoneyTrait",
        Slippery = "ChaosCurseAmmoUseDelayTrait",
        Maimed = "ChaosCursePrimaryAttackTrait",
        Flayed = "ChaosCurseSecondaryAttackTrait",
        Addled = "ChaosCurseCastAttackTrait",
        Caustic = "ChaosCurseDeathWeaponTrait",
        Enshrouded = "ChaosCurseHiddenRoomReward",
        Excruciating = "ChaosCurseDamageTrait",
        Abyssal = "ChaosCurseTrapDamageTrait",
        Atrophic = "ChaosCurseHealthTrait",
        Slothful = "ChaosCurseMoveSpeedTrait",
        Roiling = "ChaosCurseSpawnTrait",
        Halting = "ChaosCurseDashRangeTrait",
    },
    Enemies = {
        -- Uses in-game names for enemies except when a fan name is much more popular.
        -- Elite is referred to as Armored due to this being the more common term.
        -- Unused enemies, bosses, and enemies not in EnemyData are currently not included.
        -- Note that some enemies do not have Super Elite variations, some Elite variations only appear as midbosses, etc.

        -- Tartarus Enemies
        Brimstone = "HeavyRanged",
        Lout = "PunchingBag",
        Numbskull = "Swarmer",
        Pest = "ThiefMineLayer",
        Skullomat = "LightSpawner",
        Thug = "HeavyMelee",
        Witch = "LightRanged",
        Wringer = "DisembodiedHand",

        -- Tartarus Armored
        ArmoredBrimstone = "HeavyRangedElite",
        ArmoredLout = "PunchingBagElite",
        ArmoredNumbskull = "SwarmerElite",
        ArmoredPest = "ThiefMineLayerElite",
        ArmoredSkullomat = "LightSpawnerElite",
        ArmoredThug = "HeavyMeleeElite",
        ArmoredWitch = "LightRangedElite",
        ArmoredWringer = "DisembodiedHandElite",

        -- Tartarus Super Elite
        SuperEliteLout = "PunchingBagSuperElite",
        SuperEliteNumbskull = "SwarmerSuperElite",
        SuperEliteSkullomat = "LightSpawnerSuperElite",
        SuperEliteThug = "HeavyMeleeSuperElite",
        SuperEliteWitch = "LightRangedSuperElite",
        SuperEliteWringer = "DisembodiedHandSuperElite",
        
        SuperEliteDoomstone = "HeavyRangedSplitterSuperElite",

        -- Tartarus Minibosses
        Doomstone = "HeavyRangedSplitterMiniboss",
        DoomstoneFragment = "HeavyRangedSplitterFragment",
        Sneak = "WretchAssassinMiniboss",

        -- Asphodel
        Bloodless = "BloodlessNaked",
        BoneRaker = "BloodlessNakedBerserker",
        WaveMaker = "BloodlessWaveFist",

        BurnFlinger = "BloodlessPitcher",
        InfernoBomber = "BloodlessGrenadier",
        SlamDancer = "BloodlessSelfDestruct",

        Dracon = "RangedBurrower",
        Gorgon = "FreezeShotUnit",
        SkullCrusher = "CrusherUnit",
        Spreader = "SpreadShotUnit",

        -- Asphodel Armored
        ArmoredBloodless = "BloodlessNakedElite",
        ArmoredBoneRaker = "BloodlessNakedBerserkerElite",
        ArmoredWaveMaker = "BloodlessWaveFistElite",

        ArmoredBurnFlinger = "BloodlessPitcherElite",
        ArmoredInfernoBomber = "BloodlessGrenadierElite",
        ArmoredSlamDancer = "BloodlessSelfDestructElite",

        ArmoredDracon = "RangedBurrowerElite",
        ArmoredGorgon = "FreezeShotUnitElite",
        ArmoredSkullomat = "LightSpawnerElite",
        ArmoredSpreader = "SpreadShotUnitElite",

        -- Asphodel Super Elite
        SuperEliteBloodless = "BloodlessNakedSuperElite",
        SuperEliteBurnFlinger = "BloodlessPitcherSuperElite",
        SuperEliteDracon = "RangedBurrowerSuperElite",
        SuperEliteSkullomat = "LightSpawnerSuperElite",
        SuperEliteSpreader = "SpreadShotUnitSuperElite",
        
        SuperEliteMegaGorgon = "HitAndRunUnitSuperElite",

        -- Asphodel Minibosses
        ArmoredSkullCrusher = "CrusherElite",
        MegaGorgon = "HitAndRunUnitElite", --HitAndRunUnit exists but is unused
        MinibossSpreader = "SpreadShotUnitMiniboss",
        BargeVoidstone = "ShieldRangedMiniboss",
        
        -- Elysium Enemies
        Eyeball = "ShadeNaked",
        Bowman = "ShadeBowUnit",
        Shieldsman = "ShadeShieldUnit",
        Spearman = "ShadeSpearUnit",
        Swordsman = "ShadeSwordUnit",

        Chariot = "Chariot",
        Flamewheel = "ChariotSuicide",
        GhostShield = "SupportShields",
        SoulCatcher = "FlurrySpawner",
        Splitter = "SplitShotUnit",
        Voidstone = "ShieldRanged",

        -- Elysium Armored
        ArmoredEyeball = "ShadeNakedElite",
        ArmoredBowman = "ShadeBowUnitElite",
        ArmoredShieldsman = "ShadeShieldUnitElite",
        ArmoredSpearman = "ShadeSpearUnitElite",
        ArmoredSwordsman = "ShadeSwordUnitElite",

        ArmoredChariot = "ChariotElite",
        ArmoredFlamewheel = "ChariotSuicideElite",
        ArmoredSplitter = "SplitShotUnitElite",
        ArmoredVoidstone = "ShieldRangedElite",

        -- Elysium Super Elite
        SuperEliteEyeball = "ShadeNakedSuperElite",
        SuperEliteBowman = "ShadeBowUnitSuperElite",
        SuperEliteShieldsman = "ShadeShieldUnitSuperElite",
        SuperEliteSpearman = "ShadeSpearUnitSuperElite",
        SuperEliteSwordsman = "ShadeSwordUnitSuperElite",

        SuperEliteChariot = "ChariotSuperElite",
        SuperEliteSoulCatcher = "FlurrySpawnerSuperElite",
        SuperEliteVoidstone = "ShieldRangedSuperElite",

        SuperEliteiteButterflyBall = "FlurrySpawnerSuperElite",

        -- Elysium Minibosses
        ButterflyBall = "FlurrySpawnerElite",

        -- Styx Enemies
        Rat = "RatThug",
        TinyRat = "Crawler",
        Satyr = "SatyrRanged",
        Snakestone = "HeavyRangedForked",
        Bother = "ThiefImpulseMineLayer",

        -- Styx Armored
        ArmoredRat = "RatThugElite",
        ArmoredSatyr = "SatyrRangedElite",
        ArmoredSnakestone = "HeavyRangedForkedElite",

        -- Styx Super Elite
        SuperEliteSnakestone = "HeavyRangedForkedSuperElite",

        -- Styx Minibosses
        GiantVermin = "RatThugElite", -- Anthony
        SnakestoneMiniboss = "HeavyRangedForkedMiniboss",
        MegaSatyr = "SatyrRangedMiniboss",
        TinyVermin = "CrawlerMiniboss", -- Tony
    },
    EnemySets = {
        -- There are several unused enemy sets, such as survival rooms for the other two biomes- these are not included.
        Tartarus = "EnemiesBiome1",
        TartarusTrial = "EnemiesBiome1Devotion",
        TartarusSurvival = "EnemiesBiome1Survival",
        TartarusElite = "EnemiesBiome1Hard",
        TartarusThanatos = "EnemiesBiome1Thanatos",
        TartarusErebus = "ShrineChallengeTartarus",

        Asphodel = "EnemiesBiome2",
        AsphodelTrial = "EnemiesBiome2Devotion",
        AsphodelElite = "EnemiesBiome2Hard",
        AsphodelBarge = "EnemiesBiome2Wrapping",
        AsphodelTrove = "EnemiesBiome2Challenge",
        AsphodelThanatos = "EnemiesBiome2Thanatos",
        AsphodelErebus = "ShrineChallengeAsphodel",
        
        HydraHeads = "HydraHeads",

        Elysium = "EnemiesBiome3",
        ElysiumTrial = "EnemiesBiome3Devotion",
        ElysiumElite = "EnemiesBiome3Hard",
        ElysiumErebus = "ShrineChallengeElysium",

        StyxBigRoom = "EnemiesBiome4",
        StyxSmallRoom = "EnemiesBiome4Mini",
        StyxSmallRoomElite = "EnemiesBiome4MiniHard",
        StyxSmallRoomSingle = "EnemiesBiome4MiniSingle",
        StyxMinibossAdds = "EnemiesBiome4MiniBossFodder",

        HadesSmallAdds = "EnemiesHadesSmall",
        HadesLargeAdds = "EnemiesHadesLarge",
        EM4HadesSmallAdds = "EnemiesHadesSmall",
        EM4HadesLargeAdds = "EnemiesHadesLarge",

        ErebusSuperElite = "ShrineChallengeSuperElite",
    }
}
RCLib.CodeToName = {
    ChaosBlessings = {},
    ChaosCurses = {},
    Enemies = {},
    EnemySets = {},
}

RCLib.CodeToName.ChaosBlessings = ModUtil.Table.Transpose(RCLib.NameToCode.ChaosBlessings)
RCLib.CodeToName.ChaosCurses = ModUtil.Table.Transpose(RCLib.NameToCode.ChaosCurses)
RCLib.CodeToName.Enemies = ModUtil.Table.Transpose(RCLib.NameToCode.Enemies)
RCLib.CodeToName.EnemySets = ModUtil.Table.Transpose(RCLib.NameToCode.EnemySets)

function RCLib.EncodeChaosBlessing(name)
    return RCLib.NameToCode.ChaosBlessings[name]
end

function RCLib.DecodeChaosBlessing(name)
    return RCLib.CodeToName.ChaosBlessings[name]
end

function RCLib.EncodeChaosCurse(name)
    return RCLib.NameToCode.ChaosCurses[name]
end

function RCLib.DecodeChaosCurse(name)
    return RCLib.CodeToName.ChaosCurses[name]
end

function RCLib.EncodeEnemy(name)
    return RCLib.NameToCode.Enemies[name]
end

function RCLib.DecodeEnemy(name)
    return RCLib.CodeToName.Enemies[name]
end

function RCLib.EncodeEnemySet(name)
    return RCLib.NameToCode.EnemySets[name]
end

function RCLib.DecodeEnemySet(name)
    return RCLib.CodeToName.EnemySets[name]
end
