-- hello to whoever is reading this
local PLAYER = FindMetaTable("Player")
local weaponswayIntensity = CreateClientConVar("hoodlum_weaponsway_amount", 1, true, false, "Changes weapon sway intensity.", 1, 10)
local weaponswaySpeed = CreateClientConVar("hoodlum_weaponsway_speed", 12, true, false, "Changes weapon sway speed.", 1, 12)

-- should.. this.. be.. in the weapon script...?
function PLAYER:IsAiming()
    return self:KeyDown(IN_ATTACK2)
end

function PLAYER:MakeHeadDisappearAndAllThat(state)
    local head = self:LookupBone("ValveBiped.Bip01_Head1")
    if not head then return end

    if state then
        self:ManipulateBoneScale(head, Vector(0.1, 0.1, 0.1))
    else
        self:ManipulateBoneScale(head, Vector(1, 1, 1))
    end
end

local function GetStrafeSpeed(v1, v2)
    return v1:Dot(Vector(v2.y, -v2.x, 0))
end

function CalcViewBob(frequency, amplitude)
    local frequency = frequency or 12
    local amplitude = amplitude or 2

    local x = (math.sin(CurTime() * frequency) * amplitude)
	local y = 0
	local z = (math.sin(CurTime() * frequency * 0.5) * amplitude)

	return Vector(x, y, z)
end

local function LerpFT(lerp, from, to)
	return Lerp(math.min(1, lerp * FrameTime()), from, to)
end

local function LerpVectorFT(lerp, from, to)
	return LerpVector(math.min(1, lerp * FrameTime()), from, to)
end

local function LerpAngleFT(lerp, from, to)
	return LerpAngle(math.min(1, lerp * FrameTime()), from, to)
end

local function RandomFloat(min, max)
	return min + (max - min) * math.random()
end

hook.Add("RenderScene", "retarded fix", function(pos, angle, fov)
    local view = hook.Run("CalcView", LocalPlayer(), pos, angle, fov)

    render.Clear(0, 0, 0, 255, true, true, true)

    render.RenderView({
        x = 0,
        y = 0,
        w = ScrW(),
        h = ScrH(),
        angles = view.angles,
        origin = view.origin,
        drawhud = true,
        drawviewmodel = true,
        dopostprocess = true,
        drawmonitors = true
    })

    return true
end)

local falloffset_ang = Angle(0, 0, 0)
local falloffset_pos = Vector(0, 0, 0)
hook.Add("OnPlayerHitGround", "onplayerhitground", function(player, inwater, onfloater, speed)
    if not IsFirstTimePredicted() then return end

    falloffset_pos:Add(Vector(0, 0, -speed * 0.02))
    falloffset_ang:Add(Angle(speed * 0.15, 0, 0))
end)

local fall_ang, fall_pos = Angle(0, 0, 0), Vector(0, 0, 0)
hook.Add("Think", "fallthing", function()
    falloffset_pos = LerpVector(8 * FrameTime(), falloffset_pos, Vector(0, 0, 0))
    falloffset_ang = LerpAngle(8 * FrameTime(), falloffset_ang, Angle(0, 0, 0))

    fall_pos = LerpVector(8 * FrameTime(), fall_pos, falloffset_pos)
    fall_ang = LerpAngle(2 * FrameTime(), fall_ang, falloffset_ang)
end)

local function GetCameraClipOffset()
    local ply = LocalPlayer()
    local size = Vector(6, 6, 6)
    local att = ply:GetAttachment(ply:LookupAttachment("eyes"))
    local pos, ang = att.Pos, att.Ang

    local trace = util.TraceHull({
        start = ply:EyePos(),
        endpos = pos,
        filter = ply,
        mins = -size,
        maxs = size,
        mask = MASK_SOLID
    })

    --debugoverlay.SweptBox(ply:EyePos(), pos, -size, size, Angle(0, 0, 0), 1, color_white)

    if trace.Hit then
        local dist = (pos - trace.HitPos):Length()
        return trace.HitNormal * dist
    end

    return Vector(0, 0, 0)
end

