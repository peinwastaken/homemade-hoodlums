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
SWEP.DefaultFightMode = true

SWEP.SwingSound = "WeaponFrag.Throw"
SWEP.HitSounds = {"Weapon_Crowbar.Melee_Hit"}
SWEP.HitSoundEntity = "Weapon_Crowbar.Melee_Hit"

function SWEP:Initialize()
    local ply = self:GetOwner()
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "FightMode")

    self:ToggleFightMode(self.DefaultFightMode)
end

function SWEP:ToggleFightMode(state)
	if state then
		self:SetFightMode(true)
		self:SetHoldType(self.HoldType)
	else
		self:SetFightMode(false)
		self:SetHoldType("normal")
	end
end

function SWEP:Reload()
    local ply = self:GetOwner()

    if ply:KeyPressed(IN_RELOAD) then
        if IsFirstTimePredicted() then
            local fightmode = self:GetFightMode()
            self:ToggleFightMode(!fightmode)
        end
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

    ply:LagCompensation(true)

    if IsFirstTimePredicted() then
        local size = Vector(4, 4, 4)
        local trace = util.TraceHull({
            start = eyepos,
            endpos = eyepos + aimvector * self.Range,
            maxs = size,
            mins = -size,
            filter = ply,
        })
        local ent = trace.Entity
        local distance = (trace.StartPos - trace.HitPos):Length()
    
        if distance < self.Range and trace.Hit then
            if trace.MatType == MAT_FLESH then
                EmitSound(self.HitSoundEntity, trace.HitPos)
            else
                local hitsound = self.HitSounds[math.random(1, #self.HitSounds)]
            
                EmitSound(hitsound, trace.HitPos)
            end
        
            if SERVER then
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
                            physobj:ApplyForceOffset(aimvector * 2500, trace.HitPos)
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
                end
            end
        end
    end
    

    ply:LagCompensation(false)
end

function SWEP:DrawHUD()
    local fightmode = self:GetFightMode()
    local ply = self:GetOwner()
    local eyepos = ply:EyePos()
    local eyeang = ply:EyeAngles()
    local aimvector = ply:GetAimVector()
    local size = Vector(4, 4, 4)
    local trace = util.TraceHull({
        start = eyepos,
        endpos = eyepos + aimvector * self.Range,
        maxs = size,
        mins = -size,
        filter = ply,
    })
    local tracepos = trace.HitPos
    local distance = (trace.StartPos - trace.HitPos):Length()
    local pos = tracepos:ToScreen()

    local mult = math.Clamp(1 - distance/self.Range, 0.2, 1)

    local sizeMax = ScreenScale(14)
    local sizeMin = ScreenScale(10)
    local sizeLerp = Lerp(mult, sizeMin, sizeMax)

    draw.NoTexture()

    if trace.Hit then
        if distance < self.Range and fightmode then
            surface.SetDrawColor(Color(255, 0, 0, 20))
            draw.Circle(pos.x, pos.y, sizeLerp * mult, 16)

            surface.DrawCircle(pos.x, pos.y, sizeLerp * mult, Color(255, 43, 43))
        else
            surface.DrawCircle(pos.x, pos.y, sizeLerp * mult, Color(255, 255, 255, 255))
        end
    else
        if self.ShowCrosshairAlways then
            surface.DrawCircle(pos.x, pos.y, sizeLerp * mult, Color(255, 255, 255, 255))
        end
    end
end

function SWEP:SecondaryAttack()
    
end

function SWEP:Equip()
    
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

	return true
end