local chaos = 1
local chaosDecayTime = 3
local chaosDecayAmount = 0.02
local chaosOnKill = 0.02
local chaosOnCopKill = -0.05
local chaosOnCopKilled = 0.02
local maxCops = 3

local nextChaosDecay = CurTime() + chaosDecayTime

function GetChaos()
    return chaos
end

function GetCopSpawnChance()
    return 100 * chaos
end

hook.Add("Think", "chaosthink", function()
    if nextChaosDecay > CurTime() then return end
    nextChaosDecay = CurTime() + chaosDecayTime
    chaos = math.Clamp(chaos - chaosDecayAmount, 0, 1)
    print(chaos)
end)

hook.Add("DoPlayerDeath", "chaosdeath", function(ply, inflictor, damageInfo)
    local attacker = damageInfo:GetAttacker()
    if ply == attacker then return end

    local plyTeam = ply:GetTeam()
    if plyTeam == "cops" then
        chaos = chaos + chaosOnCopKill
    else
        chaos = chaos + chaosOnKill
    end
end)