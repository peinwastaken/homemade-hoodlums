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

ENT.SoundClose = "pein/pipebomb/pipebomb_close.wav"
ENT.SoundFar = "pein/pipebomb/pipebomb_far.wav"
ENT.SoundFuse = "pein/pipebomb/pipebomb_fuse.wav"

ENT.Spawnable = false

if SERVER then
	util.AddNetworkString("DoEcho")
end

if CLIENT then
	net.Receive("DoEcho", function()
		-- farsound, pos, player
		local snd = net.ReadString()
		local pos = net.ReadVector()
		local lply = LocalPlayer()

		if not IsValid(lply) then return end

		local mindist = 150
		local maxdist = 1500
		local dist = (pos - lply:EyePos()):Length() - mindist
		local mult = math.Clamp(dist / maxdist, 0, 1)

		sound.Play(snd, pos, 500, 60, mult, 1)
	end)
end

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

    self:EmitSound(self.SoundFuse, 50)
end

function ENT:Think()
    local owner = self:GetOwner()
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

            self:StopSound(self.SoundFuse)

            EmitSound(self.SoundClose, pos, 0, CHAN_AUTO, 1, 350, SND_NOFLAGS, 100, 0, player.GetAll())

            -- explosion sound, copied from immersive_sweps
            net.Start("DoEcho")
		    net.WriteString(self.SoundFar)
		    net.WriteVector(pos)
		    net.Broadcast()

            util.BlastDamage(self.Entity, owner, pos, self.BlastRadius, self.BlastDamage)

            self:Remove()
        end
    end

    self:NextThink(CurTime())

    return true
end

function ENT:Draw()
    -- mentally deficient. 
    local att = self:GetAttachment(self:LookupAttachment("spark"))
    if att then
        local data = EffectData()
        data:SetOrigin(att.Pos)
        data:SetNormal(-att.Ang:Right())
        util.Effect("effect_spark", data)
    end

    self:DrawModel()
end