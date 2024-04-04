SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "SIG P320"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Category: Realism"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 12
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.07
SWEP.Primary.Damage         = 60
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/usp/usp_unsil-1.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(2, 0.25, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(2, 0, 1)
SWEP.RecoilVertical = 80 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 20 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER
SWEP.AimWeaponTilt = 30

SWEP.AimOffsetPos           = Vector(3.9, -12, 0.41)
SWEP.AimOffsetAng           = Angle(-3, 0, 0)
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

SWEP.ViewModel				= "models/pein/p320/p320.mdl"
SWEP.WorldModel				= "models/pein/p320/p320.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-11, 0.1, 0)
			}
		},
		["romeo"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["HoloSight"] = true,
                ["AimPosAttachment"] = "pos_romeo",
                ["ReticleMaterial"] = Material("reticles/reticle_aimpoint.vmt"),
                ["ReticleSize"] = 200,
                ["SightSize"] = {x = 100, y = 100},
				["RecoilVertical"] = -10,
                ["AimOffset"] = Vector(-12, 0, 0)
			}
		},
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["compensator"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["RecoilVertical"] = 15,
				["RecoilHorizontal"] = 5
			}
		},
		["suppressed"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "weapons/usp/usp1.wav",
				["RecoilVertical"] = 15,
				["RecoilHorizontal"] = 5
			}
		}
    },
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 10,
			}
		},
		["extended"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["ClipSize"] = 14,
			}
		}
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
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Laser"] = true,
				["LaserAttachment"] = "pos_flashlight",
			}
		}
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				
			}
		}
	}
}