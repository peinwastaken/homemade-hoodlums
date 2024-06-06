if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.PrintName = "ent_ammobox"
ENT.Author = "pein"
ENT.Spawnable = false

ENT.Model = "models/pein/ammobox/ammobox.mdl"
ENT.MaxUses = 15
ENT.BodygroupString = "041"
ENT.EntityHealth = 850

ENT.UseSounds = {
    "pein/ammobox/use1.wav",
    "pein/ammobox/use2.wav",
    "pein/ammobox/use3.wav",
    "pein/ammobox/use4.wav",
    "pein/ammobox/use5.wav",
}

hook.Add("PostDrawOpaqueRenderables", "ammobox_postdrawopaque", function()
    local lply = LocalPlayer()
    local ammoboxes = ents.FindByClass("ent_ammobox")

    for _,ammobox in pairs(ammoboxes) do
        local localPos, ammoPos = lply:GetPos(), ammobox:GetPos()
        local dir = localPos - ammoPos
        local dist = dir:Length()
        local angle = dir:Angle()
        if dist < 64 then
            cam.Start3D2D(ammoPos + Vector(0, 0, 16), Angle(0, angle.y + 90, 90), 0.2)
                local usesLeft = ammobox:GetUsesRemaining()

                draw.SimpleText(usesLeft, "HudDefault", 0, 0, colorLerp, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            cam.End3D2D()
        end
    end
end)

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "UsesRemaining")

    self:SetUsesRemaining(self.MaxUses)
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetBodyGroups(self.BodygroupString)
    self:SetHealth(self.EntityHealth)

    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end
end

function ENT:OnRemove()
    local useDiv = self:GetUsesRemaining() / self.MaxUses
    local effectData = EffectData()
    effectData:SetOrigin(self:GetPos())
    effectData:SetNormal(Vector(0, 0, 1))
    effectData:SetMagnitude(3 * useDiv)
    effectData:SetScale(2)
    effectData:SetRadius(5)
    util.Effect("Sparks", effectData, false)
end

function ENT:OnTakeDamage(dmgInfo)
    local health = self:Health()
    self:SetHealth(health - dmgInfo:GetDamage())

    if self:Health() <= 0 then
        self:Remove()
    end
end

function ENT:Use(activator, caller, useType)
    if activator:IsPlayer() then
        local ply = activator
        local wep = ply:GetActiveWeapon()
        local usesLeft = self:GetUsesRemaining()

        if wep.Base == "immersive_sweps" then
            local magsLeft = wep:GetMagazinesRemaining()
            local magsMax = wep.MaxMagazines

            if magsLeft < magsMax then
                wep:SetMagazinesRemaining(magsLeft + 1)
                self:SetUsesRemaining(usesLeft - 1)

                local snd = table.Random(self.UseSounds)
                self:EmitSound(snd, 500)
                
                local useDiv = self:GetUsesRemaining() / self.MaxUses
                local value = math.floor(4 * useDiv)
                self:SetBodygroup(1, value)

                if self:GetUsesRemaining() <= 0 then
                    self:Remove()
                end
            end
        end
    end
end

function ENT:Draw()
    local lply = LocalPlayer()

    self:DrawModel()
end