local sway = {x = 0, y = 0}
hook.Add("InputMouseApply", "doSway", function(cmd, x, y, ang)
    local intensity = weaponswayIntensity:GetFloat()
    local speed = weaponswaySpeed:GetFloat()

    -- retarded but it works so i mean like is it really retarded? nothing else i tried really worked and caused the sway to fuck up
    local maxFps = 300
    
    local minMult = 0.3
    local maxMult = 1

    local curFps = 1 / FrameTime()

    local fpsMult = Lerp(curFps / maxFps, minMult, maxMult)

    -- idk why frametime works for speed but intensity n shit have to be multiplied by fpsmult.. its weird :/
    sway.x = Lerp(speed * FrameTime(), sway.x, x * 0.01 * intensity * 1 * fpsMult)
    sway.y = Lerp(speed * FrameTime(), sway.y, y * 0.01 * intensity * 1 * fpsMult)
end)

-- RETARDED!!!!!!!!!!!!!!!!!!
local camang, eyeangLerp = Angle(0, 0, 0), Angle(0, 0, 0)
local movelerp = 0
local aimlerp = 0
local recoil_cam_ang = Angle(0, 0, 0)
local recoil_pos, recoil_ang = Vector(0, 0, 0), Angle(0, 0, 0)
local suppression_ang_lerp = Angle(0, 0, 0)
local cliplerp = Vector(0, 0, 0)
local weaponsway = Vector(0, 0, 0)
local strafelerp = 0
local recoil_shake_ang, recoil_shake_pos, recoil_intensity = Angle(0, 0, 0), Vector(0, 0, 0), 0

