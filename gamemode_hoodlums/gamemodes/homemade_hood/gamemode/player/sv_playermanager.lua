local PLAYER = FindMetaTable("Player")
local specialChance = CreateConVar("hoodlum_special_chance", 2, FCVAR_NONE, "Change special class spawn chance.", 0, 100)
local friendlyFire = CreateConVar("hoodlum_friendlyfire", "1", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable or disable friendly fire.", 0, 1)

function PLAYER:GetTeam()
    return player_manager.RunClass(self, "GetAlliance")
end

local allItems = {
    ["primary"] = {
        "weapon_m4",
        "weapon_m4_new",
        "weapon_draco",
        "weapon_mpx",
        "weapon_aks74u",
        "weapon_remington870",
        "weapon_uzi",
        "weapon_mac10",
        "weapon_akm",
        "weapon_remington700",
        "weapon_mcxspear",
        "weapon_g3",
        "weapon_asval"
    },
    ["secondary"] = {
        "weapon_m1911",
        "weapon_glock",
        "weapon_sawedoff",
        "weapon_p320",
        "weapon_vz61",
        "weapon_tec9",
        "weapon_deagle"
    },
    ["melee"] = {
        "melee_bat"
    },
    ["throwable"] = {
        "weapon_pipebomb"
    },
    ["utility"] = {
        "deployable_ammobox",
    }
}

local specialClasses = {"player_demoncompany"}
hook.Add("PlayerRespawn", "hoodlum_giveclass", function(ply)
    local rand = math.Rand(0, 100)
    if rand < specialChance:GetFloat() then
        local specialClass = table.Random(specialClasses)

        player_manager.SetPlayerClass(ply, specialClass)
        player_manager.RunClass(ply, "OnRespawn")
    else
        local maxCops = GetMaxCops()
        local currentCops = GetCopCount()
        local copChance = GetCopSpawnChance()
        local rnd = math.Rand(0, 100)
        if rnd < copChance && currentCops <= maxCops then
            player_manager.SetPlayerClass(ply, "player_cops")
        else
            player_manager.SetPlayerClass(ply, "player_hoodlum")
        end
        
        if navmesh.IsLoaded() then
            player_manager.RunClass(ply, "OnRespawn")
        else
            player_manager.RunClass(ply, "OnRespawn", allItems)
        end
    end

    ply:AddEFlags(EFL_NO_DAMAGE_FORCES)

    net.Start("Hoodlum_PlayerRespawn")
    net.WriteString(ply:GetTeam())
    net.Send(ply)
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

hook.Add("PlayerCanPickupWeapon", "canpickupwep", function(ply, wep)
    local class = wep:GetClass()

    if ply:HasWeapon(class) then
        return false
    end

    return true
end)
