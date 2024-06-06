SWEP.Base = "weapon_base"

SWEP.PrintName 				= "Ammo Box"
SWEP.Author 				= "pein"
SWEP.Instructions			= "A box full of bullets."
SWEP.Category 				= "Very deadly"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
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

SWEP.HoldType = "normal"

SWEP.Slot					= 4
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/pein/ammobox/ammobox.mdl"
SWEP.WorldModel				= "models/pein/ammobox/ammobox.mdl"

SWEP.Reach = 128
SWEP.CanDrop = true
SWEP.PlaceSound = "pein/ammobox/place.wav"

SWEP.PreviewModel = nil

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	local eyepos, eyeang = ply:EyePos(), ply:EyeAngles()

	if IsFirstTimePredicted() then
		local tr = util.QuickTrace(eyepos, eyeang:Forward() * self.Reach, {ply})
		local surfaceNormal, upNormal = tr.HitNormal, vector_up
		local dot = surfaceNormal:Dot(upNormal)
		if tr.Hit and dot > 0.75 then
			if SERVER then
				local ammobox = ents.Create("ent_ammobox")

				ammobox:SetPos(tr.HitPos)

				local ang = surfaceNormal:Angle()
				ang:RotateAroundAxis(ang:Right(), -90)
				ammobox:SetAngles(ang)

				ammobox:Spawn()

				ammobox:EmitSound(self.PlaceSound, 500)

				self:Remove()
			end
		end
	end
end

function SWEP:SecondaryAttack()
	
end

function SWEP:DrawHUD()
	
end

function SWEP:Think()
	local ply = self:GetOwner()
	if CLIENT then
		if IsValid(self.PreviewModel) then
			local eyepos, eyeang = ply:EyePos(), ply:EyeAngles()

			local tr = util.QuickTrace(eyepos, eyeang:Forward() * self.Reach, {ply})
			local surfaceNormal, upNormal = tr.HitNormal, vector_up
			local dot = surfaceNormal:Dot(upNormal)
			if tr.Hit and dot > 0.75 then
				self.PreviewModel:SetColor(Color(0, 255, 0, 50))
				self.PreviewModel:SetPos(tr.HitPos)

				local ang = surfaceNormal:Angle()
				ang:RotateAroundAxis(ang:Right(), -90)
				self.PreviewModel:SetAngles(ang)
			else
				self.PreviewModel:SetColor(Color(255, 0, 0, 50))
				self.PreviewModel:SetPos(tr.HitPos)
			end
		else
			self.PreviewModel = ClientsideModel(self.WorldModel)
			self.PreviewModel:Spawn()
			self.PreviewModel:SetColor(Color(0, 255, 0, 50))
			self.PreviewModel:SetMaterial("reticles/white.vmt")
			self.PreviewModel:SetRenderMode(RENDERMODE_TRANSALPHA)
		end
	end
end

function SWEP:CleanUp()
	if IsValid(self.PreviewModel) then
		self.PreviewModel:Remove()
		self.PreviewModel = nil
	end
end

function SWEP:Holster()
	self:CleanUp()

	return true
end

function SWEP:OnRemove()
	self:CleanUp()

	return true
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end