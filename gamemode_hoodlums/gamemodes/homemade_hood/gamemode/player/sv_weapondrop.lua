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
    if wep == NULL then return end
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

hook.Add("PlayerUse", "weapondrop_pickup", function(ply, ent)
    if ent:GetClass() == "prop_physics" and ent.Type == "weapon" then
        local weaponId = ent.WeaponId
        local wep = ply:GetWeapon(weaponId)
        if IsValid(wep) then -- if player already has the weapon
            -- do something here?????
        else -- if he (or she) doesnt
            ply:Give(weaponId)
            local wepgive = ply:GetWeapon(weaponId)
            
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

hook.Add("DoPlayerDeath", "dropweaponondeath", function(ply, attacker, dmginfo)
    local wep = ply:GetActiveWeapon()
    local pos, ang = ply:EyePos(), ply:EyeAngles()

    local pos, vel, time = pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 60

    ply:DropItem(wep, pos, vel, time)
    local wepClass = wep:GetClass()
    local rand = math.random(0, 100)
    if rand < 30 and wepClass ~= "consumable_liquor" then
        ply:Give("consumable_liquor")
        local liquor = ply:GetWeapon("consumable_liquor")

        if IsValid(liquor) then
            ply:DropItem(liquor, pos, vel, time)
        end
    end
end)

concommand.Add("drop", function(ply)
    local wep = ply:GetActiveWeapon()
    local pos, ang = ply:EyePos(), ply:EyeAngles()
    if IsValid(wep) and wep.CanDrop then
        ply:DropItem(wep, pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 180)
    end
end, nil, nil, 0)