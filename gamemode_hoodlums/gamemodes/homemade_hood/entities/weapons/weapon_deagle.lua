SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Desert Eagle"
SWEP.Author 				= "pein"
SWEP.Instructions			= "I'm sure you've got the hood strength to handle it. Good luck."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 7
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.13
SWEP.Primary.Damage         = 80
SWEP.Primary.Spread         = 0.03
SWEP.Primary.BulletCount    = 1

SWEP.EjectEffect = "EjectBrass_338Mag"

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "pein/deagle/deagle_close.wav"
SWEP.Primary.SoundFar		= "pein/deagle/deagle_far.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(3, 1, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(7, 0, 2)
SWEP.RecoilVertical = 190 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 40 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER
SWEP.PlayerModelRecoilMult = 6

SWEP.AimOffsetPos           = Vector(4.25, -12, 0.05)
SWEP.AimOffsetAng           = Angle(0, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 30

SWEP.SuppressionMult = 3

SWEP.MuzzleFlashScale = 3
SWEP.MuzzleFlashStyle = 2

SWEP.BoltAnimationTime = 0.07

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "revolver"

SWEP.Slot					= 1
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/deagle/deagle.mdl"
SWEP.WorldModel				= "models/pein/deagle/deagle.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-14, 0, 0),
			}
		}
	},
	["skin"] = {
        ["none"] = {
            ["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Skin"] = 0
			}
        },
		["gold"] = {
            ["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["Skin"] = 1
			}
        }
    }
}