local PLAYER = FindMetaTable("Player")

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

function PLAYER:DropItem(wep, pos, vel, time)
    if wep == NULL or not IsValid(wep) then return end
    local classname = wep:GetClass()

    local drop = ents.Create("prop_physics")
    drop:SetModel(wep:GetModel())

    -- some properties
    drop.WeaponId = classname
    drop.Type = "weapon"
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

    if time then
        CleanupItem(drop, time)
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
    drop.Type = "weapon"
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
    if ent:GetClass() == "prop_physics" and ent.Type == "weapon" then
        if not ply:KeyPressed(IN_USE) then return end
        local weaponId = ent.WeaponId
        local wep = ply:GetWeapon(weaponId)
        if IsValid(wep) then
            -- do something here?????
        else
            ply:Give(weaponId)
            local wepgive = ply:GetWeapon(weaponId)

            wepgive.PrintName = ent.Name
            
            local attachments = ent.EquippedAttachments
            if attachments then
                for slot, att in pairs(attachments) do
                    wepgive:SetAttachmentSlot(slot, att)
                end
            end

            local remaining = ent.Remaining
            if remaining then
                wepgive:SetRemaining(remaining)
            end

            wepgive:SetClip1(ent.Clip)

            RemoveItemFromCleanup(ent)
            ent:Remove()
            return false
        end
    end

    return true
end)

local le_drinks = {"consumable_liquor", "consumable_henny"}
hook.Add("DoPlayerDeath", "dropweaponondeath", function(ply, attacker, dmginfo)
    local wep = ply:GetActiveWeapon()
    local pos, ang = ply:EyePos(), ply:EyeAngles()

    local pos, vel, time = pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 60

    if wep.CanDrop then
        ply:DropItem(wep, pos, vel, time)
    end
    
    --[[
    local rand = math.random(0, 100)
    if rand < 30 then
        local drink = le_drinks[math.random(1, #le_drinks)]
        local item = ply:GetWeapon(drink)

        if IsValid(item) then
            --print("drink valid")
            ply:DropItem(drink, pos, vel, time)
        else
            --print("give drink and drop")
            local item = ply:Give(drink)

            ply:DropItem(item, pos, vel, time)
        end
    end]]
end)

concommand.Add("drop", function(ply)
    local wep = ply:GetActiveWeapon()
    local pos, ang = ply:EyePos(), ply:EyeAngles()
    if IsValid(wep) and wep.CanDrop then
        ply:DropItem(wep, pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 180)
    end
end, nil, nil, 0)