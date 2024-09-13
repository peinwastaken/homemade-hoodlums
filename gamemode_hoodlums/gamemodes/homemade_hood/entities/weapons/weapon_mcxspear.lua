SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "SIG MCX Spear"
SWEP.Author 				= "pein"
SWEP.Instructions			= "The cream of the crop. Obtained through questionable sources. Don't drop it, it's very expensive."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.08
SWEP.Primary.Damage         = 80
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/mcx/mcx_close.wav"
SWEP.Primary.SoundFar		= "pein/mcx/mcx_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(0.5, 0.04, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1.5, 0, 3)
SWEP.RecoilVertical = 90 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 20 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.55 -- CROUCH RECOIL MULTIPLIER
SWEP.PlayerModelRecoilMult = 1.5

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(3, -3, 0)
SWEP.AimSpeed               = 6
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 7

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

SWEP.ViewModel				= "models/pein/mcx_spear/w_mcxspear.mdl"
SWEP.WorldModel				= "models/pein/mcx_spear/w_mcxspear.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-4, 0.02, 0),
				["VisualRecoilAdd"] = Vector(0.25, 0, 0)
			}
		},
        ["holo"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["HoloSight"] = true,
                ["AimPosAttachment"] = "att_holo",
                ["ReticleMaterial"] = Material("reticles/reticle_eotech.vmt"),
                ["ReticleSize"] = 400,
                ["SightSize"] = {x = 125, y = 90},
				["RecoilVertical"] = -10,
                ["AimOffset"] = Vector(-7, 0, 0),
				["VisualRecoilAdd"] = Vector(0.5, 0, 0)
			}
		},
		--[[ doesnt load for some reason?
        ["holosun"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 2,
            ["effects"] = {
                ["HoloSight"] = true,
                ["AimPosAttachment"] = "att_holosun",
                ["ReticleMaterial"] = Material("reticles/reticle_aimpoint.vmt"),
                ["ReticleSize"] = 500,
                ["SightSize"] = {x = 125, y = 90},
				["RecoilVertical"] = -10,
                ["AimOffset"] = Vector(-7, -0.6, 0)
            }
		},]]
        ["acog"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 3,
            ["effects"] = {
                ["AimPosAttachment"] = "att_acog",
				["AimOffset"] = Vector(-2, 0, 0),
				["PIPSight"] = true,
				["PIPRadius"] = 50,
				["PIPFov"] = 15,
				["ReticleMaterial"] = Material("reticles/reticle_acog"),
                ["ReticleSize"] = 30,
				["VignetteSize"] = 40,
				["VisualRecoilAdd"] = Vector(-0.1, 0, 0)
            }
		}
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Suppressed"] = false,
			}
		},
		["suppressed"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "pein/mcx/mcx_suppressed.wav",
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 4
			}
		}
    },
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = 5,
			["bodygroup_value"] = 0,
            ["effects"] = {
			}
		},
		["flashlight"] = {
			["bodygroup_id"] = 5,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Flashlight"] = true,
				["FlashlightAttachment"] = "att_flashlight",
				["FlashlightSize"] = 0.35,
			}
		}
	},
	["stock"] = {
		["none"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 0,
            ["effects"] = {}
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
				["ClipSize"] = 40,
				["RecoilVertical"] = 10,
				["RecoilHorizontal"] = 5
			}
		},
	}
}