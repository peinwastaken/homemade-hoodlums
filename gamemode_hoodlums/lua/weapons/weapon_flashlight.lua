-- informations
SWEP.PrintName = "Flashlight"
SWEP.Author = "pein"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "Light the way."

-- stats
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.HoldType = "passive"

SWEP.ToggleSound = Sound("items/flashlight1.wav")

-- other
SWEP.Spawnable = false

-- model
SWEP.ViewModel = "models/pein/flashlight/flashlight.mdl"
SWEP.WorldModel = "models/pein/flashlight/flashlight.mdl"

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

-- otherer
SWEP.MaxBattery = 100

SWEP.MaxBatteries = 3
SWEP.Batteries = 1

local vertices = {}
function makecircle()
    local posX, posY, radius, segments = 0, 0, 32, 16

    -- create vertices
    vertices = {}

    local posX, posY, radius, segments = 0, 0, 1, 16

    -- center vertex
    vertices[#vertices + 1] = {
        x = posX,
        y = posY,
        u = 0.5,
        v = 0.5
    }

    -- ...and the rest...
    for i = 0, segments do
        local angle = math.rad((i / segments) * 360)

        vertices[#vertices + 1] = {
            x = posX + math.sin(angle) * radius,
            y = posY + math.cos(angle) * radius,
            u = math.sin(angle) / 2 + 0.5,
            v = math.cos(angle) / 2 + 0.5
        }
    end
end
makecircle()

if CLIENT then
    local flashlightmat = Material("sprites/beam/beamtexture")

    hook.Add("PostDrawTranslucentRenderables", "light", function()
        local players = player.GetAll()
        local lply = LocalPlayer()
    
        for _,ply in pairs(players) do
            local wep = ply:GetActiveWeapon()
            if not IsValid(wep) or not wep.GetToggled then continue end
            local enabled = wep:GetToggled()
            if not enabled or wep:Reloading() or wep:GetBattery() <= 0 then continue end
            local attachment = wep:GetAttachment(wep:LookupAttachment("light"))
            if not attachment then continue end
            local pos, ang = attachment.Pos, attachment.Ang
            ang:RotateAroundAxis(ang:Right(), -90)
    
            -- glow
            cam.Start3D2D(pos, ang, 1)
    
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawPoly(vertices)
    
            cam.End3D2D()
    
            -- lens flare
            local eyeang = lply:EyeAngles()
            --local eyepos = lply:EyePos()
            local eyepos = lply:GetAttachment(lply:LookupAttachment("eyes")).Pos
            local eyedir = eyeang:Forward()
            local lightdir = -ang:Up()
            local dirtolight = (pos - eyepos):GetNormalized()
            local visCheck = util.QuickTrace(pos, eyepos - pos, {ply, lply})
    
            local dot = lightdir:Dot(dirtolight)
    
            local scale = 256 * math.Clamp(dot - 0.5, 0, 1)
    
            -- beam
            render.SetMaterial(flashlightmat)
            render.DrawBeam(pos, pos - lightdir * 100, 32, 0.02, 1, Color(255, 255, 255))
    
            if dot > 0 and not visCheck.Hit then
                -- flare
                render.SetMaterial(Material("sprites/light_glow02_add_noz"))
                render.DrawQuadEasy(pos, (eyepos - pos):GetNormalized(), scale, scale, 255, 255, 255, 0)
            end
        end
    end)
end

