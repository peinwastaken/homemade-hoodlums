hook.Add("PlayerRespawn", "hoodlum_giveclass", function(ply) 
    player_manager.SetPlayerClass(ply, "player_hoodlum")
    player_manager.RunClass(ply, "OnRespawn")
    ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

    net.Start("Hoodlum_PlayerRespawn")
    net.WriteString(player_manager.RunClass(ply, "GetAlliance"))
    net.Send(ply)
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
hook.Add("DoPlayerDeath", "hoodlum_doplayerdeath_playermanager", function(ply, attacker, dmginfo)
    if ply:LastHitGroup() ~= HITGROUP_HEAD then
        local snd = deathsounds[math.random(1, #deathsounds)]
        ply:EmitSound( snd, SNDLVL_NORM, 100 )
    end
end)

hook.Add("PlayerDeathSound", "hoodlum_deathsound", function(ply)
    return true
end)

hook.Add("GetFallDamage", "hoodlum_falldamage", function(ply, velocity)
    return velocity/6
end)

hook.Add("PlayerCanPickupWeapon", "canpickupwep", function(ply, wep)
    local class = wep:GetClass()

    if ply:HasWeapon(class) then
        return false
    end

    return true
end)