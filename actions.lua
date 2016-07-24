--
-- User: brian.ujiie
-- Date: 7/24/16
--

cSgAction = {}
cSgAction.__index = cSgAction

function cSgAction:StargatePlayerToPlayer(a_CtxPlayer, a_TargetPlayer)
    local stargate = function(a_TargetPlayer)
        if(a_CtxPlayer == a_TargetPlayer) then
            cMessage:SendFailure(a_CtxPlayer, "Stargate cannot connect to itself.")
            return false
        else
            a_FromPlayer:TeleportToEntity(a_TargetPlayer)
            cMessage:SendSuccess(a_CtxPlayer, "You traveled to " .. a_TargetPlayer:GetName() .. "!")
            cMessage:Send(a_TargetPlayer, a_CtxPlayer:GetName() .. " traveled to you!")
            return true
        end
    end

    local World = a_CtxPlayer:GetWorld()

    if not World:DoWithPlayer(a_TargetPlayer, stargate) then
        cMessage:SendFailure(a_CtxPlayer, "Could not find player " .. a_TargetPlayer:GetName())
        return false
    end
end

function cSgAction:StargatePlayerToCoords(a_Player, a_World, a_PosX, a_PosY, a_PosZ)
    local stargate = function(a_Player)
        return a_Player:TeleportToCoords(a_PosX, a_PosY, a_PosZ)
    end

    if a_World:DoWithPlayer(a_Player:GetName(), stargate) then
        cMessage:SendSuccess(a_Player, "You survived the wormhole!")
        return true
    else
        cMessage:SendFailure(a_Player, "Stargate could not lock on destination.")
        return false
    end
end

function cSgAction:StargateToCoordsByReferenceName(a_Player, a_Name, a_Global)
    local Stargate = cSgDao:ViewStargate(a_Player, a_Player:GetWorld(), a_Name, a_Global)

    if(cSgAction:StargatePlayerToCoords(a_Player, Stargate["World"], Stargate["PosX"], Stargate["PosY"], Stargate["PosZ"])) then
        return true
    else
        return false
    end
end