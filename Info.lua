--
-- User: brian.ujiie
-- Date: 7/24/16
--

g_PluginInfo =
{
    Name = "Stargate",
    Version = "3",
    Date = "2016-07-24",
    SourceLocation = "https://github.com/bujiie/cuberite-stargate",
    Description = [[
        Stargate replaces the teleport functionality as part of the Core plugin.
        Additional features like referencing coordinates with a user-friendly
        name is included. Stargate also includes admin-like commands that allow
        an admin to update any player's saved locations.]],
    Commands =
    {
        ["/test"] =
        {
            Permission = "stargate.test",
            HelpString = "Testing",
            Handler = TestHandler
        },
        ["/ld"] =
        {
            Permission = "stargate.gdo.lastdeath",
            HelpString = "Transports player to the location of their last death.",
            Subcommands =
            {
                go =
                {
                    HelpString = "Transports player to the location of their last death.",
                    Permission = "stargate.gdo.lastdeath",
                    Handler = LastDeathLocationHandler
                },
                info =
                {
                    HelpString = "Get info about the location of players last death.",
                    Permission = "stragate.gdo.lastdeath",
                    Handler = LastDeathLocationInfoHandler
                }
            }
        },
        ["/dhd"] =
        {
            Alias = "/home",
            Permission = "stargate.gdo",
            Handler = DialHomeDeviceHandler,
            HelpString = "Transports player to location set as 'home' or the last bed loation."
        },
        ["/work"] =
        {
            Permission = "stargate.gdo",
            Handler = StargateWorkHandler,
            HelpString = "Transports player to location set as 'work' if available."
        },
        ["/last"] =
        {
            Permission = "stargate.gdo",
            Handler = LastLocationHandler,
            HelpString = "Transports player to the last location before traveling."
        },
        ["/sg"] =
        {
            Permission = "stargate.gdo",
            Handler = StargateTravelHandler,
            HelpString = "Transports a player from his/her current location to the specified destination."
        },
        ["/sgc"] =
        {
            Permission = "stargate.gdo",
            HelpString = "Transports a player from his/her current location to the specified destination.",
            Subcommands =
            {
                spawn =
                {
                    HelpString = [[
                        Transport the player to the spawn coordinates.]],
                    Permission = "stargate.gdo.spawn",
                    Handler = SpawnPointHandler
                },
                spawninfo =
                {
                    Alias = "si",
                    HelpString = "The spawn point coordinates.",
                    Permission = "stargate.gdo.spawn",
                    Handler = SpawnPointInfoHandler
                },
                set =
                {
                    HelpString = "Save current coordinates to your Stargate system.",
                    Permission = "stargate.gdo.set",
                    Handler = SetStargateHandler
                },
                rename =
                {
                    HelpString = "Rename a Stargate.",
                    Permission = "stargate.gdo.rename",
                    Handler = RenameStargateHandler
                },
                update =
                {
                    Alias = "up",
                    HelpString = "Update the Stargate with the current coordinates.",
                    Permission = "stargate.gdo.update",
                    Handler = UpdateStargateHandler
                },
                remove =
                {
                    Alias = "rm",
                    HelpString = "Decommission a Stargate from your system.",
                    Permission = "stargate.gdo.remove",
                    Handler = RemoveStargateHandler
                },
                list =
                {
                    Alias = "ls",
                    HelpString = "List Stargates available to you.",
                    Permission = "stargate.gdo.list",
                    Handler = ListStargatesHandler
                },
                fetch = {
                    Alias = "fe",
                    HelpString = "Transports the specified player to your current location.",
                    Permission = "stargate.gdo.fetch",
                    Handler = StargatePlayerToYouHandler
                }
            }
        }
    },
    Permissions =
    {
        ["stargate.gdo"] =
        {
            Description = [[
                General permission that all players need to use any part of the
                Stargate system.]],
            RecommendedGroups = "admin, mod, VIP, member"
        },
        ["stargate.gdo.dhd"] =
        {
            Description = [[
                Gives player access to travel to the last bed position or
                location defined as 'home'. If 'home' is defined, it takes
                precidence over last bed position.]],
            RecommendedGroups = "member",
        },
        ["stargate.gdo.home"] =
        {
            Description = [[
                Gives player access to set an arbitrary location as 'home'.]],
            RecommendedGroups = "member"
        },
        ["stargate.gdo.spawn"] =
        {
            Description = [[
                Gives player access to travel to the spawn point.]],
            RecommendedGroups = "VIP"
        },
        ["stargate.gdo.set"] =
        {
            Description = [[
                Gives player access to set arbitrary locations with arbitrary
                names. A location marked as 'home' still inherits the dhd
                abilities.]],
            RecommendedGroups = "member"
        }
    }
}


