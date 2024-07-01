SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "G3A3"
SWEP.Author 				= "pein"
SWEP.Instructions			= "A bit of Cold War era kino. German rifle of German origin. German."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 15
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.095
SWEP.Primary.Damage         = 80
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/g3/g3_close.wav"
SWEP.Primary.SoundFar		= "pein/g3/g3_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1, 0.2, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1.5, 0, 3)
SWEP.RecoilVertical = 85 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 45 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.8 -- CROUCH RECOIL MULTIPLIER
SWEP.PlayerModelRecoilMult = 1.5

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(0, -3, 0)
SWEP.AimSpeed               = 6
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 4

SWEP.SuppressionMult = 2

SWEP.MuzzleFlashScale = 2

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/g3a3/g3a3.mdl"
SWEP.WorldModel				= "models/pein/g3a3/g3a3.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-6.5, -0.35, 0),
			}
		},
        ["specter"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["AimPosAttachment"] = "pos_specter",
                ["PIPSight"] = true,
				["PIPRadius"] = 80,
				["FovSettings"] = {
					[1] = 48, -- 1x-ish
					[2] = 10 -- "4x" except not since im restarted
				},
				["ReticleMaterial"] = Material("reticles/reticle_specter"),
                ["ReticleSize"] = 50,
				["VignetteSize"] = 60,
				["VisualRecoilAdd"] = Vector(-0.2, 0, 0),
				["AimOffset"] = Vector(-3, -0.1, 0),
			}
		},
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Suppressed"] = false,
				["RecoilVertical"] = 0,
				["RecoilHorizontal"] = 0
			}
		},
		["compensator"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["RecoilVertical"] = 7,
				["RecoilHorizontal"] = -8
			}
		},
		["suppressed"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "pein/g3/g3_suppressed.wav",
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 4
			}
		}
    },
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = -1,
			["bodygroup_value"] = -1,
            ["effects"] = {
			}
		}
	},
	["stock"] = {
		["none"] = {
			["bodygroup_id"] = -1,
			["bodygroup_value"] = -1,
            ["effects"] = {}
		}
	},
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 15
			}
		},
		["extended"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["ClipSize"] = 25,
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 5
			}
		},
		["drum"] = { -- fucking hell
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["ClipSize"] = 100,
				["RecoilVertical"] = 75,
				["RecoilHorizontal"] = 40
			}
		}
	}
}