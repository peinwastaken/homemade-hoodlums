local vignetteMat = Material("suppression/suppression.png")
local bokeh = Material("pp/blurx")

local suppressionAmount = 0
local suppressionSharpen = 0
local suppressionShake = Angle(0, 0, 0)
local suppressionVignette = 0

net.Receive("SuppressPlayer", function()
    local amount = net.ReadFloat()

    suppressionAmount = math.Clamp(suppressionAmount + amount, 0, 5)
    suppressionShake = suppressionShake + Angle(math.random(-8, 8), math.random(-8, 8), math.random(-8, 8)) * amount
    suppressionSharpen = math.Clamp(suppressionSharpen + amount * 0.25, 0, 1)
    suppressionVignette = math.Clamp(suppressionVignette + amount * 0.2, 0, 1)

    EmitSound(GetSuppressionSound(), LocalPlayer():EyePos(), LocalPlayer():EntIndex(), CHAN_AUTO, 1, 140, SND_NOFLAGS, math.random(80, 140), 1)
end)

function GetSuppressionShake()
    return suppressionShake
end

local sounds = {
    "weapons/fx/rics/ric2.wav",
    "weapons/fx/nearmiss/bulletLtoR03.wav",
    "weapons/fx/nearmiss/bulletLtoR04.wav",
    "weapons/fx/nearmiss/bulletLtoR05.wav",
    "weapons/fx/nearmiss/bulletLtoR06.wav",
    "weapons/fx/nearmiss/bulletLtoR07.wav",
    "weapons/fx/nearmiss/bulletLtoR09.wav",
    "weapons/fx/nearmiss/bulletLtoR10.wav",
    "weapons/fx/nearmiss/bulletLtoR11.wav",
    "weapons/fx/nearmiss/bulletLtoR12.wav",
    "weapons/fx/nearmiss/bulletLtoR13.wav",
    "weapons/fx/nearmiss/bulletLtoR14.wav"
}

function GetSuppressionSound()
    return sounds[math.random(1, #sounds)]
end

local tab = {
	["$pp_colour_addr"] = 0.02,
	["$pp_colour_addg"] = 0.02,
	["$pp_colour_addb"] = 0.02,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0.5,
	["$pp_colour_mulr"] = 0.02,
	["$pp_colour_mulg"] = 0.02,
	["$pp_colour_mulb"] = 0.02
}

hook.Add("RenderScreenspaceEffects", "cl_suppression_screenspace", function()
    if LocalPlayer():Alive() then
        suppressionAmount = LerpFT(1, suppressionAmount, 0)
        suppressionShake = LerpAngleFT(1, suppressionShake, Angle(0, 0, 0))
        suppressionSharpen = LerpFT(0.1, suppressionAmount, 0)
        suppressionVignette = LerpFT(0.1, suppressionVignette, 0)
    
        tab["$pp_colour_colour"] = math.Clamp(1 - suppressionAmount * 0.15, 0, 1),
        DrawColorModify(tab)

        -- sharpen
        DrawSharpen(0.75, suppressionSharpen)

        -- vignette
        vignetteMat:SetFloat("$alpha", suppressionVignette)
        render.SetMaterial(vignetteMat)
        render.DrawScreenQuad()
    end
end)

hook.Add("ClientDeath", "cl_suppression_clientdeath", function()
    suppressionAmount = 0
    suppressionSharpen = 0
    suppressionShake = Angle(0, 0, 0)
    suppressionVignette = 0
end)