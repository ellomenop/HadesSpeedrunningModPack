ModUtil.RegisterMod("EllosBoonSelectorMod")

local config = {
  showPreview = true,
  showChaosPreview = false,
  showNextRoomPreview = false,
  chaosFiltersActive = false,
  boonRarityFiltersActive = false,
}
EllosBoonSelectorMod.config = config

EllosBoonSelectorMod.RarityFilter = {}
EllosBoonSelectorMod.GodFilter = ""
EllosBoonSelectorMod.ChaosFilter = ""
EllosBoonSelectorMod.CurrentHammerIndex = 1

EllosBoonSelectorMod.RarityColors = {Color.BoonPatchCommon, Color.BoonPatchRare, Color.BoonPatchEpic, Color.BoonPatchLegendary}

EllosBoonSelectorMod.BoonGods = {"Aphrodite", "Ares", "Artemis", "Athena", "Demeter", "Dionysus", "Poseidon", "Zeus"}
EllosBoonSelectorMod.ChaosLocations = { "No Chaos", "Room 1 Chaos", "Room 2 Chaos" }
EllosBoonSelectorMod.PriorityBoons = {"WeaponTrait","SecondaryTrait","RangedTrait","RushTrait"}
EllosBoonSelectorMod.PriorityBoonsOrder = {WeaponTrait = 1, SecondaryTrait = 2, RangedTrait = 3, RushTrait = 4}
EllosBoonSelectorMod.PriorityBoonCannonicalNameToCodeName = {
    Attack = "WeaponTrait",
    Special = "SecondaryTrait",
    Dash = "RushTrait",
    Cast = "RangedTrait"
}

EllosBoonSelectorMod.HammerOptions = {
  SwordWeapon1 = {"SwordTwoComboTrait","SwordSecondaryAreaDamageTrait","SwordGoldDamageTrait","SwordBlinkTrait","SwordThrustWaveTrait","SwordHealthBufferDamageTrait","SwordSecondaryDoubleAttackTrait","SwordCriticalTrait","SwordBackstabTrait","SwordDoubleDashAttackTrait","SwordHeavySecondStrikeTrait","SwordCursedLifeStealTrait"},
  SwordWeapon2 = {"SwordTwoComboTrait","SwordSecondaryAreaDamageTrait","SwordGoldDamageTrait","SwordBlinkTrait","SwordThrustWaveTrait","SwordHealthBufferDamageTrait","SwordSecondaryDoubleAttackTrait","SwordCriticalTrait","SwordBackstabTrait","SwordDoubleDashAttackTrait","SwordHeavySecondStrikeTrait","SwordCursedLifeStealTrait"},
  SwordWeapon3 = {"SwordTwoComboTrait","SwordSecondaryAreaDamageTrait","SwordGoldDamageTrait","SwordBlinkTrait","SwordThrustWaveTrait","SwordHealthBufferDamageTrait","SwordSecondaryDoubleAttackTrait","SwordCriticalTrait","SwordBackstabTrait","SwordDoubleDashAttackTrait","SwordHeavySecondStrikeTrait","SwordCursedLifeStealTrait"},
  SwordWeapon4 = {"SwordConsecrationBoostTrait","SwordSecondaryAreaDamageTrait","SwordGoldDamageTrait","SwordBlinkTrait","SwordThrustWaveTrait","SwordHealthBufferDamageTrait","SwordSecondaryDoubleAttackTrait","SwordBackstabTrait","SwordDoubleDashAttackTrait","SwordCursedLifeStealTrait"},
  SpearWeapon1 = {"SpearReachAttack", "SpearAutoAttack", "SpearThrowExplode", "SpearThrowBounce", "SpearThrowPenetrate", "SpearThrowCritical", "SpearSpinDamageRadius", "SpearSpinChargeLevelTime", "SpearDashMultiStrike", "SpearThrowElectiveCharge", "SpearSpinChargeAreaDamageTrait", "SpearAttackPhalanxTrait"},
  SpearWeapon2 = {"SpearReachAttack", "SpearAutoAttack", "SpearThrowPenetrate", "SpearThrowCritical", "SpearSpinDamageRadius", "SpearSpinChargeLevelTime", "SpearDashMultiStrike", "SpearSpinChargeAreaDamageTrait", "SpearAttackPhalanxTrait"},
  SpearWeapon3 = {"SpearReachAttack", "SpearThrowExplode", "SpearThrowBounce", "SpearThrowPenetrate", "SpearThrowCritical", "SpearSpinDamageRadius", "SpearSpinChargeLevelTime", "SpearDashMultiStrike", "SpearThrowElectiveCharge", "SpearSpinChargeAreaDamageTrait", "SpearAttackPhalanxTrait"},
  SpearWeapon4 = {"SpearSpinTravelDurationTrait","SpearReachAttack", "SpearThrowPenetrate", "SpearSpinDamageRadius", "SpearSpinChargeLevelTime", "SpearDashMultiStrike", "SpearThrowElectiveCharge", "SpearSpinChargeAreaDamageTrait", "SpearAttackPhalanxTrait"},
  ShieldWeapon1 = {"ShieldDashAOETrait", "ShieldRushProjectileTrait", "ShieldThrowFastTrait", "ShieldThrowCatchExplode", "ShieldChargeHealthBufferTrait", "ShieldChargeSpeedTrait", "ShieldBashDamageTrait", "ShieldPerfectRushTrait", "ShieldThrowElectiveCharge", "ShieldThrowEmpowerTrait", "ShieldBlockEmpowerTrait", "ShieldThrowRushTrait"},
  ShieldWeapon2 = {"ShieldDashAOETrait", "ShieldRushProjectileTrait", "ShieldThrowFastTrait", "ShieldThrowCatchExplode", "ShieldChargeHealthBufferTrait", "ShieldChargeSpeedTrait", "ShieldBashDamageTrait", "ShieldPerfectRushTrait", "ShieldThrowEmpowerTrait", "ShieldBlockEmpowerTrait", "ShieldThrowRushTrait"},
  ShieldWeapon3 = {"ShieldDashAOETrait", "ShieldRushProjectileTrait", "ShieldThrowCatchExplode", "ShieldChargeHealthBufferTrait", "ShieldChargeSpeedTrait", "ShieldBashDamageTrait", "ShieldPerfectRushTrait", "ShieldThrowEmpowerTrait", "ShieldBlockEmpowerTrait"},
  ShieldWeapon4 = {"ShieldLoadAmmoBoostTrait", "ShieldDashAOETrait", "ShieldRushProjectileTrait", "ShieldThrowFastTrait", "ShieldThrowCatchExplode", "ShieldChargeHealthBufferTrait", "ShieldChargeSpeedTrait", "ShieldBashDamageTrait", "ShieldPerfectRushTrait", "ShieldThrowElectiveCharge", "ShieldThrowEmpowerTrait", "ShieldBlockEmpowerTrait", "ShieldThrowRushTrait"},
  BowWeapon1 = {"BowDoubleShotTrait", "BowLongRangeDamageTrait", "BowSlowChargeDamageTrait", "BowTapFireTrait", "BowPenetrationTrait", "BowPowerShotTrait", "BowSecondaryBarrageTrait", "BowTripleShotTrait", "BowSecondaryFocusedFireTrait", "BowChainShotTrait", "BowCloseAttackTrait", "BowConsecutiveBarrageTrait"},
  BowWeapon2 = {"BowDoubleShotTrait", "BowLongRangeDamageTrait", "BowSlowChargeDamageTrait", "BowTapFireTrait", "BowPenetrationTrait", "BowPowerShotTrait", "BowSecondaryBarrageTrait", "BowTripleShotTrait", "BowChainShotTrait", "BowCloseAttackTrait", "BowConsecutiveBarrageTrait"},
  BowWeapon3 = {"BowDoubleShotTrait", "BowLongRangeDamageTrait", "BowSlowChargeDamageTrait", "BowTapFireTrait", "BowPenetrationTrait", "BowPowerShotTrait", "BowSecondaryBarrageTrait", "BowTripleShotTrait", "BowSecondaryFocusedFireTrait", "BowChainShotTrait", "BowCloseAttackTrait", "BowConsecutiveBarrageTrait"},
  BowWeapon4 = {"BowBondBoostTrait", "BowDoubleShotTrait", "BowLongRangeDamageTrait", "BowSlowChargeDamageTrait", "BowPowerShotTrait", "BowSecondaryBarrageTrait", "BowTripleShotTrait", "BowChainShotTrait", "BowCloseAttackTrait"},
  FistWeapon1 = {"FistReachAttackTrait", "FistDashAttackHealthBufferTrait", "FistTeleportSpecialTrait", "FistDoubleDashSpecialTrait", "FistChargeSpecialTrait", "FistKillTrait", "FistSpecialLandTrait", "FistAttackFinisherTrait", "FistConsecutiveAttackTrait", "FistSpecialFireballTrait", "FistAttackDefenseTrait", "FistHeavyAttackTrait"},
  FistWeapon2 = {"FistReachAttackTrait", "FistDashAttackHealthBufferTrait", "FistKillTrait", "FistSpecialLandTrait", "FistAttackFinisherTrait", "FistConsecutiveAttackTrait", "FistAttackDefenseTrait", "FistHeavyAttackTrait", "FistDoubleDashSpecialTrait"},
  FistWeapon3 = {"FistReachAttackTrait", "FistDashAttackHealthBufferTrait", "FistTeleportSpecialTrait", "FistDoubleDashSpecialTrait", "FistChargeSpecialTrait", "FistKillTrait", "FistAttackFinisherTrait", "FistConsecutiveAttackTrait", "FistSpecialFireballTrait", "FistAttackDefenseTrait", "FistHeavyAttackTrait"},
  FistWeapon4 = {"FistDetonateBoostTrait", "FistSpecialLandTrait", "FistChargeSpecialTrait", "FistConsecutiveAttackTrait", "FistDashAttackHealthBufferTrait", "FistAttackDefenseTrait", "FistTeleportSpecialTrait", "FistDoubleDashSpecialTrait", "FistKillTrait"},
  GunWeapon1 = {"GunSlowGrenade", "GunMinigunTrait", "GunShotgunTrait", "GunExplodingSecondaryTrait", "GunGrenadeFastTrait", "GunArmorPenerationTrait", "GunInfiniteAmmoTrait", "GunGrenadeClusterTrait", "GunGrenadeDropTrait", "GunHeavyBulletTrait", "GunChainShotTrait", "GunHomingBulletTrait"},
  GunWeapon2 = {"GunSlowGrenade", "GunMinigunTrait", "GunShotgunTrait", "GunExplodingSecondaryTrait", "GunGrenadeFastTrait", "GunArmorPenerationTrait", "GunInfiniteAmmoTrait", "GunGrenadeClusterTrait", "GunGrenadeDropTrait", "GunHeavyBulletTrait", "GunChainShotTrait", "GunHomingBulletTrait"},
  GunWeapon3 = {"GunSlowGrenade", "GunMinigunTrait", "GunShotgunTrait", "GunExplodingSecondaryTrait", "GunGrenadeFastTrait", "GunArmorPenerationTrait", "GunInfiniteAmmoTrait", "GunGrenadeClusterTrait", "GunGrenadeDropTrait", "GunHeavyBulletTrait", "GunChainShotTrait", "GunHomingBulletTrait"},
  GunWeapon4 = {"GunLoadedGrenadeBoostTrait", "GunLoadedGrenadeLaserTrait", "GunLoadedGrenadeSpeedTrait", "GunLoadedGrenadeWideTrait", "GunLoadedGrenadeInfiniteAmmoTrait", "GunSlowGrenade", "GunGrenadeFastTrait", "GunArmorPenerationTrait"},
}

