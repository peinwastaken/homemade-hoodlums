SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "M4A1"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Every weapon addon needs one of these. Featuring ATTACHMENTS!"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.085
SWEP.Primary.Damage         = 80
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/m4a1/m4a1_close.wav"
SWEP.Primary.SoundFar		= "pein/m4a1/m4a1_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1, 0.03, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1, 0, 3)
SWEP.RecoilVertical = 90 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.65 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(-3, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 7

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/m4a1/w_m4a1.mdl"
SWEP.WorldModel				= "models/pein/m4a1/w_m4a1.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights_1",
				["AimOffset"] = Vector(-3.5, -0.3, -0.01)
			}
		},
        ["irons2"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights_2",
				["AimOffset"] = Vector(-3.5, -0.29, 0)
			}
		},
        ["holo"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 2,
            ["effects"] = {
                ["HoloSight"] = true,
                ["AimPosAttachment"] = "pos_holo",
                ["ReticleMaterial"] = Material("reticles/reticle_eotech.vmt"),
                ["ReticleSize"] = 500,
                ["SightSize"] = {x = 125, y = 90},
				["RecoilVertical"] = -10,
                ["AimOffset"] = Vector(-7, -0.6, 0)
            }
		},
        ["aimpoint"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 3,
            ["effects"] = {
                ["HoloSight"] = true,
                ["AimPosAttachment"] = "pos_aimpoint",
                ["ReticleMaterial"] = Material("reticles/reticle_aimpoint.vmt"),
                ["ReticleSize"] = 200,
                ["SightRadius"] = 40,
				["RecoilVertical"] = -10,
                ["AimOffset"] = Vector(-6.9, -0.6, 0.025)
            }
		}
	},
	["stock"] = {
		["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["VisualRecoilAdd"] = Vector(-0.5, 0, 0)
			}
		},
		["padded"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["RecoilVertical"] = 20,
				["RecoilHorizontal"] = 10
			}
		},
	},
	["magazine"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 30
			}
		},
		["extended"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["ClipSize"] = 50,
				["RecoilVertical"] = 20,
				["RecoilHorizontal"] = 10
			}
		},
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Automatic"] = true,
				["WeaponName"] = "M4A1"
			}
		},
		["pistol"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Automatic"] = false,
				["RecoilVertical"] = -20,
				["RecoilHorizontal"] = -10,
				["WeaponName"] = "AR Pistol"
			}
		}
	}
}