-- realism.. epic
local bodycam = CreateClientConVar("hoodlum_bodycam", 0, true, false, "Enable/disable bodycam mode. REALISM!!!", 0, 1)

local blur = Material("pp/blurscreen")
local refract = Material("overlay/bodycam/refract_bodycam.vmt")
local border = Material("overlay/bodycam/border.vmt")
local dirt = Material("overlay/bodycam/dirt.vmt")
local noiseRT = GetRenderTarget("NoiseRT", ScrW(), ScrH())
local noiseMaterial = CreateMaterial("NoiseMaterial", "UnlitGeneric", {
    ["$basetexture"] = noiseRT:GetName()
})

local chromaticRB = GetRenderTarget("ChromaticAbberation", ScrW(), ScrH())
local red = CreateMaterial("ColorRed", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$color2"] = "[1 0 0]",
    ["$ignorez"] = 1,
    ["$additive"] = 1
})

local green = CreateMaterial("ColorGreen", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$color2"] = "[0 1 0]",
    ["$ignorez"] = 1,
    ["$additive"] = 1
})

local blue = CreateMaterial("ColorBlue", "UnlitGeneric", {
    ["$basetexture"] = "_rt_FullFrameFB",
    ["$color2"] = "[0 0 1]",
    ["$ignorez"] = 1,
    ["$additive"] = 1
})

local black = Material("vgui/black")

function BodycamEnabled()
    local lply = LocalPlayer()
    local t = player_manager.RunClass(lply, "GetAlliance")
    if bodycam:GetBool() then
        return true
    end
end

-- VERY expensive(-200 fps on crackhouse lol)... idk if i want to keep it around even.....
function DrawNoise()
    render.PushRenderTarget(noiseRT)
        render.Clear(0, 0, 0, 0, true, true)

        cam.Start2D()
            local scrw, scrh = ScrW(), ScrH()
            local noisew = math.ceil(scrw * 0.01)
            local noiseh = math.ceil(scrh * 0.01)

            surface.SetDrawColor(255, 255, 255, 255)

            for x = 0, scrw, noisew do
                for y = 0, scrh, noiseh do
                    if math.random() > 0.5 then
                        surface.DrawRect(x, y, noisew, noiseh)
                    end
                end
            end
        cam.End2D()
    render.PopRenderTarget()

    noiseMaterial:SetTexture("$basetexture", noiseRT:GetName())
    noiseMaterial:SetFloat("$alpha", 0.05)
    render.SetMaterial(noiseMaterial)
    render.DrawScreenQuad()
end

function DrawBodycamRefract(amount, widthAdd, heightAdd)
    refract:SetFloat("$refractamount", amount)
    render.SetMaterial(refract)
    render.DrawScreenQuadEx(0 - widthAdd/2, 0 - heightAdd/2, ScrW() + widthAdd, ScrH() + heightAdd)
end

function DrawBodycamBorder()
    render.SetMaterial(border)
    render.DrawScreenQuad()
end

function DrawLensDirt(alpha)
    dirt:SetFloat("$alpha", alpha)
    render.SetMaterial(dirt)
    render.DrawScreenQuad()
end

function DrawChromaticAbberation()
    local size = 1

    render.UpdateScreenEffectTexture()

    render.SetMaterial(black)
    render.DrawScreenQuad()

    render.SetMaterial(red)
    render.DrawScreenQuadEx(size, size, ScrW(), ScrH())

    render.SetMaterial(green)
    render.DrawScreenQuadEx(-size, -size, ScrW(), ScrH())

    render.SetMaterial(blue)
    render.DrawScreenQuadEx(0, 0, ScrW(), ScrH())
end

local overlayMat = Material("vgui/white")
local pos = {
    x = ScrW() - 300,
    y = 50
}
local size = {
    x = 250,
    y = 100
}

function DrawBodycamOverlay()
    
end

hook.Add("RenderScreenspaceEffects", "bodycamscreenspace", function()
    -- umm
end)

hook.Add("HUDPaintBackground", "bodycamoverlay", function()
    if BodycamEnabled() then
        -- looks like shit..
        --DrawMotionBlur(0.5, 5, FrameTime())

        -- looks like shit and nothing i tried made it look good
        -- workshop addon also looks like shit
        -- could probably zoom it in or some shit idk not doin it rn
        --DrawBodycamRefract(-0.2, 400, 300)

        --DrawSharpen(0.5, 2)
        
        -- ultra expensive, might just create some materials...
        --DrawNoise()
        --DrawLensDirt(0.02)
        
        DrawChromaticAbberation()
        DrawBloom(0.5, 3, 10, 10, 10, 0.2, 0.5, 0.5, 0.5)

        DrawBodycamBorder()
        --DrawBodycamOverlay()
        
        -- black bars
        --[[
        local scrw, scrh = ScrW(), ScrH()
        local aspect = 1.4
        local width, height = scrh * aspect, scrw / aspect

        if width < scrw then
            local barWidth = (scrw - width) / 2
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawRect(0, 0, barWidth, scrh) -- left
            surface.DrawRect(scrw - barWidth, 0, barWidth, scrh) -- right
        end]]
    end
end)