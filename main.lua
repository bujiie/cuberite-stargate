--
-- User: brian.ujiie
-- Date: 7/23/16
--
g_UsePrefixes = true
PLUGIN = nil

function Initialize(Plugin)
    Plugin:SetName("Stargate")
    Plugin:SetVersion(1)

    PLUGIN = Plugin
    -- Load the InfoReg shared library:
    dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

    RegisterPluginInfoCommands()
    InitializeStargateSystem()
    LOG(Plugin:GetName() .. " is starting!")
    return true
end

function OnDisable()
    LOG(PLUGIN:GetName() .. " is shutting down :(")
end

