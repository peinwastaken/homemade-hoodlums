local chaos = 0
local chaosDecayTime = 3
local chaosDecayAmount = 0.02
local chaosOnKill = 0.02
local chaosOnCopKill = -0.05
local chaosOnCopKilled = 0.02
local maxCops = math.Clamp(game.MaxPlayers() * 0.25, 1, 9999)

local nextChaosDecay = CurTime() + chaosDecayTime

function GetChaos()
    return chaos
end

function GetCopSpawnChance()
    return 100 * chaos
end

function GetMaxCops()
    return maxCops
end

function GetCopCount()
    local count = 0
    local totalPlayers = 0
    
    for _, ply in ipairs(player.GetAll()) do
        totalPlayers = totalPlayers + 1
        
        if not IsValid(ply) then continue end
        
        local alliance = player_manager.RunClass(ply, "GetAlliance")
        if alliance == "cops" then
            count = count + 1
        end
    end
    return count
end

hook.Add("Think", "chaosthink", function()
    if nextChaosDecay > CurTime() then return end
    nextChaosDecay = CurTime() + chaosDecayTime
    chaos = math.Clamp(chaos - chaosDecayAmount, 0, 1)
    --print(chaos)
end)

hook.Add("PlayerDeath", "chaosdeath", function(ply, inflictor, attacker)
    if ply == attacker then return end

    local plyTeam = ply:GetTeam()
    if plyTeam == "cops" then
        chaos = chaos + chaosOnCopKill
    else
        chaos = chaos + chaosOnKill
    end
end)