--[[
Modified version of SeedControlScreen.lua
]]
ScreenData.SeedControl =
{
  ItemStartX = 1400,
  ItemStartY = 560,
  ItemSpacing = 100,
  EntryYSpacer = 50,
  ItemsPerPage = 12,
  ScrollOffset = 0,
  Digits = { 1, 2, 3, 4, 5, 6 },
}

function OpenRngSeedSelectorScreen(screen, button)
  CloseAdvancedTooltipScreen()
  UseSeedController(CurrentRun.Hero)
end

function UseSeedController( usee, args )
  PlayInteractAnimation( usee.ObjectId )
  UseableOff({ Id = usee.ObjectId })
  StopStatusAnimation( usee )
  local screen = OpenSeedControlScreen()
  UseableOn({ Id = usee.ObjectId })
end

function OpenSeedControlScreen( args )

  local screen = DeepCopyTable( ScreenData.SeedControl )
  screen.Components = {}
  local components = screen.Components
  screen.CloseAnimation = "QuestLogBackground_Out"

  OnScreenOpened({ Flag = screen.Name, PersistCombatUI = true })
  FreezePlayerUnit()
  EnableShopGamepadCursor()
  SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
  SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 8 })
  SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })

  components.ShopBackgroundDim = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_Menu" })
  components.ShopBackgroundSplatter = CreateScreenComponent({ Name = "LevelUpBackground", Group = "Combat_Menu" })
  components.ShopBackground = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_Menu" })

  SetAnimation({ DestinationId = components.ShopBackground.Id, Name = "QuestLogBackground_In", OffsetY = 30 })

  SetScale({ Id = components.ShopBackgroundDim.Id, Fraction = 4 })
  SetColor({ Id = components.ShopBackgroundDim.Id, Color = {0.090, 0.055, 0.157, 0.8} })

  PlaySound({ Name = "/SFX/Menu Sounds/FatedListOpen" })

  wait(0.2)

  -- Title
  CreateTextBox({ Id = components.ShopBackground.Id, Text = "Weave a New Thread?", FontSize = 34, OffsetX = 0, OffsetY = -460, Color = Color.White, Font = "SpectralSCLightTitling", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center" })
  CreateTextBox({ Id = components.ShopBackground.Id, Text = "Beware,  the  Fates  Watch  On  with  a  Single  Judging  Eye,  your  Thread  in  Hand", FontSize = 15, OffsetX = 0, OffsetY = -410, Width = 840, Color = {120, 120, 120, 255}, Font = "CrimsonTextItalic", ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 2}, Justification = "Center" })

  -- Description Box
  --components.DescriptionBox = CreateScreenComponent({ Name = "BlankObstacle", X = 815, Y = 290, Group = "Combat_Menu" })

  local itemLocationX = screen.ItemStartX
  local itemLocationY = screen.ItemStartY

  SeedControlScreenSyncDigits( screen )

  for digit, digitValue in ipairs( screen.Digits ) do
    components["DigitUp"..digit] = CreateScreenComponent({ Name = "ButtonCodexUp", X = itemLocationX, Y = itemLocationY - 100, Scale = 1.0, Sound = "/SFX/Menu Sounds/GeneralWhooshMENU", Group = "Combat_Menu" })
    components["DigitUp"..digit].OnPressedFunctionName = "SeedDigitDown"
    components["DigitUp"..digit].ControlHotkey = "MenuLeft"
    components["DigitUp"..digit].Digit = digit

    local digitKey = "DigitButton"..digit
    components[digitKey] = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1, X = itemLocationX, Y = itemLocationY, Group = "Combat_Menu" })
    components[digitKey].Digit = digit
    AttachLua({ Id = components[digitKey].Id, Table = components[digitKey] })

    CreateTextBox({ Id = components[digitKey].Id,
      Text = digitValue,
      Color = {245, 200, 47, 255},
      FontSize = 48,
      OffsetX = 0, OffsetY = 0,
      Font = "AlegreyaSansSCBold",
      OutlineThickness = 0,
      OutlineColor = {255, 205, 52, 255},
      ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
      })

    components["DigitDown"..digit] = CreateScreenComponent({ Name = "ButtonCodexDown", X = itemLocationX, Y = itemLocationY + 100, Scale = 1.0, Sound = "/SFX/Menu Sounds/GeneralWhooshMENU", Group = "Combat_Menu" })
    components["DigitDown"..digit].OnPressedFunctionName = "SeedDigitUp"
    components["DigitDown"..digit].ControlHotkey = "MenuRight"
    components["DigitDown"..digit].Digit = digit

    itemLocationX = itemLocationX - screen.ItemSpacing
  end

  UpdateDigitDisplay( screen )

  -- Randomize button
  components.RandomizeButton = CreateScreenComponent({ Name = "ButtonDefault", Scale = 1.0, Group = "Combat_Menu", X = 1150, Y = 760 })
  components.RandomizeButton.OnPressedFunctionName = "SeedControlScreenRandomize"
  CreateTextBox({ Id = components.RandomizeButton.Id,
      Text = "Randomize Seed",
      OffsetX = 0, OffsetY = 0,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })

  -- Roll seed for filters button
  components.ClearFiltersButton = CreateScreenComponent({ Name = "ButtonDefault", Scale = 1.0, Group = "Combat_Menu", X = 320, Y = 810 })
  components.ClearFiltersButton.OnPressedFunctionName = "ClearFilters"
  CreateTextBox({ Id = components.ClearFiltersButton.Id,
      Text = "Clear Filters",
      OffsetX = 0, OffsetY = 0,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })

  -- Roll seed for filters button
  components.RollSeedForFiltersButton = CreateScreenComponent({ Name = "ButtonDefault", Scale = 1.0, Group = "Combat_Menu", X = 625, Y = 810 })
  components.RollSeedForFiltersButton.OnPressedFunctionName = "RollSeedForFilters"
  CreateTextBox({ Id = components.RollSeedForFiltersButton.Id,
      Text = "Roll Seed For Filters",
      OffsetX = 0, OffsetY = 0,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })

  components.FiltersTitle = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 475, Y = 520 })
  local displayText = "Filter for a Specific God"
  if EllosBoonSelectorMod.config.boonRarityFiltersActive then 
    displayText = displayText.." and Boon"
  end
  CreateTextBox({ Id = components.FiltersTitle.Id,
      Text = displayText,
      OffsetX = 0, OffsetY = -100,
      FontSize = 28,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })

  -- God filter buttons
  local x = -250
  local y = 30
  for _, god in pairs(EllosBoonSelectorMod.BoonGods) do
    components[god .. "Filter"] = CreateScreenComponent({ Name = "ButtonDefault", Scale = 0.5, Group = "Combat_Menu", X = 500 + x, Y = 450 + y })
    components[god .. "Filter"].OnPressedFunctionName = "ToggleGodFilter"
    components[god .. "Filter"].GodName = god
    CreateTextBox({ Id = components[god .. "Filter"].Id,
        Text = god,
        OffsetX = 0, OffsetY = 0,
        FontSize = 16,
        Color = Color.BoonPatchCommon,
        Font = "AlegreyaSansSCRegular",
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
        Justification = "Center",
        DataProperties =
        {
          OpacityWithOwner = true,
        },
      })

    x = x + 150
    if x > 250 then
      x = -250
      y = y + 50
    end
  end

  if EllosBoonSelectorMod.config.chaosFiltersActive then
    -- Chaos filter buttons
    x = -225
    y = 290
    for _, location in pairs(EllosBoonSelectorMod.ChaosLocations) do
      components[location .. "Filter"] = CreateScreenComponent({ Name = "ButtonDefault", Scale = 0.66, Group = "Combat_Menu", X = 500 + x, Y = 450 + y })
      components[location .. "Filter"].OnPressedFunctionName = "ToggleChaosFilter"
      components[location .. "Filter"].ChaosLocation = location
      CreateTextBox({ Id = components[location .. "Filter"].Id,
          Text = location,
          OffsetX = 0, OffsetY = 0,
          FontSize = 16,
          Color = Color.BoonPatchCommon,
          Font = "AlegreyaSansSCRegular",
          ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
          Justification = "Center",
          DataProperties =
          {
            OpacityWithOwner = true,
          },
        })

      x = x + 200
    end
  end

  -- Rarity filter buttons
  x = -250
  y = 150
  if EllosBoonSelectorMod.config.boonRarityFiltersActive then
      for _, priorityBoon in pairs({"Attack", "Special", "Dash", "Cast"}) do
        components[priorityBoon .. "Filter"] = CreateScreenComponent({ Name = "ButtonDefault", Scale = 0.5, Group = "Combat_Menu", X = 500 + x, Y = 450 + y })
        components[priorityBoon .. "Filter"].OnPressedFunctionName = "CycleRarityFilter"
        components[priorityBoon .. "Filter"].PriorityBoon = EllosBoonSelectorMod.PriorityBoonCannonicalNameToCodeName[priorityBoon]
        CreateTextBox({ Id = components[priorityBoon .. "Filter"].Id,
            Text = priorityBoon,
            OffsetX = 0, OffsetY = 0,
            FontSize = 16,
            Color = Color.White,
            Font = "AlegreyaSansSCRegular",
            ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
            Justification = "Center",
            DataProperties =
            {
              OpacityWithOwner = true,
            },
          })
        x = x + 150
        if x > 250 then
          x = -250
          y = y + 60
        end
      end
  end

  -- Hammer filter button
  x = 480
  y = 675

  components["HammerFilterLeft"] = CreateScreenComponent({ Name = "ButtonCodexDown", X = x - 200, Y = y, Scale = 1.0, Group = "Combat_Menu" })
  SetAngle({ Id = components["HammerFilterLeft"].Id, Angle = -90 })
  SetScale({ Id = components["HammerFilterLeft"].Id, Fraction = .8 })
  components["HammerFilterLeft"].OnPressedFunctionName = "HammerFilterLeft"
  components["HammerFilterRight"] = CreateScreenComponent({ Name = "ButtonCodexDown", X = x + 200, Y = y, Scale = 1.0, Group = "Combat_Menu" })
  SetAngle({ Id = components["HammerFilterRight"].Id, Angle = 90 })
  SetScale({ Id = components["HammerFilterRight"].Id, Fraction = .8 })
  components["HammerFilterRight"].OnPressedFunctionName = "HammerFilterRight"

  components["HammerFilter"] = CreateScreenComponent({ Name = "BlankObstacle", Scale = 0.5, Group = "Combat_Menu", X = x, Y = y })
  EllosBoonSelectorMod.CurrentHammerIndex = 1

  local weapon = GetEquippedWeapon()
  local aspectIndex = GetEquippedWeaponTraitIndex( weapon )
  local hammerIndex = EllosBoonSelectorMod.CurrentHammerIndex
  CreateTextBox({ Id = components["HammerFilter"].Id,
      Text = EllosBoonSelectorMod.HammerOptions[weapon .. aspectIndex][hammerIndex],
      OffsetX = 0, OffsetY = 0,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })

  -- Icon Display
  components.GodIcon = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 550, Y = 665 })
  Attach({ Id = components.GodIcon.Id, DestinationId = components.ShopBackground.Id, OffsetX = 0, OffsetY = 0})
  components.Reward1 = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 1200, Y = 650 })
  CreateTextBox({ Id = components.Reward1.Id,
      Text = "",
      OffsetX = 400, OffsetY = -50,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })
  components.Reward2 = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 1200, Y = 650 })
  CreateTextBox({ Id = components.Reward2.Id,
      Text = "",
      OffsetX = 400, OffsetY = -20,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })
  components.Reward3 = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 1200, Y = 650 })
  CreateTextBox({ Id = components.Reward3.Id,
      Text = "",
      OffsetX = 400, OffsetY = 10,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })
  if EllosBoonSelectorMod.config.showChaosPreview then
    components.ChaosRoomIndicator = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 1200, Y = 650 })
    CreateTextBox({ Id = components.ChaosRoomIndicator.Id,
        Text = "",
        OffsetX = 400, OffsetY = 40,
        FontSize = 22,
        Color = Color.Purple,
        Font = "AlegreyaSansSCRegular",
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
        Justification = "Center",
        DataProperties =
        {
          OpacityWithOwner = true,
        },
      })
  end
  if EllosBoonSelectorMod.config.showNextRoomPreview then
    components.NextRoomNameIndicator = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 1200, Y = 650 })
    CreateTextBox({ Id = components.NextRoomNameIndicator.Id,
      Text = "",
      OffsetX = 400, OffsetY = 70,
      FontSize = 22,
      Color = Color.White,
      Font = "AlegreyaSansSCRegular",
      ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
      Justification = "Center",
      DataProperties =
      {
        OpacityWithOwner = true,
      },
    })
    components.NextRoomRewardIndicator = CreateScreenComponent({ Name = "BlankObstacle", Scale = 1.0, Group = "Combat_Menu", X = 1200, Y = 650 })
    CreateTextBox({ Id = components.NextRoomRewardIndicator.Id,
        Text = "",
        OffsetX = 400, OffsetY = 100,
        FontSize = 22,
        Color = Color.White,
        Font = "AlegreyaSansSCRegular",
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
        Justification = "Center",
        DataProperties =
        {
          OpacityWithOwner = true,
        },
      })
  end

  local roomReward = PredictStartingRoomReward((NextSeeds[1] or 000000))
  UpdateRewardPreview( screen, roomReward )
  ClearFilters(screen)

  -- Close button
  components.CloseButton = CreateScreenComponent({ Name = "ButtonClose", Scale = 0.7, Group = "Combat_Menu" })
  Attach({ Id = components.CloseButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = -6, OffsetY = 456 })
  components.CloseButton.OnPressedFunctionName = "CloseSeedControlScreen"
  components.CloseButton.ControlHotkey = "Cancel"

  wait(0.1)
  --TeleportCursor({ OffsetX = screen.ItemStartX - 30, OffsetY = screen.ItemStartY, ForceUseCheck = true })

  screen.KeepOpen = true
  thread( HandleWASDInput, screen )
  HandleScreenInput( screen )
