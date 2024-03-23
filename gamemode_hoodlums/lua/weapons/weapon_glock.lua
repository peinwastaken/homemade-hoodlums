SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "Glock-17"
SWEP.Author 				= "pein"
SWEP.Instructions			= "New"
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 12
SWEP.Primary.DefaultClip	= 9999 -- 120
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay          = 0.07
SWEP.Primary.Damage         = 50
SWEP.Primary.Spread         = 0.02
SWEP.Primary.BulletCount    = 1

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/glock/glock18-1.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(2, 0.25, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(3, 0, 3)
SWEP.RecoilVertical = 60 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.75 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(1.9, -12, 0)
SWEP.AimOffsetAng           = Angle(-2, 0, 0)
SWEP.AimSpeed               = 5
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "revolver"

SWEP.Slot					= 1
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pwb/glock/w_glock17.mdl"
SWEP.WorldModel				= "models/pwb/glock/w_glock17.mdl"

SWEP.Attachments = {
	["sight"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
	},
	["grip"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
	},
	["extra"] = {
		["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {}
		},
		["switch"] = {
			["bodygroup_id"] = 1,
			["bodygroup_value"] = 1,
			["effects"] = {
				["Automatic"] = true,
				["RecoilVertical"] = 60,
				["RecoilHorizontal"] = 30
			}
		}
	}
}