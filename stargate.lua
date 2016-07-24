--
-- User: brian.ujiie
-- Date: 7/23/16
--

function InitializeStargateSystem()
    cSgDao:InitializeStargateDb()
    InitializeStargateCommands()
end



function InitializeStargateCommands()
    cPluginManager.BindCommand("/sgset", "stargate.gdo", StargateSetHandler, " ~ Add a reference to the current coordinates with a name.")
    cPluginManager.BindCommand("/dhd", "stargate.gdo",  DhdHandler, " - Special command that looks for a player's 'home' Stargate.")

    cPluginManager.BindCommand("/sg", "stargate.gdo", StargateHandler, " ~ Travel to a destination referenced by name or by coordinates.")
    cPluginManager.BindCommand("/sgdel", "stargate.gdo", DeleteStargateHandler, " ~ Delete a reference previously set by you.")
    cPluginManager.BindCommand("/sgrename", "stargate.gdo", StargateRenameHandler, " ~ Rename an existing Stargate registered to the player.")
    cPluginManager.BindCommand("/sgl", "stargate.gdo", test, " ~ List all available Stargates to you.")

    cPluginManager.BindCommand("/sgc", "stargate.cmd", SGCStargateHandler, " ~ /sgc <destination> <player> where destination can be another player or Stargate.")
    cPluginManager.BindCommand("/sgcdel", "stargate.cmd", SGCDeleteStargateHandler, " ~ Delete any Stargate defined by any player.")
    cPluginManager.BindCommand("/sgcrename", "stargate.gdo", SGCStargateRenameHandler, " ~ Rename an existing Stargate registered to any player.")
    cPluginManager.BindCommand("/sgcl", "stargate.cmd", test, " ~ List all Stargates defined with optional filtering by Player.")
end

function test() end

