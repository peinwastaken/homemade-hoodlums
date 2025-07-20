include("sh_data.lua")

net.Receive("SyncHoodlumData", function(len)
    local lply = LocalPlayer()
    local data = net.ReadTable()

    lply.hoodlumData = data
end)