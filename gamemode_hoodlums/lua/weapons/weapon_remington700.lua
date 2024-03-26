SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Remington 700"
SWEP.Author 				= "pein"
SWEP.Instructions			= "A fairly mediocre hunting rifle."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 1
SWEP.Primary.Damage         = 150
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/scout/scout_fire-1.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1.45, 0.2, -0.1) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(5, 0, 5)
SWEP.RecoilVertical = 200 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 100 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.65 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(-3, -6, 0)
SWEP.AimSpeed               = 4
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = -3

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/remington700/w_remington700.mdl"
SWEP.WorldModel				= "models/pein/remington700/w_remington700.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-15, -1.25, -0.55)
			}
		},
		["scope"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["AimPosAttachment"] = "pos_scope",
				["AimOffset"] = Vector(-3, -0.23, -0.12),
				["PIPSight"] = true,
				["PIPRadius"] = 90,
				["PIPFov"] = 20,
				["ReticleMaterial"] = Material("reticles/reticle_remington"),
                ["ReticleSize"] = 7000,
			}
		}
	},
    ["stock"] = {
        ["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["camo"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {}
		}
    },
    ["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		}
    },
    ["magazine"] = {
        ["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
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