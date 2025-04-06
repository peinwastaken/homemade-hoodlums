if SERVER then
    AddCSLuaFile()
end

ENT.Type = "anim"
ENT.PrintName = "ent_money"
ENT.Author = "pein"
ENT.Spawnable = false

local moneyAmounts = {100, 50, 25, 10, 5} // retarded
local skins = {
    [100] = 0,
    [50] = 1,
    [25] = 2,
    [10] = 3,
    [5] = 4
}

// 5, 10, 25, 50, 100
function ENT:SetWorth(amount)
    self:SetAmount(amount)

    if !skins[amount] then
        print("skin not found for amount")
        return
    end

    self:SetSkin(skins[amount])
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Amount")
    self:NetworkVar("Float", 0, "DespawnTime")

    self:SetDespawnTime(CurTime() + 120) // 2 min

    self:SetWorth(moneyAmounts[math.random(1, #moneyAmounts)])
end

function ENT:Initialize()
    self:SetModel("models/pein/money/w_money.mdl")
    self:SetModelScale(1)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
    self:Activate()
end

function ENT:Use(ent)
    if !ent:IsPlayer() then return end
    if !ent:KeyPressed(IN_USE) then return end

    if IsFirstTimePredicted() then
        local pos = self:GetPos()
        EmitSound(string.format("pein/money/pickup1.wav", math.random(1, 4)), pos, 0, CHAN_AUTO, 1, 350, SND_NOFLAGS, 100, 0, player.GetAll())
        ent:AddMoney(100)
        self:Remove()
    end
end

function ENT:Think()
    if SERVER then
        if CurTime() > self:GetDespawnTime() then
            self:Remove()
        end
    end
end