function ResetBones(ply)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), Angle(0, 0, 0))

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), Angle(0, 0, 0))

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger1"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"), Angle(0, 0, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger12"), Angle(0, 0, 0))
end

hook.Add("Think", "animateflashlights", function()
    -- never do this
    --[[
    for flashlight,_ in pairs(flashlights) do
        if not IsValid(flashlight) then 
            flashlights[flashlight] = false 
            continue 
        end

        local owner = flashlight:GetOwner()

        if not IsValid(owner) or owner:GetActiveWeapon() ~= flashlight then
            ResetBones(owner)
            continue 
        end
        
        if flashlight.Animate then
            flashlight:Animate()
        end
    end]]

    local plys = player.GetAll()

    for _,ply in pairs(plys) do
        local wep = ply:GetActiveWeapon()

        if wep.ClassName == "weapon_flashlight" then
            wep:Animate()
        end
    end
end)

hook.Add("PreDrawOpaqueRenderables", "predrawflashlights", function(drawingdepth, drawskybox, draw3dskybox)
    local plys = player.GetAll()

    for _,ply in pairs(plys) do
        local wep = ply:GetActiveWeapon()

        -- lets do something retarded here
        if wep.ClassName == "weapon_flashlight" then
            local attachment = wep:GetAttachment(wep:LookupAttachment("light"))
            local pos, ang = attachment.Pos, attachment.Ang

            local battery = wep:GetBattery()
            local enabled = wep:GetToggled()
            
            if enabled and battery > 0 then
                if not ply.Light then
                    print("creating light for " .. ply:Name())

                    ply.Light = ProjectedTexture()
                    ply.Light:SetTexture("effects/flashlight001")
                    ply.Light:SetColor(Color(220, 242, 250))
                    ply.Light:SetFOV(30)
                    ply.Light:SetBrightness(3)
                    ply.Light:SetFarZ(1000)
                    ply.Light:SetNearZ(1)
                    ply.Light:SetEnableShadows(true)
                    ply.Light:Update()
                else
                    ply.Light:SetPos(pos)
                    ply.Light:SetAngles(ang)
                    ply.Light:Update()
                end
            else
                if ply.Light then
                    print("deleting light for " .. ply:Name())
    
                    ply.Light:Remove()
                    ply.Light = nil
                end
            end
        else
            if ply.Light then
                print("deleting light for " .. ply:Name())

                ply.Light:Remove()
                ply.Light = nil
            end
        end
    end
end)

function SWEP:Holster(wep)
    local ply = self:GetOwner()

    ResetBones(ply)

    return true
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "Toggled")
    self:NetworkVar("Bool", 1, "Crouching")
    self:NetworkVar("Float", 2, "Battery")
    self:NetworkVar("Float", 3, "Batteries")

    self:SetToggled(false)
    self:SetCrouching(false)
    self:SetBattery(self.MaxBattery)
    self:SetBatteries(1)
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:Reloading()
    return timer.Exists("reload"..self:EntIndex())
end

function SWEP:TranslateActivity(act)
    local ply = self:GetOwner()
    local activity = self:GetActivity()

    if act == ACT_MP_STAND_IDLE then
        return ACT_HL2MP_IDLE_PISTOL
    elseif act == ACT_MP_WALK then
        return ACT_HL2MP_WALK_PISTOL
    elseif act == ACT_MP_RUN then
        return ACT_HL2MP_RUN_PISTOL
    elseif act == ACT_MP_RELOAD_STAND then
        return ACT_HL2MP_GESTURE_RELOAD_PISTOL
    elseif act == ACT_MP_CROUCH_IDLE then
        return ACT_HL2MP_IDLE_CROUCH_MELEE
    elseif act == ACT_MP_CROUCHWALK then
        return ACT_HL2MP_WALK_CROUCH_MELEE
    end

    return act
end

function SWEP:ToggleLight(playsound)
    local enabled = self:GetToggled()
    local battery = self:GetBattery()

    if playsound then
        self:EmitSound(self.ToggleSound, 60, 100, 1)
    end

    if enabled then
        self:SetToggled(false)
    else
        self:SetToggled(true)
    end
end

function SWEP:Reload()
    if self:Reloading() then return end
    local batteries = self:GetBatteries()

    if batteries <= 0 then return end

    local ply = self:GetOwner()

    ply:SetAnimation(PLAYER_RELOAD)

    timer.Create("reload"..self:EntIndex(), 1.5, 0, function()
        timer.Remove("reload"..self:EntIndex())

        self:SetBattery(self.MaxBattery)
        self:SetBatteries(batteries - 1)
    end)
end

function SWEP:PrimaryAttack()
    self:ToggleLight(true)
end

function SWEP:SecondaryAttack()
    -- temporary
    local ply = self:GetOwner()
    self:SendWeaponAnim(ACT_MELEE_ATTACK1)
