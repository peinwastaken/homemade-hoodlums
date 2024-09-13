if SERVER then
	AddCSLuaFile("cl_recoil.lua")

	AddCSLuaFile("sh_attachments.lua")
	include("sh_attachments.lua")

	AddCSLuaFile("sh_laser.lua")
	include("sh_laser.lua")

	AddCSLuaFile("sh_impacteffects.lua")
	include("sh_impacteffects.lua")

	AddCSLuaFile("sh_magazines.lua")
	include("sh_magazines.lua")
end
if CLIENT then
	include("cl_recoil.lua")
	include("sh_attachments.lua")
	include("sh_laser.lua")
	include("sh_impacteffects.lua")
	include("sh_magazines.lua")
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
SWEP.Primary.BulletCount = 1

SWEP.EjectEffect = "EjectBrass_57"

SWEP.ReloadTime = 2
SWEP.ReloadSound = ""

-- WEAPON HANDLING
SWEP.VisualRecoil = Vector(4, 2, 0) 
SWEP.VisualRecoilAngle = Angle(-1, 0, 0)
SWEP.RecoilVertical = 0
SWEP.RecoilHorizontal = 0
SWEP.CrouchRecoilMult = 0.5
SWEP.PlayerModelRecoilMult = 1

-- AIMING
SWEP.AimOffsetPos = Vector(5.1, -7, 0.725)
SWEP.AimOffsetAng = Angle(0, 15, -25)
SWEP.AimSpeed = 0.1
SWEP.AimSpreadReduction = true
SWEP.AimSpreadReductionMult = 1
SWEP.AimWeaponTilt = 0

SWEP.SuppressionMult = 1

SWEP.MuzzleFlashScale = 1
SWEP.MuzzleFlashStyle = 1

SWEP.PumpAction = false 
SWEP.CycleTime = 0.2

SWEP.UseRandomSkin = true

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "ar2"

SWEP.CanDrop = true

SWEP.BoltAnimationTime = 0.05

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
	local ply = self:GetOwner()

	local attachment = self.Attachments["sight"][self.EquippedAttachments["sight"]]

	if attachment then
		local att_effects = self:GetAttachmentEffects()
		local att_name = att_effects["AimPosAttachment"]
		local att = self:GetAttachment(self:LookupAttachment(att_name))

		return att.Pos, self.AimOffsetAng
	end

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
	local requiresPump = self:GetRequiresPump()
	local lastPump = self:GetLastPump()
	local timeSincePump = CurTime() - lastPump

	if requiresPump then
		self:DoPump()
		return false
	end

	if timeSincePump < self.CycleTime then
		return false
	end

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

	return true
end

function SWEP:Reloading()
	return timer.Exists("reload" .. self:EntIndex())
end

function SWEP:CancelReload()
	if self:Reloading() then
		timer.Remove("reload" .. self:EntIndex())
	end
end

function SWEP:Reload()
	
end

function SWEP:Initialize()
	self:SetNextPrimaryFire(CurTime())
	self:SetHoldType(self.HoldType)

	self.EquippedAttachments = {
		["sight"] = "none",
		["stock"] = "none",
		["barrel"] = "none",
		["underbarrel"] = "none",
		["magazine"] = "none",
		["extra"] = "none",
		["skin"] = "none"
	}
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Aiming")
	self:NetworkVar("Bool", 1, "Crouching")
	self:NetworkVar("Bool", 3, "FirstEquip")

	self:SetAiming(false)
	self:SetCrouching(false)
	self:SetFirstEquip(true)

    self:NetworkVar("Float", 5, "LastPump")
    self:NetworkVar("Bool", 5, "RequiresPump")

    self:SetLastPump(CurTime())
    self:SetRequiresPump(false)

	self:InitMagazines()
end

