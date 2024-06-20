SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "AKM"
SWEP.Author 				= "pein"
SWEP.Instructions			= "A relic from the battles of Homemade Grad."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.1
SWEP.Primary.Damage         = 90
SWEP.Primary.Spread         = 0.05
SWEP.Primary.BulletCount    = 1

SWEP.EjectEffect = "EjectBrass_338Mag"

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/ak47/ak47-1.wav"
SWEP.Primary.SoundFar		= "pein/ak74/ak_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1.2, 0, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(0, 0, 1)
SWEP.RecoilVertical = 120 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.9 -- CROUCH RECOIL MULTIPLIER
SWEP.AimWeaponTilt = 0
SWEP.PlayerModelRecoilMult = 1

SWEP.AimOffsetPos           = Vector(6, -4.3, 1.43)
SWEP.AimOffsetAng           = Angle(-5, 0, 0)
SWEP.AimSpeed               = 8
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1

SWEP.MuzzleFlashScale = 2

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/akm_old/akm.mdl"
SWEP.WorldModel				= "models/pein/akm_old/akm.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-13, -2.3, 0)
			}
		}
	}
}