end

function DoesRewardMatchFilters(roomReward)
  if EllosBoonSelectorMod.ChaosFilter == "No Chaos" and (roomReward.FirstRoomChaos or roomReward.SecondRoomChaos) then
    return false
  elseif EllosBoonSelectorMod.ChaosFilter == "Room 1 Chaos" and not roomReward.FirstRoomChaos then
    return false
  elseif EllosBoonSelectorMod.ChaosFilter == "Room 2 Chaos" and not roomReward.SecondRoomChaos then
    return false
  end

  local targetReward = "Boon"

  if EllosBoonSelectorMod.GodFilter == "" and next(EllosBoonSelectorMod.RarityFilter) == nil then
    targetReward = "Hammer"
  end

  if roomReward.Type == "Boon" then
    -- If looking for a hammer, return false
    if targetReward == "Hammer" then
      return false
    end

    -- God must match filtered god if specified
    if EllosBoonSelectorMod.GodFilter ~= "" and EllosBoonSelectorMod.GodFilter ~= roomReward.BoonData.God then
      return false
    end

    -- Rarities much match all active rarity filters    
    for priorityBoon, rarityFilter in pairs(EllosBoonSelectorMod.RarityFilter) do
      local thisFilterPassed = false;
      for index, boonOption in ipairs(roomReward.BoonData.Options) do
        if boonOption.Blocked == nil then
          if rarityFilter == nil or rarityFilter == 0 then
            thisFilterPassed = true
          elseif rarityFilter > 0 and priorityBoon == PriorityBoonType(boonOption.Boon) and rarityFilter <= boonOption.Rarity then
            thisFilterPassed = true
          end
        end
      end
      -- If any rarity filter fails, return false
      if not thisFilterPassed then
        return false
      end
    end

    -- All filters passed
    return true
  elseif roomReward.Type == "Hammer" then
    -- If looking for a boon, return false
    if targetReward == "Boon" then
      return false
    end

    local weapon = GetEquippedWeapon()
    local aspectIndex = GetEquippedWeaponTraitIndex( weapon )
    local hammerIndex = EllosBoonSelectorMod.CurrentHammerIndex

    for index, hammerOption in ipairs(roomReward.HammerData.Options) do
      if hammerOption.Blocked == nil then
        if hammerOption.Name == EllosBoonSelectorMod.HammerOptions[weapon .. aspectIndex][hammerIndex] then
          return true
        end
      end
    end

    return false
  end
