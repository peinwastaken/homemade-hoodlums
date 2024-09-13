include("sh_data.lua")
PlayerData = {}

local PLAYER = FindMetaTable("Player")

local defaultData = {
    ["Kills"] = 0,
    ["Deaths"] = 0,
    ["Money"] = 0
}

function PLAYER:SetDataTable(dataTable)
    PlayerData[self] = dataTable
end

function PLAYER:SetupData()
    self:SetDataTable(defaultData)
end

hook.Add("PlayerInitialSpawn",  "setupdata", function(ply, trans)
    ply:SetupData()
end)