hook.Add("CalcView", "calc view", function(ply, pos, ang, fov)    
    local cam_offset = Vector(2, 1, 0)
    local cam_ang_offset = Angle(10, 5, 0)
    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()
    local ragdoll = ply:GetNWEntity("ragdoll")
    local limbData = ply:GetLimbData()
    local helmet, armor = ply:GetNWEntity("helmet"), ply:GetNWEntity("armor")

    ply:MakeHeadDisappearAndAllThat(GetConVar("hoodlum_invishead"):GetBool())
        
    if ply:InVehicle() then
        ply:MakeHeadDisappearAndAllThat(false)
        return
    end

    -- active slop alert
    local eyeang = ply:EyeAngles()
    local velocity = ply:GetVelocity()
    local speed = velocity:Length()

    -- eyes
    local eye = ply:GetAttachment(ply:LookupAttachment("eyes"))
    if not eye then return end
    local eye_pos, eye_ang = eye.Pos, eye.Ang
    local eye_forward, eye_right, eye_up = ang:Forward(), ang:Right(), ang:Up()

    -- apply offset to eye pos
    local camera_offset = eye_forward * cam_offset.x + eye_up * cam_offset.y + eye_right * cam_offset.z
    eye_pos:Add(camera_offset)

    -- hand
    local hand = ply:GetAttachment(ply:LookupAttachment("anim_attachment_rh"))
    if not hand then return end
    local hand_pos, hand_ang = hand.Pos, hand.Ang
    local hand_forward, hand_right, hand_up = hand_ang:Forward(), hand_ang:Right(), hand_ang:Up()

    local muzzle_forward, muzzle_right, muzzle_up = Vector(0, 0, 0), Vector(0, 0, 0), Vector(0, 0, 0)

    -- original camera pos
    local campos = eye_pos

    -- targets
    local eyetarget_pos = campos
    local eyetarget_ang = camang

    if IsValid(wep) and wep.Base == "immersive_sweps" then
        local att_effects = wep:GetAttachmentEffects()

        local aimSpeedMult = 1
        if limbData then
            if ply:LimbBroken("RightArm") or ply:LimbBroken("LeftArm") then
                aimSpeedMult = 0.35
            end
        end
        if IsValid(helmet) then
            aimSpeedMult = aimSpeedMult * helmet.AimSpeedMult
        end

        if ply:IsAiming() and not ply:IsSprinting() and ply:IsOnGround() and not wep:Reloading() then
            aimlerp = LerpFT(wep:GetAimSpeed() * aimSpeedMult, aimlerp, 1)
        else
            aimlerp = LerpFT(wep:GetAimSpeed() * aimSpeedMult, aimlerp, 0)
        end
    
        local aimpos, aimang = wep:GetAimOffset()
        local offset = att_effects["AimOffset"] or Vector(0, 0, 0)
        eyetarget_pos = aimpos + hand_ang:Forward() * offset.x + hand_ang:Up() * offset.y + hand_ang:Right() * offset.z
        eyetarget_ang = camang + aimang
        
        local muzzle_pos, muzzle_ang = wep:GetMuzzle()
        muzzle_forward = muzzle_ang:Forward()
    
        recoil_pos, recoil_ang = wep:GetRecoil()
    end

    recoil_cam_ang = LerpAngleFT(40, recoil_cam_ang, (wep.eyeangleoffset or Angle(0, 0, 0))) -- still weird
    recoil_shake_ang = Angle(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-5, 5)) * recoil_intensity
    recoil_intensity = Lerp(12 * FrameTime(), recoil_intensity, 0)

    local max = speed / ply:GetRunSpeed()
    if speed > 1 then
        movelerp = math.Clamp(movelerp + 0.5 * FrameTime(), 0, max)
    else
        movelerp = math.Clamp(movelerp - 1 * FrameTime(), 0, max)
    end

    cliplerp = LerpVectorFT(16, cliplerp, GetCameraClipOffset())
    
    local strafespeed = GetStrafeSpeed(velocity, ply:EyeAngles():Forward())
    local strafemult = math.Clamp(strafespeed / ply:GetRunSpeed(), -1, 1)

    local velocityang = Angle(0, 0, 7) * math.Clamp(strafemult, -0.5, 0.5)
    local viewbob = CalcViewBob(15, 0.5) * movelerp * 0.25
    suppression_ang_lerp = LerpAngleFT(4, suppression_ang_lerp, GetSuppressionShake())

    weaponsway = Vector(-sway.y, sway.x, 0) * aimlerp
    
    local recoil_offset = muzzle_forward * recoil_pos.x + eye_up * recoil_pos.y + eye_right * recoil_pos.z
    local viewbob_offset = eye_up * viewbob.x + eye_right * viewbob.y + eye_right * viewbob.z
    local weaponsway_offset = eye_up * weaponsway.x + eye_right * weaponsway.y + eye_right * weaponsway.z

    camang = LerpAngle(GetConVar("hoodlum_cam_smooth"):GetFloat() * FrameTime(), camang, eyeang + velocityang)
    eyeangLerp = LerpAngle(8 * FrameTime(), eyeangLerp, eye_ang)

    local finalpos = LerpVector(aimlerp, campos, eyetarget_pos) + recoil_offset + viewbob_offset + fall_pos + cliplerp + weaponsway_offset
    local finalang = LerpAngle(aimlerp, camang, eyetarget_ang) + Angle(0, 0, recoil_lerp_roll) + cam_ang_offset + fall_ang + recoil_cam_ang + suppression_ang_lerp + recoil_shake_ang
    
    ply:SetEyeAngles(Angle(math.Clamp(eyeang.x, -85, 85), eyeang.y, eyeang.z))

    if BodycamEnabled() then
        -- what the fuck am i looking at lmao
        local spine = ply:GetAttachment(ply:LookupAttachment("eyes"))
        local pos, ang = spine.Pos, spine.Ang
        --local off = Vector(17, -6, 5)
        local off = Vector(4, 0, -6)
        pos = pos + ang:Forward() * off.x + ang:Right() * off.y + ang:Up() * off.z
        local pitch = math.Clamp(eyeang.x, -55, 48)
        ply:SetEyeAngles(Angle(pitch, eyeang.y, eyeang.z))
        local lerp = aimlerp * 0.2
        local bodycambob = CalcViewBob(17, 0.1) * math.Clamp(movelerp * 5, 0, 1)
        local walk_pos_offset = eye_up * bodycambob.x + eye_right * bodycambob.y + eye_right * bodycambob.z

        finalpos = LerpVector(lerp, pos, eyetarget_pos) + walk_pos_offset * 2 + fall_pos * 3 + weaponsway_offset + recoil_offset
        finalang = Angle(pitch, eyeang.y, eyeang.z) + cam_ang_offset + fall_ang + suppression_ang_lerp * 0.2
    end

    if IsValid(ragdoll) then
        local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))

        eyeangLerp = LerpAngle(12 * FrameTime(), eyeangLerp, att.Ang)

        local view = {
            origin = att.Pos,
            angles = eyeangLerp,
            fov = GetConVar("hoodlum_fov"):GetFloat(),
            drawviewer = false,
            znear = 5
        }

        return view
    end

    local view = {
		origin = finalpos,
		angles = finalang,
		fov = GetConVar("hoodlum_fov"):GetFloat(),
		drawviewer = true,
        znear = 1
    }

    return view
end)

function GetSway()
    return sway
end

function GetMoveLerp()
    return movelerp
end

function GetAimLerp()
    return aimlerp
end

function SetRecoilShakeIntensity(value)
    recoil_intensity = value
end