end

function RollSeedForFilters( screen, button )
  local roomReward = nil
  local counter = 0
  local seed = (NextSeeds[1] or 000000)
  repeat
    roomReward = PredictStartingRoomReward(seed + counter)
    counter = counter + 1

    -- Cool spinner visual, but searches much slower
    --wait(.05)
    --UpdateRewardPreview( screen, roomReward )
    --SeedControlScreenSyncDigits( screen )
    --UpdateDigitDisplay( screen )
  until DoesRewardMatchFilters(roomReward) or counter > 1000

  if counter > 1000 then
    -- TODO: tell the user we failed to find a seed
  end

  UpdateRewardPreview( screen, roomReward )
  SeedControlScreenSyncDigits( screen )
  UpdateDigitDisplay( screen )
end

function ClearFilters ( screen, button )
  EllosBoonSelectorMod.GodFilter = ""
  EllosBoonSelectorMod.ChaosFilter = ""
  EllosBoonSelectorMod.RarityFilter = {}

  -- TODO: Use a constant for the priority boons so we don't hardcode them in multiple places
  for _, god in pairs(EllosBoonSelectorMod.BoonGods) do
    ModifyTextBox({ Id = screen.Components[god .. "Filter"].Id, Color = Color.BoonPatchCommon })
  end
  if EllosBoonSelectorMod.config.chaosFiltersActive then
    for _, location in pairs(EllosBoonSelectorMod.ChaosLocations) do
      ModifyTextBox({ Id = screen.Components[location .. "Filter"].Id, Color = Color.BoonPatchCommon })
    end
  end
  if EllosBoonSelectorMod.config.boonRarityFiltersActive then
    for _, priorityBoon in pairs({"Attack", "Special", "Dash", "Cast"}) do
      ModifyTextBox({ Id = screen.Components[priorityBoon .. "Filter"].Id, Color = Color.BoonPatchCommon })
    end
  end
