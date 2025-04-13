include("sh_data.lua")

net.Receive("SyncHoodlumData", function(len)
    local lply = LocalPlayer()
    local data = net.ReadTable()

    lply.hoodlumData = data
end)

-- temporarily putting it here
hook.Add("HUDPaint", "drawmoney", function()
    local lply = LocalPlayer()
    local hoodlumData = lply:GetHoodlumData()

    if !hoodlumData then return end

    local text = string.format("$%s", hoodlumData["Money"])
    local pos = {
        x = ScrW() - 50,
        y = 50
    }
    //DrawInfoText(text, 1, pos.x, pos.y)

    draw.SimpleTextOutlined(text, "GrandTheftAuto", pos.x, pos.y, Color(61, 107, 49), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 2, Color(0, 0, 0))
end)