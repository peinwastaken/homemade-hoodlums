local color_crips = Color(50, 50, 255)
local color_bloods = Color(255, 50, 50)
local alpha = 0
local alliance = "crips"
local alphamult = 1

local timesincespawn = 0
local damagelerp = 0

local white = Material("reticles/white.vmt")
local healthMat = Material("icon64/health.png", "alphatest")

net.Receive("PlayerDamage", function()
    damagelerp = 1
end)

local function DrawHealth(health, shake)
    surface.SetFont("HudMedium")
    local textSizeX, textSizeY = surface.GetTextSize("000")

    local padding = {x = 20, y = 5}
    local pos = {
        x = 50 - padding.x/2 + math.random(-shake, shake),
        y = ScrH() - 50 - padding.y/2 + math.random(-shake, shake)
    }

    local sizeHealth = 32
    local offsetHealth = {x = 3 + padding.y, y = 0}
    
    local textOffset = {
        x = 16, y = -0
    }

    local size = {
        x = textSizeX + padding.x + textOffset.x + sizeHealth/2,
        y = textSizeY + padding.y
    }

    local posText = {
        x = pos.x + offsetHealth.x + 32 + textOffset.x,
        y = pos.y + textOffset.y
    }

    -- background
    surface.SetDrawColor(0, 0, 0, 50)
    surface.DrawRect(pos.x, pos.y - size.y/2, size.x, size.y)

    -- icon
    surface.SetMaterial(healthMat)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(pos.x + offsetHealth.x, pos.y + offsetHealth.y - sizeHealth/2, sizeHealth, sizeHealth)

    -- health
    draw.SimpleText(health, "HudMedium", posText.x, posText.y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local function DrawLimbText(text, color, posX, posY)
    surface.SetFont("HudSmall")
    local textSizeX, textSizeY = surface.GetTextSize(text)
    
    local padding = {x = 20, y = 5}
    local size = {x = textSizeX + padding.x, y = textSizeY + padding.y}
    local x = posX - size.x
    local y = posY - size.y/2

    local textPos = {
        x = x + textSizeX/2 + padding.x/2,
        y = y + textSizeY/2
    }

    surface.SetDrawColor(0, 0, 0, 50)
    surface.DrawRect(x, y, size.x, size.y)

    draw.SimpleText(text, "HudSmall", textPos.x, textPos.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local last = SysTime()
hook.Add("Think", "homemade_doalpha", function()
    local ft = SysTime() - last
    last = SysTime()

    alpha = math.floor(LerpFT(4, alpha, 0))
    if timesincespawn > 1 then
        alphamult = math.Approach(alphamult, 0, FrameTime())
    end
    timesincespawn = timesincespawn + ft
    damagelerp = Lerp(12 * FrameTime(), damagelerp, 0)
end)

hook.Add("HUDPaint", "homemade_drawhud", function()
    -- respawn thingy
    local name, color = _G.Teams[alliance]["Name"], _G.Teams[alliance]["RespawnColor"]
    draw.NoTexture()
    surface.SetDrawColor(color.r, color.g, color.b, alpha)

    surface.DrawTexturedRect(-1, -1, ScrW() + 1, ScrH() + 1)

    local lply = LocalPlayer()
    local ragdoll = lply:GetNWEntity("ragdoll")
    local wep = lply:GetActiveWeapon()
    
    if lply:Alive() and not IsValid(ragdoll) then
        --DrawHealth(math.Clamp(lply:Health(), 0, lply:GetMaxHealth()), 10 * damagelerp)
    end
end)

hook.Add("HUDDrawPickupHistory", "homemade_drawpickup", function()
    return false
end)

local function DoRespawnScreen(t)
    alpha = 200
    alphamult = 1
    timesincespawn = 0
    alliance = t

    local pos = {
        x = ScrW()/2,
        y = ScrH()/2
    }

    hook.Add("HUDPaint", "showteam", function()
        local name, color = _G.Teams[alliance]["Name"], _G.Teams[alliance]["RespawnColor"]
        --print(name, color)

        draw.DrawText(name, "FancyOldTimey", pos.x, 150, Color(color.r, color.g, color.b, 100 * alphamult), TEXT_ALIGN_CENTER)
    end)
    timer.Simple(2, function()
        hook.Remove("HUDPaint", "showteam")
    end)
end

net.Receive("Hoodlum_PlayerRespawn", function()
    local t = net.ReadString()
    DoRespawnScreen(t)
end)

-- this is here only to hide some retarded rendertarget shit when the game is paused
local ang = 0
local logo = Material("gui/logo.png")
local size = {x = 288, y = 128}
hook.Add("PostDrawHUD", "pausehud", function()
    ang = ang + FrameTime() * 20
    if ang > 360 then
        ang = 0
    end
    if gui.IsGameUIVisible() then
        draw.NoTexture()
        surface.SetDrawColor(Color(0, 0, 0, 255))
        surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)

        surface.SetDrawColor(255, 255, 255, 255)
        draw.DrawText("unpause the game cuz.. your homies need you", "BudgetLabel", ScrW()/2, ScrH()/2 - 256, color_white, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(logo)
        surface.DrawTexturedRectRotated(ScrW()/2, ScrH()/2, size.x, size.y, -ang)
    end
end)

local hide = {
	["CHudCrosshair"] = true,
    ["CHUDQuickInfo"] = true,
    ["CHudSuitPower"] = true,
    ["CHudZoom"] = true,
    ["CHudHealth"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if (hide[ name ]) then
		return false
	end
end)