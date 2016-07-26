--
-- User: brian.ujiie
-- Date: 7/24/16
--

g_PluginInfo =
{
    Name = "Stargate",
    Version = "1",
    Date = "2016-07-24",
    SourceLocation = "https://github.com/bujiie/cuberite-stargate",
    Description = [[
        Stargate replaces the teleport functionality as part of the Core plugin.
        Additional features like referencing coordinates with a user-friendly
        name is included. Stargate also includes admin-like commands that allow
        an admin to update any player's saved locations.]],
    Commands =
    {
        ["/dhd"] =
        {
            Permission = "stargate.gdo",
            Handler = DialHomeDeviceHandler,
            HelpString = "Transports player to location set as 'home' or the last bed loation."
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
                    HelpString = "The spawn point coordinates.",
                    Permission = "stargate.gdo.spawn",
                    Handler = SpawnPointInfoHandler
                },
                set =
                {
                    HelpString = "Save current coordinates to your Stargate system.",
                    Permission = "stargate.gdo.set",
                    Handler = SetStargateHandler
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
        ["stargate.gdo.work"] =
        {
            Description = [[
                Gives player access to set an arbitrary location as 'work'.]],
            RecommendedGroups = "member"
        },
        ["stargate.gdo.set"] =
        {
            Description = [[
                Gives player access to set arbitrary locations with arbitrary
                names. A location marked as 'home' still inherits the dhd
                abilities.]],
            RecommendedGroups = "member"
        },
        ["stargate.sg1.gdo"] =
        {
            Description = [[
                SG-1 is established as the primary exploration tream. Allows a
                player full access to the Stargate system which includes
                traveling to global and player defined gates as well as
                setting/deleting/renaming/updating as many ]],
            RecommendedGroups = "VIP",
        }
    }
}


