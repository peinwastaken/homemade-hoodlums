SWEP.Base = "consumable_base"

-- informations
SWEP.PrintName = "Cigarettes"
SWEP.Author = "pein"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Newports. Or something."

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.HoldType = "passive"

SWEP.Spawnable = false

-- model
SWEP.ViewModel = "models/pein/cigarette/w_cigarette.mdl"
SWEP.WorldModel = "models/pein/cigarette/w_cigarette.mdl"

SWEP.StartAmount = 75
SWEP.MaxAmount = 75
SWEP.UseDelay = 0.2
SWEP.Alcohol = 0

SWEP.CanDrop = true

SWEP.Emitter = nil

function SWEP:Reload()
    if IsFirstTimePredicted() then
        if SERVER then
            
        end
    end
end

function SWEP:Think()
    local ply = self:GetOwner()
    local using = self:GetUsing()
    local remaining = self:GetRemaining()
	local lastuse = self:GetLastUse()

    if ply:KeyDown(IN_ATTACK) then
        self:SetUsing(true)
    else
        self:SetUsing(false)
    end

    if using then
        self:SetRemaining(remaining - 5 * engine.TickInterval())
    end

    self:SetWeaponHoldType(self.HoldType)
end


function SWEP:DrawHUD()
    local remaining = self:GetRemaining()

	local mult = math.Clamp(remaining / self.MaxAmount, 0, 100)

    draw.SimpleText(string.format("%.1f", 100 * mult) .. "%", "CloseCaption_Bold", 50, ScrH() - 200, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    --draw.SimpleText(self:Ammo1(), "CloseCaption_Bold", 50, ScrH() - 175, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function SWEP:Animate()
	local ply = self:GetOwner()
    local using = self:GetUsing()
    local remaining = self:GetRemaining()

    local progress = math.Clamp(remaining / self.MaxAmount, 0, 1)

    self:SetPoseParameter("progress", 1 - progress)

	-- head
	local head = ply:LookupBone("ValveBiped.Bip01_Head1")

	-- right
	local upperR = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
	local lowerR = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
	local handR = ply:LookupBone("ValveBiped.Bip01_R_Hand")

	-- left
	local upperL = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
	local lowerL = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
	local handL = ply:LookupBone("ValveBiped.Bip01_L_Hand")

	-- variable soup
	self.anglehead = self.anglehead or Angle(0, 0, 0)

	self.angleupperR = self.angleupperR or Angle(0, 0, 0)
    self.angleforeR = self.angleforeR or Angle(0, 0, 0)
    self.anglehandR = self.anglehandR or Angle(0, 0, 0)

    self.angleupperL = self.angleupperL or Angle(0, 0, 0)
    self.angleforeL = self.angleforeL or Angle(0, 0, 0)
    self.anglehandL = self.anglehandL or Angle(0, 0, 0)

    -- animate here
    local lerpHand = 8 * FrameTime()

    -- using
    if using then
        self.angleupperR = LerpAngle(lerpHand, self.angleupperR, Angle(20, -30, 20))
        self.angleforeR = LerpAngle(lerpHand, self.angleforeR, Angle(-0, -40, 0))
        self.anglehandR = LerpAngle(lerpHand, self.anglehandR, Angle(0, 0, 60))

        self.angleupperL = LerpAngle(lerpHand, self.angleupperL, Angle(-5, 0, 30))
        self.angleforeL = LerpAngle(lerpHand, self.angleforeL, Angle(0, 40, 0))
        self.anglehandL = LerpAngle(lerpHand, self.anglehandL, Angle(0, 0, 70))
    else
        self.angleupperR = LerpAngle(lerpHand, self.angleupperR, Angle(5, 0, -30))
        self.angleforeR = LerpAngle(lerpHand, self.angleforeR, Angle(40, 20, 0))
        self.anglehandR = LerpAngle(lerpHand, self.anglehandR, Angle(40, 0, 0))

        self.angleupperL = LerpAngle(lerpHand, self.angleupperL, Angle(-5, 0, 30))
        self.angleforeL = LerpAngle(lerpHand, self.angleforeL, Angle(0, 40, 0))
        self.anglehandL = LerpAngle(lerpHand, self.anglehandL, Angle(0, 0, 70))
    end

	-- set bone angles
	ply:ManipulateBoneAngles(head, self.anglehead, false)

	ply:ManipulateBoneAngles(upperR, self.angleupperR, false)
	ply:ManipulateBoneAngles(lowerR, self.angleforeR, false)
	ply:ManipulateBoneAngles(handR, self.anglehandR, false)

	ply:ManipulateBoneAngles(upperL, self.angleupperL, false)
	ply:ManipulateBoneAngles(lowerL, self.angleforeL, false)
	ply:ManipulateBoneAngles(handL, self.anglehandL, false)
end