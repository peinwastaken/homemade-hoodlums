include("player/player_hoodlum.lua")
include("player/player_demoncompany.lua")
include("player/player_cops.lua")
include("player/ragdoll/sh_ragdoll.lua")
include("sh_globals.lua")
include("game/cl_game.lua")
include("player/cl_death.lua")
include("player/cl_view.lua")
include("player/cl_hud.lua")
include("player/cl_taa.lua")
include("player/suppression/cl_suppression.lua")
include("settings/cl_binds.lua")
include("settings/cl_settings.lua")
include("player/health/cl_limbhealth.lua")
include("player/health/sh_limbhealth.lua")
include("player/armor/cl_armor.lua")
include("player/armor/sh_armor.lua")
include("player/cl_bodycam.lua")

surface.CreateFont("FancyOldTimey", {
    font = "DS Cloister Black",
    size = ScreenScale(32),
    weight = 500
})

surface.CreateFont("HudMedium", {
    font = "Chopin Light",
    size = ScreenScale(16),
    weight = 500,
})

surface.CreateFont("HudSmall", {
    font = "Chopin Light",
    size = ScreenScale(11),
    weight = 500,
})

hook.Add("InitPostEntity", "hoodlum_clientloaded", function()
    net.Start("ClientLoaded")
    net.SendToServer()
end)