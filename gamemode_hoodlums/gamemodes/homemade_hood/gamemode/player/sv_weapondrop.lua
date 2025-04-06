local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")

local cleanuptable = {}
function CleanupItem(ent, time)
    cleanuptable[ent] = CurTime() + time
end

function RemoveItemFromCleanup(ent)
    if cleanuptable[ent] then
        cleanuptable[ent] = nil
    end
end

hook.Add("Think", "cleanupitems", function()
    for ent, time in pairs(cleanuptable) do
        if time < CurTime() and IsValid(ent) then
            ent:Remove()
            RemoveItemFromCleanup(ent)
        end
    end
end)

function PLAYER:DropCurrentWeapon()
    local wep = ply:GetActiveWeapon()
    if not wep.CanDrop then return end
    
    local pos, ang = ply:EyePos(), ply:EyeAngles()

    local pos, vel, time = pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 60

    ply:DropItem(wep, pos, vel, time)
end

function PLAYER:DropItem(wep, pos, vel, time)
    if wep == NULL or not IsValid(wep) then return end
    local classname = wep:GetClass()

    local drop = ents.Create("prop_physics")
    drop:SetModel(wep:GetModel())

    -- some properties
    drop.WeaponId = classname
    drop.Type = wep.Type or "weapon"
    drop.Attachments = wep:GetAttachments()
    drop.EquippedAttachments = wep.EquippedAttachments
    drop.Name = wep.PrintName

    local bodygroups = wep:GetBodyGroups()
    for i,tbl in ipairs(bodygroups) do
        drop:SetBodygroup(tbl.id, wep:GetBodygroup(tbl.id)) 
    end

    if wep.Base == "consumable_base" then
        drop.Remaining = wep:GetRemaining()
    end

    if wep.GetMagazinesRemaining then
        drop.Magazines = wep:GetMagazinesRemaining()
    end

    -- save some variables
    drop.Clip = wep:Clip1()

    drop:Spawn()
    drop:Activate()
    drop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

    drop:SetPos(pos)
    local physobjs = drop:GetPhysicsObjectCount()
    for i = 0, physobjs do
        local physobj = drop:GetPhysicsObjectNum(0)
        if IsValid(physobj) then
            physobj:SetVelocity(vel)
        end
    end

    drop:SetSkin(wep:GetSkin())

    if time then
        CleanupItem(drop, time)
    end

    if drop.Type == "grenade" then
        local plyAmmo = self:GetAmmoCount("grenade")
        if plyAmmo <= 1 then
            self:SetAmmo(0, "grenade")
            self:StripWeapon(wep:GetClass())
            return
        else
            wep:TakePrimaryAmmo(1)
            return
        end
    end

    self:StripWeapon(wep:GetClass())
end

function PLAYER:PickUpWeapon(wep)
    -- this just exists then i guess??????
end

