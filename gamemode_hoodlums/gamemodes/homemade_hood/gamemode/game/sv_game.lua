-- network strings
util.AddNetworkString("Hoodlum_PlayerRespawn")
util.AddNetworkString("PlayerDeath")
util.AddNetworkString("DeathEvent")
util.AddNetworkString("PlayerDamage")

function GetRandomNavPoint()
    local navpoints = navmesh.GetAllNavAreas()
    local rand, selected

    if #navpoints > 0 then
        repeat
            rand = math.random(1, #navpoints)
            selected = navpoints[rand]
        until selected:IsUnderwater() == false

        return selected:GetCenter()
    end

    return nil
end

function RespawnPlayer(ply, t)
    local time = t or 5

    timer.Simple(time, function()
        ply:Spawn()

        local mins, maxs = ply:GetHull()

        local spawnpos = Vector(0, 0, 0)
        local found = false

        local navpoints = navmesh.GetAllNavAreas()

        if #navpoints > 0 then
            repeat
                print("trying to find spawn for " .. ply:Name())
    
                local pos = GetRandomNavPoint()
                local trace = util.TraceHull({
                    start = pos + Vector(0, 0, 32),
                    endpos = pos + Vector(0, 0, 32),
                    maxs = maxs,
                    mins = mins,
                    filter = ply,
                    ignoreworld = false
                })
    
                if not trace.Hit then
                    --print("found spawn!")
                    found = true
                    spawnpos = pos + Vector(0, 0, 8)
                else
                    --print("finding new spawn")
                end
            until found
    
            ply:SetPos(spawnpos)
        end

        hook.Run("PlayerRespawn", ply)
    end)
end

hook.Add("PlayerDeath", "hoodlum_playerdeath", function(ply, inflictor, attacker)
    RespawnPlayer(ply, 5)

    net.Start("PlayerDeath")
    net.WritePlayer(ply)
    net.WriteEntity(inflictor)
    net.WriteEntity(attacker)
    net.Broadcast()

    if ply:LastHitGroup() == HITGROUP_HEAD then
        net.Start("DeathEvent")
        net.WriteBool(true)
        net.Send(ply)
    else
        net.Start("DeathEvent")
        net.WriteBool(false)
        net.Send(ply)
    end
end)

hook.Add("PlayerDeathThink", "hoodlum_deaththink", function(ply)
    return true
end)