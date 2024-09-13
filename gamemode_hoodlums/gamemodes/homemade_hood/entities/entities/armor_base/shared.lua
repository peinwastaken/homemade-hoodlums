AddCSLuaFile()
include("offsets.lua")

ENT.Type = "anim"

ENT.Name = "Base Helmet Entity"
ENT.Model = "models/pein/helmets/weldingmask/weldingmask.mdl"
ENT.Attachment = "eyes"

-- random....
ENT.Offset = Vector(0, 0, 0)
ENT.AngOffset = Angle(0, 0, 0)
ENT.Scale = 1

ENT.Durability = 100
ENT.AimSpeedMult = 1  -- only helmet
ENT.WalkSpeedMult = 1 -- only armor

ENT.Overlay = false
ENT.OverlayMaterial = nil

ENT.HudMaterial = nil
ENT.ArmorType = "helmet"

function ENT:GetOverlay()
    return self.Overlay, self.OverlayMaterial
end

function ENT:Initialize()
    self:SetModel(self.Model)
end

function ENT:Think()
    local ply = self:GetOwner()

    if IsValid(ply) then
        self:SetPos(ply:GetPos())
    end
        
    if SERVER then
        if self:Health() <= 0 or not IsValid(ply) then
            self:Remove()
        end
    end
end

function ENT:Draw()
    local ply = self:GetOwner()

    if IsValid(ply) then
        local ragdoll = ply:GetNWEntity("ragdoll")

        if IsValid(ragdoll) then
            ply = ragdoll
        end

        local mdl = ply:GetModel()
        local scale = 1
        if scales[mdl] then
            scale = scales[mdl][self.Attachment]
        end

        local offset = Vector(0, 0, 0)
        if offsets[mdl] then
            offset = offsets[mdl][self.Attachment]
        end

        local att_id = ply:LookupAttachment(self.Attachment)
        if not att_id then return end
        local att = ply:GetAttachment(att_id)
        if not att then return end
        local pos, ang = att.Pos, att.Ang

        ang:RotateAroundAxis(ang:Forward(), self.AngOffset.x)
        ang:RotateAroundAxis(ang:Right(), self.AngOffset.y)
        ang:RotateAroundAxis(ang:Up(), self.AngOffset.z)

        local forward, up, right = ang:Forward(), ang:Up(), ang:Right()
        local renderPos = pos + forward * (self.Offset.x + offset.x) + up * (self.Offset.y + offset.y) + right * (self.Offset.z + offset.z)

        self:SetRenderOrigin(renderPos)
        self:SetRenderAngles(ang)

        self:SetRenderBounds(-Vector(64, 64, 64), Vector(64, 64, 64))

        if ply == LocalPlayer() and self.ArmorType == "helmet" then
            self:SetModelScale(0)

            return
        end

        if ply:IsPlayer() then
            local wep = ply:GetActiveWeapon()
            if IsValid(wep) and wep.Base == "immersive_sweps" and ply:IsAiming() and ply == LocalPlayer() then
                self:SetModelScale(0)
            else
                self:SetModelScale(self.Scale * scale)
            end
        end
    end
    
    self:DrawModel()
end