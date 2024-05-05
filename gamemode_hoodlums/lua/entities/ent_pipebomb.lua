if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.PrintName = "throwable_grenade"
ENT.Author = "pein"

ENT.Model = "models/pein/pipebomb/w_pipebomb.mdl"
ENT.BlastDamage = 150
ENT.BlastRadius = 400
ENT.FuseTime = 4

ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "DetonationTime")

    local time = CurTime() + self.FuseTime
    self:SetDetonationTime(time)
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetModelScale(1)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:Activate()

    self:SetBodygroup(1, 1)
end

function ENT:Think()
    if SERVER then
        local detonationTime = self:GetDetonationTime()
        if detonationTime < CurTime() and IsValid(self) then
            local pos = self:GetPos()

            local trace = {}
            trace.start = pos
            trace.endpos = pos + Vector(0, 0, -20)
            local tr = util.TraceLine(trace)

            local data = EffectData()
            data:SetOrigin(trace.start)
            util.Effect("effect_explosion", data)

            if tr.Hit then
                util.Decal("Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
            end

            EmitSound("BaseExplosionEffect.Sound", pos, 0, CHAN_AUTO, 1, 600, SND_NOFLAGS, 100, 0, player.GetAll())

            util.BlastDamage(self.Entity, self:GetOwner(), pos, self.BlastRadius, self.BlastDamage)

            self:Remove()
        end
    end

    self:NextThink(CurTime())

    return true
end

function ENT:Draw()
    local att = self:GetAttachment(self:LookupAttachment("spark"))
    if att then
        local data = EffectData()
        data:SetOrigin(att.Pos)
        data:SetNormal(-att.Ang:Right())
        util.Effect("effect_spark", data)
    end

    self:DrawModel()
end