local limbMats = {
    ["Head"] = Material("gui/limbs/head.png", "smooth"),
    ["Torso"] = Material("gui/limbs/torso.png", "smooth"),
    ["RightArm"] = Material("gui/limbs/rightarm.png", "smooth"),
    ["LeftArm"] = Material("gui/limbs/leftarm.png", "smooth"),
    ["RightLeg"] = Material("gui/limbs/rightleg.png", "smooth"),
    ["LeftLeg"] = Material("gui/limbs/leftleg.png", "smooth"),
}

net.Receive("SyncLimbData", function()
    local data = net.ReadTable()
    local lply = LocalPlayer()

    lply.LimbData = data
end)

-- extremely temporary.... but is it really?
hook.Add("HUDPaint", "limbhealth_hud", function()
    local lply = LocalPlayer()
    local limbData = lply:GetLimbData()

    if not limbData or not lply:Alive() then return end

    local pos = {x = 50, y = 50}
    local size = {x = 100, y = 220}
    local padding = 10

    draw.NoTexture()
    surface.SetDrawColor(0, 0, 0, 50)
    surface.DrawTexturedRect(pos.x - padding/2, pos.y - padding/2, size.x + padding, size.y + padding)

    for limb, health in pairs(limbData) do
        local health = limbData[limb]
        local color
        if not health or not limb then continue end

        if health > LimbBrokenHealth[limb] then
            local lerp = health / defaultLimbHealth[limb]
            color = LerpColor(1 - lerp, color_white, Color(255, 24, 24))
        else
            color = Color(25, 25, 25)
        end

        

        surface.SetMaterial(limbMats[limb])
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(pos.x, pos.y, size.x, size.y)

        --local text = string.format("%s: %s", limb, health)

        --if limb == "Health" then
        --    text = string.format("%s: %s", "TotalHealth", lply:GetTotalLimbHealth())
        --end

        --[[
        local gap = ScreenScale(13)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.SetFont("HudSmall")
        local bgx, bgy = surface.GetTextSize(text)
        surface.DrawTexturedRect(50 - 2.5, 25 + gap * times, bgx + 5, bgy)

        draw.SimpleText(text, "HudSmall", 50, 25 + gap * times, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        times = times + 1]]
    end
end)