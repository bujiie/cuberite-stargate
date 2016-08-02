--
-- User: brian.ujiie
-- Date: 7/26/16
--

function OnKilled(Victim, TDI, DeathMessage)
    -- If the victim is not a player, who cares???
    if(not(Victim:IsPlayer())) then
        return true
    end

    return ManagePlayersLastDeathLocation(Victim)
end
