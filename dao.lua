--
-- User: brian.ujiie
-- Date: 7/24/16
--

StargateDb = nil

local StargateDbName = "stargate"
local StargateDbFilename = StargateDbName:gsub("^%l", string.lower) .. ".sqlite"
local StargateDbTableName = StargateDbName:gsub("^%l", string.upper)


function InitializeDb()
    local DbError
    local StargateDbColumns = {
        "ID INTEGER PRIMARY KEY AUTOINCREMENT",
        "PlayerId VARCHAR(255) NOT NULL",
        "World VARCHAR(255) NOT NULL",
        "Name VARCHAR(255) NOT NULL",
        "PosX VARCHAR(255) NOT NULL",
        "PosY VARCHAR(255) NOT NULL",
        "PosZ VARCHAR(255) NOT NULL",
        "Global INTEGER default 0",
        "Enabled INTEGER default 1"
    }

    StargateDb, DbError = NewSQLiteDB(StargateDbFilename)

    if StargateDb then
        if(StargateDb:CreateDBTable(StargateDbTableName, StargateDbColumns)) then
            INFO(
                "Columns created in {Database} successfully.",
                {Database=StargateDbName})
        else
            ERROR(
                "Could not create columns in {Database}.",
                {Database=StargateDbName})
        end
    else
        ERROR(
            "Cannot open {Database} database. ({Error})",
            {Database=StargateDbName, Error=DbError})
        ERROR(
            "{Error}",
            {Error=DbError})
    end
    return true
end

function AddStargate(Player, World, Name, X, Y, Z, Global)
    if IsNameRegisteredToPlayer(Player, Name, Global) then
        return false
    end

    local Result, DbError = StargateDb:ExecuteStatement(
        "INSERT INTO Stargate (PlayerId, World, Name, PosX, PosY, PosZ, Global) VALUES (?, ?, ?, ?, ?, ?, ?)",
        {Player:GetUUID(), World:GetName(), Name, X, Y, Z, Global})

    if Result ~= nil then
        INFO(
            "Stargate '{Stargate}' was added by {Player} to the database.",
            {Stargate=Name, Player=Player:GetName()})
        return true
    else
        ERROR(
            "Stargate '{Stargate}' could not be added by {Player} to the database. ({Error})",
            {Stargate=Name, Player=Player:GetName(), Error=DbError})
        return false
    end
end

function UpdateStargateName(Player, OldName, NewName, Global)
    if not IsNameRegisteredToPlayer(Player, OldName, Global) then
        FailureMessage(
            Player,
            "Stargate is not registered to you.")
        return false
    end

    local Result, DbError = StargateDb:ExecuteStatement(
        "UPDATE Stargate SET Name = ? WHERE Name = ? AND PlayerId = ? AND Enabled = 1",
        {NewName, OldName, Player:GetUUID()})

    if Result ~= nil then
        INFO(
            "Stargate name was updated: {Old} -> {New}",
            {Old=OldName, New=NewName})
        return true
    else
        ERROR(
            "Stargate '{Stargate}' was not updated. ({Error})",
            {Stargate=OldName, Error=DbError})
        return false
    end
end

function UpdateStargateCoordinates(Player, Name, World, X, Y, Z, Global)
    if not IsNameRegisteredToPlayer(Player, Name, Global) then
        FailureMessage(
            Player,
            "Stargate is not registered to you.")
        return false
    end

    local Result, DbError = StargateDb:ExecuteStatement(
        "UPDATE Stargate SET PosX = ?, PosY = ?, PosZ = ?, World = ?, Global = ? WHERE Name = ? AND PlayerId = ? AND Enabled = 1",
        {X, Y, Z, World:GetName(), Global, Name, Player:GetUUID()})

    if Result ~= nil then
        INFO(
            "Stargate '{Stargate}' coordinates owned by {Owner} was updated.",
            {Stargate=Name, Owner=Player:GetName()})
        return true
    else
        ERROR(
            "Stargate '{Stargate}' coordinates were not updated. ({Error})",
            {Stargate=Name, Error=DbError})
        return false
    end
end

function DeleteStargate(Player, Name, Global)
    if not IsNameRegisteredToPlayer(Player, Name, Global) then
        FailureMessage(
            Player,
            "Stargate is not registered to you.")
        return false
    end

    local Result, DbError = StargateDb:ExecuteStatement(
        "UPDATE Stargate SET Enabled = 0 WHERE Name = ? AND PlayerId = ? AND Global = ? AND Enabled = 1",
        {Name, Player:GetUUID(), Global})

    if Result ~= nil then
        INFO(
            "Stargate '{Stargate}' owned by {Owner} was disabled.",
            {Stargate=Name, Owner=Player:GetName()})
        return true
    else
        ERROR(
            "Stargate '{Stargate}' was not disabled. ({Error})",
            {Stargate=Name, Error=DbError})
        return false
    end
