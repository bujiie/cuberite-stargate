--
-- User: brian.ujiie
-- Date: 8/2/16
--

function OnEntityTeleport(Entity, OldPosition, NewPosition)
    -- If the entity is not a player, who cares???
    if not Entity:IsPlayer() then
        return false
    end

    if not ManagePlayersLastTeleportLocation(Entity, OldPosition) then
        ERROR("Last position of {Player} could not be saved.", {Player=Entity:GetName()})
    end
    return false
end
