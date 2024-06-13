SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Škorpion vz. 61"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Budget MP5. I think.. It doesn't matter, it's cheap and it gets the job done."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 10
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.08
SWEP.Primary.Damage         = 20
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/vz61/vz61_close.wav"
SWEP.Primary.SoundFar		= "pein/vz61/vz61_far.wav"
SWEP.ReloadSound            = "weapons/pistol/pistol_reload1.wav"

SWEP.VisualRecoil = Vector(1, 0.2, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1.5, 0, 1)
SWEP.RecoilVertical = 60 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 10 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.65 -- CROUCH RECOIL MULTIPLIER
SWEP.PlayerModelRecoilMult = 2

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

SWEP.Slot					= 1
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/vz61/w_vz61.mdl"
SWEP.WorldModel				= "models/pein/vz61/w_vz61.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = -1,
			["bodygroup_value"] = -1,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-10, 0, 0)
			}
		},
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
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["unfolded"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["RecoilVertical"] = -15,
				["RecoilHorizontal"] = -5,
				["VisualRecoilAdd"] = Vector(-0.3, -0.1, 0)
			}
		},
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Suppressed"] = false,
			}
		},
		["suppressed"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "pein/vz61/vz61_suppressed.wav",
				["RecoilVertical"] = 15,
				["RecoilHorizontal"] = 4
			}
		}
    },
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 10
			}
		},
		["extended"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["ClipSize"] = 20,
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 5
			}
		},
		["drum"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["ClipSize"] = 40,
				["RecoilVertical"] = 20,
				["RecoilHorizontal"] = 15
			}
		},
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
	}
}