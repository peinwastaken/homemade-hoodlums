SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Draco Pistol"
SWEP.Author 				= "pein"
SWEP.Instructions			= "A very short AK..semi auto..."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 30
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.1
SWEP.Primary.Damage         = 80
SWEP.Primary.Spread         = 0.05
SWEP.Primary.BulletCount    = 1

SWEP.EjectEffect = "EjectBrass_556"

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "pein/ak74/ak_single.wav"
SWEP.Primary.SoundFar		= "pein/ak74/ak_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(2, 0.2, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(3, 0, 3)
SWEP.RecoilVertical = 150 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 50 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER
SWEP.AimWeaponTilt = -40
SWEP.PlayerModelRecoilMult = 1.5

SWEP.AimOffsetPos           = Vector(6, -4.3, 1.43)
SWEP.AimOffsetAng           = Angle(0, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "ar2"

SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/draco/w_draco.mdl"
SWEP.WorldModel				= "models/pein/draco/w_draco.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-19, -1.65, -0.42)
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
                ["SightSize"] = {x = 150, y = 125},
				["AimOffset"] = Vector(-10, -0.9, -0.2)
            }
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