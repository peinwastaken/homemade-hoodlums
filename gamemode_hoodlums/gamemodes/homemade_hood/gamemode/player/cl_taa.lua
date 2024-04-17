local taa = CreateClientConVar("cl_taa", 0, true, false, "Enable/Disable TAA", 0, 1)

local blur = Material("pp/blurx")
hook.Add("RenderScreenspaceEffects", "render_taa", function()
    local enabled = taa:GetBool()

    if enabled then
        blur:SetFloat("$size", 1)
        render.SetMaterial(blur)
        render.DrawScreenQuad()

        DrawMotionBlur(0.2, 1, 0.01) 
    end
end)