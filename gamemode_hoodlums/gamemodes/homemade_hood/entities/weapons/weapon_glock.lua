SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Glock-17"
SWEP.Author 				= "pein"
SWEP.Instructions			= "New"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 12
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.08
SWEP.Primary.Damage         = 50
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 2
SWEP.EjectEffect = "EjectBrass_9mm"
SWEP.BoltAnimationTime = 0.05

SWEP.Primary.Sound          = "pein/glock/glock_close.wav"
SWEP.Primary.SoundFar		= "pein/glock/glock_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(0.8, 0.4, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(2, 0, 1)
SWEP.RecoilVertical = 60 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER
SWEP.AimWeaponTilt = 30
SWEP.PlayerModelRecoilMult = 4

SWEP.AimOffsetPos           = Vector(3.9, -12, 0.41)
SWEP.AimOffsetAng           = Angle(0, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "revolver"

SWEP.Slot					= 1
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/glock/glock17.mdl"
SWEP.WorldModel				= "models/pein/glock/glock17.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-11, 0.05, 0.01)
			}
		},
	},
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 12,
			}
		},
		["extended"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["ClipSize"] = 33,
			}
		}
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		--[[
		["suppressed"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "pein/glock/glock_suppressed.wav",
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 5
			}
		}]]
    },
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 0,
            ["effects"] = {
			}
		},
		["flashlight"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Flashlight"] = true,
				["FlashlightAttachment"] = "pos_flashlight",
				["FlashlightSize"] = 0.35,
			}
		},
		["laser"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["Laser"] = true,
				["LaserAttachment"] = "pos_laser",
			}
		}
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Automatic"] = false,
			}
		},
		["switch"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
			["effects"] = {
				["Automatic"] = true,
				["RecoilVertical"] = 15,
				["RecoilHorizontal"] = 30,
				["FireRate"] = 0.07
			}
		}
	}
}