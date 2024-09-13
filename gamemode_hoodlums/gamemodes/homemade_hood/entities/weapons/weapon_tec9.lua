SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "TEC-9"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Good for eco rounds."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.06
SWEP.Primary.Damage         = 30
SWEP.Primary.Spread         = 0.04
SWEP.Primary.BulletCount    = 1

SWEP.EjectEffect = "EjectBrass_9mm"

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/tec9/tec9_close.wav"
SWEP.Primary.SoundFar		= "pein/tec9/tec9_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1, 0.1, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1.25, 0, 2)
SWEP.RecoilVertical = 90 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.65 -- CROUCH RECOIL MULTIPLIER
SWEP.PlayerModelRecoilMult = 3

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(-3, 0, 0)
SWEP.AimSpeed               = 8
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

SWEP.ViewModel				= "models/pein/tec9/tec9.mdl"
SWEP.WorldModel				= "models/pein/tec9/tec9.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-8, 0, 0)
			}
		},
		["holo"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["HoloSight"] = true,
                ["AimPosAttachment"] = "pos_holo",
                ["ReticleMaterial"] = Material("reticles/reticle_eotech.vmt"),
                ["ReticleSize"] = 400,
                ["SightSize"] = {x = 125, y = 90},
				["RecoilVertical"] = -10,
                ["AimOffset"] = Vector(-10, 0, 0)
			}
		},
	},
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["laser"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Laser"] = true,
				["LaserAttachment"] = "pos_laser",
			}
		}
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Suppressed"] = false
			}
		},
		["suppressed"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "pein/vz61/vz61_suppressed.wav",
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 5
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
				["RecoilVertical"] = 5
			}
		},
		["extendeded"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["ClipSize"] = 30,
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 4
			}
		},
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["auto"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Automatic"] = true,
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 10
			}
		}
	}
}