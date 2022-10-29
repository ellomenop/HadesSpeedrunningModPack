ModUtil.Mod.Register("InteractableChaos")

local config = {
  ModName = "Interactable Chaos",
  Enabled = true
}
InteractableChaos.config = config

-- Spawn the chaos interactable and prevent interaction with the normal chaos gate
ModUtil.Path.Wrap("DoUnlockRoomExits", function ( baseFunc, run, room )
  baseFunc(run, room)

  if not config.Enabled then
    return
  end

  -- Check each exit door
  local exitDoorsIPairs = CollapseTableOrdered( OfferedExitDoors )
  for index, door in ipairs( exitDoorsIPairs ) do
    -- If chaos gate, disable the gate from interaction and spawn a boon instead
    if door.Name == "SecretDoor" then
      door.ReadyToUse = false
      UseableOff({ Id = door.ObjectId })
      HideUseButton( door.ObjectId, door )
      CreateLoot({
        LootData = MergeTables(LootData.TrialUpgrade, {
          IsInteractableChaosLoot = true, -- Special flag for this mod
          IgnoreInvincibubbleOnHit = true, -- For case where not enough hp
          UseText = "{I} Get Chaos Boon {#UseTextDamageFormat}(-".. GetSecretDoorCost() .. "{!Icons.Health_Small})"}),
        SpawnPoint = door.ObjectId, -- Spawn the boon on the gate
        DoesNotBlockExit = true}) -- Allow the boon to be skipped
    end
  end
end, InteractableChaos)

-- Prevent chaos gates from unlocking visually
ModUtil.Path.Wrap("ExitDoorUnlockedPresentation", function ( baseFunc, exitDoor )
  -- If this is a chaos gate, do not unlock
  if exitDoor.Name == "SecretDoor" and config.Enabled then
    return
  end

  -- Otherwise proceed as normal
  baseFunc(exitDoor)
end, InteractableChaos)

-- Handling for picking up the special chaos interactable
ModUtil.Path.Wrap("HandleLootPickup", function ( baseFunc, currentRun, loot )
  if loot.IsInteractableChaosLoot and config.Enabled then

    -- Calculate health cost and reduce it to 0 if chaos egg is equipped
    local healthCost = GetSecretDoorCost()
    if HeroHasTrait( "ChaosBoonTrait" ) then
      healthCost = 0
    end

    -- If Zag has enough health to pick up the chaos boon, then loot it normally and take the hp cost
    if CurrentRun.Hero.Health > healthCost then
      -- Only play damaged FX if Zag is actually taking damage
      if healthCost > 0 then
        CreateAnimation({ Name = "SacrificeHealthFx", DestinationId = CurrentRun.Hero.ObjectId })
        Damage( CurrentRun.Hero, { triggeredById = CurrentRun.Hero.ObjectId, DamageAmount = healthCost, PureDamage = true } )
      end
      baseFunc(currentRun, loot)
      -- Removing Chaos visual artifacts
      AdjustRadialBlurDistance({ Fraction = 0, Duration = 2 })
      AdjustRadialBlurStrength({ Fraction = 0, Duration = 2 })
      return

    -- If Zag does not have enough hp, push him away and show a text box saying why he cannot pick up the boon
    else
      RepulseFromObject( loot, { Text = "Not Enough Health", OffsetZ = -70, Scale = 0.65, VoiceLines = HeroVoiceLines.InteractionBlockedVoiceLines, ShadowScale = 0.66 } )
    end
  end

  -- If not chaos loot, run as normal
  baseFunc(currentRun, loot)
end, InteractableChaos)
