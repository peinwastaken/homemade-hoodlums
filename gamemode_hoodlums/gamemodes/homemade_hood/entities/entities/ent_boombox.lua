if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.PrintName = "ent_boombox"
ENT.Author = "pein"
ENT.Spawnable = false

ENT.Model = "models/pein/boombox/boombox.mdl"
ENT.EntityHealth = 500

-- thanks faz
ENT.Songs = {
    "pein/boombox/songs/homemadehood.mp3",
    "pein/boombox/songs/chronicles.mp3",
    "pein/boombox/songs/hhblues.mp3",
    "pein/boombox/songs/nightmares.mp3",
    "pein/boombox/songs/struggle.mp3",
    "pein/boombox/songs/survivaltactics.mp3",
    "pein/boombox/songs/deadeyedevil.mp3",
    "pein/boombox/songs/deadeyedevilskibidi.mp3",
}

ENT.SelectedSong = 1

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetHealth(self.EntityHealth)
    self:DrawShadow(false)

    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end

    for i, snd in ipairs(self.Songs) do
        self.Songs[i] = CreateSound(self.Entity, snd)
    end
end

function ENT:OnRemove()
    local selected = self.SelectedSong
    local curSong = self.Songs[selected]

    if curSong:IsPlaying() then
        curSong:Stop()
    end
end

function ENT:OnTakeDamage(dmgInfo)
    local health = self:Health()
    self:SetHealth(health - dmgInfo:GetDamage())

    if self:Health() <= 0 then
        self:Remove()

        local effectData = EffectData()
        effectData:SetOrigin(self:GetPos())
        effectData:SetNormal(Vector(0, 0, 1))
        effectData:SetMagnitude(2)
        effectData:SetScale(2)
        effectData:SetRadius(5)
        util.Effect("Sparks", effectData, false)
    end
end

function ENT:Use(activator, caller, useType)
    if activator:IsPlayer() then
        local ply = activator
        local selected = self.SelectedSong
        local curSong = self.Songs[selected]

        if not curSong:IsPlaying() then
            self:EmitSound("buttons/lightswitch2.wav", 50, 120)
            curSong:Play()
        else
            self:EmitSound("buttons/lightswitch2.wav", 50, 80)
            curSong:Stop()
            
            self.SelectedSong = math.random(1, 8)

            if self.SelectedSong > #self.Songs then
                self.SelectedSong = 1
            end
        end
    end
end

function ENT:Draw()
    local lply = LocalPlayer()

    self:DrawModel()
end