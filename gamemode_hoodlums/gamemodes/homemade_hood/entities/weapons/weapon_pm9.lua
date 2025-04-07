SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "PM9"
SWEP.Author 				= "pein"
SWEP.Instructions			= "EVIL GUN"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 20
SWEP.Primary.DefaultClip	= 9999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.1
SWEP.Primary.Damage         = 100
SWEP.Primary.Spread         = 0.08
SWEP.Primary.BulletCount    = 1
SWEP.Primary.TracerName = nil

SWEP.EjectEffect = "EjectBrass_9mm"
SWEP.MuzzleEffect = "effect_muzzleflash_evil"

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/pm9/pm9.wav"
SWEP.Primary.SoundFar		= "pein/pm9/pm9_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(2, 0.25, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(3, 0, 1)
SWEP.RecoilVertical = 70 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 25 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 3 -- CROUCH RECOIL MULTIPLIER
SWEP.PlayerModelRecoilMult = 1

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(-3, 0, 0)
SWEP.AimSpeed               = 8
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 30

SWEP.BoltAnimationTime = 0.05
SWEP.MuzzleFlashScale = 2
SWEP.SuppressionMult = 4

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "smg"

SWEP.Slot					= 1
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/pm9/w_pm9.mdl"
SWEP.WorldModel				= "models/pein/pm9/w_pm9.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-3, 1, 0)
			}
		}
	},
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
			}
		}
    },
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 10
			}
		}
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
	}
}