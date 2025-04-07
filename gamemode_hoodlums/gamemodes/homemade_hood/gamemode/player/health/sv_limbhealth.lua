local PLAYER = FindMetaTable("Player")
util.AddNetworkString("SyncLimbData")
local friendlyFire = GetConVar("hoodlum_friendlyfire")

function PLAYER:SetupLimbs()
    self.LimbData = {}

    for k,v in pairs(defaultLimbHealth) do
        self.LimbData[k] = v
    end
end

function PLAYER:SyncLimbData()
    net.Start("SyncLimbData")
    net.WriteTable(self.LimbData)
    net.Send(self)
end

function PLAYER:PropagateDamage(limb, damage)
    for limb, mult in pairs(PropagationTable[limb]) do
        if self.LimbData[limb] <= 0 then continue end
        local newLimbHealth = math.Clamp(self.LimbData[limb] - damage * mult, 0, defaultLimbHealth[limb])
        self:SetLimbHealth(limb, newLimbHealth)
    end
end

function PLAYER:TakeLimbDamageInfo(hitgroup, dmginfo, propagated)
    local hitLimb = HitGroupToLimb[hitgroup] or hitgroup
    local limbHealth = self.LimbData[hitLimb]
    local origDamage = dmginfo:GetDamage()
    local damagedArmor = false
    local helmet, armor = self:GetNWEntity("helmet"), self:GetNWEntity("armor")

    if IsValid(helmet) and hitLimb == "Head" then
        dmginfo:ScaleDamage(0.1)
        self:TakeArmorDamage("helmet", origDamage)
    end
    
    if IsValid(armor) and hitLimb == "Torso" then
        dmginfo:ScaleDamage(0.1)
        self:TakeArmorDamage("armor", origDamage)
    end

    local damage = dmginfo:GetDamage()

    --print(origDamage)
    --print(damage)

    if self.LimbData and limbHealth then
        if self.LimbData[hitLimb] <= 0 and not propagated then
            self:PropagateDamage(hitLimb, damage)
        end

        local newHealth = math.Clamp(self.LimbData[hitLimb] - damage, 0, defaultLimbHealth[hitLimb])
        self.LimbData[hitLimb] = newHealth

        if self.LimbData["Head"] <= 0 or self.LimbData["Torso"] <= 0 then
            KillPlayerDamageInfo(self, dmginfo)
        end

        self:SyncLimbData()
    end
end

function PLAYER:TakeLimbDamage(hitgroup, damage, propagated)
    local hitLimb = HitGroupToLimb[hitgroup] or hitgroup
    local limbHealth = self.LimbData[hitLimb]

    if self.LimbData and limbHealth then
        if self.LimbData[hitLimb] <= 0 and not propagated then
            self:PropagateDamage(hitLimb, damage)
        end

        local newHealth = math.Clamp(self.LimbData[hitLimb] - damage, 0, defaultLimbHealth[hitLimb])
        self.LimbData[hitLimb] = newHealth

        if self.LimbData["Head"] <= 0 or self.LimbData["Torso"] <= 0 then
            self:Kill() -- no damage info = suicide :/
        end

        self:SyncLimbData()
    end
end

function PLAYER:SetLimbHealth(limb, newHealth)
    if not self.LimbData then return end

    self.LimbData[limb] = math.Clamp(newHealth, 0, defaultLimbHealth[limb])
    self:SyncLimbData()
end

function PLAYER:HealLimb(limb, amount)
    if not self.LimbData then return end
    
    self.LimbData[limb] = math.Clamp(self.LimbData[limb] + amount, 0, defaultLimbHealth[limb])
    self:SyncLimbData()
end

function PLAYER:HealAllLimbs(amount)
    if not self.LimbData then return end

    for limb,_ in pairs(defaultLimbHealth) do
        local newHealth = math.Clamp(self.LimbData[limb] + amount, 0, defaultLimbHealth[limb])
        self:SetLimbHealth(limb, newHealth)
    end

    self:SyncLimbData()
