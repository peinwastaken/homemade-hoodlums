net.Receive("SyncLimbData", function()
    local data = net.ReadTable()
    local lply = LocalPlayer()

    lply.LimbData = data
end)

-- extremely temporary.... but is it really?
local limbOrder = {"Head", "Torso", "RightArm", "LeftArm", "RightLeg", "LeftLeg", "Health"}
hook.Add("HUDPaint", "limbhealth_hud", function()
    local lply = LocalPlayer()
    local limbData = lply:GetLimbData()

    if not limbData then return end

    local times = 0
    for _, limb in ipairs(limbOrder) do
        local health = limbData[limb]
        local color = Color(255, 255, 255, 255)
        if health and health < LimbBrokenHealth[limb] then
            color = Color(255, 97, 97)
        end

        local text = string.format("%s: %s", limb, health)

        if limb == "Health" then
            text = string.format("%s: %s", "TotalHealth", lply:GetTotalLimbHealth())
        end

        local gap = ScreenScale(13)
        surface.SetDrawColor(0, 0, 0, 50)
        surface.SetFont("HudSmall")
        local bgx, bgy = surface.GetTextSize(text)
        surface.DrawTexturedRect(50 - 2.5, 25 + gap * times, bgx + 5, bgy)

        draw.SimpleText(text, "HudSmall", 50, 25 + gap * times, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        times = times + 1
    end
end)