local taa = CreateClientConVar("cl_taa", 0, true, false, "Enable/Disable TAA", 0, 1)
local sharpen = CreateClientConVar("cl_sharpen", 0, true, false, "Sharpen for TAA", 0, 5)

local blur = Material("pp/blurx")
hook.Add("RenderScreenspaceEffects", "render_taa", function()
    local lply = LocalPlayer()
    local enabled = taa:GetBool()

    if enabled then
        blur:SetFloat("$size", 1)
        render.SetMaterial(blur)
        render.DrawScreenQuad()

        DrawSharpen(sharpen:GetFloat(), 0.5)

        DrawMotionBlur(0.2, 1, 0.01) 
    end
end)