end

function ToggleGodFilter ( screen, button )
  local godName = button.GodName

  EllosBoonSelectorMod.GodFilter = godName

  for _, god in pairs(EllosBoonSelectorMod.BoonGods) do
    if god == godName and EllosBoonSelectorMod.GodFilter then
      ModifyTextBox({ Id = screen.Components[god .. "Filter"].Id, Color = Color.BoonPatchCommon })
    else
      ModifyTextBox({ Id = screen.Components[god .. "Filter"].Id, Color = Color.Gray })
    end
  end
end

function ToggleChaosFilter( screen, button )
  local chaosLocation = button.ChaosLocation
  EllosBoonSelectorMod.ChaosFilter = chaosLocation

  for _, location in pairs(EllosBoonSelectorMod.ChaosLocations) do
    if location == chaosLocation then
      ModifyTextBox({ Id = screen.Components[location .. "Filter"].Id, Color = Color.BoonPatchCommon })
    else
      ModifyTextBox({ Id = screen.Components[location .. "Filter"].Id, Color = Color.Gray })
    end
  end
end

function CycleRarityFilter ( screen, button )
  local priorityBoon = button.PriorityBoon

  local currentFilterLevel = (EllosBoonSelectorMod.RarityFilter[priorityBoon] or 0)
  currentFilterLevel = (currentFilterLevel + 1) % 3
  EllosBoonSelectorMod.RarityFilter[priorityBoon] = currentFilterLevel

  -- CurrentFilterLevel goes from 0 to 2, add 1 to map to rarity values
  ModifyTextBox({ Id = button.Id, Color = EllosBoonSelectorMod.RarityColors[currentFilterLevel + 1] })
end

function HammerFilterLeft ( screen, button )
  local weapon = GetEquippedWeapon()
  local aspectIndex = GetEquippedWeaponTraitIndex( weapon )
  local hammerIndex = EllosBoonSelectorMod.CurrentHammerIndex

  hammerIndex = hammerIndex - 1
  if hammerIndex == 0 then
    hammerIndex = TableLength(EllosBoonSelectorMod.HammerOptions[weapon .. aspectIndex])
  end
  EllosBoonSelectorMod.CurrentHammerIndex = hammerIndex
  ModifyTextBox({Id = screen.Components["HammerFilter"].Id, Text = EllosBoonSelectorMod.HammerOptions[weapon .. aspectIndex][hammerIndex]})
end

function HammerFilterRight ( screen, button )
  local weapon = GetEquippedWeapon()
  local aspectIndex = GetEquippedWeaponTraitIndex( weapon )
  local hammerIndex = EllosBoonSelectorMod.CurrentHammerIndex

  hammerIndex = hammerIndex + 1
  if hammerIndex == TableLength(EllosBoonSelectorMod.HammerOptions[weapon .. aspectIndex]) + 1 then
    hammerIndex = 1
  end
  EllosBoonSelectorMod.CurrentHammerIndex = hammerIndex
  ModifyTextBox({Id = screen.Components["HammerFilter"].Id, Text = EllosBoonSelectorMod.HammerOptions[weapon .. aspectIndex][hammerIndex]})
end

function SeedDigitUp( screen, button )
  local newDigitValue = screen.Digits[button.Digit]
  newDigitValue = newDigitValue - 1
  if newDigitValue < 0 then
    newDigitValue = 9
  end
  screen.Digits[button.Digit] = newDigitValue
  local newSeed = 0
  for digit, digitValue in ipairs( screen.Digits ) do
    newSeed = newSeed + (digitValue * math.pow(10, digit - 1))
  end
  local roomReward = PredictStartingRoomReward(newSeed)
  UpdateRewardPreview( screen, roomReward )
  UpdateDigitDisplay( screen )
end

function SeedDigitDown( screen, button )
  local newDigitValue = screen.Digits[button.Digit]
  newDigitValue = newDigitValue + 1
  if newDigitValue > 9 then
    newDigitValue = 0
  end
  screen.Digits[button.Digit] = newDigitValue
  local newSeed = 0
  for digit, digitValue in ipairs( screen.Digits ) do
    newSeed = newSeed + (digitValue * math.pow(10, digit - 1))
  end
  local roomReward = PredictStartingRoomReward(newSeed)
  UpdateRewardPreview( screen, roomReward )
  UpdateDigitDisplay( screen )
end

function SeedControlScreenSyncDigits( screen )
  local displayNumber = (NextSeeds[1] or 000000)
  if displayNumber ~= nil then
    for digit = 1, #screen.Digits do
      local digitValue = displayNumber % 10
      screen.Digits[digit] = digitValue
      displayNumber = math.floor( displayNumber / 10 )
    end
  end
end

function UpdateDigitDisplay( screen )
  for digit, digitValue in ipairs( screen.Digits ) do
    local digitKey = "DigitButton"..digit
    ModifyTextBox({ Id = screen.Components["DigitButton"..digit].Id, Text = digitValue })
  end
end

function SeedControlScreenRandomize( screen, button )
  local newSeed = RandomInt(0, 999999)
  local roomReward = PredictStartingRoomReward(newSeed)
  UpdateRewardPreview( screen, roomReward )
  SeedControlScreenSyncDigits( screen )
  UpdateDigitDisplay( screen )
