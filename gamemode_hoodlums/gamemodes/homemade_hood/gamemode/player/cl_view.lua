-- hello to whoever is reading this

local PLAYER = FindMetaTable("Player")

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

local function CalcViewBob(frequency, amplitude)
    local frequency = frequency or 12
    local amplitude = amplitude or 2

    local x = 0 -- :(
	local y = (math.sin(CurTime() * frequency) * amplitude)
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
    falloffset_ang:Add(Angle(speed * 0.1, 0, 0))
end)

local fall_ang, fall_pos = Angle(0, 0, 0), Vector(0, 0, 0)
hook.Add("Think", "fallthing", function()
    falloffset_pos = LerpVector(8 * FrameTime(), falloffset_pos, Vector(0, 0, 0))
    falloffset_ang = LerpAngle(3 * FrameTime(), falloffset_ang, Angle(0, 0, 0))

    fall_pos = LerpVector(8 * FrameTime(), fall_pos, falloffset_pos)
    fall_ang = LerpAngle(2 * FrameTime(), fall_ang, falloffset_ang)
end)

-- RETARDED!!!!!!!!!!!!!!!!!!
local camang = Angle(0, 0, 0)
local movelerp = 0
local aimlerp = 0
local recoil_cam_ang = Angle(0, 0, 0)
local recoil_pos, recoil_ang = Vector(0, 0, 0), Angle(0, 0, 0)
local suppression_ang_lerp = Angle(0, 0, 0)
hook.Add("CalcView", "calc view", function(ply, pos, ang, fov)    
    local cam_offset = Vector(2, 1, 0)
    local cam_ang_offset = Angle(10, 5, 0)

    local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()
    local ragdoll = ply:GetNWEntity("ragdoll")
    
    ply:MakeHeadDisappearAndAllThat(GetConVar("hoodlum_invishead"):GetBool())

    if IsValid(ragdoll) then
        local att = ragdoll:GetAttachment(ragdoll:LookupAttachment("eyes"))

        local view = {
            origin = att.Pos,
            angles = att.Ang,
            fov = GetConVar("hoodlum_fov"):GetFloat(),
            drawviewer = false,
            znear = 5
        }

        return view
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
    local campos = eye_pos + ang:Forward() * 1

    -- targets
    local eyetarget_pos = campos
    local eyetarget_ang = camang

    if IsValid(wep) and wep.Base == "immersive_sweps" then
        local att_effects = wep:GetAttachmentEffects()

        if ply:IsAiming() and not ply:IsSprinting() and ply:IsOnGround() and not wep:Reloading() then
            aimlerp = LerpFT(wep:GetAimSpeed(), aimlerp, 1)
        else
            aimlerp = LerpFT(wep:GetAimSpeed(), aimlerp, 0)
        end
    
        local aimpos, aimang = wep:GetAimOffset()
        local offset = att_effects["AimOffset"] or Vector(0, 0, 0)
        eyetarget_pos = aimpos + hand_ang:Forward() * offset.x + hand_ang:Up() * offset.y + hand_ang:Right() * offset.z
        eyetarget_ang = camang + aimang
        
        local muzzle_pos, muzzle_ang = wep:GetMuzzle()
        muzzle_forward = muzzle_ang:Forward()
    
        recoil_pos, recoil_ang = wep:GetRecoil()
        recoil_cam_ang = LerpAngleFT(12, recoil_cam_ang, wep.eyeangleoffset)
    end

    local max = speed / ply:GetRunSpeed()
    if speed > 1 then
        movelerp = math.Clamp(movelerp + 0.5 * FrameTime(), 0, max)
    else
        movelerp = math.Clamp(movelerp - 1 * FrameTime(), 0, max)
    end

    local strafespeed = GetStrafeSpeed(velocity, ply:EyeAngles():Forward())
    local strafemult = math.Clamp(strafespeed / ply:GetRunSpeed(), -1, 1)
    local velocityang = Angle(0, 0, 7) * strafemult
    local viewbob = CalcViewBob(15, 0.5) * movelerp * 0.25
    suppression_ang_lerp = LerpAngleFT(4, suppression_ang_lerp, GetSuppressionShake())
    
    local recoil_offset = muzzle_forward * recoil_pos.x + eye_up * recoil_pos.y + eye_right * recoil_pos.z
    local viewbob_offset = eye_up * viewbob.y + eye_right * viewbob.z + eye_right * viewbob.x -- axis are all wrong!!!!!!!! im restarted

    camang = LerpAngle(GetConVar("hoodlum_cam_smooth"):GetFloat() * FrameTime(), camang, eyeang + velocityang * aimlerp)

    local finalpos = LerpVector(aimlerp, campos, eyetarget_pos) + recoil_offset + viewbob_offset + fall_pos
    local finalang = LerpAngle(aimlerp, camang, eyetarget_ang) + Angle(0, 0, recoil_lerp_roll) + cam_ang_offset + fall_ang + recoil_cam_ang + suppression_ang_lerp
    
    local view = {
		origin = finalpos,
		angles = finalang,
		fov = GetConVar("hoodlum_fov"):GetFloat(),
		drawviewer = true,
        znear = 1
    }

    return view
end)