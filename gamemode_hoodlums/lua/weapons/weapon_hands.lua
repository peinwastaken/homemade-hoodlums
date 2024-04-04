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

SWEP.Reach = 64

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType               = "normal"

SWEP.Slot					= 2
SWEP.SlotPos				= 1
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.WorldModel				= ""

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

SWEP.Interacting = nil
SWEP.InteractingPhys = nil
function SWEP:GetInteract()
	return self.Interacting, self.InteractingPhys
end

function SWEP:SetInteract(ent, physbone)
	if IsValid(ent) then
		self.Interacting = ent
		self.InteractingPhys = physbone
	else
		self.Interacting = nil
		self.InteractingPhys = nil
	end
end

local allowgrab = {
	["prop_ragdoll"] = true,
	["prop_physics"] = true
}

SWEP.holding = false
function SWEP:Think()
	local ply = self:GetOwner()

	if SERVER then
		local eyepos, eyeang = ply:EyePos(), ply:EyeAngles()
		if not self.holding and ply:KeyDown(IN_ATTACK) then
			self.holding = true

			print(self.holding)
		elseif self.holding and not ply:KeyDown(IN_ATTACK) then
			self.holding = false

			print(self.holding)

			self:SetInteract(nil, nil)
		end

		if self.holding then
			local ent, phys = self:GetInteract()
			if not ent or not phys then
				local tr = util.QuickTrace(eyepos, eyeang:Forward() * self.Reach, {ply})
				if IsValid(tr.Entity) and tr.PhysicsBone then
					if allowgrab[tr.Entity:GetClass()] then
						self:SetInteract(tr.Entity, tr.PhysicsBone)
					end
				end
			else
				local physobj = ent:GetPhysicsObject(phys)
				local phys_pos = physobj:GetPos()
				local diff = (eyepos + eyeang:Forward() * self.Reach) - phys_pos

				if physobj:IsAsleep() then
					physobj:Wake()
				end

				physobj:SetVelocity(diff * 5)
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
		
		surface.SetDrawColor(255, 255, 255, 80)
		draw.Circle(pos.x, pos.y, ScreenScale(12) * size, 32)
	end
end

function SWEP:SecondaryAttack()

end