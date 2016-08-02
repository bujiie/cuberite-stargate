--
-- User: brian.ujiie
-- Date: 7/24/16
--

function TransportPlayerToPlayer(SourcePlayer, TargetPlayer)
    local Transport = function(TargetPlayer)
        if SourcePlayer == TargetPlayer then
            FailureMessage(SourcePlayer, "Could not travel to player, {Target}. Chevron seven could not lock.", {Target=TargetPlayer:GetName()})
            return false
        else
            SourcePlayer:TeleportToEntity(TargetPlayer)
            return true
        end
    end

    local World = SourcePlayer:GetWorld()

    if World:DoWithPlayer(TargetPlayer, Transport) then
        SuccessMessage(SourcePlayer, "You survived the wormhole!")
        SuccessMessage(TargetPlayer, "{Source} traveled to you!", {Source=SourcePlayer:GetName()})
        return true
    else
        FailureMessage(SourcePlayer, "Chevron seven could not lock onto {Target}'", {Target=TargetPlayer:GetName()})
        ERROR("Could not transport {Source} to {Target}.", {Source=SourcePlayer, Target=TargetPlayer})
        return false
    end
end

function TransportPlayerToCoordinates(Player, World, X, Y, Z)
    local Transport = function(Player)
        return Player:TeleportToCoords(X, Y, Z)
    end

    if World:DoWithPlayer(Player:GetName(), Transport) then
        SuccessMessage(Player, "You survived the wormhole!")
        return true
    else
        FailureMessage(Player, "Chevron seven could not lock.")
        ERROR("Could not transport {Player} to  coordinates.", {Player=Player:GetName()})
        return false
    end
end

function TransportPlayerToCoordinatesByReferenceName(Player, Name, Global)
    local Status, Result = ViewStargateByName(Player, Name, Global)

    if Status then
        return TransportPlayerToCoordinates(Player, Result["World"], Result["PosX"], Result["PosY"], Result["PosZ"])
    else
        return false
    end
end

function TransportPlayerToCoordinatesByVector(Player, World, Vector)
    return TransportPlayerToCoordinates(Player, World, Vector:X(), Vector:Y(), Vector:Z())
end