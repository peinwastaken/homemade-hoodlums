SWEP.Base = "weapon_base"

SWEP.PrintName 				= "Boombox"
SWEP.Author 				= "pein"
SWEP.Instructions			= "MC Pein - WELCOME TO THE HOMEMADE HOOD, on loop, of course."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 0
SWEP.Primary.DefaultClip	= 0

SWEP.VisualRecoil = Vector(3, 0.5, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(2, 0, 2)
SWEP.RecoilVertical = 60 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 40 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(4.25, -12, 0.05)
SWEP.AimOffsetAng           = Angle(0, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 30

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "normal"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= Model("models/pein/boombox/boombox.mdl")

SWEP.Playing = false
SWEP.CurrentSound = nil
SWEP.MaxAudioDistance = 150
SWEP.Audio = Sound("pein/boombox/homemade_hood.wav")

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end
if CLIENT then
	hook.Add("Think", "boombox.soundthink", function()
		local lply = LocalPlayer()
		local att = lply:GetAttachment(lply:LookupAttachment("eyes"))

		for _,ply in player.Iterator() do
			local wep = ply:GetActiveWeapon()

			if wep.PrintName == "Boombox" then
				local snd = wep.CurrentSound
				local dist = (wep:GetPos() - att.Pos):Length()
				local mult = 1 - (dist/wep.MaxAudioDistance)
				local multClamped = math.Clamp(mult, 0, 1)

				if snd then
					snd:ChangeVolume(1)
				end
			end
		end
	end)
end

function SWEP:Deploy()
	local ply = self:GetOwner()

	self.CurrentSound = CreateSound(self, self.Audio, player.GetAll())
	self.CurrentSound:Play()
end

function SWEP:Holster()
	if self.CurrentSound then
		self.CurrentSound:Stop()
		self.CurrentSound = nil
	end

	return true
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()

	ply:SelectWeightedSequence(ACT_HL2MP_WALK_PISTOL)
end

function SWEP:SecondaryAttack()

end