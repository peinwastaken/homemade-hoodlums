local limbMats = {
    ["Head"] = Material("gui/limbs/head.png", "smooth"),
    ["Torso"] = Material("gui/limbs/torso.png", "smooth"),
    ["RightArm"] = Material("gui/limbs/rightarm.png", "smooth"),
    ["LeftArm"] = Material("gui/limbs/leftarm.png", "smooth"),
    ["RightLeg"] = Material("gui/limbs/rightleg.png", "smooth"),
    ["LeftLeg"] = Material("gui/limbs/leftleg.png", "smooth"),
}

local armorMats = {
    ["Helmet"] = Material("gui/armor/helmet.png", "smooth"),
    ["Vest"] = Material("gui/armor/vest.png", "smooth"),
}

local batteryIcon = Material("gui/armor/BatteryIcon.png", "smooth")

local colors = {
    ["High"] = Color(255, 255, 255),
    ["Low"] = Color(255, 24, 24),
    ["None"] = Color(25, 25, 25)
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

    if not limbData or not lply:Alive() or BodycamEnabled() then return end

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
            color = LerpColor(1 - lerp, colors["High"], colors["Low"])
        else
            color = colors["None"]
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

    local helmet, armor = lply:GetHelmet(), lply:GetArmor()

    if IsValid(helmet) then
        local dur = helmet:Health()
        local maxDur = helmet.Durability
        local lerp = dur / maxDur
        local color = LerpColor(1 - lerp, colors["High"], colors["Low"])
        local mat = helmet.HudMaterial or armorMats["Helmet"]

        surface.SetMaterial(mat)
        surface.SetDrawColor(color)
        surface.DrawTexturedRect(pos.x, pos.y, size.x, size.y)
    end

    if IsValid(armor) then
        local dur = armor:Health()
        local maxDur = armor.Durability
        local lerp = dur / maxDur
        local color = LerpColor(1 - lerp, colors["High"], colors["Low"])
        local mat = armor.HudMaterial or armorMats["Vest"]

        if lerp ~= 0 then
            surface.SetMaterial(mat)
            surface.SetDrawColor(color)
            surface.DrawTexturedRect(pos.x, pos.y, size.x, size.y)
        end
    end

    local currentBattery = lply:Armor()

    if currentBattery > 0 then
        local mat = batteryIcon
        local iconSize = {x = 25, y = 25}
        local text = string.format(currentBattery)

        surface.SetMaterial(mat)
        surface.SetDrawColor(255,255,255)
        surface.DrawTexturedRect(pos.x, pos.y + size.y * 1.05, iconSize.x, iconSize.y)
        draw.SimpleTextOutlined(text, "GTAsmall", pos.x + (iconSize.x * 1.25), pos.y + size.y * 1.09, Color(124,140,95), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0,0,0))
    end
    
end)