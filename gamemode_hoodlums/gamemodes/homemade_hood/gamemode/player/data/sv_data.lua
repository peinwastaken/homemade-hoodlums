include("sh_data.lua")
local PLAYER = FindMetaTable("Player")

util.AddNetworkString("SyncHoodlumData")
util.AddNetworkString("DropMoney")

hook.Add("PlayerInitialSpawn",  "setupdata", function(ply, trans)
    ply.hoodlumData = {
        ["Kills"] = 0,
        ["Deaths"] = 0,
        ["Money"] = 0
    }
end)

hook.Add("PlayerSay", "data_commands", function(ply, text, teamChat)
    local moneySpawnPos = ply:GetPos() + vector_up * 48 + ply:EyeAngles():Forward() * 8

    local kaboom = string.Explode(" ", text)

    if kaboom[1] == "!dropmoney" then
        local hoodlumData = ply:GetHoodlumData()
        local amount = tonumber(kaboom[2])

        if amount > hoodlumData["Money"] then return "im too poor bruh" end
        
        local moneyToSpawn = ValueToDollars(amount)

        for i = 1, #moneyToSpawn, 1 do
            SpawnDroppedMoney(moneySpawnPos, ply:EyeAngles():Forward(), 200, moneyToSpawn[i])
            ply:SetMoney(hoodlumData["Money"] - moneyToSpawn[i])
        end

        return ""
    end
end)

function SpawnDroppedMoney(pos, dir, velocity, amount)
    local ent = ents.Create("ent_money")
    ent:SetPos(pos)
    ent:Spawn()

    local phys = ent:GetPhysicsObject()
    if (phys) then
        phys:SetVelocity(dir * velocity)
        phys:SetAngleVelocity(Vector(600, 0, 200))
    end

    if amount then
        ent:SetWorth(amount)
    end
end

function ValueToDollars(value)
    local dollars = {100, 50, 20, 10, 5}
    local bills = {}
    value = tonumber(value)
    
    for i = 1, #dollars, 1 do
        while value >= dollars[i] do
            value = value - dollars[i]
            table.insert(bills, dollars[i])
        end
    end
    
    return bills
end

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