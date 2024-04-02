SWEP.Base = "immersive_sweps"

SWEP.PrintName 				= "M4A1"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Every weapon addon needs one of these."
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

SWEP.ReloadTime             = 2

SWEP.Primary.Sound          = "weapons/m4a1/m4a1_unsil-1.wav"
SWEP.ReloadSound            = "weapons/ar2/ar2_reload.wav"

SWEP.VisualRecoil = Vector(1, 0.02, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(1, 0, 3)
SWEP.RecoilVertical = 90 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 30 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.65 -- CROUCH RECOIL MULTIPLIER

SWEP.AimOffsetPos           = Vector(5.5, -2, -0.989)
SWEP.AimOffsetAng           = Angle(-6, 0, 0)
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

SWEP.ViewModel				= "models/pwb2/weapons/w_m4a1.mdl"
SWEP.WorldModel				= "models/pwb2/weapons/w_m4a1.mdl"

SWEP.Attachments = {
    ["sight"] = {
        ["none"] = {
			["bodygroup_id"] = 0,
			["bodygroup_value"] = 0,
            ["effects"] = {
				["AimPosAttachment"] = "ironsights",
				["AimOffset"] = Vector(-5, -0.8, 0)
			}
		},
    }
}