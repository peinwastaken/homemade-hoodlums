-- retarded
local PLAYER = FindMetaTable("Player")

local function DropTrace(ent, pos, ang, distance)
    return util.TraceLine({
        start = pos,
        endpos = pos + ang:Forward() * distance,
        filter = {ent}
    })
end

-- copied from sv_weapondrop
function CreateDroppedArmor(armorClass, pos, durability, time)
    local armor = scripted_ents.Get(armorClass)

    local drop = ents.Create("prop_physics")
    drop:SetModel(armor.Model)

    drop.Id = armorClass
    drop.Type = armor.ArmorType
    drop.Durability = durability or armor.Durability

    drop:PhysicsInit(SOLID_CUSTOM)

    drop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR) -- ummm weird HELLO>????

    drop:Spawn()
    drop:Activate()

    drop:SetPos(pos)

    if time then
        CleanupItem(drop, time)
    end

    return drop
end

concommand.Add("droparmor", function(ply, cmd, args, argStr)
    ply:DropArmor()
end)

concommand.Add("drophelmet", function(ply, cmd, args, argStr)
    ply:DropHelmet()
end)

-- weird retarded double function ARRGHHHHhhhh
function PLAYER:DropArmor()
    local armor = self:GetArmor()
    if not IsValid(armor) then print("armor not valid") return end

    local class = armor:GetClass()

    local pos, ang = self:EyePos(), self:EyeAngles()
    local tr = DropTrace(ply, pos, ang, 32)

    local ent = CreateDroppedArmor(class, tr.HitPos, armor:Health(), 180)
    local phys = ent:GetPhysicsObject()
    if phys then
        phys:SetVelocity(ang:Forward() * 100)
    end

    self:ResetArmor()
end

function PLAYER:DropHelmet()
    local armor = self:GetHelmet()
    if not IsValid(armor) then print("armor not valid") return end

    local class = armor:GetClass()

    local pos, ang = self:EyePos(), self:EyeAngles()
    local tr = DropTrace(ply, pos, ang, 32)

    local ent = CreateDroppedArmor(class, tr.HitPos, armor:Health(), 180)
    local phys = ent:GetPhysicsObject()
    if phys then
        phys:SetVelocity(ang:Forward() * 100)
    end

    self:ResetHelmet()
end

function PLAYER:GiveArmor(name, durability)
    if not self:Alive() then print("player not alive") return end

    local armor = scripted_ents.Get(name)
    if not armor or armor.ArmorType ~= "armor" then print("not armor") return end

    local curArmor = self:GetNWEntity("armor")
    if IsValid(curArmor) then
        curArmor:Remove()
    end

    local ent = ents.Create(name)
    local dur = durability or ent.Durability

    ent:SetPos(self:GetPos())
    ent:SetOwner(self)
    ent:Spawn()

    ent:SetHealth(dur)

    self:SetNWEntity("armor", ent)
end

function PLAYER:GiveHelmet(name, durability)
    if not self:Alive() then print("player not alive") return end

    local helmet = scripted_ents.Get(name)
    if not helmet or helmet.ArmorType ~= "helmet" then print("not helmet") return end

    local curHelmet = self:GetNWEntity("helmet")
    if IsValid(curArmor) then
        curHelmet:Remove()
    end

    local ent = ents.Create(name)
    local dur = durability or ent.Durability

    ent:SetPos(self:GetPos())
    ent:SetOwner(self)
    ent:Spawn()

    ent:SetHealth(dur)

    self:SetNWEntity("helmet", ent)
end

function PLAYER:ResetArmors()
    local helmet = self:GetNWEntity("helmet")
    local armor = self:GetNWEntity("armor")

    if IsValid(helmet) then helmet:Remove() end
    if IsValid(armor) then armor:Remove() end
end

function PLAYER:ResetArmor()
    local armor = self:GetNWEntity("armor")
    if IsValid(armor) then armor:Remove() end
end

function PLAYER:ResetHelmet()
    local helmet = self:GetNWEntity("helmet")
    if IsValid(helmet) then helmet:Remove() end
end

function PLAYER:ResetArmorSlot(slot)
    local armor = self:GetNWEntity(slot)
    if IsValid(armor) then armor:Remove() end
end

function PLAYER:TransferArmorOwnership(slot, newEntity)
    local armor = self:GetNWEntity(slot)
    if not IsValid(armor) then return end

    newEntity:SetNWEntity(slot, armor)
    self:SetNWEntity(slot, nil)
end

function PLAYER:TakeArmorDamage(slot, dmg)
    if not slot == "helmet" or not slot == "helmet" then return end
    local armor = self:GetNWEntity(slot)
    if not IsValid(armor) then return end

    local health = armor:Health()

    armor:SetHealth(health - dmg)

    if armor:Health() <= 0 then
        armor:Remove()
        self:SetNWEntity(slot, nil)
    end
end

--[[
hook.Add("PlayerRespawn", "eiase", function(ply)
    local rag = ply:GetRagdoll()
    if rag then
        local helmet, armor = ply:GetArmors()
        if IsValid(helmet) then
            ply:TransferArmorOwnership("helmet", rag)
        end
        if IsValid(armor) then
            ply:TransferArmorOwnership("armor", rag)
        end
    end

    ply:GiveHelmet("helmet_welding")
    ply:GiveArmor("armor_6b23")
end)]]