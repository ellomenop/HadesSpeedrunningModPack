RCLib.NameToCode = {
    Aspects = {
        -- Uses in-game names for aspects, format <Aspect><Weapon>.
        -- This avoids confusion with BoonSets in cases like Zeus/Poseidon/Chaos and lines up with how aspects are often referred to in the community. No abbreviations are used for clarity.
        ZagreusSword = "SwordBaseUpgradeTrait",
        NemesisSword = "SwordCriticalParryTrait",
        PoseidonSword = "DislodgeAmmoTrait",
        ArthurSword = "SwordConsecrationTrait",
        ZagreusSpear = "SpearBaseUpgradeTrait",
        AchillesSpear = "SpearTeleportTrait",
        HadesSpear = "SpearWeaveTrait",
        GuanYuSpear = "SpearSpinTravel",
        ZagreusShield = "ShieldBaseUpgradeTrait",
        ZeusShield = "ShieldTwoShieldTrait",
        ChaosShield = "ShieldRushBonusProjectileTrait",
        BeowulfShield = "ShieldLoadAmmoTrait",
        ZagreusBow = "BowBaseUpgradeTrait",
        HeraBow = "BowLoadAmmoTrait",
        ChironBow = "BowMarkHomingTrait",
        RamaBow = "BowBondTrait",
        ZagreusFists = "FistBaseUpgradeTrait",
        TalosFists = "FistVacuumTrait",
        DemeterFists = "FistWeaveTrait",
        GilgameshFists = "FistDetonateTrait",
        ZagreusRail = "GunBaseUpgradeTrait",
        HestiaRail = "GunManualReloadTrait",
        ErisRail = "GunGrenadeSelfEmpowerTrait",
        LuciferRail = "GunLoadedGrenadeTrait",
    },
    Boons = {
        -- Uses in-game names for boons.
        -- Several boons are unused- these are not currently included.
        -- Duos
        BlizzardShot = "BlizzardOrbTrait",
        CalculatedRisk = "SlowProjectileTrait",
        ColdEmbrace = "SelfLaserTrait",
        ColdFusion = "JoltDurationTrait",
        CrystalClarity = "HomingLaserTrait",
        CurseOfDrowning = "PoseidonAresProjectileTrait",
        CurseOfLonging = "CurseSickTrait",
        CurseOfNausea = "PoisonTickRateTrait",
        DeadlyReversal = "ArtemisReflectBuffTrait",
        ExclusiveAccess = "RaritySuperBoost",
        FreezingVortex = "StationaryRiftTrait",
        HeartRend = "HeartsickCritDamageTrait",
        HuntingBlades = "AresHomingTrait",
        IceWine = "IceStrikeArrayTrait",
        LightningPhalanx = "ReboundingAthenaCastTrait",
        LightningRod = "AmmoBoltTrait",
        LowTolerance = "DionysusAphroditeStackIncreaseTrait",
        MercifulEnd = "TriggerCurseTrait",
        MirageShot = "ArtemisBonusProjectileTrait",
        PartingShot = "CastBackstabTrait",
        SeaStorm = "ImpactBoltTrait",
        ScintillatingFeast = "LightningCloudTrait",
        SmolderingAir = "RegeneratingCappedSuperTrait",
        SplittingHeadache = "PoisonCritVulnerabilityTrait",
        StubbornRoots = "NoLastStandRegenerationTrait",
        SweetNectar = "ImprovedPomTrait",
        UnshakableMettle = "StatusImmunityTrait",
        VengefulMood = "AutoRetaliateTrait",
        
        -- Zeus
        LightningStrike = "ZeusWeaponTrait",
        ThunderFlourish = "ZeusSecondaryTrait",
        ElectricShot = "ZeusRangedTrait",
        ThunderFlare = "ShieldLoadAmmo_ZeusRangedTrait",
        ThunderDash = "ZeusRushTrait",
        ZeusAid = "ZeusShoutTrait",
        
        StaticDischarge = "ZeusLightningDebuff",

        StormLightning = "ZeusBonusBounceTrait",
        DoubleStrike = "ZeusBonusBoltTrait",
        HighVoltage = "ZeusBoltAoETrait",
        HeavensVengeance = "RetaliateWeaponTrait",
        LightningReflexes = "PerfectDashBoltTrait",
        CloudedJudgment = "SuperGenerationTrait",
        BillowingStrength = "OnWrathDamageBuffTrait",

        SplittingBolt = "ZeusChargedBoltTrait",

        -- Athena
        DivineStrike = "AthenaWeaponTrait",
        DivineFlourish = "AthenaSecondaryTrait",
        PhalanxShot = "AthenaRangedTrait",
        PhalanxFlare = "ShieldLoadAmmo_AthenaRangedTrait",
        DivineDash = "AthenaRushTrait",
        AthenasAid = "AthenaShoutTrait",

        BlindingFlash = "AthenaBackstabDebuffTrait",

        BrilliantRiposte = "AthenaShieldTrait",
        HolyShield = "AthenaRetaliateTrait",
        SureFooting = "TrapDamageTrait",
        BronzeSkin = "EnemyDamageTrait",
        LastStand = "LastStandHealTrait",
        DeathlessStand = "LastStandDurationTrait",
        ProudBearing = "PreloadSuperGenerationTrait",

        DivineProtection = "ShieldHitTrait",

        -- Poseidon
        TempestStrike = "PoseidonWeaponTrait",
        TempestFlourish = "PoseidonSecondaryTrait",
        FloodShot = "PoseidonRangedTrait",
        FloodFlare = "ShieldLoadAmmo_PoseidonRangedTrait",
        TidalDash = "PoseidonRushTrait",
        PoseidonAid = "PoseidonShoutTrait",

        RazorShoals = "SlipperyTrait",

        BreakingWave = "SlamExplosionTrait",
        TyphoonsFury = "BonusCollisionTrait",
        HydraulicMight = "EncounterStartOffenseBuffTrait",
        SunkenTreasure = "RandomMinorLootDrop",
        OceansBounty = "RoomRewardBonusTrait",
        WavePounding = "BossDamageTrait",
        BoilingPoint = "DefensiveSuperGenerationTrait",
        RipCurrent = "PoseidonShoutDurationTrait",

        SecondWave = "DoubleCollisionTrait",
        HugeCatch = "FishingTrait",

        -- Ares
        CurseOfAgony = "AresWeaponTrait",
        CurseOfPain = "AresSecondaryTrait",
        SlicingShot = "AresRangedTrait",
        SlicingFlare = "ShieldLoadAmmo_AresRangedTrait",
        BladeDash = "AresRushTrait",
        AresAid = "AresShoutTrait",

        BlackMetal = "AresAoETrait",
        EngulfingVortex = "AresDragTrait",
        CurseOfVengeance = "AresRetaliateTrait",
        UrgeToKill = "IncreasedDamageTrait",
        BattleRage = "OnEnemyDeathDamageInstanceBuffTrait",
        BloodFrenzy = "LastStandDamageBonusTrait",
        ImpendingDoom = "AresLongCurseTrait",
        DireMisfortune = "AresLoadCurseTrait",

        ViciousCycle = "AresCursedRiftTrait",

        -- Aphrodite
        HeartbreakStrike = "AphroditeWeaponTrait",
        HeartbreakFlourish = "AphroditeSecondaryTrait",
        CrushShot = "AphroditeRangedTrait",
        PassionFlare = "ShieldLoadAmmo_AphroditeRangedTrait",
        PassionDash = "AphroditeRushTrait",
        AphroditesAid = "AphroditeShoutTrait",

        EmptyInside = "AphroditeDurationTrait",
        BrokenResolve = "AphroditePotencyTrait",
        SweetSurrender = "AphroditeWeakenTrait",
        WaveOfDespair = "AphroditeRetaliateTrait",
        DyingLament = "AphroditeDeathTrait",
        DifferentLeague = "ProximityArmorTrait",
        LifeAffirmation = "HealthRewardBonusTrait",
        BlownKiss = "AphroditeRangedBonusTrait",

        UnhealthyFixation = "CharmTrait",

        -- Artemis
        DeadlyStrike = "ArtemisWeaponTrait",
        DeadlyFlourish = "ArtemisSecondaryTrait",
        TrueShot = "ArtemisRangedTrait",
        HuntersFlare = "ShieldLoadAmmo_ArtemisRangedTrait",
        HunterDash = "ArtemisRushTrait",
        ArtemisAid = "ArtemisShoutTrait",

        HuntersMark = "CritVulnerabilityTrait",

        PressurePoints = "CritBonusTrait",
        SupportFire = "ArtemisSupportingFireTrait",
        ExitWounds = "ArtemisAmmoExitTrait",
        CleanKill = "ArtemisCriticalTrait",
        HideBreaker = "CriticalBufferMultiplierTrait",
        HunterInstinct = "CriticalSuperGenerationTrait",

        FullyLoaded = "MoreAmmoTrait",

        -- Dionysus
        DrunkenStrike = "DionysusWeaponTrait",
        DrunkenFlourish = "DionysusSecondaryTrait",
        TrippyShot = "DionysusRangedTrait",
        TrippyFlare = "ShieldLoadAmmo_DionysusRangedTrait",
        DrunkenDash = "DionysusRushTrait",
        DionysusAid = "DionysusShoutTrait",

        AfterParty = "DoorHealTrait",
        PositiveOutlook = "LowHealthDefenseTrait",
        PremiumVintage = "DionysusGiftDrop",
        StrongDrink = "FountainDamageBonusTrait",
        NumbingSensation = "DionysusSlowTrait",
        PeerPressure = "DionysusSpreadTrait",
        HighTolerance = "DionysusDefenseTrait",
        BadInfluence = "DionysusPoisonPowerTrait",

        BlackOut = "DionysusComboVulnerability",

        -- Demeter
        FrostStrike = "DemeterWeaponTrait",
        FrostFlourish = "DemeterSecondaryTrait",
        CrystalBeam = "DemeterRangedTrait", --BEAM
        IcyFlare = "ShieldLoadAmmo_DemeterRangedTrait",
        MistralDash = "DemeterRushTrait",
        DemetersAid = "DemeterShoutTrait",

        RavenousWill = "ZeroAmmoBonusTrait",
        ArcticBlast = "MaximumChillBlast",
        KillingFreeze = "MaximumChillBonusSlow",
        FrozenTouch = "DemeterRetaliateTrait",
        SnowBurst = "CastNovaTrait",
        NourishedSoul = "HealingPotencyTrait",
        RareCrop = "HarvestBoonDrop",
        GlacialGlare = "DemeterRangedBonusTrait",
        InstantChillKill = "InstantChillKill",

        -- Hermes
        GreatestReflex = "BonusDashTrait",
        HyperSprint = "RushSpeedBoostTrait",
        GreaterHaste = "MoveSpeedTrait",
        QuickRecovery = "RushRallyTrait",
        GreaterEvasion = "DodgeChanceTrait",
        SwiftStrike = "HermesWeaponTrait",
        SwiftFlourish = "HermesSecondaryTrait",
        SideHustle = "ChamberGoldTrait",
        QuickReload = "AmmoReclaimTrait",
        FlurryCast = "RapidCastTrait",
        AutoReload = "AmmoReloadTrait",
        SecondWind = "HermesShoutDodge",
        QuickFavor = "RegeneratingSuperTrait",

        RushDelivery = "SpeedDamageTrait",

        GreaterRecall = "MagnetismTrait",
        BadNews = "UnstoredAmmoDamageTrait",
    },
    BoonSets = {
        Zeus = "ZeusUpgrade",
        Athena = "AthenaUpgrade",
        Poseidon = "PoseidonUpgrade",
        Ares = "AresUpgrade",
        Aphrodite = "AphroditeUpgrade",
        Artemis = "ArtemisUpgrade",
        Dionysus = "DionysusUpgrade",
        Demeter = "DemeterUpgrade",
        Hermes = "HermesUpgrade",
        Chaos = "TrialUpgrade",
        Hammer = "WeaponUpgrade",
        Pom = "StackUpgrade",
    },
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
    },
    Hammers = {
        -- Sword
        WorldSplitter = "SwordHeavySecondStrikeTrait",
        FlurrySlash = "SwordTwoComboTrait",
        ShadowSlash = "SwordBackstabTrait",
        BreachingSlash = "SwordHealthBufferDamageTrait",
        SuperNova = "SwordSecondaryAreaDamageTrait",
        DoubleNova = "SwordSecondaryDoubleAttackTrait",
        DoubleEdge = "SwordDoubleDashAttackTrait",
        CruelThrust = "SwordCriticalTrait",
        PiercingWave = "SwordThrustWaveTrait",
        CursedSlash = "SwordCursedLifeStealTrait",
        HoardingSlash = "SwordGoldDamageTrait",
        DashNova = "SwordBlinkTrait",
        GreaterConsecration = "SwordConsecrationBoostTrait",

        -- Spear
        ExtendingJab = "SpearReachAttack",
        ChainSkewer = "SpearThrowBounce",
        BreachingSkewer = "SpearThrowPenetrate",
        ViciousSkewer = "SpearThrowCritical",
        ChargedSkewer = "SpearThrowElectiveCharge",
        ExplodingLauncher = "SpearThrowExplode",
        MassiveSpin = "SpearSpinDamageRadius",
        QuickSpin = "SpearSpinChargeLevelTime",
        FlurryJab = "SpearAutoAttack",
        SerratedPoint = "SpearDashMultiStrike",
        FlaringSpin = "SpearSpinChargeAreaDamageTrait",
        TripleJab = "SpearAttackPhalanxTrait",
        WingedSerpent = "SpearSpinTravelDurationTrait",

        -- Shield
        DreadFlight = "ShieldThrowFastTrait",
        ExplosiveReturn = "ShieldThrowCatchExplode",
        PulverizingBlow = "ShieldBashDamageTrait",
        DashingWallop = "ShieldDashAOETrait",
        SuddenRush = "ShieldChargeSpeedTrait",
        MinotaurRush = "ShieldPerfectRushTrait",
        BreachingRush = "ShieldChargeHealthBufferTrait",
        ChargedShot = "ShieldRushProjectileTrait",
        ChargedFlight = "ShieldThrowElectiveCharge",
        EmpoweringFlight = "ShieldThrowEmpowerTrait",
        FerociousGuard = "ShieldBlockEmpowerTrait",
        DashingFlight = "ShieldThrowRushTrait",
        UnyieldingDefense = "ShieldLoadAmmoBoostTrait",

        -- Bow
        SniperShot = "BowLongRangeDamageTrait",
        FlurryShot = "BowTapFireTrait",
        PerfectShot = "BowPowerShotTrait",
        RelentlessVolley = "BowSecondaryBarrageTrait",
        PiercingVolley = "BowPenetrationTrait",
        ChargedVolley = "BowSecondaryFocusedFireTrait",
        TripleShot = "BowTripleShotTrait",
        TwinShot = "BowDoubleShotTrait",
        ExplosiveShot = "BowSlowChargeDamageTrait",
        ChainShot = "BowChainShotTrait",
        ConcentratedVolley = "BowConsecutiveBarrageTrait",
        PointBlankShot = "BowCloseAttackTrait",
        RepulseShot = "BowBondBoostTrait",

        -- Rail
        FlurryFire = "GunMinigunTrait",
        DeltaChamber = "GunInfiniteAmmoTrait",
        PiercingFire = "GunArmorPenerationTrait",
        TripleBomb = "GunGrenadeFastTrait",
        SpreadFire = "GunShotgunTrait",
        RocketBomb = "GunExplodingSecondaryTrait",
        TargetingSystem = "GunSlowGrenade",
        ClusterBomb = "GunGrenadeClusterTrait",
        HazardBomb = "GunGrenadeDropTrait",
        RicochetFire = "GunChainShotTrait",
        SeekingFire = "GunHomingBulletTrait",
        GreaterInferno = "GunLoadedGrenadeBoostTrait",
        ConcentratedBeam = "GunLoadedGrenadeLaserTrait",
        FlashFire = "GunLoadedGrenadeSpeedTrait",
        TripleBeam = "GunLoadedGrenadeWideTrait",
        EternalChamber = "GunLoadedGrenadeInfiniteAmmoTrait",

        -- Fist
        LongKnuckle = "FistReachAttackTrait",
        RollingKnuckle = "FistAttackFinisherTrait",
        ConcentratedKnuckle = "FistConsecutiveAttackTrait",
        BreachingCross = "FistDashAttackHealthBufferTrait",
        ExplosiveUpper = "FistDoubleDashSpecialTrait",
        RushKick = "FistTeleportSpecialTrait",
        FlyingCutter = "FistChargeSpecialTrait",
        DrainingCutter = "FistKillTrait",
        QuakeCutter = "FistSpecialLandTrait",
        KineticLauncher = "FistSpecialFireballTrait",
        HeavyKnuckle = "FistHeavyAttackTrait",
        ColossusKnuckle = "FistAttackDefenseTrait",
        RendingClaws = "FistDetonateBoostTrait",
    },
    Keepsakes = {
        LuckyTooth = "ReincarnationTrait",
        BlackShawl = "BackstabAlphaStrikeTrait",
        BoneHourglass = "ShopDurationTrait",
        OldSpikedCollar = "MaxHealthKeepsakeTrait",
        MyrmidonBracer = "DirectionalArmorTrait",
        BrokenSpearpoint = "ShieldAfterHitTrait",
        ShatteredShackle = "VanillaTrait",
        DistantMemory = "DistanceDamageTrait",
        SkullEarring = "LowHealthDamageTrait",
        HarpyFeatherDuster = "LifeOnUrnTrait",
        ChthonicCoinPurse = "BonusMoneyTrait",
        OwlPendant = "ForceAthenaBoonTrait",
        EternalRose = "ForceAphroditeBoonTrait",
        AdamantArrowhead = "ForceArtemisBoonTrait",
        ThunderSignet = "ForceZeusBoonTrait",
        ConchShell = "ForcePoseidonBoonTrait",
        BloodFilledVial = "ForceAresBoonTrait",
        OverflowingCup = "ForceDionysusBoonTrait",
        FrostbittenHorn = "ForceDemeterBoonTrait",
        CosmicEgg = "ChaosBoonTrait",
        PiercedButterfly = "PerfectClearDamageBonusTrait",
        LambentPlume = "FastClearDodgeBonusTrait",
        EvergreenAcorn = "ShieldBossTrait",
        PomBlossom = "ChamberStackTrait",
        SigilOfTheDead = "HadesShoutKeepsake",
    },
    WellItems = {
        -- Uses in-game names for well items.
        -- Several well items are unused; these are not currently included. Patroclus' items, however, are- they will also work correctly when placed in wells.
        LifeEssence = "HealDropRange",
        PriceOfMidas = "DamageSelfDrop",
        KissOfStyx = "LastStandDrop",
        KissOfStyxPremium = "BuffExtraChance", -- exclusive to Patroclus
        TouchOfStyx = "TemporaryLastStandHealTrait",
        TouchOfStyxDark = "UpgradedTemporaryLastStandHealTrait", -- exclusive to Patroclus
        HydraLite = "TemporaryDoorHealTrait",
        HydraLiteGold = "BuffHealing", -- exclusive to Patroclus
        CentaurSoul = "EmptyMaxHealthDrop",
        EyeOfLamia = "TemporaryWeaponLifeOnKillTrait",

        CyclopsJerky = "TemporaryImprovedWeaponTrait",
        CyclopsJerkySelect = "TemporaryImprovedWeaponTrait_Patroclus", -- exclusive to Patroclus
        ChimaeraJerky = "TemporaryImprovedSecondaryTrait",
        BraidOfAtlas = "TemporaryImprovedRangedTrait",
        PrometheusStone = "TemporaryMoreAmmoTrait",
        NemesisCrest = "TemporaryBackstabTrait",
        ErisBangle = "TemporaryAlphaStrikeTrait",
        NailOfTalos = "TemporaryArmorDamageTrait",
        IgnitedIchor = "TemporaryMoveSpeedTrait",
        StygianShard = "TemporaryImprovedTrapDamageTrait",
        AetherNet = "TemporaryPreloadSuperGenerationTrait",
        FlameWheelsRelease = "TemporaryBlockExplodingChariotsTrait",
        YarnOfAriadne = "TemporaryBoonRarityTrait",
        LightOfIxion = "TemporaryForcedSecretDoorTrait",
        TroveTracker = "TemporaryForcedChallengeSwitchTrait",
        SkeletalLure = "TemporaryForcedFishingPointTrait",

        NightSpindle = "KeepsakeChargeDrop",
        FatefulTwist = "RandomStoreItem",
        TingeOfErebus = "MetaDropRange",
        GaeasTreasure = "GemDropRange",
    }
}
RCLib.CodeToName = {
    Aspects = {},
    Boons = {},
    BoonSets = {},
    ChaosBlessings = {},
    ChaosCurses = {},
    Enemies = {},
    EnemySets = {},
    Hammers = {},
    Keepsakes = {},
}

