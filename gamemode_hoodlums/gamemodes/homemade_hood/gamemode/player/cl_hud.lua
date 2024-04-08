local color_crips = Color(50, 50, 255)
local color_bloods = Color(255, 50, 50)
local alpha = 0
local alliance = "crips"
local alphamult = 1

local timesincespawn = 0

local white = Material("reticles/white.vmt")

local last = SysTime()
hook.Add("Think", "homemade_doalpha", function()
    local ft = SysTime() - last
    last = SysTime()

    alpha = math.floor(LerpFT(4, alpha, 0))
    if timesincespawn > 1 then
        alphamult = math.Approach(alphamult, 0, FrameTime())
    end
    timesincespawn = timesincespawn + ft
end)

hook.Add("HUDPaint", "homemade_drawhud", function()
    if alliance == "crips" then
        surface.SetDrawColor(50, 50, 255, alpha)
    else
        surface.SetDrawColor(255, 50, 50, alpha)
    end

    surface.DrawTexturedRect(-1, -1, ScrW() + 1, ScrH() + 1)
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
        if alliance == "crips" then
            draw.DrawText("Crips", "FancyOldTimey", pos.x, 150, Color(0, 0, 255, 100 * alphamult), TEXT_ALIGN_CENTER)
        else
            draw.DrawText("Bloods", "FancyOldTimey", pos.x, 150, Color(255, 0, 0, 100 * alphamult), TEXT_ALIGN_CENTER)
        end
        
    end)
    timer.Simple(2, function()
        hook.Remove("HUDPaint", "showteam")
    end)
end

net.Receive("Hoodlum_PlayerRespawn", function()
    local t = net.ReadString()
    DoRespawnScreen(t)
end)