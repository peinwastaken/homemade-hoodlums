SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Remington 870"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Wow another remington"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 8
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.Primary.Delay          = 0.4
SWEP.Primary.Damage         = 10
SWEP.Primary.Spread         = 0.1
SWEP.Primary.BulletCount    = 15

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "pein/remington870/remington_close.wav"
SWEP.Primary.SoundFar		= "pein/remington870/remington_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(4, 0.7, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(18, 1, 10)
SWEP.RecoilVertical = 200 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 100 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER
SWEP.AimWeaponTilt = -40

SWEP.ManualCycle = true 
SWEP.CycleTime = 0.2
SWEP.CycleSound = "pein/remington870/pump.wav"

SWEP.AimOffsetPos           = Vector(3.9, -12, 0.41)
SWEP.AimOffsetAng           = Angle(-3, 0, 0)
SWEP.AimSpeed               = 4
SWEP.AimSpreadReduction 	= true
SWEP.AimSpreadReductionMult = 0.3

SWEP.Weight					= 6
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/remington870/w_remington870.mdl"
SWEP.WorldModel				= "models/pein/remington870/w_remington870.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-10, -1.5, -0.4)
			}
		},
		["holo"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["HoloSight"] = true,
                ["AimPosAttachment"] = "pos_holo",
                ["ReticleMaterial"] = Material("reticles/reticle_eotech.vmt"),
                ["ReticleSize"] = 400,
                ["SightSize"] = {x = 100, y = 80},
				["AimOffset"] = Vector(-9, -1.5, -0.4),
				["RecoilVertical"] = -40,
				["RecoilHorizontal"] = -20,
            }
		}
	},
    ["stock"] = {
        ["none"] = {
			["bodygroup_id"] = 2,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["polymer"] = {
			["bodygroup_id"] = 2,
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
	["underbarrel"] = {
		["none"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["laser"] = {
			["bodygroup_id"] = 3,
			["bodygroup_value"] = 1,
            ["effects"] = {
				["Laser"] = true,
				["LaserAttachment"] = "pos_laser",
			}
		}
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
	}
}