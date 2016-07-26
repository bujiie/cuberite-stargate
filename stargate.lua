--
-- User: brian.ujiie
-- Date: 7/23/16
--


function InitializeStargateSystem()
    cSgDao:InitializeStargateDb()
    cPluginManager:AddHook(cPluginManager.HOOK_KILLED, OnKilled)
    --InitializeStargateCommands()
end



function InitializeStargateCommands()
    cPluginManager.BindCommand("/sgset", "stargate.gdo", StargateSetHandler, " ~ Add a reference to the current coordinates with a name.")
    cPluginManager.BindCommand("/dhd", "stargate.gdo",  DialHomeDeviceHandler, " - Special command that looks for a player's 'home' Stargate.")

    cPluginManager.BindCommand("/sg", "stargate.gdo", StargateHandler, " ~ Travel to a destination referenced by name or by coordinates.")
    cPluginManager.BindCommand("/sgdel", "stargate.gdo", DeleteStargateHandler, " ~ Delete a reference previously set by you.")
    cPluginManager.BindCommand("/sgrename", "stargate.gdo", StargateRenameHandler, " ~ Rename an existing Stargate registered to the player.")
    cPluginManager.BindCommand("/sgl", "stargate.gdo", test, " ~ List all available Stargates to you.")

    cPluginManager.BindCommand("/sgc", "stargate.cmd", SGCStargateHandler, " ~ /sgc <destination> <player> where destination can be another player or Stargate.")
    cPluginManager.BindCommand("/sgcdel", "stargate.cmd", SGCDeleteStargateHandler, " ~ Delete any Stargate defined by any player.")
    cPluginManager.BindCommand("/sgcrename", "stargate.gdo", SGCStargateRenameHandler, " ~ Rename an existing Stargate registered to any player.")
    cPluginManager.BindCommand("/sgcl", "stargate.cmd", test, " ~ List all Stargates defined with optional filtering by Player.")
end

-- /dhd
-- {2} /sg <player>
-- {2} /sg <location>
-- {2} /sg g:<location>
-- {2} /sg <player>:<location>
-- {2} /sg spawn

-- {3} -- /sg set <location>
-- {4} -- /sg set (-g|--global) <location>

-- {4} -- /sg rename <old> <new>
-- {4} -- /sg rn <old> <new>

-- {3} -- /sg update <location>
-- {3} -- /sg up <location>

-- {3} -- /sg delete <location>
-- {3} -- /sg del <location>

-- {2} -- /sg list
-- {2} -- /sg ls



-- {3} /sgc <player> <player>
-- {3} /sgc <player> <location>
-- {3} /sgc <player> g:<location>
-- {3} /sgc <player> <player>:<location>

-- {4} /sgc set <player> <location>
-- {4} /sgc set (-g|--global) <location>

-- {5} /sgc rename <player> <old> <new>
-- {5} /sgc rename (-g|--global) <old> <new>
-- {5} /sgc rn <player> <old> <new>
-- {5} /sgc rn (-g|--global) <old> <new>

-- {4} /sgc update <player> <location>
-- {4} /sgc update (-g|--global) <location>
-- {4} /sgc up <player> <location>
-- {4} /sgc up (-g|--global) <location>

-- {4} /sgc delete <player> <location>
-- {4} /sgc del <player> <location>
-- {4} /sgc delete (-g|--global) <location>
-- {4} /sgc del (-g|--global) <location>

-- {3} /sgc list <player>
-- {3} /sgc list (-g|--global)
-- {3} /sgc ls <player>
-- {3} /sgc ls (-g|--global)