function CreateDroppedWeapon(weaponClass, pos, randomAttachments, time)
    local wep = weapons.Get(weaponClass)

    local drop = ents.Create("prop_physics")
    drop:SetModel(wep.WorldModel)

    -- some properties
    drop.WeaponId = weaponClass
    drop.Type = wep.Type or "weapon"
    drop.Name = wep.PrintName
    drop.Clip = wep.Primary.ClipSize

    drop:Spawn()
    drop:Activate()
    drop:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

    if randomAttachments and wep.Attachments then
        drop.EquippedAttachments = wep.EquippedAttachments
        local attsIndexed = wep:GetRandomAttachments()

        for slot, att in pairs(drop.EquippedAttachments) do
            local att_slot = wep.Attachments[slot]
            if att_slot then
                if attsIndexed[slot] then
                    drop.EquippedAttachments[slot] = attsIndexed[slot][math.random(1, #attsIndexed[slot])]

                    local data = wep.Attachments[slot][drop.EquippedAttachments[slot]]
                    drop:SetBodygroup(data["bodygroup_id"], data["bodygroup_value"])

                    if data["effects"]["ClipSize"] then
                        drop.Clip = data["effects"]["ClipSize"]
                    end
                end
            end
        end

        --[[
        local id, value = att_slot["bodygroup_id"], att_slot["bodygroup_value"]

        self:SetBodygroup(id, value)

        for slot, tbl in pairs(drop.EquippedAttachments) do
            local rnd = math.random(1, #tbl)
            self:SetAttachmentSlot(slot, tbl[rnd])
        end]]
    end

    drop:SetPos(pos)

    if time then
        CleanupItem(drop, time)
    end
end

hook.Add("PlayerUse", "weapondrop_pickup", function(ply, ent)
    if ent:GetClass() == "prop_physics" and ply:KeyPressed(IN_USE) then
        if ent.Type == "weapon" then
            if not ply:KeyPressed(IN_USE) then return end
            local weaponId = ent.WeaponId
            local wep = ply:GetWeapon(weaponId)
    
            if IsValid(wep) then return false end
    
            ply:Give(weaponId)
            local wepgive = ply:GetWeapon(weaponId)
            
            -- for guns
            local attachments = ent.EquippedAttachments
            if attachments then
                for slot, att in pairs(attachments) do
                    wepgive:SetAttachmentSlot(slot, att)
                end
            end
    
            -- just for some retarded vss issue lol
            -- tbf the attachment system is all a bit restarted but its fine since the player will never see this code anyway
            -- and all that matters is that it plays well :)
            local count = ent:GetNumBodyGroups()
            for id = 0, count - 1 do
                local value = ent:GetBodygroup(id)
                wepgive:SetBodygroup(id, value)
            end
    
            -- for drinks
            local remaining = ent.Remaining
            if remaining then
                wepgive:SetRemaining(remaining)
            end
    
            local mags = ent.Magazines
            if mags then
                wepgive:SetMagazinesRemaining(ent.Magazines)
            end
    
            wepgive:SetClip1(ent.Clip)
    
            RemoveItemFromCleanup(ent)
            ent:Remove()
            return false
        elseif ent.Type == "grenade" then
            if not ply:KeyPressed(IN_USE) then return end
    
            local weaponId = ent.WeaponId
            local wep = ply:GetWeapon(weaponId)
            local wepClass = weapons.Get(weaponId)
    
            -- temp hardcoded grenade ammo until i add more ammotypes and more nades :thumbsup:
            -- yeah..... temp......... right buddy............
            if IsValid(wep) then
                local plyAmmo = ply:GetAmmoCount("grenade")
                if plyAmmo < wepClass.MaxAmmo then
                    ply:GiveAmmo(1, "grenade")
                end
            else
                ply:Give(weaponId)
                ply:SetAmmo(1, "grenade")
            end
    
            ent:Remove()
            return false
        elseif ent.Type == "armor" then
            ply:GiveArmor(ent.Id, ent.Durability)

            print(ent.Durability)

            ent:Remove()
            return false
        elseif ent.Type == "helmet" then
            ply:GiveHelmet(ent.Id, ent.Durability)

            ent:Remove()
            return false
        end
    end

    return true
end)

local le_drinks = {"consumable_liquor", "consumable_henny"}
hook.Add("PlayerDeath", "dropweaponondeath", function(ply, inflictor, attacker)
    local wep = ply:GetActiveWeapon()
    local pos, ang = ply:EyePos(), ply:EyeAngles()

    --[[ print("hi")
    I actually really like this print... I can always count on a friendly greeting when checking the console.. I can't bring myself to delete it so I'll just comment it out.
    ]]

    local pos, vel, time = pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 60

    if wep.CanDrop then
        ply:DropItem(wep, pos, vel, time)
    end
end)

concommand.Add("drop", function(ply)
    local wep = ply:GetActiveWeapon()
    local pos, ang = ply:EyePos(), ply:EyeAngles()
    if IsValid(wep) and wep.CanDrop then
        ply:DropItem(wep, pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 180)
    end
end, nil, nil, 0)