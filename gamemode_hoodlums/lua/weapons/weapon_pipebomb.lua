SWEP.Base = "weapon_base"

SWEP.PrintName 				= "Pipe Bomb"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Something actually homemade for once."
SWEP.Category 				= "Very deadly"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

------------------------------------------

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "grenade"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 0
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = ""
SWEP.Primary.Force = 450
SWEP.ShootWait = 5
							
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 10
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "grenade"

SWEP.Slot					= 4
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/pipebomb/w_pipebomb.mdl"
SWEP.WorldModel				= "models/pein/pipebomb/w_pipebomb.mdl"

SWEP.CanDrop = false

function SWEP:ThrowGrenade(force)
	local ply = self:GetOwner()

	ply:SetAnimation(PLAYER_ATTACK1)

	if SERVER then
		local pos = ply:EyePos() + ply:EyeAngles():Right() * 25
		local dir = ply:EyeAngles():Forward() * force

		local angle = Angle(0, 0, 0)

		local grenade = ents.Create("ent_pipebomb")
		grenade:SetPos(ply:GetPos() + Vector(0, 0, 64))
		grenade:SetAngles(angle)
		grenade:SetOwner(ply)
		grenade:Spawn()

		local vel = ply:GetVelocity()
		local phys = grenade:GetPhysicsObject()
		phys:SetVelocity(dir + vel)
		local axis = grenade:GetAngles():Up() - grenade:GetAngles():Forward()
		phys:SetAngleVelocity(axis * 500)

		self:Remove()
	end
end

function SWEP:PrimaryAttack()
    if self:Ammo1() <= 0 then return end

	local ply = self:GetOwner()

    self:SetNextPrimaryFire(CurTime() + self.ShootWait)
    self:ThrowGrenade(800)

	ply:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
	if self:Ammo1() <= 0 then return end

	local ply = self:GetOwner()

	if self:GetNextPrimaryFire() > CurTime() then return end
	self:SetNextPrimaryFire(CurTime() + self.ShootWait)
    self:ThrowGrenade(400)
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	local pos = ply:EyePos()
	local ang = ply:EyeAngles():Forward()

	local screenpos = (pos + ang * 100):ToScreen()

	draw.RoundedBox(10, screenpos.x, screenpos.y, 7, 7, Color(255, 255, 255))
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end