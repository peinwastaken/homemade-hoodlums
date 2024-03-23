if SERVER then
	AddCSLuaFile("cl_recoil.lua")

	AddCSLuaFile("sh_attachments.lua")
	include("sh_attachments.lua")
end
if CLIENT then
	include("cl_recoil.lua")
	include("sh_attachments.lua")
end


SWEP.Base = "weapon_base"

SWEP.PrintName 				= "immersive_sweps"
SWEP.Author 				= "pein"
SWEP.Instructions			= ""
SWEP.Category 				= "Other"

SWEP.Spawnable 				= false
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Damage = 100
SWEP.Primary.Spread = 0
SWEP.Primary.Sound = "weapons/fiveseven/fiveseven-1.wav"
SWEP.Primary.SoundFar       = Sound("pein/m1911/m1911_far.wav")
SWEP.Primary.Delay = 0.12
SWEP.Primary.BulletCount = 1 -- BULLET AMOUNT

SWEP.Automatic = true

SWEP.ReloadTime = 2 -- RELOAD TIME
SWEP.ReloadSound = "" -- RELOAD SOUND

-- WEAPON HANDLING
SWEP.VisualRecoil = Vector(4, 2, 0) -- CAMERA RECOIL
SWEP.VisualRecoilAngle = Angle(-1, 0, 0)
SWEP.RecoilVertical = 0 -- VERTICAL RECOIL
SWEP.RecoilHorizontal = 0 -- HORIZONTAL RECOIL
SWEP.CrouchRecoilMult = 0.5 -- CROUCH RECOIL MULTIPLIER

-- AIMING
SWEP.AimOffsetPos = Vector(5.1, -7, 0.725) -- ADS POSITION OFFSET
SWEP.AimOffsetAng = Angle(0, 15, -25) -- ADS ANGLE OFFSET
SWEP.AimSpeed = 0.1 -- ADS SPEED MULTIPLIER (0 - 1)
SWEP.AimSpreadReduction = true -- DOES AIMING REMOVE SPREAD?
SWEP.AimSpreadReductionMult = 1 -- ^ Multiplier

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = ""

function LerpFT(lerp, from, to)
	return Lerp(math.min(1, lerp * FrameTime()), from, to)
end

function LerpVectorFT(lerp, from, to)
	return LerpVector(math.min(1, lerp * FrameTime()), from, to)
end

function LerpAngleFT(lerp, from, to)
	return LerpAngle(math.min(1, lerp * FrameTime()), from, to)
end

function RandomFloat(min, max)
	return min + (max - min) * math.random()
end

function SWEP:GetAimOffset()
	return self.AimOffsetPos, self.AimOffsetAng
end

function SWEP:GetAimSpeed()
	return self.AimSpeed
end

function SWEP:GetMuzzle()
	local ply = self:GetOwner()
	local att = self:GetAttachment(self:LookupAttachment("muzzle"))
	
	if att then
		return att.Pos, att.Ang
	end

	return nil
end

function SWEP:CanFire()
	local ply = self:GetOwner()

	if ply:IsSprinting() then
		return false
	end

	if self:GetNextPrimaryFire() > CurTime() then
		return false
	end

	if timer.Exists("reload" .. self:EntIndex()) then
		return false 
	end

	if self:Clip1() <= 0 then
		return false 
	end

	if self.Automatic and ply:KeyDown(IN_ATTACK) then
		return true
	end

	if not self.Automatic and ply:KeyPressed(IN_ATTACK) then
		return true
	end

	return true
end

function SWEP:Reloading()
	return timer.Exists("reload" .. self:EntIndex())
end

function SWEP:Reload()
	if not self:Reloading() and self:Ammo1() > 0 and self:Clip1() < self:GetMaxClip1() then
		local ply = self:GetOwner()
		ply:SetAnimation(PLAYER_RELOAD)
		self:EmitSound(self.ReloadSound, 60, 100, 1, CHAN_AUTO)
		timer.Create("reload" .. self:EntIndex(), self.ReloadTime, 1, function()
			if not IsValid(self) then return end

			local ammo = self:Ammo1()
			local clip = self:Clip1()
			local maxclip = self:GetMaxClip1()
			local missing = maxclip - clip
			local retarded_ammo_shit_fucking_gg = math.Clamp(ammo, 0, maxclip)
			
			ply:SetAmmo(ammo - missing, self.Primary.Ammo)
			self:SetClip1(retarded_ammo_shit_fucking_gg)
		end)
	end
end

function SWEP:Initialize()
	self:SetNextPrimaryFire(CurTime())
	self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Aiming")
	self:NetworkVar("Bool", 1, "Crouching")

	self:SetAiming(false)
	self:SetCrouching(false)
end

function SWEP:SecondaryAttack()

end

hook.Add("Think", "client_immersive_sweps", function()
	for _,ply in player.Iterator() do
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep.Base == "immersive_sweps" then
			wep:Animate()
		end
	end
end)

function SWEP:Think()
	local ply = self:GetOwner()

	if ply:KeyDown(IN_ATTACK2) then
		self:SetAiming(true)
	else
		self:SetAiming(false)
	end

	if ply:KeyDown(IN_DUCK) then
		self:SetCrouching(true)
	else
		self:SetCrouching(false)
	end

	self:SetWeaponHoldType(self.HoldType)
