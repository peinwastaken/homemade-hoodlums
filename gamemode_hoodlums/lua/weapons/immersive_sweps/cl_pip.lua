pip_size = 512
local pipRenderTarget = GetRenderTarget("PIPScope" .. pip_size, pip_size, pip_size)
local pipMaterial = CreateMaterial("PIPScope" .. pip_size, "UnlitGeneric",{
    ["$ignorez"] = 1
})

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

local rendering = false
function DoScope()
    local lply = LocalPlayer()
    local wep = lply:GetActiveWeapon()
    if not IsValid(wep) then return end
    local effect = wep:GetAttachmentEffects()
    local att_scope = wep:GetAttachment(wep:LookupAttachment(effect["AimPosAttachment"]))
    local scope_pos, scope_ang = att_scope.Pos, att_scope.Ang
    scope_ang:RotateAroundAxis(scope_ang:Forward(), -90)

    local att_muzzle = wep:GetAttachment(wep:LookupAttachment("muzzle"))
    local muzzle_pos, muzzle_ang = att_muzzle.Pos, att_muzzle.Ang
    muzzle_ang:RotateAroundAxis(muzzle_ang:Forward(), -90)

    if not rendering then
        rendering = true

        local tr = util.QuickTrace(scope_pos, scope_ang:Forward() * 16, {lply})

        render.PushRenderTarget(pipRenderTarget)

        if tr.Hit then
            render.Clear(0, 0, 0, 255)
        else
            render.RenderView({origin = scope_pos + scope_ang:Forward() * 10, angles = scope_ang, fov = effect["PIPFov"], znear = 5, drawviewer = false})
        end

        render.PopRenderTarget()

        rendering = false
    end
end

local black = Material("reticles/black")
function DoPip(wep, pos, ang)
    if not IsValid(wep) then return end

    local effect = wep:GetAttachmentEffects()
    local reticlemat, reticlesize, pipradius = effect["ReticleMaterial"], effect["ReticleSize"], effect["PIPRadius"]
    
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

            pipMaterial:SetTexture("$basetexture", pipRenderTarget)
        cam.End3D2D()

        local size = 99999

        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(black)
        surface.DrawTexturedRect(-size/2, -size/2, size, size)

        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(pipMaterial)
        draw.Circle(0, 0, reticlesize/2, 32)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(reticlemat)
        surface.DrawTexturedRect(-reticlesize/2, -reticlesize/2, reticlesize, reticlesize)

        render.SetStencilEnable(false)
    cam.End3D2D()
end

hook.Add("PreDrawEffects", "predraweffects", function()
    DoScope()
end)