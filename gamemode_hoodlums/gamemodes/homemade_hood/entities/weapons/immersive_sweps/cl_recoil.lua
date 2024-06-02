SWEP.eyeoffset = Vector(0, 0, 0)
SWEP.eyeangleoffset = Angle(0, 0, 0)
SWEP.rec_vertical = 0
SWEP.rec_horizontal = 0

hook.Add("Think", "do recoil", function()
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()

    if wep.Base == "immersive_sweps" then
        wep:UpdateRecoil()
    end
end)

-- holy shit
local last = SysTime()
hook.Add("StartCommand", "recoil setupmove", function(ply, cmd)
    local wep = ply:GetActiveWeapon()

    if wep.Base == "immersive_sweps" then
        local viewangles = cmd:GetViewAngles()

        local ft = SysTime() - last

        cmd:SetViewAngles(viewangles + Angle(wep.rec_vertical, wep.rec_horizontal, 0) * ft)

        wep.rec_vertical = Lerp(20 * ft, wep.rec_vertical, 0)
        wep.rec_horizontal = Lerp(20 * ft, wep.rec_horizontal, 0)
    end

    last = SysTime()
end)

function SWEP:GetRecoil()
	return self.eyeoffset, Vector(self.rec_vertical, self.rec_horizontal, 0)
end

function SWEP:ApplyRecoil()
	local ply = self:GetOwner()
    local att_effects = self:GetAttachmentEffects()

    local recoil_vert_add, recoil_hor_add, recoil_vis_add = 0, 0, Vector(0, 0, 0)
    if att_effects["RecoilVertical"] then
        recoil_vert_add = recoil_vert_add + att_effects["RecoilVertical"]
    end
    if att_effects["RecoilHorizontal"] then
        recoil_hor_add = recoil_hor_add + att_effects["RecoilHorizontal"]
    end
    if att_effects["VisualRecoilAdd"] then
        recoil_vis_add = recoil_vis_add + att_effects["VisualRecoilAdd"]
    end

    local mult = 1

    if self:GetCrouching() then
        mult = self.CrouchRecoilMult
    end

    local recoil_vert = math.Clamp(self.RecoilVertical + recoil_vert_add, 0, 999)
    local recoil_hor = math.Clamp(self.RecoilHorizontal + recoil_hor_add, 0, 999)

    self.rec_vertical = -recoil_vert * mult
    self.rec_horizontal = recoil_hor * RandomFloat(-1, 1) * mult

    local mult = 1
    if ply:Crouching() then
        mult = self.CrouchRecoilMult
    end

    self.eyeoffset = self.eyeoffset + (self.VisualRecoil + recoil_vis_add) * (att_effects["VisualRecoilMult"] or 1)
    self.eyeangleoffset = self.eyeangleoffset + Angle(self.VisualRecoilAngle.x, self.VisualRecoilAngle.y, math.random(-self.VisualRecoilAngle.z, self.VisualRecoilAngle.z))
end

function SWEP:UpdateRecoil()
    local ply = self:GetOwner()

    self.eyeoffset = LerpVectorFT(7, self.eyeoffset, Vector(0, 0, 0))
    self.eyeangleoffset = LerpAngleFT(2, self.eyeangleoffset, Angle(0, 0, 0))
end
