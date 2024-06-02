-- server
include("player/sv_playermanager.lua")
include("player/ragdoll/sv_ragdoll.lua")
include("game/sv_game.lua")
include("game/sv_objectives.lua")
include("player/suppression/sv_suppression.lua")
include("player/sv_weapondrop.lua")

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

-- shared
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

AddCSLuaFile("sh_globals.lua")
include("sh_globals.lua")

AddCSLuaFile("player/player_hoodlum.lua")
include("player/player_hoodlum.lua")

AddCSLuaFile("player/player_demoncompany.lua")
include("player/player_demoncompany.lua")

AddCSLuaFile("player/ragdoll/sh_ragdoll.lua")
include("player/ragdoll/sh_ragdoll.lua")