function SWEP:SecondaryAttack()
	-- :(
end

hook.Add("Think", "client_immersive_sweps", function()
	for _,ply in player.Iterator() do
		local wep = ply:GetActiveWeapon()

		if IsValid(wep) and wep.Base == "immersive_sweps" then
			wep:Animate()

			wep:SetWeaponHoldType(wep.HoldType)
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

	self:MagThink()
end


if SERVER then
	util.AddNetworkString("DoShot")
end

if CLIENT then
	net.Receive("DoShot", function()
		local snd = net.ReadString()
		local pos = net.ReadVector()
		local ply = net.ReadPlayer()
		local suppressed = net.ReadBool()
		local lply = LocalPlayer()

		if not IsValid(lply) then return end

		local mindist = 150
		local maxdist = 1500
		local dist = (pos - lply:EyePos()):Length() - mindist
		local mult = math.Clamp(dist / maxdist, 0, 1)

		if not suppressed then
			local light = DynamicLight(ply:EntIndex(), false)
    		if light then
    		   light.pos = pos
    		   light.r = 255
    		   light.g = 100
    		   light.b = 50
    		   light.brightness = 2
    		   light.decay = 5000
    		   light.size = 170
    		   light.dietime = CurTime() + 0.1
			end

			sound.Play(snd, pos, 500, 60, mult, 1)
		end

		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep.DoBolt then
			wep:DoBolt()
		end
	end)
end

local SurfaceHardness = {
	[MAT_CONCRETE] = 0.75,
	[MAT_DIRT] = 0.5,
	[MAT_PLASTIC] = 0.25,
	[MAT_WOOD] = 0.5,
	[MAT_FLESH] = 0.35,
	[MAT_GLASS] = 0.1,
}

function SWEP:CalculateBulletPenetration(trace)
	local ply = self:GetOwner()
	local hitpos, normal, hitnormal, hardness = trace.HitPos, trace.Normal, trace.HitNormal, SurfaceHardness[trace.MatType]
	if not hardness or hardness == 0 then
		hardness = 1
	end
	local ang = math.abs(math.deg(math.asin(normal:Dot(hitnormal))))

	-- todo: add ricochets if ang > 20-ish
	local penetrated = false
	local maxdist = self.Primary.Damage * 0.1 / hardness
	local dist = 5
	local pos = trace.HitPos
	while not penetrated and dist < maxdist do
		pos = hitpos + normal * dist
		local tr = util.QuickTrace(pos, -normal * dist)
		if not tr.StartSolid and tr.Hit then
			penetrated = true

			local bullet = {}
			bullet.Damage = self.Primary.Damage / (dist / 5)
			bullet.Num = 1
			bullet.Src = pos + normal
			bullet.Dir = normal
			bullet.Spread = 0
			bullet.AmmoType = self.Primary.Ammo
			bullet.Attacker = ply
			bullet.IgnoreEntity = ply:GetVehicle() or nil
			bullet.TracerName = "nil"
			bullet.Tracer = 0
			ply:FireBullets(bullet) -- actual bullet

			local bullet = {}
			bullet.Damage = 0
			bullet.Num = 1
			bullet.Src = pos + normal
			bullet.Dir = -normal
			bullet.Spread = 0
			bullet.AmmoType = self.Primary.Ammo
			bullet.Attacker = nil
			bullet.TracerName = "nil"
			bullet.Tracer = 0
			ply:FireBullets(bullet) -- retarded
		else
			dist = dist + 5
		end
	end
end

function SWEP:BulletCallback(ply, trace, dmginfo)
	self:CalculateBulletPenetration(trace)
end

function SWEP:EjectBrass()
	if IsFirstTimePredicted() then
		local eject = self:GetAttachment(self:LookupAttachment("brasseject"))
		if eject then
			local ePos, eAng = eject.Pos, eject.Ang
			--debugoverlay.Line(ePos, ePos + eAng:Up() * 16, 1, color_white, true)

			eAng:RotateAroundAxis(eAng:Right(), 90)
			local effectDataBrass = EffectData()
			effectDataBrass:SetOrigin(ePos)
			effectDataBrass:SetAngles(eAng)
			effectDataBrass:SetFlags(150)
			util.Effect(self.EjectEffect, effectDataBrass, false, ply)
		end
	end
end

SWEP.bolt = 0 -- maybe change this?
function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
	local att_effects = self:GetAttachmentEffects()

	if not self:CanFire() then return end

	self:SetNextPrimaryFire(CurTime() + (att_effects["FireRate"] or self.Primary.Delay))
    
    local muzzle = self:GetAttachment(self:LookupAttachment("muzzle"))
    if not muzzle then return end
    local pos, ang = muzzle.Pos, muzzle.Ang

	if att_effects["Suppressed"] then
		self:EmitSound(att_effects["WeaponSound"], 70, 100, 1)
	else
		self:EmitSound(self.Primary.Sound, 80, 100, 1)
	end

	if self.PumpAction then
		self:SetRequiresPump(true)
	end

	ply:LagCompensation(true)

	if IsFirstTimePredicted() then
		local spread = self.Primary.Spread
		if ply:KeyDown(IN_ATTACK2) and self.AimSpreadReduction then
			spread = spread - spread * self.AimSpreadReductionMult
		end

		local effectdatasmoke = EffectData()
		effectdatasmoke:SetOrigin(pos)
    	effectdatasmoke:SetNormal(ang:Forward())
		util.Effect("effect_muzzlesmoke", effectdatasmoke)

		if CLIENT then
			self:DoBolt()
		end

		if not self.PumpAction then
			self:EjectBrass()
		end

		if not att_effects["Suppressed"] then
			local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(ang:Forward())
			effectdata:SetEntity(self)
			effectdata:SetAttachment(self:LookupAttachment("muzzle"))
			effectdata:SetScale(self.MuzzleFlashScale)
			effectdata:SetFlags(self.MuzzleFlashStyle)
			util.Effect("effect_muzzleflash", effectdata)

			if CLIENT then
				local light = DynamicLight(self:EntIndex(), false)
    			if light then
    			   light.pos = pos
    			   light.r = 255
    			   light.g = 100
    			   light.b = 50
    			   light.brightness = 2
    			   light.decay = 5000
    			   light.size = 200
    			   light.dietime = CurTime() + 0.1
    			end
			end
		end
		
		local bullet = {}
		bullet.Damage = self.Primary.Damage + (att_effects["DamageAdd"] or 0)
		bullet.Num = self.Primary.BulletCount
		bullet.Src = pos
		bullet.Dir = ang:Forward()
		bullet.Spread = Vector(spread, spread)
		bullet.AmmoType = self.Primary.Ammoa
		bullet.Attacker = ply
		bullet.IgnoreEntity = ply:GetVehicle() or nil
		bullet.TracerName = self.Primary.TracerName or "Tracer"
		bullet.Tracer = 1
		bullet.Callback = function(ply, trace, dmginfo)
			self:BulletCallback(ply, trace, dmginfo)
		end
		
		ply:FireBullets(bullet, true)

		if CLIENT then
			self:ApplyRecoil(self.VisualRecoil, self.Recoil)
		end
	end

	if SERVER then
		net.Start("DoShot")
		net.WriteString(self.Primary.SoundFar)
		net.WriteVector(pos)
		net.WritePlayer(ply)
		net.WriteBool(att_effects["Suppressed"])
		net.SendOmit(self:GetOwner())
	end

	self:TakePrimaryAmmo(1)

	ply:LagCompensation(false)
end

function SWEP:DoBolt()
	self.timesincelastshot = 0
	self.bolt = 1
end

SWEP.pump = 0
function SWEP:DoPump()
	local requiresPump = self:GetRequiresPump()
	local lastPump = self:GetLastPump()
	local timeSincePump = CurTime() - lastPump + self.Primary.Delay

	if IsFirstTimePredicted() then
		if requiresPump and timeSincePump > 0.5 then
			self.pump = 0
			self:SetRequiresPump(false)
			self:SetLastPump(CurTime())
			self:EmitSound(self.CycleSound, 60, 100, 1, CHAN_AUTO)
	
			self:EjectBrass()
		end
	end
end

-- thank you gpt!
function linear(t)
    t = t % 1
    if t < 0.5 then
        return t * 2
    else
        return 2 - (t * 2)
    end
end

-- hello to whoever is reading this
-- this is retarded i know. maybe ill fix it later?? who knows :)
SWEP.timesincelastshot = 999
function SWEP:Animate()
	local ply = self:GetOwner()
	local lastPump = self:GetLastPump()
	local timeSinceLastPump = CurTime() - lastPump

	-- shouldnt be doing this here but whatever
	self.timesincelastshot = self.timesincelastshot + FrameTime()
	self.pump = self.pump + FrameTime()

	-- WEAPON
	-- bolt
	local bolt = self:LookupPoseParameter("bolt")
	local ham = self:LookupPoseParameter("hammer")

	local cycleTime = self.BoltAnimationTime
	local cycle = math.Clamp(self.timesincelastshot / cycleTime, 0, 1)
	local cycleDelta = 180 * cycle
	
	-- all of these are buggin for some reason
	if bolt and CLIENT then
		if self.PumpAction then -- do pump n allat
			local cycle = math.Clamp(timeSinceLastPump / self.CycleTime, 0, 1)
			self:SetPoseParameter("bolt", linear(cycle))
			self:InvalidateBoneCache()
		elseif ham then -- for pistols and such
			self.bolt = math.sin(math.rad(cycleDelta))
			self:SetPoseParameter("bolt", linear(cycle))
			self:SetPoseParameter("hammer", 1 - linear(cycle))
			self:InvalidateBoneCache()
		else -- for other, normal weapons
			self:SetPoseParameter("bolt", self.bolt)
			self.bolt = math.Clamp(self.bolt - 25 * FrameTime(), 0, 1)
			self:InvalidateBoneCache()
		end
	end

	-- CHARACTER
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

    --self.angleupperL = self.angleupperL or Angle(0, 0, 0)
    --self.angleforeL = self.angleforeL or Angle(0, 0, 0)
    --self.anglehandL = self.anglehandL or Angle(0, 0, 0)

	-- head distance from wall
	local maxdist = 30
	local eyes = ply:LookupAttachment("eyes")
	local att = ply:GetAttachment(eyes)
	if not att then return end
	local eye_pos, eye_ang = att.Pos, att.Ang
	local tr = util.QuickTrace(eye_pos, eye_ang:Forward() * maxdist, {ply})
	local lerp = math.Clamp(tr.Fraction, 0, 1)
	local wallcloseangle = Angle(90, -50, 0) * (1 - lerp)

	-- animate here

	-- sprinting
	if ply:IsSprinting() and not self:Reloading() then
		if self:GetHoldType() == "revolver" then
			self.angleupperR = LerpAngleFT(4, self.angleupperR, Angle(-15, 20, 0))
			self.angleforeR = LerpAngleFT(4, self.angleforeR, Angle(-20, -30, -30))
			self.anglehandR = LerpAngleFT(4, self.anglehandR, Angle(0, -30, 0))
		else
			self.angleupperR = LerpAngleFT(4, self.angleupperR, Angle(20, 30, 0))
			self.angleforeR = LerpAngleFT(4, self.angleforeR, Angle(-20, -20, 30))
			self.anglehandR = LerpAngleFT(4, self.anglehandR, Angle(0, -30, -30))
		end
	else
		self.angleupperR = LerpAngleFT(4, self.angleupperR, Angle(0, 0, 0))
		self.angleforeR = LerpAngleFT(4, self.angleforeR, Angle(0, 0, 0))
	end

	-- aiming
	if self:GetAiming() then
		self.anglehandR = LerpAngleFT(4, self.anglehandR, Angle(0, 0, self.AimWeaponTilt))
		self.anglehead = LerpAngleFT(4, self.anglehead, Angle(-15, -10, 15))
	else
		self.anglehead = LerpAngleFT(4, self.anglehead, Angle(0, 0, 0))
	end

	self.anglehandR = LerpAngleFT(8, self.anglehandR, Angle(0, 0, -15) + wallcloseangle)

	-- recoil
	if CLIENT then
		if LocalPlayer() ~= ply then
			local visRecoil = self.VisualRecoil
			local recoilPitch, recoilYaw = self.RecoilVertical, self.RecoilHorizontal
			local lerp = math.Clamp(self.timesincelastshot / 0.1, 0, 1)
			if self:GetHoldType() == "ar2" then
				self.angleupperR = self.angleupperR + Angle(0, 1 - lerp, 0) * visRecoil.x * 200 * FrameTime()
				self.angleforeR = self.angleforeR - Angle(0, 1 - lerp, 0) * visRecoil.x * 200 * FrameTime()
			end
			self.anglehandR = self.anglehandR + Angle(1 - lerp, 0) * (recoilPitch * self.PlayerModelRecoilMult * FrameTime())
		end
	end

	-- pumping
	if self.PumpAction then
		local cycle = math.Clamp(timeSinceLastPump * 2 / self.CycleTime, 0, 1)
		
		self.angleupperR = self.angleupperR + Angle(0, 4, 0) * 100 * FrameTime() * linear(cycle)
		self.angleforeR = self.angleforeR - Angle(0, 4, 0) * 100 * FrameTime() * linear(cycle)
		self.anglehandR = self.anglehandR + Angle(0.4, -2, 2) * 100 * FrameTime() * linear(cycle)
	end

	-- set bone angles
	ply:ManipulateBoneAngles(head, self.anglehead, false)

	ply:ManipulateBoneAngles(upperR, self.angleupperR, false)
	ply:ManipulateBoneAngles(lowerR, self.angleforeR, false)
	ply:ManipulateBoneAngles(handR, self.anglehandR, false)

	ply:ManipulateBoneAngles(upperL, Angle(0, 0, 0), false)
	ply:ManipulateBoneAngles(lowerL, Angle(0, 0, 0), false)
	ply:ManipulateBoneAngles(handL, Angle(0, 0, 0), false)
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

	self:StopCheckingMag()
	self:CancelReload()

	if CLIENT then
		self:ResetRecoil()
	end

	return true
end

function SWEP:Deploy()
	local firstEquip = self:GetFirstEquip()

	if firstEquip then
		self:SetFirstEquip(false)

		self:StartCheckingMag()
	end
end