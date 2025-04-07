-- server
include("player/sv_playermanager.lua")
include("player/ragdoll/sv_ragdoll.lua")
include("game/sv_game.lua")
include("game/sv_objectives.lua")
include("player/suppression/sv_suppression.lua")
include("player/sv_weapondrop.lua")
include("player/health/sv_limbhealth.lua")
include("player/armor/sv_armor.lua")
include("game/sv_chaos.lua")
include("player/data/sv_data.lua")

-- client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("game/cl_game.lua")
AddCSLuaFile("player/cl_death.lua")
AddCSLuaFile("player/cl_view.lua")
AddCSLuaFile("player/cl_hud.lua")
AddCSLuaFile("player/cl_taa.lua")
AddCSLuaFile("player/suppression/cl_suppression.lua")
AddCSLuaFile("settings/cl_binds.lua")
AddCSLuaFile("settings/cl_settings.lua")
AddCSLuaFile("player/health/cl_limbhealth.lua")
AddCSLuaFile("player/armor/cl_armor.lua")
AddCSLuaFile("player/cl_bodycam.lua")
AddCSLuaFile("player/data/cl_data.lua")
AddCSLuaFile("player/ragdoll/cl_ragdoll.lua")

-- shared
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

AddCSLuaFile("sh_globals.lua")
include("sh_globals.lua")

AddCSLuaFile("player/player_hoodlum.lua")
include("player/player_hoodlum.lua")

AddCSLuaFile("player/player_demoncompany.lua")
include("player/player_demoncompany.lua")

AddCSLuaFile("player/player_cops.lua")
include("player/player_cops.lua")

AddCSLuaFile("player/ragdoll/sh_ragdoll.lua")
include("player/ragdoll/sh_ragdoll.lua")

AddCSLuaFile("player/health/sh_limbhealth.lua")
include("player/health/sh_limbhealth.lua")

AddCSLuaFile("player/armor/sh_armor.lua")
include("player/armor/sh_armor.lua")

include("player/data/sh_data.lua")
AddCSLuaFile("player/data/sh_data.lua")

local loaded = {}

function IsPlayerLoaded(ply)
    return loaded[ply] or false
end

util.AddNetworkString("ClientLoaded")
net.Receive("ClientLoaded", function(len, ply)
    if not loaded[ply] then
        loaded[ply] = true
        hook.Run("PlayerRespawn", ply)
        ply:SyncHoodlumData()
    end
end)