hook.Add("PlayerRespawn", "hoodlum_giveclass", function(ply) 
    player_manager.SetPlayerClass(ply, "player_hoodlum")
end)

hook.Add("PlayerInitialSpawn", "hoodlum_intialspawn", function(ply)
    hook.Run("PlayerRespawn", ply)
end)

local deathsounds = {
    "vo/coast/odessa/male01/nlo_cubdeath01.wav",
    "vo/coast/odessa/male01/nlo_cubdeath02.wav",
    "vo/npc/male01/pain01.wav",
    "vo/npc/male01/pain02.wav",
    "vo/npc/male01/pain03.wav",
    "vo/npc/male01/pain04.wav",
    "vo/npc/male01/pain05.wav",
    "vo/npc/male01/pain06.wav",
    "vo/npc/male01/pain07.wav",
    "vo/npc/male01/ow01.wav",
    "vo/npc/male01/ow02.wav"
}
hook.Add("DoPlayerDeath", "hoodlum_doplayerdeath_playermanager", function(ply)
    if ply:LastHitGroup() ~= HITGROUP_HEAD then
        local snd = deathsounds[math.random(1, #deathsounds)]
        ply:EmitSound( snd, SNDLVL_NORM, 100 )
    end
end)

hook.Add("PlayerDeathSound", "hoodlum_deathsound", function(ply)
    return true
end)