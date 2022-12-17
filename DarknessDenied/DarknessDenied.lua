--[[
    DarknessDenied
    Author:
        SleepSoul (Discord: SleepSoul#6006)

    Prevent darkness either from happening instantly (as the first attack of a phase), or from happening at all.
]]
ModUtil.Mod.Register("DarknessDenied")

local config = {
    RemoveDarkness = false, -- If true, RemoveInstadarkness does nothing
    RemoveInstadarkness = false,
}
DarknessDenied.config = config

DarknessDenied.BlockInstadarknessFlag = true

ModUtil.Path.Wrap( "StartRoom", function( baseFunc, currentRun, currentRoom )
    DarknessDenied.BlockInstadarknessFlag = true -- This should always be true at the start of a room
    baseFunc( currentRun, currentRoom )
end, DarknessDenied)

ModUtil.Path.Wrap( "BossStageTransition", function( baseFunc, boss, currentRun, aiStage )
    DarknessDenied.BlockInstadarknessFlag = true
    baseFunc( boss, currentRun, aiStage )
end, DarknessDenied)

ModUtil.Path.Wrap( "IsEnemyWeaponEligible", function( baseFunc, enemy, weaponName )
    if DarknessDenied.config.RemoveDarkness and weaponName == "HadesInvisibility" then
        return false
    elseif DarknessDenied.config.RemoveInstadarkness and weaponName == "HadesInvisibility" and DarknessDenied.BlockInstadarknessFlag then
        DarknessDenied.BlockInstadarknessFlag = false -- We only need to block Instadarkness once; this flag will be set back to true next time he phases
        return false
    end
    return baseFunc( enemy, weaponName )
end, DarknessDenied)
