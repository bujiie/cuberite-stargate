--
-- User: brian.ujiie
-- Date: 7/23/16
--


function InitializeStargateSystem()
    InitializeDb()
    cPluginManager:AddHook(cPluginManager.HOOK_KILLED, OnKilled)
    cPluginManager:AddHook(cPluginManager.HOOK_ENTITY_TELEPORT, OnEntityTeleport)
end