end

function CloseSeedControlScreen( screen, button )

  local newSeed = 0
  local place = 1
  for digit, digitValue in ipairs( screen.Digits ) do
    newSeed = newSeed + (digitValue * math.pow(10, digit - 1))
  end

  DisableShopGamepadCursor()
  SetConfigOption({ Name = "FreeFormSelectWrapY", Value = false })
  SetConfigOption({ Name = "FreeFormSelectStepDistance", Value = 16 })
  SetConfigOption({ Name = "FreeFormSelectSuccessDistanceStep", Value = 8 })
  SetAnimation({ DestinationId = screen.Components.ShopBackground.Id, Name = screen.CloseAnimation })
  PlaySound({ Name = "/SFX/Menu Sounds/FatedListClose" })
  CloseScreen( GetAllIds( screen.Components ), 0.1 )
  UnfreezePlayerUnit()
  screen.KeepOpen = false
  OnScreenClosed({ Flag = screen.Name })
end

function IsSecondRoomRewardEligible(requirements, firstRoomReward)
  if requirements.RequiredUpgradeableGodTraits ~= nil and requirements.RequiredUpgradeableGodTraits >= 1 and firstRoomReward ~= "Boon" then
    return false
  end
  if requirements.RequiredMaxWeaponUpgrades ~= nil and requirements.RequiredMaxWeaponUpgrades < 1 and firstRoomReward == "Hammer" then
    return false
  end
  if requirements.RequiredMinDepth ~= nil and requirements.RequiredMinDepth >= 2 then
    return false
  end
  if requirements.RequiredMinBiomeDepth ~= nil and requirements.RequiredMinBiomeDepth >= 2 then
    return false
  end
  if requirements.RequiredFalseCosmetics ~= nil then
    return false
  end
  return true
end

function PredictSecondRoomReward(seedForPrediction, firstRoomReward, firstRoomShrine, secondRoomName)
  RandomSetNextInitSeed( {Seed = seedForPrediction} )
  local rewardStore = "MetaProgress"
  if firstRoomShrine or secondRoomName == "RoomSimple01" then
    rewardStore = "RunProgress"
  end
  local eligibleRewards = {}
  for key, reward in pairs(RewardStoreData[rewardStore]) do
    if IsSecondRoomRewardEligible(reward.GameStateRequirements, firstRoomReward) then
      table.insert(eligibleRewards, key)
    end
  end
  RandomSynchronize(4)
  local selectedKey = GetRandomValue( eligibleRewards )
  local reward = RewardStoreData[rewardStore][selectedKey].Name
  RemoveValueAndCollapse( eligibleRewards, selectedKey )
  local eligibleGods = DeepCopyTable(EllosBoonSelectorMod.BoonGods)
  if reward == "Boon" then
    reward = GetRandomValue( eligibleGods )
    RemoveValueAndCollapse( eligibleGods, reward )
  end
  if firstRoomShrine then
    -- roll for the actual exit second
    RandomSynchronize(4)
    selectedKey = GetRandomValue( eligibleRewards )
    reward = RewardStoreData.RunProgress[selectedKey].Name
    if reward == "Boon" then
      reward = GetRandomValue( eligibleGods )
    end
  end
  return reward
end

--- Takes in a seed and returns the predicted RoomReward object for the starting room.
-- TODO: Update this to use a separate RNG entirely rather than using the current RNG and putting it back again
--
-- @param int seedForPrediction RNG seed to use when predicting the rng calls
-- @param int currentSeed RNG seed to reset to after making the predictions (Optional)
-- @return RoomReward where RoomReward has a {Type} ("Hammer" or "Boon") and the corresponding Data e.g. {BoonData} or {HammerData}
function PredictStartingRoomReward( seedForPrediction, currentSeed )
  local roomReward = {}

  local roomRewardType = PredictRoomRewardType(seedForPrediction, currentSeed)
  roomReward.Type = roomRewardType.Name

  if roomReward.Type == "Boon" then
    roomReward.BoonData = {}
    roomReward.BoonData.God = roomRewardType.God

    -- Get exact boon rewards and rarity and update the menu
    roomReward.BoonData.Options = PredictStartingGodBoonOptions( roomReward.BoonData.God, seedForPrediction, currentSeed )
    roomReward.FirstRoomChaos = PredictChaos(6, seedForPrediction)
    if roomReward.FirstRoomChaos then
      roomReward.FirstRoomShrine = false
    else
      roomReward.FirstRoomShrine = PredictChaos(7, seedForPrediction)
    end
  elseif roomReward.Type == "Hammer" then
    roomReward.HammerData = {}
    local currentWeapon = GetEquippedWeapon()
    roomReward.HammerData.Options = PredictHammerOptionsForWeapon(currentWeapon, GetEquippedWeaponTraitIndex( currentWeapon ), seedForPrediction, currentSeed)
    roomReward.FirstRoomChaos = PredictChaos(5, seedForPrediction)

    if roomReward.FirstRoomChaos then
      roomReward.FirstRoomShrine = false
    else
      roomReward.FirstRoomShrine = PredictChaos(6, seedForPrediction)
    end
  end

  if roomReward.FirstRoomChaos then
    roomReward.SecondRoomChaos = false
  else
    roomReward.SecondRoomChaos = PredictChaos(2, seedForPrediction)
  end

  RandomSynchronize(1) -- Known offset at which the RNG rolls the room
  roomReward.SecondRoomName = GetRandomValue({
    "A_Combat01",
    "A_Combat02",
    "A_Combat03",
    "A_Combat04",
    "A_Combat05",
    "A_Combat06",
    "A_Combat07",
    "A_Combat08A",
    "A_Combat09",
    "A_Combat10",
    "A_Combat12",
    "A_Combat13",
    "A_Combat14",
    "A_Combat15",
    "A_Combat16",
    "A_Combat19",
    "A_Combat21",
    "A_Combat24",
    "RoomSimple01"
  })
  roomReward.SecondRoomReward = PredictSecondRoomReward(
    seedForPrediction,
    roomReward.Type,
    roomReward.FirstRoomShrine,
    roomReward.SecondRoomName)
  return roomReward
end

function GetBlockedIndicesForAP()
  -- Resync and calculate blocked indices from AP
  RandomSynchronize(2)
  local blockedIndices = {}
  for i = 1, 3 do
    table.insert( blockedIndices, i )
  end
  for i = 1, CalcNumLootChoices() do
    RemoveRandomValue( blockedIndices )
  end
  return blockedIndices
end

function GetChaosChance()
  -- TODO: How to retrieve room date for a future room? Just need tile name?
  --local secretChance = room.SecretSpawnChance or RoomData.BaseRoom.SecretSpawnChance
  local secretChance = RoomData.BaseRoom.SecretSpawnChance
  for k, mutator in pairs( GameState.ActiveMutators ) do
    if mutator.SecretSpawnChanceMultiplier ~= nil then
      secretChance = secretChance * mutator.SecretSpawnChanceMultiplier
    end
  end
  return 0.15
end