end

function SWEP:Animate()
    if SERVER then return end
    local ply = self:GetOwner()
    local enabled = self:GetToggled()
    local crouching = self:GetCrouching()
    local sprinting = ply:IsSprinting()

    local crouchlerp = 5 * FrameTime()
    local standlerp = 8 * FrameTime()

    -- variable hell............
    self.angleupperR = self.angleupperR or Angle(0, 0, 0)
    self.angleforeR = self.angleforeR or Angle(0, 0, 0)
    self.anglehandR = self.anglehandR or Angle(0, 0, 0)

    self.angleupperL = self.angleupperL or Angle(0, 0, 0)
    self.angleforeL = self.angleforeL or Angle(0, 0, 0)
    self.anglehandL = self.anglehandL or Angle(0, 0, 0)

    if crouching then
        self.angleupperR = LerpAngle(crouchlerp, self.angleupperR, Angle(-70, -40, -60))
        self.angleforeR = LerpAngle(crouchlerp, self.angleforeR, Angle(0, 20, 0))
        self.anglehandR = LerpAngle(crouchlerp, self.anglehandR, Angle(100, 0, -10))

        self.angleupperL = LerpAngle(crouchlerp, self.angleupperL, Angle(20, 20, 0))
        self.angleforeL = LerpAngle(crouchlerp, self.angleforeL, Angle(0, -20, 0))
        self.anglehandL = LerpAngle(crouchlerp, self.anglehandL, Angle(0, 0, 0))
    else
        self.angleupperR = LerpAngle(standlerp, self.angleupperR, Angle(0, 40, 0))
        self.angleforeR = LerpAngle(standlerp, self.angleforeR, Angle(0, -80, 0))
        self.anglehandR = LerpAngle(standlerp, self.anglehandR, Angle(65, 25, 5))

        self.angleupperL = LerpAngle(standlerp, self.angleupperL, Angle(0, 0, 0))
        self.angleforeL = LerpAngle(standlerp, self.angleforeL, Angle(0, 0, 0))
        self.anglehandL = LerpAngle(standlerp, self.anglehandL, Angle(0, 0, 0))
    end

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_UpperArm"), self.angleupperR)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Forearm"), self.angleforeR)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Hand"), self.anglehandR)

    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_UpperArm"), self.angleupperL)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Forearm"), self.angleforeL)
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_L_Hand"), self.anglehandL)

    -- finger fix
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger1"), Angle(0, -20, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger11"), Angle(0, -25, 0))
    ply:ManipulateBoneAngles(ply:LookupBone("ValveBiped.Bip01_R_Finger12"), Angle(0, -35, 0))
end

function SWEP:IsPlayerMoving()
    local ply = self:GetOwner()
    return ply:KeyDown(IN_MOVERIGHT) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK)
end

function SWEP:Think()
    local ply = self:GetOwner()
    local enabled = self:GetToggled()
    local crouched = self:GetCrouching(true)
    local battery = self:GetBattery()

    if ply:KeyDown(IN_DUCK) then
        self:SetCrouching(true)
    else
        self:SetCrouching(false)
    end

    if battery > 0 and enabled then
        self:SetBattery(math.Clamp(battery - 0.01, 0, self.MaxBattery))
    end
end

function SWEP:DrawHUD()
    local batteries = self:GetBatteries()
    local battery = self:GetBattery()

    local size = {
        x = 250,
        y = 14
    }
    local pos = {
        x = ScrW() / 2,
        y = ScrH() - 50
    }

    local battery = self:GetBattery()
    local sizemult = battery/self.MaxBattery
    size.x = size.x * sizemult

    surface.SetDrawColor(Color(228, 168, 0))
    surface.DrawRect(ScrW()/2-size.x/2, ScrH() - 50, size.x, size.y)

    draw.DrawText("Battery: " .. math.floor(battery), "DermaDefaultBold", pos.x, pos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER)

    draw.DrawText("Batteries Left: " .. batteries, "DermaDefaultBold", pos.x, pos.y - 20, Color(255, 255, 255), TEXT_ALIGN_CENTER)
end