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
    local drop = ents.Create("prop_physics")
    drop:SetCreator(self)
    drop:SetModel(wep:GetModel())

    -- some properties
    drop.WeaponId = wep:GetClass()
    drop.Type = "weapon"
    drop.Attachments = wep:GetAttachments()
    drop.EquippedAttachments = wep.EquippedAttachments

    local bodygroups = wep:GetBodyGroups()
    for i,tbl in ipairs(bodygroups) do
        drop:SetBodygroup(tbl.id, wep:GetBodygroup(tbl.id)) 
    end

    -- save some variables
    drop.Clip1 = wep:Clip1()

    drop:Spawn()
    drop:Activate()

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
            wepgive:SetClip1(ent.Clip1)
            
            local attachments = ent.EquippedAttachments
            if attachments then
                for slot, att in pairs(attachments) do
                    wepgive:SetAttachmentSlot(slot, att)
                end
            end

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
    if IsValid(wep) and wep.CanDrop then
        ply:DropItem(wep, pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 60)
    end
end)

concommand.Add("drop", function(ply)
    local wep = ply:GetActiveWeapon()
    local pos, ang = ply:EyePos(), ply:EyeAngles()
    if IsValid(wep) and wep.CanDrop then
        ply:DropItem(wep, pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 180)
    end
end, nil, nil, 0)