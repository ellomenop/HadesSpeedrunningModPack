ModUtil.RegisterMod("ColorblindMod")

local config =
{
    TartarusEnabled = false,
    AsphodelEnabled = false,
    ElysiumEnabled = false,
    StyxEnabled = false,

    -- Exclude very specific things like fury assists in the meg fight
    SpeedrunMode = true,
    ExcludeTraps = false,
    ExcludeBreakables = false,
}
ColorblindMod.config = config

local Outlines =
{
    -- Fallback if the biome name is somehow nil
    Default =
    {
        R = 50,
        G = 50,
        B = 255,
        Opacity = 0.8,
        Thickness = 1,
        Threshold = 0.6,
    },
    Tartarus =
    {
        R = 50,
        G = 50,
        B = 255,
        Opacity = 0.8,
        Thickness = 1,
        Threshold = 0.6,
    },
    Asphodel =
    {
        R = 50,
        G = 50,
        B = 255,
        Opacity = 0.8,
        Thickness = 1,
        Threshold = 0.6,
    },
    Elysium =
    {
        R = 50,
        G = 50,
        B = 255,
        Opacity = 0.8,
        Thickness = 1,
        Threshold = 0.6,
    },
    Styx =
    {
        R = 50,
        G = 50,
        B = 255,
        Opacity = 0.8,
        Thickness = 1,
        Threshold = 0.6,
    },
    -- Only for Greece, dad fight is in Styx
    Surface =
    {
        R = 50,
        G = 50,
        B = 255,
        Opacity = 0.8,
        Thickness = 1,
        Threshold = 0.6,
    },
}

function IsOutlineLegal(enemy)
    if config.ExcludeTraps and enemy.InheritFrom ~= nil and Contains(enemy.InheritFrom, "BaseTrap") then
        return false
    end

    if config.ExcludeTraps and enemy.InheritFrom ~= nil and Contains(enemy.InheritFrom, "IsNeutral") then
        return false
    end

    if config.ExcludeTraps and enemy.Name == "CharonGhostChargeSource" then
        return false
    end

    if config.ExcludeBreakables and enemy.InheritFrom ~= nil and Contains(enemy.InheritFrom, "BaseBreakable") then
        return false
    end

    if config.SpeedrunMode and enemy.Name == "HarpySupportUnit" then
        return false
    end

    return true
end

ModUtil.WrapBaseFunction("CreateLevelDisplay", function ( baseFunc, newEnemy, currentRun )
  local biome = CurrentRun.CurrentRoom.RoomSetName

  if ColorblindMod.config[(biome or "nil") .. "Enabled"] and IsOutlineLegal(newEnemy) then
      newEnemy.Outline = Outlines[CurrentRun.CurrentRoom.RoomSetName] or Outlines.Default
      newEnemy.Outline.Id = newEnemy.ObjectId
      AddOutline( newEnemy.Outline )
  end
  baseFunc(newEnemy, currentRun)
end, ColorblindMod)

ModUtil.BaseOverride("DoEnemyHealthBufferDeplete", function ( enemy )
	if enemy.OnHealthBufferDepleteFunctionName ~= nil then
		_G[enemy.OnHealthBufferDepleteFunctionName]( enemy )
	end
  -- Mod start
  local biome = CurrentRun.CurrentRoom.RoomSetName
  if not ColorblindMod.config[(biome or "nil") .. "Enabled"] then
    RemoveOutline({ Id = enemy.ObjectId })
  end
  -- Mod end
  if enemy.TetherIds ~= nil then
		for k, tetherId in ipairs( enemy.TetherIds ) do
			RemoveOutline({ Id = tetherId })
		end
	end
	if not enemy.WasImmuneToStunWithoutArmor then
		SetUnitProperty({ Property = "ImmuneToStun", Value = false, DestinationId = enemy.ObjectId })
	end
	ApplyEffectFromWeapon({ Id = CurrentRun.Hero.ObjectId, DestinationId = enemy.ObjectId, WeaponName = "ArmorBreakAttack", EffectName = "ArmorBreakStun" })
end, ColorblindMod)

OnAnyLoad{function ()
    local biome = ModUtil.SafeGet(_G, ModUtil.PathToIndexArray("CurrentRun.CurrentRoom.RoomSetName"))
    while ColorblindMod.config[(biome or "nil") .. "Enabled"] do
	    local ammoIds = GetIdsByType({ Name = "AmmoPack" })
        if ammoIds ~= nil then
            for _, id in pairs (ammoIds) do
                local outline = Outlines[CurrentRun.CurrentRoom.RoomSetName] or Outlines.Default
                outline.Id = id
                AddOutline( outline )
            end
        end
        wait(1)
    end
end}

ModUtil.WrapBaseFunction( "HarpyKillPresentation", function(baseFunc, unit, args)
    RemoveOutline({ Id = unit.ObjectId})
    return baseFunc(unit, args)
end)

ModUtil.WrapBaseFunction( "HydraKillPresentation", function(baseFunc, unit, args)
    RemoveOutline({ Id = unit.ObjectId})
    return baseFunc(unit, args)
end)

ModUtil.WrapBaseFunction( "HydraKillPresentation", function(baseFunc, unit, args)
    RemoveOutline({ Id = unit.ObjectId})
    return baseFunc(unit, args)
end)

ModUtil.WrapBaseFunction( "TheseusMinotaurKillPresentation", function(baseFunc, unit, args)
    RemoveOutline({ Id = unit.ObjectId})
    return baseFunc(unit, args)
end)

ModUtil.WrapBaseFunction( "CrawlerMiniBossKillPresentation", function(baseFunc, unit, args)
    RemoveOutline({ Id = unit.ObjectId})
    return baseFunc(unit, args)
end)

ModUtil.WrapBaseFunction( "HadesKillPresentation", function(baseFunc, unit, args)
    RemoveOutline({ Id = unit.ObjectId})
    return baseFunc(unit, args)
end)

ModUtil.WrapBaseFunction( "KillPresentation", function(baseFunc, victim, args)
    RemoveOutline({ Id = victim.ObjectId})
    return baseFunc(victim, args)
end)

ModUtil.WrapBaseFunction( "DeathPresentation", function(baseFunc, currentRun, killer, killingUnitWeapon )
    RemoveOutline({ Id = currentRun.Hero.ObjectId})
    return baseFunc(currentRun, killer, killingUnitWeapon )
end)

ModUtil.WrapBaseFunction( "BoatToDeathAreaTransition", function(baseFunc, unit, args)
    RemoveOutline({ Id = CurrentRun.Hero.ObjectId})
    return baseFunc(unit, args)
end)

ModUtil.WrapBaseFunction( "SurfaceDeathPresentation", function(baseFunc, unit, args)
    RemoveOutline({ Id = CurrentRun.Hero.ObjectId})
    return baseFunc(unit, args)
end)
