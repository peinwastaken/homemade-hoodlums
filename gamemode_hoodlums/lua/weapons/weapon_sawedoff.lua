SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Sawed-Off Shotgun"
SWEP.Author 				= "pein"
SWEP.Instructions			= "A shotgun of unknown origin. Why did you shorten the barrel?"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 2
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.Primary.Delay          = 0.1
SWEP.Primary.Damage         = 10
SWEP.Primary.Spread         = 0.2
SWEP.Primary.BulletCount    = 15

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/xm1014/xm1014-1.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(4, 1, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(4, 1, 10)
SWEP.RecoilVertical = 300 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 100 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER
SWEP.AimWeaponTilt = 30

SWEP.AimOffsetPos           = Vector(3.9, -12, 0.41)
SWEP.AimOffsetAng           = Angle(-3, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction 	= true
SWEP.AimSpreadReductionMult = 0.3

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "pistol"

SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/doublebarrel/w_doublebarrel.mdl"
SWEP.WorldModel				= "models/pein/doublebarrel/w_doublebarrel.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-20, 0, 0)
			}
		},
	}
}