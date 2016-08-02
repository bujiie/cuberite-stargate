--
-- User: brian.ujiie
-- Date: 7/24/16
--

function TestHandler(Split, Player)
    local TestCount, FailureCount = RunTests(Split, Player)

    if FailureCount > 0 then
        FailureMessage(Player, FailureCount .. " of " .. TestCount .. " Tests failed.")
    else
        SuccessMessage(Player, "All " .. TestCount .. " tests passed.")
    end

    return true
end

function DialHomeDeviceHandler(Split, Player)
    local DEFAULT_LOCATION = "home"

    if not IsPrivateOrGlobalNameRegisteredToPlayer(Player, DEFAULT_LOCATION) then
        FailureMessage(Player, "Stargate could not connect to '{Home}'.", {Home=DEFAULT_LOCATION})
        return true
    else
        TransportPlayerToCoordinatesByReferenceName(Player, DEFAULT_LOCATION, false)
        return true
    end
end

function StargateTravelHandler(Split, Player)
    local Target = Split[2]

    if(Target == "spawn") then
        return SpawnPointHandler(Split, Player)
    elseif(DoesStargateNameMatchPlayers(Target)) then
        return TransportPlayerToPlayer(Player, Target)
    elseif(IsPrivateOrGlobalNameRegisteredToPlayer(Player, Target)) then
        return TransportPlayerToCoordinatesByReferenceName(Player, Target, false)
    else
        FailureMessage(Player, "Chevron seven could not lock")
    end
    return true
end

function SetStargateHandler(Split, Player)
    local ProposedName = Split[3]

    if(DoesStargateNameMatchPlayers(ProposedName)) then
        FailureMessage(Player, "'{ProposedName}' coincides with a Player's name. Choose a different name.", {ProposedName=ProposedName})
        return true
    end

    if(IsReservedWord(ProposedName)) then
        FailureMessage(Player, "'{Word}' is a reserved word.", {Word=ProposedName})
        return true
    end

    if AddStargate(Player, Player:GetWorld(), ProposedName, Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), false) then
        SuccessMessage(Player, "Stargate '{Stargate}' added to the system.", {Stargate=ProposedName})
    else
        FailureMessage(Player, "Could not lock onto coordinates. Stargate not added.")
    end
    return true
end

function RenameStargateHandler(Split, Player)
    local OldName = Split[3]
    local NewName = Split[4]

    if(DoesStargateNameMatchPlayers(OldName)) then
        FailureMessage(Player, "'{Old}' coincides with a Player's name. Choose a different name.", {Old=OldName})
        return true
    end

    if(DoesStargateNameMatchPlayers(NewName)) then
        FailureMessage(Player, "'{New}' coincides with a Player's name. Choose a different name.", {New=NewName})
        return true
    end

    if(IsReservedWord(NewName)) then
        FailureMessage(Player, "'{Word}' is a reserved word.", {Word=NewName})
        return true
    end

    if not IsPrivateOrGlobalNameRegisteredToPlayer(Player, OldName) then
        FailureMessage(Player, "'{Old}' Stargate is not registered to your system.", {Old=OldName})
        return true
    end

    if IsPrivateOrGlobalNameRegisteredToPlayer(Player, NewName) then
        FailureMessage(Player, "'{New}' Stargate is not registered to your system.", {New=NewName})
        return true
    end

    if UpdateStargateName(Player, OldName, NewName, false) then
        SuccessMessage(Player, "Stargate name was updated: {Old} -> {New}", {Old=OldName, New=NewName})
    else
        FailureMessage(Player, "Stargate name could not be updated.")
    end
    return true
end

function UpdateStargateHandler(Split, Player)
    local Name = Split[3]

    if(DoesStargateNameMatchPlayers(Name)) then
        FailureMessage(Player, "'{Name}' coincides with a Player's name.", {Name=Name})
        return true
    end

    if not IsPrivateOrGlobalNameRegisteredToPlayer(Player, Name) then
        FailureMessage(Player, "'{Name}' Stargate is not registered to your system.", {Name=Name})
        return true
    end

    if(IsReservedWord(Name)) then
        FailureMessage(Player, "'{Word}' is a reserved word.", {Word=Name})
        return true
    end

    if UpdateStargateCoordinates(Player, Name, Player:GetWorld(), Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), false) then
        SuccessMessage(Player, "Stargate coordinates were updated.")
    else
        FailureMessage(Player, "Stargate coordinates could not be updated.")
    end
    return true
