SWEP.Base = "melee_base"

SWEP.PrintName 				= "Hands"
SWEP.Author 				= "pein"
SWEP.Instructions			= "Walk around like a normal person or beat someone up. Your choice."
SWEP.Category 				= "Immersive SWEPs"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.Damage = 3
SWEP.Primary.ClipSize       = 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Delay = 0.5
SWEP.Primary.Automatic = false

SWEP.Range = 100
SWEP.RagdollChance = 0
SWEP.ShowCrosshairAlways = false
SWEP.DefaultFightMode = false

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "fist"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= ""

SWEP.SwingSound = "WeaponFrag.Throw"
SWEP.HitSounds = {"Weapon_Crowbar.Melee_Hit"}
SWEP.HitSoundEntity = "Weapon_Crowbar.Melee_Hit"

SWEP.cooldown = 0
SWEP.holding = false

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

function SWEP:Think()
	local ply = self:GetOwner()
	local fightmode = self:GetFightMode()

	if fightmode then return end

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
				local tr = util.QuickTrace(eyepos, eyeang:Forward() * self.Range, {ply})
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
				if mass < 1 then 
					mass = 1
				end

				local forcemult = 50
				local targetPos = ent:LocalToWorld(self.InteractingPos)
				if ent:GetClass() == "prop_ragdoll" then
					forcemult = 600
					targetPos = physobj:GetPos()
				end

				local dir = (eyepos + eyeang:Forward() * self.InteractingDist) - targetPos

				if dir:Length() > self.Range then
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
					physobj:SetVelocity(eyeang:Forward() * 1000 / mass)
					self:SetInteract(nil, nil)
					self:SetCooldown(1)
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()

end