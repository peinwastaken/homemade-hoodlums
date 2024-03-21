-- server
include("player/sv_playermanager.lua")
include("player/ragdoll/sv_ragdoll.lua")
include("game/sv_game.lua")
include("player/suppression/sv_suppression.lua")

-- client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("game/cl_game.lua")
AddCSLuaFile("player/cl_death.lua")
AddCSLuaFile("player/cl_view.lua")
AddCSLuaFile("player/suppression/cl_suppression.lua")

-- shared
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

AddCSLuaFile("player/player_hoodlum.lua")
include("player/player_hoodlum.lua")

AddCSLuaFile("player/ragdoll/sh_ragdoll.lua")
include("player/ragdoll/sh_ragdoll.lua")