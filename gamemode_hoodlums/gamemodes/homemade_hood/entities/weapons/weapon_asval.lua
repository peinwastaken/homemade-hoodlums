SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "AS VAL"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Demon 0-1's beloved... Right after Demon 0-2. Actually I'm not sure."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.07
SWEP.Primary.Damage         = 60
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.EjectEffect = "EjectBrass_57"

SWEP.ReloadTime             = 1.5

SWEP.Primary.Sound          = "pein/as_val/as_val_close.wav"
SWEP.Primary.SoundFar		= "pein/as_val/as_val_close.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(0.5, 0.02, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(0.8, 0, 1)
SWEP.RecoilVertical = 70 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.7 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(3, -3, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 10

SWEP.SuppressionMult = 1

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/as_val/w_as_val.mdl"
SWEP.WorldModel				= "models/pein/as_val/w_as_val.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-13, -1, 0),
				["VisualRecoilAdd"] = Vector(0, 0.05, 0),
			}
		},
        ["okp"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["HoloSight"] = true,
                ["AimPosAttachment"] = "att_okp",
                ["ReticleMaterial"] = Material("reticles/reticle_okp.vmt"),
                ["ReticleSize"] = 450,
                ["SightSize"] = {x = 125, y = 90},
				["RecoilVertical"] = -10,
				["VisualRecoilAdd"] = Vector(0, 0.05, 0),
                ["AimOffset"] = Vector(-6, -0.5, 0)
			}
		},
        ["pso"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 2,
            ["effects"] = {
                ["AimPosAttachment"] = "att_pso",
				["AimOffset"] = Vector(-2, -0.175, 0),
				["PIPSight"] = true,
				["PIPRadius"] = 60,
				["PIPFov"] = 15,
				["ReticleMaterial"] = Material("reticles/reticle_pso.vmt"),
                ["ReticleSize"] = 4000,
				["VignetteSize"] = 5000,
				["VisualRecoilAdd"] = Vector(0, 0.2, 0),
				["VisualRecoilMult"] = 0.5
            }
		}
	},
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["flashlight"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Flashlight"] = true,
				["FlashlightAttachment"] = "att_flashlight",
				["FlashlightSize"] = 0.7,
			}
		},
		["laser"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 2,
            ["effects"] = {
				["Laser"] = true,
				["LaserAttachment"] = "att_laser",
			}
		}
	},
	["barrel"] = {
        ["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Suppressed"] = true
			}
		},
    },
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Automatic"] = true,
				["WeaponName"] = "AS VAL",
				["ClipSize"] = 30,
				["FireRate"] = 0.07,
				["WeaponSound"] = "pein/as_val/as_val_close.wav"
			}
		},
		["vss"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 1, -- doesnt apply when picking up a dropped vss but automatic works fine?????
            ["effects"] = {
				["Automatic"] = false,
				["RecoilVertical"] = 30,
				["RecoilHorizontal"] = -5,
				["WeaponName"] = "VSS Vintorez",
				["ClipSize"] = 10,
				["DamageAdd"] = 30,
				["VisualRecoilAdd"] = Vector(0.3, 0.1, 0),
				["FireRate"] = 0.1,
				["WeaponSound"] = "pein/as_val/as_val_close.wav"
			}
		}
	}
}