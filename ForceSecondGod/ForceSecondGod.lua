--[[
    ForceSecondGod
    Author:
        SleepSoul (Discord: SleepSoul#6006)
    Dependencies: ModUtil, RCLib
    Force a second god to appear by the point of Tartarus midboss, configurable per aspect.
]]
ModUtil.Mod.Register("ForceSecondGod")
ForceSecondGod.IsGodKeepsake = {
    ForceZeusBoonTrait = true,
    ForcePoseidonBoonTrait = true,
    ForceAphroditeBoonTrait = true,
    ForceArtemisBoonTrait = true,
    ForceDionysusBoonTrait = true,
    ForceAthenaBoonTrait = true,
    ForceAresBoonTrait = true,
    ForceDemeterBoonTrait = true,
}

ModUtil.Path.Wrap( "SetupRoomReward", function( baseFunc, currentRun, room, previouslyChosenRewards, args )
    
    args = args or {}

    CheckPreviousReward( currentRun, room, previouslyChosenRewards, args )

    if room.ChosenRewardType == "Boon" then
        local currentAspect = RCLib.GetAspectName()
        local godToForce = RCLib.EncodeBoonSet(ForceSecondGod.config.AspectSettings[currentAspect])
        local keepsakeCharges = 0
        local isMiniboss = room.IsMiniBossRoom or false
        local excludeLootNames = {}
		if previouslyChosenRewards ~= nil then -- Same vanilla code that prevents duplicate gods
			for i, data in pairs( previouslyChosenRewards ) do
				if data.RewardType == "Boon" then
					table.insert( excludeLootNames, data.ForceLootName )
				end
			end
		end

        if ForceSecondGod.IsGodKeepsake[GameState.LastAwardTrait] then
            for k, data in ipairs(CurrentRun.Hero.Traits) do
                if data.Name == GameState.LastAwardTrait and data.Uses then
                    keepsakeCharges = data.Uses
                end
            end
        end
        
        ForceSecondGod.DumpExcluded = excludeLootNames
        if not CurrentRun.LootTypeHistory[godToForce]
        and isMiniboss 
        and keepsakeCharges <= 0
        and not Contains(excludeLootNames, godToForce) then
            room.ForceLootName = godToForce
        end
    end
    
    baseFunc( currentRun, room, previouslyChosenRewards, args )
end, ForceSecondGod)
