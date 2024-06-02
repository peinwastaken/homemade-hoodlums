SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "MAC-10"
SWEP.Author 				= "pein"
SWEP.Instructions			= ""
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.06
SWEP.Primary.Damage         = 30
SWEP.Primary.Spread         = 0.04
SWEP.Primary.BulletCount    = 1

SWEP.EjectEffect = "EjectBrass_9mm"

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/mac10/mac10_close.wav"
SWEP.Primary.SoundFar		= "pein/mac10/mac10_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1.25, 0.05, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1.25, 0, 2)
SWEP.RecoilVertical = 70 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.65 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(-3, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 30

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "revolver"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/mac10/w_mac10.mdl"
SWEP.WorldModel				= "models/pein/mac10/w_mac10.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = -1,
			["bodygroup_value"] = -1,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-7, -0.1, 0.01)
			}
		}
	},
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = -1,
			["bodygroup_value"] = -1,
            ["effects"] = {}
		}
	},
	["stock"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["extended"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["RecoilVertical"] = -10,
				["RecoilHorizontal"] = -10,
				["VisualRecoilAdd"] = Vector(-0.5, 0, 0)
			}
		}
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Suppressed"] = false
			}
		},
		["flashhider"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Suppressed"] = false,
				["RecoilVertical"] = -5,
				["RecoilHorizontal"] = -5
			}
		},
		["suppressed"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "pein/mac10/mac10_suppressed.wav",
				["RecoilVertical"] = 15,
				["RecoilHorizontal"] = 10
			}
		}
    },
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = -1,
			["bodygroup_value"] = -1,
            ["effects"] = {
				["ClipSize"] = 30
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