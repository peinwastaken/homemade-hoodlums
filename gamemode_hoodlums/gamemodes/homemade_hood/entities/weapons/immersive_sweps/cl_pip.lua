pip_size = 512
local pipRenderTarget = GetRenderTarget("PIPScope" .. pip_size, math.Clamp(pip_size, 0, ScrW()), math.Clamp(pip_size, 0, ScrH()))
local pipMaterial = CreateMaterial("PIPScope" .. pip_size, "UnlitGeneric",{
    ["$ignorez"] = 1
})

-- liked it until it started causing issues, maybe ill like it once more when i fix it
--CreateClientConVar("hoodlum_pip_fisheye", 0, true, false, "PIP Scope fisheye effect", 0, 1)
--CreateClientConVar("hoodlum_pip_fisheye_amount", 0.1, true, false, "PIP Scope fisheye effect", 0, 1)

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local fisheye = Material("reticles/fisheye/scope_fisheye")
function DrawRefract(amount)
    render.CopyRenderTargetToTexture(render.GetScreenEffectTexture())
    fisheye:SetFloat("$refractamount", amount)
    render.SetMaterial(fisheye)
    render.DrawScreenQuad()
end

local rendering = false
function DoScope()
    local lply = LocalPlayer()
    local wep = lply:GetActiveWeapon()
    if not IsValid(wep) or not wep.GetAttachmentEffects then return end
    local effect = wep:GetAttachmentEffects()
    local att_scope = wep:GetAttachment(wep:LookupAttachment(effect["AimPosAttachment"]))
    local scope_pos, scope_ang = att_scope.Pos, att_scope.Ang
    scope_ang:RotateAroundAxis(scope_ang:Forward(), -90)

    local att_muzzle = wep:GetAttachment(wep:LookupAttachment("muzzle"))
    local muzzle_pos, muzzle_ang = att_muzzle.Pos, att_muzzle.Ang
    muzzle_ang:RotateAroundAxis(muzzle_ang:Forward(), -90)

    if not rendering then
        rendering = true

        local tr = util.QuickTrace(scope_pos, scope_ang:Forward() * 24, {lply})

        render.PushRenderTarget(pipRenderTarget)

        if tr.Hit then
            render.Clear(0, 0, 0, 255)
        else
            render.RenderView({origin = scope_pos + scope_ang:Forward() * 12, angles = scope_ang, fov = effect["PIPFov"], znear = 5, drawviewer = false})
        end
        
        --[[
        if GetConVar("hoodlum_pip_fisheye"):GetBool() then
            local amount = GetConVar("hoodlum_pip_fisheye_amount"):GetFloat()
            DrawRefract(amount)
        end]]

        render.PopRenderTarget()

        rendering = false
    end
end

local black = Material("reticles/black")
local vignetteMat = Material("reticles/vignette")
function DoPip(wep, pos, ang)
    if not IsValid(wep) then return end

    local effect = wep:GetAttachmentEffects()
    local reticlemat, reticlesize, pipradius = effect["ReticleMaterial"], effect["ReticleSize"], effect["PIPRadius"]
    local vignettesize = effect["VignetteSize"] or reticlesize
    local aimlerp = GetAimLerp()
    
    cam.Start3D2D(pos + ang:Up() * -64, ang, 0.01)
        cam.Start3D2D(pos, ang, 0.01)
            -- no fucking clue
            render.ClearStencil()
            render.SetStencilEnable(true)
            render.SetStencilTestMask(255)
            render.SetStencilWriteMask(255)
            render.SetStencilReferenceValue(64)
            render.SetStencilCompareFunction(STENCIL_ALWAYS)
            render.SetStencilPassOperation(STENCIL_REPLACE)
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilZFailOperation(STENCIL_REPLACE)

            surface.SetDrawColor(0, 0, 0, 1)
            draw.Circle(0, 0, pipradius, 32)
            draw.NoTexture()

            -- no fucking clue
            render.SetStencilCompareFunction(STENCIL_EQUAL)
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilZFailOperation(STENCIL_KEEP)

            surface.SetMaterial(black)
            render.DrawScreenQuad(false)

            pipMaterial:SetTexture("$basetexture", pipRenderTarget)
            pipMaterial:SetVector("$color", Vector(1, 1, 1) * math.Clamp(aimlerp * 2, 0, 1))
        cam.End3D2D()

        local size = 99999 -- weird

        -- its black
        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(black)
        surface.DrawTexturedRect(-size/2, -size/2, size, size)

        -- pip
        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(pipMaterial)
        draw.Circle(0, 0, vignettesize/2, 32)

        -- reticle
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(reticlemat)
        surface.DrawTexturedRect(-reticlesize/2, -reticlesize/2, reticlesize, reticlesize)

        -- vignette
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(vignetteMat)
        surface.DrawTexturedRect(-vignettesize/2, -vignettesize/2, vignettesize, vignettesize)

        render.SetStencilEnable(false)
    cam.End3D2D()
end

hook.Add("PreDrawEffects", "predraweffects", function()
    local lply = LocalPlayer()
    local wep = lply:GetActiveWeapon()
    if wep.Base == "immersive_sweps" and lply:KeyDown(IN_ATTACK2) then
        local effect = wep:GetAttachmentEffects()
        if effect["PIPSight"] then
            DoScope()
        end
    end
end)