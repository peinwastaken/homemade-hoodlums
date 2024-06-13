local PLAYER = FindMetaTable("Player")
util.AddNetworkString("SyncLimbData")

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
        local newLimbHealth = self.LimbData[limb] - damage * mult
        self:SetLimbHealth(limb, newLimbHealth)
    end
end

function PLAYER:TakeLimbDamage(hitgroup, damage, propagated)
    local hitLimb = HitGroupToLimb[hitgroup]
    local limbHealth = self.LimbData[hitLimb]

    if self.LimbData and limbHealth then
        self.LimbData[hitLimb] = math.Clamp(self.LimbData[hitLimb] - damage, 0, defaultLimbHealth[hitLimb])

        if self.LimbData[hitLimb] <= 0 and not propagated then
            self:PropagateDamage(hitLimb, damage)
        end

        if self.LimbData["Head"] <= 0 or self.LimbData["Torso"] <= 0 then
            self:Kill()
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

hook.Add("PostEntityTakeDamage", "hoodlum_limbdamage", function(ent, dmgInfo, tookDamage)
    if not ent:IsPlayer() then return end

    local dmgType = dmgInfo:GetDamageType()
    local dmg = dmgInfo:GetDamage()

    net.Start("PlayerDamage")
    net.Send(ent)

    --[[
    if dmgType == DMG_BLAST then
        if dmginfo:GetDamage() > 20 then
            local dir = dmginfo:GetDamageForce()
            local dirNormal = dir:GetNormalized()
            local vel = dirNormal * 300
            ent:ToggleRagdoll(nil, true, "weapon_hands", vel)
            return true
        end
    end]]

    if dmgInfo:IsDamageType(DMG_BULLET) then
        local hitGroup = ent:LastHitGroup()
        ent:TakeLimbDamage(hitGroup, dmg, false)
    end
end)