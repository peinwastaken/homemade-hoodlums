include("sh_data.lua")

net.Receive("SyncHoodlumData", function(len)
    local lply = LocalPlayer()
    local data = net.ReadTable()

    lply.hoodlumData = data
    PrintTable(lply:GetHoodlumData())
end)

-- temporarily putting it here
hook.Add("HUDPaint", "drawmoney", function()
    local lply = LocalPlayer()
    local hoodlumData = lply:GetHoodlumData()

    local text = string.format("$%s", hoodlumData["Money"])
    local pos = {
        x = ScrW() - 50,
        y = 50
    }
    DrawInfoText(text, 1, pos.x, pos.y)
end)