SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "M1911"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Old"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 7
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.09
SWEP.Primary.Damage         = 60
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/usp/usp_unsil-1.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(3, 0.5, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(4, 0, 2)
SWEP.RecoilVertical = 80 -- VERTICAL RECOIL
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

SWEP.HoldType               = "revolver"

SWEP.Slot					= 1
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/m1911/m1911.mdl"
SWEP.WorldModel				= "models/pein/m1911/m1911.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-11, 0, 0)
			}
		}
	}
}