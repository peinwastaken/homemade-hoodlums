include("sh_data.lua")
local PLAYER = FindMetaTable("Player")

util.AddNetworkString("SyncHoodlumData")

hook.Add("PlayerInitialSpawn",  "setupdata", function(ply, trans)
    ply.hoodlumData = {
        ["Kills"] = 0,
        ["Deaths"] = 0,
        ["Money"] = 0
    }
end)

function PLAYER:SyncHoodlumData()
    net.Start("SyncHoodlumData")
    net.WriteTable(self.hoodlumData) -- optimize later or something (16 bits of something per something idk)
    net.Send(self)
end

function PLAYER:AddMoney(amount)
    local money = self.hoodlumData["Money"]

    self.hoodlumData["Money"] = money + amount
    self:SyncHoodlumData()
end

function PLAYER:RemoveMoney(amount)
    local money = self.hoodlumData["Money"]

    self.hoodlumData["Money"] = money - amount
    self:SyncHoodlumData()
end

function PLAYER:SetMoney(amount)
    self.hoodlumData["Money"] = amount
    self:SyncHoodlumData()
end

-- todo add kills deaths and whatnot lol