end

function ViewStargatesAccessibleByPlayer(Player, Offset, Limit)
    local Locations = {}
    local Index = 0

    local Result, DbError = StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE PlayerId = ? AND Enabled = 1 LIMIT ? OFFSET ?",
        {Player:GetUUID(), Limit, Offset},
        function(Row)
            local World = Row["World"]
            local Name = Row["Name"]

            if(World == "world") then
                Name = Name .. " (W)"
            elseif(World == "world_nether") then
                Name = Name .. " (N)"
            elseif(World == "world_end") then
                Name = Name .. " (E)"
            else
                Name = Name .. " (?)"
            end

            Locations[Index] = Name
            Index = Index + 1
        end)

    if Result ~= nil then
        return true, Locations
    else
        ERROR(
            "Could not retrieve Stargates accessible by {Player}. ({Error})",
            {Player=Player:GetName(), Error=DbError})
        return false, nil
    end
end

function ViewStargateByName(Player, Name, Global)
    if not IsNameRegisteredToPlayer(Player, Name, Global) then
        FailureMessage(
            Player,
            "Stargate is not registered to you.")
        return false, nil
    end

    local Location = {}

    local Result, DbError = StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE Name = ? AND PlayerId = ? AND Global = ? AND Enabled = 1 LIMIT 1",
        {Name, Player:GetUUID(), Global},
        function(Row)
            Location["PosX"] = Row["PosX"]
            Location["PosY"] = Row["PosY"]
            Location["PosZ"] = Row["PosZ"]
            Location["World"] = GetWorldByName(Row["World"])
        end)

    if Result ~= nil then
        return true, Location
    else
        ERROR(
            "Location for {Player} not found. ({Error})",
            {Player=Player:GetName(), Error=DbError})
        return false, nil
    end
end

function PlayersLastDeathCoordinates(Player)
    if not IsNameRegisteredToPlayer(Player, "last_death", false) then
        FailureMessage(
            Player,
            "You have no died yet.")
        return false, nil
    end

    local Location = {}
    local Result, DbError = StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE Name = 'last_death' AND PlayerId = ? LIMIT 1",
        {Player:GetUUID()},
        function(Row)
            Location["PosX"] = Row["PosX"]
            Location["PosY"] = Row["PosY"]
            Location["PosZ"] = Row["PosZ"]
            Location["World"] = GetWorldByName(Row["World"])
        end)

    if Result ~= nil then
        return true, Location
    else
        ERROR(
            "Last death location for {Player} not found. ({Error})",
            {Player=Player:GetName(), Error=DbError})
        return false, nil
    end
end

function IsPrivateOrGlobalNameRegisteredToPlayer(Player, Name)
    local Count = 0
    local Result, DbError = StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE PlayerId = ? AND Name = ? AND Enabled = 1 LIMIT 1",
        {Player:GetUUID(), Name},
        function(Row)
            Count = Count + 1
        end
    )

    if Result ~= nil then
        return Count > 0
    else
        ERROR(
            "Stargate '{Stargate}' could not be found. ({Error})",
            {Stargate=Name, Error=DbError})
        return false
    end
end

function IsNameRegisteredToPlayer(Player, Name, Global)
    local Count = 0
    local Result, DbError = StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE PlayerId = ? AND Name = ? AND Global = ? AND Enabled = 1 LIMIT 1",
        {Player:GetUUID(), Name, Global},
        function(Row)
            Count = Count + 1
        end
    )

    if Result ~= nil then
        return Count > 0
    else
        ERROR(
            "Stargate '{Stargate}' could not be found. ({Error})",
            {Stargate=Name, Error=DbError})
        return false
    end
end

function IsPrivateNameRegisteredToPlayer(Player, Name)
    return IsNameRegisteredToPlayer(Player, Name, false)
end

function IsGlobalNameRegisteredToPlayer(Player, Name)
    return IsNameRegisteredToPlayer(Player, Name, true)
end

function GetPlayerByName(PlayerName)
    local Result
    cRoot:Get():ForEachPlayer(
        function(Player)
            if(Player:GetName() == PlayerName) then
                Result = Player
            end
        end)
    return Result
end

function DoesStargateNameMatchPlayers(Name)
    return GetPlayerByName(Name) ~= nil
end

function GetWorldByName(WorldName)
    return cRoot:Get():GetWorld(WorldName)
end