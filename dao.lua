--
-- User: brian.ujiie
-- Date: 7/24/16
--

cSgDao = {}
cSgDao.__index = cSgDao

local StargateDbName = "stargate"
local StargateDbFilename = StargateDbName:gsub("^%l", string.lower) .. ".sqlite"
local StargateDbTableName = StargateDbName:gsub("^%l", string.upper)

function cSgDao:InitializeStargateDb()
    local DbError
    StargateDb, DbError = NewSQLiteDB(StargateDbFilename)

    if not(StargateDb) then
        cLogger:ERROR("Cannot open the ${DbName} database.", {DbName = StargateDbName})
        cLogger:ERROR("SQLite: ${DbError}", {DbError = DbError})
    end

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

    if(not(StargateDb:CreateDBTable(StargateDbTableName, StargateDbColumns))) then
        cLogger:ERROR("Could not create ${DbName} columns.", {DbName = StargateDbName})
    end
end

function cSgDao:AddStargate(a_Player, a_World, a_Name, a_PosX, a_PosY, a_PosZ, a_Global)
    if(cSgDao:IsStargateNameRegistered(a_Player, a_Name, a_Global)) then
        return false
    end

    local result = StargateDb:ExecuteStatement(
        "INSERT INTO Stargate (PlayerId, World, Name, PosX, PosY, PosZ, Global) VALUES (?, ?, ?, ?, ?, ?, ?)",
        {a_Player:GetUUID(), a_World:GetName(), a_Name, a_PosX, a_PosY, a_PosZ, a_Global}
    )

    if(result == nil) then
        cLogger:WARN(
            "Stargate ${StargateName} added by ${PlayerName} failed.",
            {StargateName = a_Name, PlayerName = a_Player:GetName()})
        return false
    else
        cLogger:INFO(
            "Stargate ${StargateName} added by ${PlayerName} successful!",
            {StargateName = a_Name, PlayerName = a_Player:GetName()})
        return true
    end
end

function cSgDao:DeleteStargate(a_Player, a_World, a_Name)
    local result = StargateDb:ExecuteStatement(
        "UPDATE Stargate SET Enabled=0 WHERE Name = ? AND World = ? AND PlayerId = ?",
        {a_Name, a_World:GetName(), a_Player:GetUUID()}
    )

    if(result == nil)  then
        cLogger:WARN(
            "Stargate ${StargateName} added by ${PlayerName} was not found. Cannot decommission.",
            {StargateName = a_Name, PlayerName = a_Player:GetName()})
        return false
    else
        cLogger:INFO(
            "Stargate ${StargateName} added by ${PlayerName} was decommissioned.",
            {StargateName = a_Name, PlayerName = a_Player:GetName()})
        return true
    end
end

function cSgDao:UpdateStargate(a_Player, a_World, a_OldName, a_NewName)
    local result = StargateDb:ExecuteStatement(
        "UPDATE Stargate SET Name = ? WHERE Name = ? AND World = ? AND PlayerId = ? AND Enabled = 1",
        {a_NewName, a_OldName, a_World:GetName(), a_Player:GetUUID()}
    )

    if(result == nil) then
        cLogger:WARN(
            "Stargate name '${StargateName}' was not updated.",
            {StargateName = a_OldName}
        )
        return false
    else
        cLogger:INFO(
            "Stargate '${StargateOld}' name was updated to '${StargateNew}'.",
            {StargateOld = a_OldName, StargateNew = a_NewName}
        )
        return true
    end
end

function cSgDao:ViewStargate(a_Player, a_World, a_Name, a_Global)
    local Resource = {}
    Resource["World"] = a_World

    local result = StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE Name = ? AND World = ? AND PlayerId = ? AND Global = ? AND Enabled = 1 LIMIT 1",
        {a_Name, a_World:GetName(), a_Player:GetUUID(), a_Global},
        function(a_Row)
            Resource["PosX"] = a_Row["PosX"]
            Resource["PosY"] = a_Row["PosY"]
            Resource["PosZ"] = a_Row["PosZ"]
        end
    )

    if(result == nil) then
        cLogger:ERROR(
            "Could not retrieve information about '${StargateName}'.",
            {StargateName = a_Name})
    end
    return Resource
end


function cSgDao:ViewStargatesAccessibleByPlayer(Player, World, Name)
    local Resource = {}
    Resource["World"] = World

    -- If a Stargate registered to a player has the same name as a globally defined Stargate, the player gate
    -- takes precedence.
    local result = StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE Name = ? AND World = ? AND (PlayerId = ? OR Global = 1) AND Enabled = 1 LIMIT 1",
        {Name, World:GetName(), Player:GetUUID()},
        function(Rpw)
            Resource["PosX"] = Rpw["PosX"]
            Resource["PosY"] = Rpw["PosY"]
            Resource["PosZ"] = Rpw["PosZ"]
        end
    )

    if(result == nil) then
        cLogger:ERROR(
            "Could not retrieve information about '${StargateName}'.",
            {StargateName = Name})
    end
    return Resource
end





function cSgDao:IsStargateNameRegistered(a_Player, a_Name, a_Global)
    if(cSgDao:StargateNameMatchesPlayer(a_Name)) then
        cMessage:SendFailure("Stargate name cannot match a Player's name.")
        return true
    end

    if(a_Global and cSgDao:StargateNameRegisteredAsGlobal(a_Name)) then
        cMessage:SendFailure(a_Player, "Global Stragate name already exists.")
        return true
    elseif(not(a_Global) and cSgDao:StargateNameRegisteredToPlayer(a_Player, a_Name)) then
        cMessage:SendFailure(a_Player, "You already have a Stargate with that name.")
        return true
    end
    return false
end

function cSgDao:IsStargateAccessibleByPlayer(Player, Name)
    return (cSgDao:StargateNameRegisteredAsGlobal(Name) or
            cSgDao:StargateNameRegisteredToPlayer(Player, Name))
end

function cSgDao:StargateNameRegisteredToPlayer(a_Player, a_Name)
    local RowCount = 0

    StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE Name = ? AND PlayerId = ? AND Enabled = 1 LIMIT 1",
        {a_Name, a_Player:GetUUID()},
        function(a_Row)
            RowCount = RowCount + 1
        end
    )

    return RowCount > 0
end

function cSgDao:StargateNameRegisteredAsGlobal(a_Name)
    local RowCount = 0

    StargateDb:ExecuteStatement(
        "SELECT * FROM Stargate WHERE Name = ? AND Global = 1 AND Enabled = 1  LIMIT 1",
        {a_Name},
        function(a_Row)
            RowCount = RowCount + 1
        end
    )
    return RowCount > 0
end

-- Should not be used as a standalone function. To be used as part of
-- a helper function.
function cSgDao:StargateNameMatchesPlayer(a_Name)
    return (cSgDao:GetPlayerByName(a_Name) ~= nil)
end

function cSgDao:GetPlayerByName(a_PlayerName)
    local Player
    cRoot:Get():ForEachPlayer(
        function(a_Player)
            if(a_Player:GetName() == a_PlayerName) then
                Player = a_Player
            end
        end
    )
    return Player
end

function cSgDao:GetPlayerByUUID(a_PlayerUUID)
    cRoot:Get():ForEachPlayer(
        function(a_Player)
            if(a_Player:GetUUID() == a_PlayerUUID) then
                return a_Player
            end
        end
    )
    return nil
end
