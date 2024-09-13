if SERVER then
	AddCSLuaFile("sh_statuseffects.lua")
	include("sh_statuseffects.lua")
end
if CLIENT then
	include("sh_statuseffects.lua")
end

SWEP.Base = "weapon_base"

-- informations
SWEP.PrintName = "Consumable Item"
SWEP.Author = "pein"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Consume it."

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.HoldType = "pistol"

SWEP.Spawnable = false

-- model
SWEP.ViewModel = "models/pein/bottle/bottle.mdl"
SWEP.WorldModel = "models/pein/bottle/bottle.mdl"

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.StartAmount = 100
SWEP.MaxAmount = 100
SWEP.UseDelay = 0.1
SWEP.Alcohol = 0.1

local PLAYER = FindMetaTable("Player")

function ResetBones(ply)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_Head1"), Angle(0, 0, 0), true)

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0), true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0), true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0), true)

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0), true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0), true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0), true)

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger1"), Angle(0, 0, 0), true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"), Angle(0, 0, 0), true)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger12"), Angle(0, 0, 0), true)
end

-- reminder: DO SOMETHING ABOUT THESE DAMN HOOKS!!!
hook.Add("Think", "client_consumable_base", function()
    if SERVER then return end
	for _,ply in player.Iterator() do
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep.Base == "consumable_base" then
			wep:Animate()
		end
	end
end)

function SWEP:Initialize()
    local ply = self:GetOwner()

    self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Using")
    self:NetworkVar("Float", 0, "Remaining")
	self:NetworkVar("Float", 1, "LastUse")

    self:SetUsing(false)
    self:SetRemaining(self.StartAmount)
end

function SWEP:Think()
    local ply = self:GetOwner()
    local using = self:GetUsing()
    local remaining = self:GetRemaining()
	local lastuse = self:GetLastUse()

    if ply:KeyDown(IN_ATTACK) and remaining > 0 then
        self:SetUsing(true)
    else
        self:SetUsing(false)
    end

    if using then
        self:SetRemaining(remaining - 5 * engine.TickInterval())

		ply:SetAlcohol(ply:GetAlcohol() + 0.1 * engine.TickInterval())

		local health = ply:Health()
		local maxhealth = ply:GetMaxHealth()

		if lastuse + self.UseDelay < CurTime() then
			self:SetLastUse(CurTime())
			--ply:SetHealth(math.Clamp(health + 2, 0, maxhealth))

            if SERVER then
                ply:HealAllLimbs(2)
            end
        end
    end

    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
    
end

function SWEP:PrimaryAttack()
    
end

function SWEP:DrawHUD()
    local remaining = self:GetRemaining()

	local mult = math.Clamp(remaining / self.MaxAmount, 0, 100)

    draw.SimpleText(string.format("%.1f", 100 * mult) .. "%", "CloseCaption_Bold", 100, ScrH() - 200, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function SWEP:SecondaryAttack()
    
end

function SWEP:Equip()
    
end

function SWEP:Animate()
	local ply = self:GetOwner()
    local using = self:GetUsing()

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
        self.angleupperR = LerpAngle(lerpHand, self.angleupperR, Angle(60, -60, 50))
        self.angleforeR = LerpAngle(lerpHand, self.angleforeR, Angle(-60, 0, 0))
        self.anglehandR = LerpAngle(lerpHand, self.anglehandR, Angle(60, 0, -10))

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

function SWEP:OnRemove()
	local ply = self:GetOwner()

	if IsValid(ply) then
		ResetBones(ply)
	end
end

function SWEP:Holster()
	local ply = self:GetOwner()

	if IsValid(ply) then
		ResetBones(ply)
	end

    self.anglehead = Angle(0, 0, 0)

	self.angleupperR = Angle(0, 0, 0)
    self.angleforeR = Angle(0, 0, 0)
    self.anglehandR = Angle(0, 0, 0)

    self.angleupperL = Angle(0, 0, 0)
    self.angleforeL = Angle(0, 0, 0)
    self.anglehandL = Angle(0, 0, 0)

	return true
end