RCLib.CodeToName.Aspects = ModUtil.Table.Transpose(RCLib.NameToCode.Aspects)
RCLib.CodeToName.Boons = ModUtil.Table.Transpose(RCLib.NameToCode.Boons)
RCLib.CodeToName.BoonSets = ModUtil.Table.Transpose(RCLib.NameToCode.BoonSets)
RCLib.CodeToName.ChaosBlessings = ModUtil.Table.Transpose(RCLib.NameToCode.ChaosBlessings)
RCLib.CodeToName.ChaosCurses = ModUtil.Table.Transpose(RCLib.NameToCode.ChaosCurses)
RCLib.CodeToName.Enemies = ModUtil.Table.Transpose(RCLib.NameToCode.Enemies)
RCLib.CodeToName.EnemySets = ModUtil.Table.Transpose(RCLib.NameToCode.EnemySets)
RCLib.CodeToName.Hammers = ModUtil.Table.Transpose(RCLib.NameToCode.Hammers)
RCLib.CodeToName.Keepsakes = ModUtil.Table.Transpose(RCLib.NameToCode.Keepsakes)
RCLib.CodeToName.WellItems = ModUtil.Table.Transpose(RCLib.NameToCode.WellItems)

function RCLib.EncodeAspect(name)
    return RCLib.NameToCode.Aspects[name]
end

function RCLib.DecodeAspect(name)
    return RCLib.CodeToName.Aspects[name]
end

function RCLib.EncodeBoon(name)
    return RCLib.NameToCode.Boons[name]
end

function RCLib.DecodeBoon(name)
    return RCLib.CodeToName.Boons[name]
end

function RCLib.EncodeBoonSet(name)
    return RCLib.NameToCode.BoonSets[name]
end

function RCLib.DecodeBoonSet(name)
    return RCLib.CodeToName.BoonSets[name]
end

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

function RCLib.EncodeHammer(name)
    return RCLib.NameToCode.Hammers[name]
end

function RCLib.DecodeHammer(name)
    return RCLib.CodeToName.Hammers[name]
end

function RCLib.EncodeKeepsake(name)
    return RCLib.NameToCode.Keepsakes[name]
end

function RCLib.DecodeKeepsake(name)
    return RCLib.CodeToName.Keepsakes[name]
end

function RCLib.EncodeWellItem(name)
    return RCLib.NameToCode.WellItems[name]
end

function RCLib.DecodeWellItem(name)
    return RCLib.CodeToName.WellItems[name]
end
