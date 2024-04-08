SWEP.Base = "weapon_base"

SWEP.PrintName 				= "Hands"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Walk around like a normal person for once."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize       = 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic = true

SWEP.Reach = 100

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "normal"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= ""

SWEP.cooldown = 0

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:GetInteract()
	return self.Interacting, self.InteractingPhys
end

function SWEP:SetInteract(ent, physbone, worldPos, dist)
	if IsValid(ent) then
		self.Interacting = ent
		self.InteractingPhys = physbone
		self.InteractingPos = ent:WorldToLocal(worldPos)
		self.InteractingDist = dist
	else
		self.Interacting = nil
		self.InteractingPhys = nil
		self.InteractingPos = nil
		self.InteractingDist = nil
	end
end

function SWEP:SetCooldown(time)
	self.cooldown = CurTime() + time
end

function SWEP:IsOnCooldown()
	return CurTime() < self.cooldown
end

local allowgrab = {
	["prop_ragdoll"] = true,
	["prop_physics"] = true,
	["prop_physics_multiplayer"] = true,
}

SWEP.holding = false
function SWEP:Think()
	local ply = self:GetOwner()

	if SERVER then
		if self:IsOnCooldown() then return end

		local eyepos, eyeang = ply:EyePos(), ply:EyeAngles()
		if not self.holding and ply:KeyDown(IN_ATTACK) then
			self.holding = true

		elseif self.holding and not ply:KeyDown(IN_ATTACK) then
			self.holding = false

			self:SetInteract(nil, nil)
			self:SetCooldown(0.5)
		end

		if self.holding then
			local ent, phys = self:GetInteract()
			if not ent or not phys then
				local tr = util.QuickTrace(eyepos, eyeang:Forward() * self.Reach, {ply})
				if IsValid(tr.Entity) and tr.PhysicsBone then
					if allowgrab[tr.Entity:GetClass()] then
						local dist = (eyepos - tr.HitPos):Length()
						self:SetInteract(tr.Entity, tr.PhysicsBone, tr.HitPos, dist)
					end
				end
			else
				if not IsValid(ent) then
					self:SetInteract(nil)
					self:SetCooldown(1)
					return
				end
				local physobj = ent:GetPhysicsObjectNum(phys)
				local ang_vel = physobj:GetAngleVelocity()
				local phys_vel = physobj:GetVelocity()
				local phys_pos = physobj:GetPos()
				local mass = physobj:GetMass()

				local forcemult = 50
				local targetPos = ent:LocalToWorld(self.InteractingPos)
				if ent:GetClass() == "prop_ragdoll" then
					forcemult = 600
					targetPos = physobj:GetPos()
				end

				local dir = (eyepos + eyeang:Forward() * self.InteractingDist) - targetPos

				if dir:Length() > self.Reach then
					self:SetInteract(nil)
					return
				end

				local force = (dir * forcemult) / mass
				local forceAmount = force:Length()
				
				-- damping
				local dampingMult = 1
				local dampingForce = -phys_vel * dampingMult

				physobj:Wake()
				physobj:ApplyForceOffset(force + dampingForce, targetPos)
				physobj:AddAngleVelocity(-ang_vel * 0.5)
				
				if ply:KeyPressed(IN_ATTACK2) then
					physobj:SetVelocity(eyeang:Forward() * 500)
					self:SetInteract(nil, nil)
					self:SetCooldown(1)
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	
end

function SWEP:DrawHUD()
	local ply = self:GetOwner()
	local eyepos, eyeang = ply:EyePos(), ply:EyeAngles()
	
	local tr = util.QuickTrace(eyepos, eyeang:Forward() * self.Reach, {ply})
	if tr.Hit then
		local pos = tr.HitPos:ToScreen()
		local dist = (eyepos - tr.HitPos):Length()
		local size = math.Clamp(1 - dist / self.Reach + 0.25, 0, 1)
		
		if tr.Entity and allowgrab[tr.Entity:GetClass()] then
			surface.SetDrawColor(121, 181, 98, 40)
		else
			surface.SetDrawColor(255, 255, 255, 40)
		end
		draw.Circle(pos.x, pos.y, ScreenScale(5) * size, 32)
	end
end

function SWEP:SecondaryAttack()

end