end


if SERVER then
	util.AddNetworkString("DoEcho")
end

if CLIENT then
	net.Receive("DoEcho", function()
		-- farsound, pos, player
		local snd = net.ReadString()
		local pos = net.ReadVector()
		local ply = net.ReadPlayer()
		local lply = LocalPlayer()

		local mindist = 150
		local maxdist = 1500
		local dist = (pos - lply:EyePos()):Length() - mindist
		local mult = math.Clamp(dist / maxdist, 0, 1)

		sound.Play(snd, pos, 500, 60, mult, 1)
	end)
end

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()

	if not self:CanFire() then return end

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    
    local muzzle = self:GetAttachment(self:LookupAttachment("muzzle"))
    if not muzzle then return end
    local pos, ang = muzzle.Pos, muzzle.Ang

	self:EmitSound(self.Primary.Sound, 80, 100, 1)

	if SERVER then
		net.Start("DoEcho")
		net.WriteString(self.Primary.SoundFar)
		net.WriteVector(pos)
		net.WritePlayer(ply)
		net.Broadcast()
	end

	ply:LagCompensation(true)

	if IsFirstTimePredicted() then
		local spread = self.Primary.Spread
		if ply:KeyDown(IN_ATTACK2) and self.AimSpreadReduction then
			spread = spread - spread * self.AimSpreadReductionMult
		end

		self:SetAttachmentSlot("extra", "switch")
		
		local bullet = {}
		bullet.Damage = self.Primary.Damage
		bullet.Num = self.Primary.BulletCount
		bullet.Src = pos
		bullet.Dir = ang:Forward()
		bullet.Spread = Vector(spread, spread)
		bullet.AmmoType = self.Primary.Ammoa
		bullet.Attacker = ply
		bullet.IgnoreEntity = ply:GetVehicle() or nil
		bullet.TracerName = self.Primary.TracerName or "Tracer"
		bullet.Tracer = 1

		if SERVER then
			ply:SetAnimation(PLAYER_ATTACK1)
		end
		
		ply:FireBullets(bullet, true)

		if CLIENT then
			self:ApplyRecoil(self.VisualRecoil, self.Recoil)
		end
	end

	ply:LagCompensation(false)

	if SERVER then
		self:TakePrimaryAmmo(1)
	end

	local effectdata = EffectData()
	effectdata:SetEntity(self)
	effectdata:SetAttachment(self:LookupAttachment("muzzle"))
	effectdata:SetFlags(3)
	util.Effect("MuzzleFlash", effectdata)

	local effectdatasmoke = EffectData()
	effectdatasmoke:SetOrigin(pos)
	effectdatasmoke:SetMagnitude(0)
	effectdatasmoke:SetScale(0)
	util.Effect("ElectricSpark", effectdata)
end

-- hello to whoever is reading this
-- this is retarded i know. maybe ill fix it later?? who knows :)
function SWEP:Animate()
	local ply = self:GetOwner()

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

	-- head distance from wall
	local maxdist = 30
	local att = ply:GetAttachment(ply:LookupAttachment("eyes"))
	local eye_pos, eye_ang = att.Pos, att.Ang
	local tr = util.QuickTrace(eye_pos, eye_ang:Forward() * maxdist, {ply})
	local lerp = math.Clamp(tr.Fraction, 0, 1)
	local wallcloseangle = Angle(90, -50, 0) * (1 - lerp)

	-- animate here

	-- sprinting
	if ply:IsSprinting() and not self:Reloading() then
		self.angleupperR = LerpAngleFT(4, self.angleupperR, Angle(20, 30, 0))
		self.angleforeR = LerpAngleFT(4, self.angleforeR, Angle(-20, -20, 30))
		self.anglehandR = LerpAngleFT(4, self.anglehandR, Angle(0, -30, -30))
	else
		self.angleupperR = LerpAngleFT(4, self.angleupperR, Angle(0, 0, 0))
		self.angleforeR = LerpAngleFT(4, self.angleforeR, Angle(0, 0, 0))
	end

	-- aiming
	if self:GetAiming() then
		if self:GetHoldType() == "revolver" then -- pistol?
			self.anglehandR = LerpAngleFT(4, self.anglehandR, Angle(0, 0, 30))
		else -- maybe not..
			self.anglehandR = LerpAngleFT(4, self.anglehandR, Angle(0, 0, -30))
		end
		self.anglehead = LerpAngleFT(4, self.anglehead, Angle(-15, -10, 15))
	else
		self.anglehead = LerpAngleFT(4, self.anglehead, Angle(0, 0, 0))
	end

	self.anglehandR = LerpAngleFT(8, self.anglehandR, Angle(0, 0, -15) + wallcloseangle)

	-- set bone angles
	ply:ManipulateBoneAngles(head, self.anglehead, false)

	ply:ManipulateBoneAngles(upperR, self.angleupperR, false)
	ply:ManipulateBoneAngles(lowerR, self.angleforeR, false)
	ply:ManipulateBoneAngles(handR, self.anglehandR, false)

	ply:ManipulateBoneAngles(upperL, self.angleupperL, false)
	ply:ManipulateBoneAngles(lowerL, self.angleforeL, false)
	ply:ManipulateBoneAngles(handL, self.anglehandL, false)
end