function PredictFirstRoomChaos(seedForPrediction, currentSeed)
  RandomSetNextInitSeed( {Seed = seedForPrediction} )
  RandomSynchronize(5) -- Known offset at which the RNG rolls reward type
  local chaosPresent = RandomChance(GetChaosChance())

  -- Reset RNG to the pre-call state
  if currentSeed ~= nil then
    RandomSetNextInitSeed( {Seed = currentSeed} )
  end

  return chaosPresent
end

function PredictChaos(offset, seedForPrediction, currentSeed)
  RandomSetNextInitSeed( {Seed = seedForPrediction} )
  RandomSynchronize(offset) -- Known offset at which the RNG rolls reward type
  local chaosPresent = RandomChance(GetChaosChance())

  -- Reset RNG to the pre-call state
  if currentSeed ~= nil then
    RandomSetNextInitSeed( {Seed = currentSeed} )
  end

  return chaosPresent
end

--- Takes in a seed and returns the predicted RoomRewardType object.
-- TODO: Update this to use a separate RNG entirely rather than using the current RNG and putting it back again
--
-- @param int seedForPrediction RNG seed to use when predicting the rng calls
-- @param int currentSeed RNG seed to reset to after making the predictions (Optional)
-- @return RoomRewardType where RoomRewardType has a {Name} ("Hammer" or "Boon") and conditionally a {God}
function PredictRoomRewardType( seedForPrediction, currentSeed )
  local roomRewardType = {}

  -- Save off the current RNG the load the provided seed and offset
  RandomSetNextInitSeed( {Seed = seedForPrediction} )
  RandomSynchronize(4) -- Known offset at which the RNG rolls reward type
  roomRewardType.Name = GetRandomValue({"Boon", "Boon", "Boon", "Hammer"})

  if roomRewardType.Name == "Boon" then
    local godOptions = DeepCopyTable(EllosBoonSelectorMod.BoonGods)
    local rarityTraits = GetHeroTraitValues("RarityBonus", { UnlimitedOnly = false })
    local god = ""
    for i, rarityTraitData in pairs(rarityTraits) do
      if rarityTraitData.RequiredGod ~= nil and rarityTraitData.RequiredGod ~= "TrialUpgrade" then
        god = string.sub(rarityTraitData.RequiredGod, 1, -8)
      end
    end
    if god == "" then
       god = RemoveRandomValue(godOptions)
    end
    roomRewardType.God = god -- God RNG roll will happen at the next offset
  end

  -- Reset RNG to the pre-call state
  if currentSeed ~= nil then
    RandomSetNextInitSeed( {Seed = currentSeed} )
  end

  return roomRewardType
end

--- Takes in a weapon name and seed and returns a list of HammerOption objects.
-- TODO: Update this to use a separate RNG entirely rather than using the current RNG and putting it back again
--
-- @param string weapon The name of the weapon used to find the eligible hammers
-- @param int aspectIndex Index corrseponding to the aspect of the weapon (e.g. 1-4 in order of unlock)
-- @param int seedForPrediction RNG seed to use when predicting the rng calls
-- @param int currentSeed RNG seed to reset to after making the predictions (Optional)
-- @return list<HammerOption> where HammerOption has a {Name}
function PredictHammerOptionsForWeapon( weapon, aspectIndex, seedForPrediction, currentSeed )
  local hammerOptions = {}

  -- Save off the current RNG the load the provided seed and offset
  RandomSetNextInitSeed( {Seed = seedForPrediction} )
  local blockedIndices = GetBlockedIndicesForAP()
  RandomSynchronize(1) -- Offset that when the hammer options start being rolled at

  local eligibleHammers = DeepCopyTable(EllosBoonSelectorMod.HammerOptions[weapon .. aspectIndex])

  local selectedIndexes = TableLength( eligibleHammers )
  for index = 1, 3 do
    hammerOptions[index] = {}
    local selectedHammer = GetRandomValue(eligibleHammers)
    hammerOptions[index].Name = selectedHammer

    -- Remove the picked hammer from the pool of eligible Hammers
    for i, hammer in ipairs(eligibleHammers) do
      if hammer == selectedHammer then
          table.remove(eligibleHammers, i)
          break
      end
    end

  end

  -- Reset RNG to the pre-call state
  if currentSeed ~= nil then
    RandomSetNextInitSeed( {Seed = currentSeed} )
  end

  for _ , value in pairs(blockedIndices) do
    hammerOptions[value].Blocked = true
  end

  return hammerOptions
end

function PriorityBoonType(boon) 
  for _, boonType in pairs(EllosBoonSelectorMod.PriorityBoons) do
    if string.find(boon, boonType) then
      return boonType
    end
  end
  return "No boon type found."
end

--- Takes in a gods name and seed and returns a list of BoonOption objects for the starting room only.
-- TODO: Update this to use a separate RNG entirely rather than using the current RNG and putting it back again
--
-- @param string god The god for which the boon options should be predicted
-- @param int seedForPrediction RNG seed to use when predicting the rng calls
-- @param int currentSeed RNG seed to reset to after making the predictions (Optional)
-- @return list<BoonOption> where BoonOption has a {God}, {Name} and {Rarity} (numeric)
function PredictStartingGodBoonOptions( god, seedForPrediction, currentSeed )
  local startingBoons = {}

  -- Save off the current RNG the load the provided seed and offset
  RandomSetNextInitSeed( {Seed = seedForPrediction} )
  local blockedIndices = GetBlockedIndicesForAP()
  RandomSynchronize(1) -- Offset that when the boons start being rolled at

  -- Checking for Aspect of Beowulf for cast changes, ignoring poseidon/dionysus
  local beowulfFlag = HeroHasTrait("ShieldLoadAmmoTrait") and god ~= "Poseidon" and god ~= "Dionysus"

  -- First room always offers 3 priority boons (selected by excluding one of the 4 options)
  local boonRewards = DeepCopyTable(EllosBoonSelectorMod.PriorityBoons)

  for i, boonReward in ipairs(boonRewards) do
    if boonReward == "RangedTrait" and beowulfFlag then
      boonRewards[3] = "ShieldLoadAmmo_"..god..boonReward
    else
      boonRewards[i] = god..boonReward
    end
  end
  

  local excluded = RemoveRandomValue(boonRewards)
  boonRewards = CollapseTableOrdered(boonRewards)

  local rarities = ElloGetBoonRarityChances(god)
  for index = 1, 3 do
    startingBoons[index] = {}
    startingBoons[index].Boon = boonRewards[index]
    RandomChance(0) -- Legendary isn't possible for starting boons
    if RandomChance(rarities.Epic) then -- Skip Heroic because starting boons can't naturally roll Heroic
      startingBoons[index].Rarity = 2
    elseif RandomChance(rarities.Rare) then
      startingBoons[index].Rarity = 1
    else
      startingBoons[index].Rarity = 0
    end
  end

  -- Reset RNG to the pre-call state
  if currentSeed ~= nil then
    RandomSetNextInitSeed( {Seed = currentSeed} )
  end

  table.sort( startingBoons, function(boon1, boon2) return EllosBoonSelectorMod.PriorityBoonsOrder[PriorityBoonType(boon1.Boon)] < EllosBoonSelectorMod.PriorityBoonsOrder[PriorityBoonType(boon2.Boon)] end)

  for key, value in pairs(blockedIndices) do
    startingBoons[value].Blocked = true
  end
  return startingBoons