end

function PLAYER:DamageAllLimbs(amount)
    if not self.LimbData then return end

    for limb,_ in pairs(defaultLimbHealth) do
        local newHealth = math.Clamp(self.LimbData[limb] - amount, 0, defaultLimbHealth[limb])
        self:SetLimbHealth(limb, newHealth)
    end

    self:SyncLimbData()
end

function ResetPlayersLimbs()
    for _,ply in player.Iterator() do
        ply:SetupLimbs()
        ply:SyncLimbData()
    end
end
ResetPlayersLimbs()

hook.Add("PlayerRespawn", "hoodlum_limbrespawn", function(ply)
    ply:SetupLimbs()
    ply:SyncLimbData()
end)

hook.Add("PlayerShouldTakeDamage", "hoodlum_shouldtakedamage", function(ply, attacker)
    return false
end)


local fallsounds = {
    "player/pl_fallpain3.wav",
    "player/pl_fallpain1.wav"
}
hook.Add("OnPlayerHitGround", "hoodlum_hitground", function(ply, inWater, onFloater, speed)
    if ply:HasGodMode() then return end
    local limbData = ply:GetLimbData()

    if not limbData then return true end

    local rightLeg, leftLeg = limbData["RightLeg"], limbData["LeftLeg"]
    local damage = speed/12

    local minSpeed = 450
    local maxSpeed = 1500
    local mult = 0
    if speed > minSpeed then
        mult = math.Clamp(speed / maxSpeed, 0, 1)
    end

    if speed > minSpeed then
        ply:TakeLimbDamage("RightLeg", damage, false)
        ply:TakeLimbDamage("LeftLeg", damage, false)

        if limbData["RightLeg"] < LimbBrokenHealth["RightLeg"] or limbData["LeftLeg"] < LimbBrokenHealth["LeftLeg"] then
            local snd = fallsounds[math.random(1, #fallsounds)]
            ply:EmitSound(snd, 60)
        end
    end

    return true
end)

hook.Add("PostEntityTakeDamage", "hoodlum_limbdamage", function(ent, dmgInfo, tookDamage)
    if not ent:IsPlayer() then return end
    if ent:HasGodMode() then return end

    if ent:Armor() > 0 then
        local newArmor = math.max(0, ent:Armor() - dmgInfo:GetDamage() / 2)
        ent:SetArmor(newArmor)
        return
    end

    local attacker = dmgInfo:GetAttacker()
    
    if IsValid(attacker) and attacker:IsPlayer() and not friendlyFire:GetBool() then
        local victimTeam = ent:GetTeam()
        local attackerTeam = attacker:GetTeam()
        
        if victimTeam and attackerTeam and victimTeam == attackerTeam then
            dmgInfo:SetDamage(0)
            return
        end
    end
    
    local limbData = ent:GetLimbData()
    local dmgType = dmgInfo:GetDamageType()
    local dmg = dmgInfo:GetDamage()

    net.Start("PlayerDamage")
    net.Send(ent)

    if dmgType == DMG_BLAST then
        if dmgInfo:GetDamage() > 20 then
            local dir = dmgInfo:GetDamageForce()
            local dirNormal = dir:GetNormalized()
            local vel = dirNormal * 300
            ent:TakeLimbDamage("Torso", dmg, false)
            ent:PropagateDamage("Torso", dmg, true)
            ent:ToggleRagdoll(nil, true, "weapon_hands", vel)
        end

        return -- Bye!
    end

    if dmgInfo:IsDamageType(DMG_BULLET) then
        local hitGroup = ent:LastHitGroup()
        ent:TakeLimbDamageInfo(hitGroup, dmgInfo, false)

        return -- Bye!
    end

    -- Hello!
    ent:TakeLimbDamage("Torso", dmg, false)
    ent:PropagateDamage("Torso", dmg, true)
end)
