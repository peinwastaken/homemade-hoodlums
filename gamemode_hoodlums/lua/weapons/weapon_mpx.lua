SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "MPX"
SWEP.Author 				= "pein"
SWEP.Instructions			= "A bit fancy for the hood, dont you think?"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.07
SWEP.Primary.Damage         = 60
SWEP.Primary.Spread         = 0.03
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/mp5navy/mp5-1.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(0.75, 0.1, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1, 0, 0)
SWEP.RecoilVertical = 70 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.5 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(-2, -3, 0)
SWEP.AimSpeed               = 7
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = -5

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/mpx/w_mpx.mdl"
SWEP.WorldModel				= "models/pein/mpx/w_mpx.mdl"

SWEP.Attachments = {
    ["sight"] = {
        ["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-5, -0.38, -0.16)
			}
		},
		["ironsights"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-5, -0.42, -0.116),
			}
		},
		["att_reflex"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["AimPosAttachment"] = "pos_reflex",
				["AimOffset"] = Vector(-7, -0.62, -0.16),
				["HoloSight"] = true,
				["ReticleMaterial"] = Material("reticles/reticle_aimpoint.vmt"),
                ["ReticleSize"] = 300,
                ["SightSize"] = {x = 125, y = 90},
				["RecoilVertical"] = -10,
			}
		},
    },
    ["stock"] = {
        ["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["RecoilVertical"] = 50,
				["RecoilHorizontal"] = 20
			}
		},
		["collapsed"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["RecoilVertical"] = 30,
				["RecoilHorizontal"] = 10
			}
		},
		["extended"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 2,
            ["effects"] = {}
		},
    },
    ["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["suppressed"] = {
			["bodygroup_id"] = 4,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Suppressed"] = true,
				["WeaponSound"] = "weapons/m4a1/m4a1-1.wav",
				["RecoilVertical"] = 15,
				["RecoilHorizontal"] = 5
			}
		}
    },
    ["magazine"] = {
        ["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["ClipSize"] = 30,
			}
		},
		["short"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["ClipSize"] = 20,
				["RecoilVertical"] = -7,
				["RecoilHorizontal"] = -5
			}
		},
		["extended"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["ClipSize"] = 40,
				["RecoilVertical"] = 15,
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
				["WeaponName"] = "MPX"
			}
		},
		["pistol"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Automatic"] = false,
				["RecoilVertical"] = -20,
				["RecoilHorizontal"] = -10,
				["WeaponName"] = "MPX Pistol"
			}
		}
	}
}