end

function ElloGetBoonRarityChances( godName, roomRarityOverride )
  local name = godName
  --local ignoreTempRarityBonus = args.IgnoreTempRarityBonus
  local referencedTable = "BoonData"
  -- "HermesUpgrade" then referencedTable = "HermesData"

  local legendaryRoll = CurrentRun.Hero[referencedTable].LegendaryChance or 0
  local heroicRoll = CurrentRun.Hero[referencedTable].HeroicChance or 0
  local epicRoll = CurrentRun.Hero[referencedTable].EpicChance or 0
  local rareRoll = CurrentRun.Hero[referencedTable].RareChance or 0

  if roomRarityOverride ~= nil then
    legendaryRoll = roomRarityOverride.Legendary or legendaryRoll
    heroicRoll = roomRarityOverride.Heroic or heroicRoll
    epicRoll = roomRarityOverride.EpicChance or epicRoll
    rareRoll =  roomRarityOverride.RareChance or rareRoll
  end

  local metaupgradeRareBoost = GetNumMetaUpgrades( "RareBoonDropMetaUpgrade" ) * ( MetaUpgradeData.RareBoonDropMetaUpgrade.ChangeValue - 1 )
  local metaupgradeEpicBoost = GetNumMetaUpgrades( "EpicBoonDropMetaUpgrade" ) * ( MetaUpgradeData.EpicBoonDropMetaUpgrade.ChangeValue - 1 ) + GetNumMetaUpgrades( "EpicHeroicBoonMetaUpgrade" ) * ( MetaUpgradeData.EpicBoonDropMetaUpgrade.ChangeValue - 1 )
  local metaupgradeLegendaryBoost = GetNumMetaUpgrades( "DuoRarityBoonDropMetaUpgrade" ) * ( MetaUpgradeData.EpicBoonDropMetaUpgrade.ChangeValue - 1 )
  local metaupgradeHeroicBoost = GetNumMetaUpgrades( "EpicHeroicBoonMetaUpgrade" ) * ( MetaUpgradeData.EpicBoonDropMetaUpgrade.ChangeValue - 1 )
  legendaryRoll = legendaryRoll + metaupgradeLegendaryBoost
  heroicRoll = heroicRoll + metaupgradeHeroicBoost
  rareRoll = rareRoll + metaupgradeRareBoost
  epicRoll = epicRoll + metaupgradeEpicBoost

  local rarityTraits = GetHeroTraitValues("RarityBonus", { UnlimitedOnly = false })
  for i, rarityTraitData in pairs(rarityTraits) do
    if rarityTraitData.RequiredGod == nil or rarityTraitData.RequiredGod == name .. "Upgrade" then
      if rarityTraitData.RareBonus then
        rareRoll = rareRoll + rarityTraitData.RareBonus
      end
      if rarityTraitData.EpicBonus then
        epicRoll = epicRoll + rarityTraitData.EpicBonus
      end
      if rarityTraitData.HeroicBonus then
        heroicRoll = heroicRoll + rarityTraitData.HeroicBonus
      end
      if rarityTraitData.LegendaryBonus then
        legendaryRoll = legendaryRoll + rarityTraitData.LegendaryBonus
      end
    end
  end
  return
  {
    Rare = rareRoll,
    Epic = epicRoll,
    Heroic = heroicRoll,
    Legendary = legendaryRoll,
  }
end

function UpdateRewardPreview( screen, roomReward )
  if config.showPreview == false then
    return
  end
  if roomReward.Type == "Boon" then
    SetAnimation({ Name = "BoonSymbol" .. roomReward.BoonData.God .. "Isometric", DestinationId = screen.Components.GodIcon.Id, OffsetX = 640, OffsetY = -45})

    local roomRewardOptions = roomReward.BoonData.Options
    for index, boonOption in ipairs(roomRewardOptions) do
      local color = EllosBoonSelectorMod.RarityColors[boonOption.Rarity + 1]
      if boonOption.Blocked == true then
        color = Color.Red
      end
      ModifyTextBox({ Id = screen.Components["Reward" .. index].Id, Text = boonOption.Boon, Color = color})
    end
  elseif roomReward.Type == "Hammer" then
    SetAnimation({ Name = "WeaponUpgradePreview", DestinationId = screen.Components.GodIcon.Id, OffsetX = 640, OffsetY = -45})
    local hammerOptions = roomReward.HammerData.Options

    for index = 1, 3 do
      local color = Color.BoonPatchCommon
      if hammerOptions[index].Blocked == true then
        color = Color.Red
      end
      ModifyTextBox({ Id = screen.Components["Reward" .. index].Id, Text = hammerOptions[index].Name, Color = color })
    end
  end

  if EllosBoonSelectorMod.config.showChaosPreview then
    if roomReward.FirstRoomChaos then
      ModifyTextBox({ Id = screen.Components.ChaosRoomIndicator.Id, Text = "Room 1 Chaos" })
    elseif roomReward.SecondRoomChaos then
      ModifyTextBox({ Id = screen.Components.ChaosRoomIndicator.Id, Text = "Room 2 Chaos" })
    else
      ModifyTextBox({ Id = screen.Components.ChaosRoomIndicator.Id, Text = "No Chaos" })
    end
  end
  if EllosBoonSelectorMod.config.showNextRoomPreview then
    ModifyTextBox({ Id = screen.Components.NextRoomNameIndicator.Id, Text = roomReward.SecondRoomName})
    ModifyTextBox({ Id = screen.Components.NextRoomRewardIndicator.Id, Text = roomReward.SecondRoomReward})
  end
end

-- Convenient place to add a button to the AdvancedTooltipScreen
ModUtil.WrapBaseFunction("CreatePrimaryBacking", function ( baseFunc )
  local components = ScreenAnchors.TraitTrayScreen.Components

  -- Add button for RNG seed select menu but only between runs
  if ModUtil.PathGet("CurrentDeathAreaRoom") then
    components.RngSeedButton = CreateScreenComponent({ Name = "ButtonDefault", Scale = 1.0, Group = "Combat_Menu_TraitTray", X = CombatUI.TraitUIStart + 105, Y = 930 })
    components.RngSeedButton.OnPressedFunctionName = "OpenRngSeedSelectorScreen"
    CreateTextBox({ Id = components.RngSeedButton.Id,
        Text = "Set Starting Boon",
        OffsetX = 0, OffsetY = 0,
        FontSize = 22,
        Color = Color.White,
        Font = "AlegreyaSansSCRegular",
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
        Justification = "Center",
        DataProperties =
        {
          OpacityWithOwner = true,
        },
      })
    Attach({ Id = components.RngSeedButton.Id, DestinationId = components.RngSeedButton, OffsetX = 500, OffsetY = 500 })
  end
  baseFunc()
end, EllosBoonSelectorMod)