SWEP.Base = "weapon_base"

SWEP.PrintName 				= "Hands"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Walk around like a normal person for once."
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

SWEP.WorldModel				= ""

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()

	ply:SelectWeightedSequence(ACT_HL2MP_WALK_PISTOL)
end

function SWEP:SecondaryAttack()

end