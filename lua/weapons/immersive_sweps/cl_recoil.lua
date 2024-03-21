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

    local mult = 1

    if self:GetCrouching() then
        mult = self.CrouchRecoilMult
    end

    self.rec_vertical = -self.RecoilVertical * mult
    self.rec_horizontal = self.rec_horizontal + RandomFloat(-self.RecoilHorizontal, self.RecoilHorizontal) * mult

    local mult = 1
    if ply:Crouching() then
        mult = self.CrouchRecoilMult
    end

    self.eyeoffset = self.eyeoffset + self.VisualRecoil
    self.eyeangleoffset = self.eyeangleoffset + Angle(self.VisualRecoilAngle.x, self.VisualRecoilAngle.y, math.random(-self.VisualRecoilAngle.z, self.VisualRecoilAngle.z))
end

function SWEP:UpdateRecoil()
    local ply = self:GetOwner()

    self.eyeoffset = LerpVectorFT(7, self.eyeoffset, Vector(0, 0, 0))
    self.eyeangleoffset = LerpAngleFT(2, self.eyeangleoffset, Angle(0, 0, 0))
end
