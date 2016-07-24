--
-- User: brian.ujiie
-- Date: 7/24/16
--
cSgHandler = {}
cSgHandler.__index = cSgHandler

function StargateSetHandler(a_Split, a_Player)
    local Global    = false
    local World     = a_Player:GetWorld()
    local PosX      = a_Player:GetPosX()
    local PosY      = a_Player:GetPosY()
    local PosZ      = a_Player:GetPosZ()
    local Name      = ""

    if(#a_Split == 3) then
        Name = a_Split[3]
        Global = CheckGlobalFlag(a_Split[2])
    else
        Name = a_Split[2]
    end

    if(cSgDao:AddStargate(a_Player, World, Name, PosX, PosY, PosZ, Global)) then
        cMessage:SendSuccess(a_Player, "Stargate '${StargateName}' added to the system.", {StargateName = Name})
        return true
    else
        cMessage:SendFailure(a_Player, "Stargate '${StargateName}' could not be added.", {StargateName = Name})
        return false
    end
end

function DhdHandler(a_Split, a_Player)
    if(not(cSgDao:StargateNameRegisteredToPlayer(a_Player, "home"))) then
        cMessage:SendFailure(a_Player, "Stargate cannot connect. Home not found.")
        return false
    end

    if(cSgAction:StargateToCoordsByReferenceName(a_Player, "home", false)) then
        return true
    else
        return false
    end
end

function StargateRenameHandler(a_Split, a_Player)
    local OldName
    local NewName

    if(#a_Split == 4) then
        if(CheckGlobalFlag(a_Split[2])) then
            OldName = a_Split[3]
            NewName = a_Split[4]
        else
            cMessage:SendFailure(a_Player, "Only global flag allowed (-g or --global)")
            return false
        end
    else
        OldName = a_Split[2]
        NewName = a_Split[3]
    end

    if(not(cSgDao:StargateNameRegisteredToPlayer(a_Player, OldName))) then
        cMessage:SendFailure(a_Player, "No Stargates with that name exists for you.")
        return true
    elseif(cSgDao:StargateNameRegisteredToPlayer(a_Player, NewName)) then
        cMessage:SendFailure(a_Player, "Stargate with that name is already registered to you.")
        return true
    end

    if(cSgDao:UpdateStargate(a_Player, a_Player:GetWorld(), OldName, NewName)) then
        cMessage:SendSuccess(a_Player, "Stargate was renamed: ${From} -> ${To}", {From = OldName, To = NewName})
    else
        cMessage:SendFailure(a_Player, "Stargate could not be renamed.")
    end
    return true
end

function SGCStargateRenameHandler(a_Split, a_Player)
    local TargetPlayerName = a_Split[2]
    local TargetPlayer = cSgDao:GetPlayerByName(TargetPlayerName)

    if(TargetPlayer == nil) then
        cMessage:SendFailure(a_Player, "Could not find Player: ${PlayerName}.", {PlayerName = TargetPlayerName})
        return true
    end

    return StargateRenameHandler(Tail(a_Split), TargetPlayer)
end

function StargateHandler(a_Split, a_Player)
    local Target = a_Split[2]
    if(cSgDao:StargateNameMatchesPlayer(Target)) then
        return cSgAction:StargatePlayerToPlayer(a_Player, Target)
    else
        return cSgAction:StargateToCoordsByReferenceName(a_Player, Target, false)
    end
end

function SGCStargateHandler(a_Split, a_Player)
    local CtxPlayer
    local TargetDestination
    local Result

    if(#a_Split == 2) then
        CtxPlayer = a_Player
        TargetDestination = a_Split[2]
    else
        CtxPlayer = a_Split[2]
        TargetDestination = a_Split[3]
    end

    if(cSgDao:StargateNameMatchesPlayer(TargetDestination)) then
        Result = cSgAction:StargatePlayerToPlayer(CtxPlayer, TargetDestination)
    else
        Result = cSgAction:StargateToCoordsByReferenceName(CtxPlayer, TargetDestination, false)
    end

    if(Result) then
        cMessage:SendSuccess(a_Player, "${CtxPlayer} successfully traveled to ${TargetPlayer}!", {CtxPlayer = CtxPlayer, TargetPlayer = TargetPlayer})
        return true
    else
        cMessage:SendFailure(a_Player, "Could not send ${CtxPlayer} through the Stargate.", {CtxPlayer = CtxPlayer})
        return false
    end
end

function SGCDeleteStargateHandler(a_Split, a_Player)
    local StargateName
    local Player
    local World

    if(#a_Split == 2) then
        StargateName = a_Split[2]
        Player = a_Player
        World = Player:GetWorld()
    else
        StargateName = a_Split[3]
        Player = a_Split[2]
        World = Player:GetWorld()
    end

    if(cSgDao:DeleteStargate(Player, World, StargateName)) then
        cMessage:SendSuccess(a_Player, "Stargate '${StargateName}' was decommissioned.", {StargateName = StargateName})

        if(a_Player ~= Player) then
            cMessage:Send(Player, "${SGCPlayer} decommissioned your Stargate '${StargateName}'.", {SGCPlayer = a_Player, StargateName = StargateName})
        end
        return true
    else
        cMessage:SendFailure(a_Player, "Stargate '${StargateName}' could not be decommissioned.", {StargateName = StargateName})
        return false
    end
end

function DeleteStargateHandler(a_Split, a_Player)
    local World = a_Player:GetWorld()
    local StargateName = a_Split[2]
    if(cSgDao:DeleteStargate(a_Player, World, StargateName)) then
        cMessage:SendSuccess(a_Player, "Stargate ${StargateName} was deleted!", {StargateName = StargateName})
        return true
    else
        cMessage:SendFailure(a_Player, "Stargate was not deleted. :(")
        return false
    end
end


