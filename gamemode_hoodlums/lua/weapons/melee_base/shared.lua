SWEP.Base = "weapon_base"

-- informations
SWEP.PrintName = "Melee Weapon"
SWEP.Author = "pein"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Use it."

-- stats
SWEP.Primary.Damage = 25
SWEP.Primary.FireDelay = 0.5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.HoldType = "melee2"

SWEP.Spawnable = false

-- model
SWEP.ViewModel = "models/pein/flashlight/flashlight.mdl"
SWEP.WorldModel = "models/pein/flashlight/flashlight.mdl"

SWEP.Range = 50
SWEP.RagdollChance = 50
SWEP.ShowCrosshairAlways = true

SWEP.SwingSound = "WeaponFrag.Throw"
SWEP.HitSounds = {"Weapon_Crowbar.Melee_Hit"}
SWEP.HitSoundEntity = "Weapon_Crowbar.Melee_Hit"

function SWEP:Initialize()
    local ply = self:GetOwner()

    self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "FightMode")

	self:SetFightMode(true)
end

function SWEP:UpdateFightMode(state)
	if state then
		self:SetFightMode(true)

		self:SetHoldType(self.HoldType)
	else
		self:SetFightMode(false)

		self:SetHoldType("normal")
	end
end

-- todo: add a debounce
function SWEP:Reload()
    if IsFirstTimePredicted() then
        local fightmode = self:GetFightMode()
        self:UpdateFightMode(!fightmode)
    end
end

function SWEP:PrimaryAttack()
    local fightmode = self:GetFightMode()

    if not fightmode then return end

    self:SetNextPrimaryFire(CurTime() + self.Primary.FireDelay)
    
    local ply = self:GetOwner()
    local aimvector = ply:GetAimVector()
    local eyepos, eyeang = ply:EyePos(), ply:EyeAngles()
    local pos, ang = ply:GetPos(), ply:GetAngles()

    self:EmitSound(self.SwingSound)

    ply:SetAnimation(PLAYER_ATTACK1)

    if SERVER then
        local trace = util.QuickTrace(eyepos, aimvector * self.Range, {ply})
        local ent = trace.Entity
        local distance = (trace.StartPos - trace.HitPos):Length()

        if distance < self.Range and trace.Hit then
            if trace.MatType == MAT_FLESH then
                EmitSound(self.HitSoundEntity, trace.HitPos)
            else
                local hitsound = self.HitSounds[math.random(1, #self.HitSounds)]

                EmitSound(hitsound, trace.HitPos)
            end

            if IsValid(ent) then
                local damage = DamageInfo()
                damage:SetDamage(self.Primary.Damage)
                damage:SetAttacker(ply)
                damage:SetInflictor(self)
                damage:SetDamagePosition(pos)
                damage:SetDamageType(DMG_GENERIC)

                ent:TakeDamageInfo(damage)

                local physbone = trace.PhysicsBone
                if physbone then
                    local physobj = ent:GetPhysicsObjectNum(physbone)
                    if IsValid(physobj) then
                        physobj:ApplyForceCenter(aimvector * 5000)
                    end
                end

                local bone = ent:TranslatePhysBoneToBone(physbone)
                local bonename = ent:GetBoneName(bone)
                local rand = math.random(0, 100)
                if ent:IsPlayer() then
                    if bonename == "ValveBiped.Bip01_Head1" then
                        ent:ToggleRagdoll(nil, true, "weapon_hands")
                    elseif rand < self.RagdollChance and ent:IsPlayer() then
                        ent:ToggleRagdoll()
                    end
                end

                EmitSound(self.HitSoundEntity, trace.HitPos)
            end
        end
    end
end

function SWEP:DrawHUD()
    local fightmode = self:GetFightMode()
    local ply = self:GetOwner()
    local trace = ply:GetEyeTrace()
    local tracepos = trace.HitPos
    local distance = (trace.StartPos - trace.HitPos):Length()
    local pos = tracepos:ToScreen()

    local size1 = 12
    local size2 = 6

    if trace.Hit then
        if distance < self.Range then -- if can hit
            surface.DrawCircle(pos.x, pos.y, size1, Color(255, 0, 0, 255))
        elseif distance > self.Range and self.ShowCrosshairAlways then -- if not
            surface.DrawCircle(pos.x, pos.y, size1, Color(255, 255, 255, 255))
        end
    end
end

function SWEP:SecondaryAttack()
    
end

function SWEP:Equip()
    
end

function SWEP:OnRemove()

end