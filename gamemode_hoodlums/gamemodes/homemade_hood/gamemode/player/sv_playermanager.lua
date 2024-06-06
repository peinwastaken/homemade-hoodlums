local PLAYER = FindMetaTable("Player")

function PLAYER:GetTeam()
    return player_manager.RunClass(self, "GetAlliance")
end

local specialClasses = {"player_demoncompany"}
hook.Add("PlayerRespawn", "hoodlum_giveclass", function(ply)
    local specialChance = 2 -- make a convar
    local rand = math.Rand(0, 100)
    if rand < specialChance then -- if is special...
        local specialClass = table.Random(specialClasses)

        player_manager.SetPlayerClass(ply, specialClass)
        player_manager.RunClass(ply, "OnRespawn")
    else -- if not :/
        player_manager.SetPlayerClass(ply, "player_hoodlum")
        player_manager.RunClass(ply, "OnRespawn")
    end

    ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

    net.Start("Hoodlum_PlayerRespawn")
    net.WriteString(ply:GetTeam())
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
    local hitgroup = ply:LastHitGroup()

    if hitgroup == HITGROUP_HEAD then
        hook.Run("HoodlumDeath", ply, true)
    else
        hook.Run("HoodlumDeath", ply, false)
    end
end)

hook.Add("HoodlumDeath", "hoodlum_death", function(ply, headshot)
    if not headshot then
        local snd = deathsounds[math.random(1, #deathsounds)]
        ply:EmitSound(snd, SNDLVL_NORM, 100)
    end

    ply:SetNWBool("flashlight", false)
    ply:SetNWBool("laser", false)
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