end

function RemoveStargateHandler(Split, Player)
    local Target = Split[3]

    local IsRegisteredGlobal = IsPrivateOrGlobalNameRegisteredToPlayer(Player, Target)
    local IsRegisteredPrivate = IsPrivateOrGlobalNameRegisteredToPlayer(Player, Target)

    if not IsRegisteredPrivate and not IsRegisteredGlobal then
        FailureMessage(Player, "No Stargate registered to you with name '${StargateName}'.", {StargateName=Target})
        return true
    end

    if(IsReservedWord(Target)) then
        FailureMessage(Player, "'{Word}' is a reserved word.", {Word=Target})
        return true
    end

    if IsRegisteredPrivate then
        if DeleteStargate(Player, Target, false) then
            SuccessMessage(Player, "Stargate '{Stargate}' was decommissioned.", {Stargate=Target})
        else
            FailureMessage(Player, "Stargate '{Stargate}' was not decommissioned.", {Stargate=Target})
        end
    elseif IsRegisteredGlobal then
        if DeleteStargate(Player, Target, true) then
            EveryoneSuccessMessage("Stargate '{Stargate}' was decommissioned by {Player}.", {Stargate=Target, Player=Player:GetName()})
        else
            FailureMessage(Player, "Stargate '{Stargate}' was not decommissioned.", {Stargate=Target})
        end
    end
    return true
end

function SpawnPointHandler(Split, Player)
    World = cRoot:Get():GetDefaultWorld()

    if(World ~= nil) then
        return TransportPlayerToCoordinates(Player, World, World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
    end
    FailureMessage(Player, "A default world was not found. Cannot travel to spawn point.")
    return true
end

function SpawnPointInfoHandler(Split, Player)
    World = cRoot:Get():GetDefaultWorld()

    if(World ~= nil) then
        SuccessMessage(Player, "Spawn Point: <{X}, {Y}, {Z}>", {X=World:GetSpawnX(), Y=World:GetSpawnY(), Z=World:GetSpawnZ()})
    else
        FailureMessage(Player, "A default world was not found. Cannot travel to spawn point.")
    end
    return true
end

function ListStargatesHandler(Split, Player)
    local Status
    local Results
    local DEFAULT_LIMIT = 10
    local DEFAULT_OFFSET = 0
    local Message = ""

    if(#Split == 2) then
        Status, Results = ViewStargatesAccessibleByPlayer(Player, DEFAULT_OFFSET, DEFAULT_LIMIT)
    elseif(#Split == 3) then
        Status, Results = ViewStargatesAccessibleByPlayer(Player, Split[3], DEFAULT_LIMIT)
    elseif(#Split == 4) then
        Status, Results = ViewStargatesAccessibleByPlayer(Player, Split[3], Split[4])
    end

    if Status then
        for Key, Value in pairs(Results) do
            Message = Message .. Value
            Message = Message .. ", "
        end

        SuccessMessage(Player, "{Message}", {Message=Message})
    else
        FailureMessage(Player, "Could not load Stargate system.")
    end

    return true
end

function LastDeathLocationHandler(Split, Player)
    local Status, Result = PlayersLastDeathCoordinates(Player)
    if not Status then
        FailureMessage(Player, "You have not died yet.")
        return true
    end
    local World = Result["World"]
    local PosX = Result["PosX"]
    local PosY = Result["PosY"]
    local PosZ = Result["PosZ"]

    return TransportPlayerToCoordinates(Player, World, PosX, PosY, PosZ)
end

function LastDeathLocationInfoHandler(Split, Player)
    local Status, Result = PlayersLastDeathCoordinates(Player)

    if not Status then
        FailureMessage(Player, "You have not died yet.")
        return true
    end

    local World = Result["World"]:GetName()
    local PosX = Result["PosX"]
    local PosY = Result["PosY"]
    local PosZ = Result["PosZ"]

    SuccessMessage(Player, "Last Death: {World} - <{X}, {Y}, {Z}>", {World=World, X=PosX, Y=PosY, Z=PosZ})
    return true
end