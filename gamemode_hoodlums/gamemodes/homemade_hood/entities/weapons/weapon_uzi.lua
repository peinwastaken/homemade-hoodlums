SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Uzi"
SWEP.Author 				= "pein"
SWEP.Instructions			= "It kills... at around 500 RPM."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 25
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.095
SWEP.Primary.Damage         = 30
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/uzi/uzi_close.wav"
SWEP.Primary.SoundFar		= "pein/uzi/uzi_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1.5, 0.04, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1, 0, 3)
SWEP.RecoilVertical = 70 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.65 -- CROUCH RECOIL MULTIPLIER
SWEP.PlayerModelRecoilMult = 4

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

SWEP.ViewModel				= "models/pein/uzi/w_uzi.mdl"
SWEP.WorldModel				= "models/pein/uzi/w_uzi.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-7.6, 0, -0.01)
			}
		},
        ["holo"] = {
			["bodygroup_id"] = 2,
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
        ["mro"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 2,
            ["effects"] = {
                ["HoloSight"] = true,
                ["AimPosAttachment"] = "pos_mro",
                ["ReticleMaterial"] = Material("reticles/reticle_aimpoint.vmt"),
                ["ReticleSize"] = 200,
                ["SightSize"] = {x = 50, y = 50},
				["RecoilVertical"] = -10,
                ["AimOffset"] = Vector(-7, 0, 0)
            }
		},
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
	["stock"] = {
		["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["extended"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["RecoilVertical"] = -15,
				["RecoilHorizontal"] = -5,
				["VisualRecoilAdd"] = Vector(-0.4, 0, 0)
			}
		},
		["wood"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["RecoilVertical"] = -30,
				["RecoilHorizontal"] = -5,
				["VisualRecoilAdd"] = Vector(-0.4, 0, 0)
			}
		},
	},
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 25
			}
		},
		["extended"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["ClipSize"] = 40,
				["RecoilVertical"] = 15,
				["RecoilHorizontal"] = 5
			}
		},
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Automatic"] = true
			}
		}
	}
}