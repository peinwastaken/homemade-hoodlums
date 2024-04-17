-- retardation incoming
local PLAYER = FindMetaTable("Player")

local RagdollCleanup = {}

function PLAYER:GetRagdollCooldown()
    return timer.Exists("ragdollcooldown"..self:EntIndex())
end

concommand.Add("hoodlum_ragdolls_clear", function(ply)
    if ply:IsAdmin() then
        for _,ent in pairs(ents.GetAll()) do
            if ent:GetClass() == "prop_ragdoll" then
                ent:Remove()
            end
        end
    else
        ply:PrintMessage(HUD_PRINTCONSOLE, "sod off")
    end
end, nil, "Clear hoodlum ragdolls", FCVAR_NONE)

--[[
local RagdollHierarchy = {
    -- HEAD
    [HITGROUP_HEAD] = {
        ["ValveBiped.Bip01_Neck1"] = 1,
        ["ValveBiped.Bip01_Head1"] = 1
    },

    -- ARMS
    [HITGROUP_RIGHTARM] = {
        ["ValveBiped.Bip01_R_UpperArm"] = 1,
        ["ValveBiped.Bip01_R_Elbow"] = 2,
        ["ValveBiped.Bip01_R_Forearm"] = 2,
        ["ValveBiped.Bip01_R_Ulna"] = 2,
        ["ValveBiped.Bip01_R_Wrist"] = 3,
        ["ValveBiped.Bip01_R_Hand"] = 3,
        ["ValveBiped.Bip01_R_Finger0"] = 3,
        ["ValveBiped.Bip01_R_Finger01"] = 3,
        ["ValveBiped.Bip01_R_Finger02"] = 3,
        ["ValveBiped.Bip01_R_Finger1"] = 3,
        ["ValveBiped.Bip01_R_Finger11"] = 3,
        ["ValveBiped.Bip01_R_Finger12"] = 3,
        ["ValveBiped.Bip01_R_Finger2"] = 3,
        ["ValveBiped.Bip01_R_Finger21"] = 3,
        ["ValveBiped.Bip01_R_Finger22"] = 3,
        ["ValveBiped.Bip01_R_Finger3"] = 3,
        ["ValveBiped.Bip01_R_Finger31"] = 3,
        ["ValveBiped.Bip01_R_Finger32"] = 3,
        ["ValveBiped.Bip01_R_Finger4"] = 3,
        ["ValveBiped.Bip01_R_Finger41"] = 3,
        ["ValveBiped.Bip01_R_Finger42"] = 3,
        ["ValveBiped.Anim_Attachment_RH"] = 3
    },
    [HITGROUP_LEFTARM] = {
        ["ValveBiped.Bip01_L_UpperArm"] = 1,
        ["ValveBiped.Bip01_L_Elbow"] = 2,
        ["ValveBiped.Bip01_L_Forearm"] = 2,
        ["ValveBiped.Bip01_L_Ulna"] = 2,
        ["ValveBiped.Bip01_L_Wrist"] = 3,
        ["ValveBiped.Bip01_L_Hand"] = 3,
        ["ValveBiped.Bip01_L_Finger0"] = 3,
        ["ValveBiped.Bip01_L_Finger01"] = 3,
        ["ValveBiped.Bip01_L_Finger02"] = 3,
        ["ValveBiped.Bip01_L_Finger1"] = 3,
        ["ValveBiped.Bip01_L_Finger11"] = 3,
        ["ValveBiped.Bip01_L_Finger12"] = 3,
        ["ValveBiped.Bip01_L_Finger2"] = 3,
        ["ValveBiped.Bip01_L_Finger21"] = 3,
        ["ValveBiped.Bip01_L_Finger22"] = 3,
        ["ValveBiped.Bip01_L_Finger3"] = 3,
        ["ValveBiped.Bip01_L_Finger31"] = 3,
        ["ValveBiped.Bip01_L_Finger32"] = 3,
        ["ValveBiped.Bip01_L_Finger4"] = 3,
        ["ValveBiped.Bip01_L_Finger41"] = 3,
        ["ValveBiped.Bip01_L_Finger42"] = 3,
        ["ValveBiped.Anim_Attachment_LH"] = 3
    },

    -- LEGS
    [HITGROUP_RIGHTLEG] = {
        ["ValveBiped.Bip01_R_Thigh"] = 1,
        ["ValveBiped.Bip01_R_Calf"] = 2,
        ["ValveBiped.Bip01_R_Foot"] = 3,
        ["ValveBiped.Bip01_R_Toe0"] = 3
    },
    [HITGROUP_LEFTLEG] = {
        ["ValveBiped.Bip01_L_Thigh"] = 1,
        ["ValveBiped.Bip01_L_Calf"] = 2,
        ["ValveBiped.Bip01_L_Foot"] = 3,
        ["ValveBiped.Bip01_L_Toe0"] = 3
    }
}]]

local RagdollHitGroups = {
    ["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
    ["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
    ["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
    ["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
    ["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
    ["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
    ["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
    ["ValveBiped.Bip01_Pelvis"] = HITGROUP_STOMACH,
    ["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
    ["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
    ["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
    ["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
    ["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
    ["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
    ["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG
}

local HitgroupDamageMultiplier = {
    [HITGROUP_HEAD] = 2,
    [HITGROUP_CHEST] = 1,
    [HITGROUP_STOMACH] = 0.7,
    [HITGROUP_RIGHTARM] = 0.3,
    [HITGROUP_RIGHTLEG] = 0.3,
    [HITGROUP_LEFTARM] = 0.3,
    [HITGROUP_LEFTLEG] = 0.3
}

concommand.Add("hoodlum_ragdoll", function(ply)
    ply:ToggleRagdoll(nil)
end, false, "toggle ragdoll", FCVAR_NONE)

function PLAYER:ClearRagdoll(time)
    local ragdoll = self:GetNWEntity("ragdoll")

    if IsValid(ragdoll) then
        self:SetNWEntity("ragdoll", NULL)
        ragdoll:SetOwner(nil)
        RagdollCleanup[ragdoll] = CurTime() + time
    end
end

function PLAYER:ToggleRagdoll(hitgroup, dropweapon, lastweapon)
    local ragdoll = self:GetNWEntity("ragdoll")

    if self:GetRagdollCooldown() then return end

    if not IsValid(ragdoll) then
        local new = ents.Create("prop_ragdoll")
        new:SetOwner(self)

        -- initial shit
        new:SetModel(self:GetModel())
        new:SetHealth(self:Health())

        -- transform
        new:SetPos(self:GetPos())
        new:SetAngles(self:GetAngles())

        new:Spawn()
        
        new:Activate()

        local bonecount = new:GetBoneCount()
        for i = 0, bonecount do
            local physobj = new:TranslateBoneToPhysBone(i)
            local obj = new:GetPhysicsObjectNum(i)
            if obj then
                if IsValid(obj) then
                    local bone = new:TranslatePhysBoneToBone(i)
                    local matrix = self:GetBoneMatrix(bone)
                    local pos = self:GetBonePosition(bone)
                    local ang = matrix:GetAngles()

                    obj:SetPos(pos)
                    obj:SetAngles(ang)
                    obj:SetMass(obj:GetMass() * 10)
                    obj:SetVelocity(self:GetVelocity())
                    obj:SetBuoyancyRatio(5)
                end
            end
        end

        -- physics
        new:PhysWake()
        new:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)

        if hitgroup == HITGROUP_HEAD then
            local bone = new:LookupBone("ValveBiped.Bip01_Head1")
            new:ManipulateBoneScale(bone, Vector(0, 0, 0))

            timer.Create("bleed"..new:EntIndex(), 0.1, 50, function()
                local bonepos = new:GetBonePosition(bone)
                local boneang = new:GetBoneMatrix(bone):GetAngles()

                local rand = math.random(0, 100)
                if rand > 80 then
                    util.Decal("Blood", bonepos + Vector(math.random(-10, 10), math.random(-10, 10), 0), bonepos - Vector(0, 0, 64), new)
                end

                local effectData = EffectData()
                effectData:SetFlags(3)
                effectData:SetColor(0)
                effectData:SetScale(6)
                effectData:SetOrigin(bonepos)
                effectData:SetNormal(boneang:Forward())

                util.Effect("bloodspray", effectData, true, true)
            end)
        end

        timer.Create("ragdollcooldown"..self:EntIndex(), 2, 1, function() end)

        if dropweapon then
            local wep = self:GetActiveWeapon()
            local pos, ang = self:EyePos(), self:EyeAngles()
            if IsValid(wep) and wep.CanDrop then
                self:DropItem(wep, pos + ang:Forward() * 20 - Vector(0, 0, 10), ang:Forward() * 200, 180)
            end
        end

        if lastweapon then
            self.lastweapon = lastweapon
        else
            if IsValid(self:GetActiveWeapon()) then
                self.lastweapon = self:GetActiveWeapon():GetClass()
            end
        end
        self:SetActiveWeapon(NULL)
        self:SetNWEntity("ragdoll", new)
        self:Spectate(OBS_MODE_CHASE)
        self:Lock()
    else
        if not self:Alive() then print("not alive") return end

        self:UnSpectate()
        self:Spawn()
        self:UnLock()

        self:SetPos(ragdoll:GetPos())
        self:SetModel(ragdoll:GetModel())
        self:SetHealth(ragdoll:Health())

        if self.lastweapon then
            self:SelectWeapon(self.lastweapon)
            self.lastweapon = nil
        end

        self:ClearRagdoll(0)
    end
end

hook.Add("PlayerRespawn", "sv_hoodlum_ragdoll_playerrespawn", function(ply)
    ply:ClearRagdoll(60)
    ply:SetLastHitGroup(-1)

    ply:UnSpectate()
    ply:UnLock()
end)

hook.Add("PlayerDeath", "sv_hoodlum_ragdoll_playerdeath", function(ply, inflictor, attacker)
    local fakeragdoll = ply:GetRagdollEntity()
    local ragdoll = ply:GetNWEntity("ragdoll")

    if IsValid(fakeragdoll) then
        fakeragdoll:Remove()
    end

    if not IsValid(ragdoll) then
        local hitgroup = ply:LastHitGroup()

        ply:ToggleRagdoll(hitgroup)
    end
end)

local function getthingstodestroy(bone)
    -- convert bone to hitgroup
    local hitgroup = RagdollHitGroups[bone]

    if hitgroup and RagdollHierarchy[hitgroup] then -- if hitgroup is valid
        local bones = {}

        local priority = RagdollHierarchy[hitgroup][bone]

        for i, v in pairs(RagdollHierarchy[hitgroup]) do
            if v >= priority then
                bones[i] = v
            end
        end

        return bones
    end
    
    return {}
end

hook.Add("PostEntityTakeDamage", "aassadassa", function(ent, dmginfo, what)
    if ent:GetClass() == "prop_ragdoll" then
        local attacker = dmginfo:GetAttacker()

        if attacker:IsPlayer() then
            local owner = ent:GetOwner()
            local inflictor = dmginfo:GetInflictor()
            local wep = attacker:GetActiveWeapon()
            local dmgtype = dmginfo:GetDamageType()

            if IsValid(owner) and owner:Alive() and dmgtype == DMG_GENERIC then
                local damage = dmginfo:GetDamage()
                local health = ent:Health()

                ent:SetHealth(health - damage)

                if ent:Health() < 0 then
                    owner:Kill()
                end
            end

            if IsValid(wep) and wep.GetMuzzle then
                local start, ang = wep:GetMuzzle()
                local hitpos = dmginfo:GetDamagePosition()
                local trace = util.QuickTrace(start, ang:Forward() * 1024, player.GetAll())

                if trace.Hit then
                    --[[
                    local bone = ent:TranslatePhysBoneToBone(trace.PhysicsBone)
                    local destroylist = getthingstodestroy(ent:GetBoneName(bone))

                    local tbl = {}
                    for i,v in pairs(destroylist) do
                        table.insert(tbl, {key = i, value = v})
                    end
                    table.sort(tbl, function(a, b)
                        return a.value < b.value
                    end)

                    local bonelist = {}
                    for i,pair in ipairs(tbl) do
                        bonelist[i] = pair.key
                    end

                    for i,v in ipairs(bonelist) do
                        local b = ent:LookupBone(v)
                        ent:ManipulateBoneScale(b, Vector(0, 0, 0))
                    end]]

                    local bone = ent:TranslatePhysBoneToBone(trace.PhysicsBone)
                    local bonename = ent:GetBoneName(bone)
                    local hitgroup = RagdollHitGroups[bonename]

                    -- handle ragdoll headshot
                    if RagdollHitGroups[bonename] == HITGROUP_HEAD then
                        local head = ent:LookupBone("ValveBiped.Bip01_Head1")
                        ent:ManipulateBoneScale(head, Vector(0, 0, 0))

                        -- temp
                        if not ent.headshot then
                            ent.headshot = true

                            local owner = ent:GetOwner()
                            if IsValid(owner) and owner:Alive() then
                                owner:SetLastHitGroup(HITGROUP_HEAD)
                                owner:Kill()
                            end

                            net.Start("DeathEvent")
                            net.WriteBool(true)
                            net.Send(owner)

                            timer.Create("bleed"..ent:EntIndex(), 0.1, 50, function()
                                local bonepos = ent:GetBonePosition(head)
                                local boneang = ent:GetBoneMatrix(head):GetAngles()
                            
                                local rand = math.random(0, 100)
                                if rand > 80 then
                                    util.Decal("Blood", bonepos + Vector(math.random(-10, 10), math.random(-10, 10), 0), bonepos - Vector(0, 0, 64), new)
                                end
                            
                                local effectData = EffectData()
                                effectData:SetFlags(3)
                                effectData:SetColor(0)
                                effectData:SetScale(6)
                                effectData:SetOrigin(bonepos)
                                effectData:SetNormal(boneang:Forward())
                            
                                util.Effect("bloodspray", effectData, true, true)
                            end)

                            return
                        end 
                    end

                    local owner = ent:GetOwner()
                    if IsValid(owner) and owner:Alive() then
                        if HitgroupDamageMultiplier[hitgroup] then
                            local damage = dmginfo:GetDamage()
                            local health = ent:Health()
                            local mult = HitgroupDamageMultiplier[hitgroup]

                            ent:SetHealth(health - damage)

                            if ent:Health() < 0 then
                                owner:Kill()
                            end
                        end
                    end
                end
            end
        else -- if not player
            local owner = ent:GetOwner()
            if not IsValid(owner) or not owner:Alive() then return false end
            local health = ent:Health()

            if dmginfo:GetDamageType() == DMG_CRUSH then
                dmginfo:ScaleDamage(0.5)
            end

            local damage = dmginfo:GetDamage()

            local newhealth = health - damage

            ent:SetHealth(newhealth)

            if newhealth < 0 then
                owner:Kill()
            end
        end
    end
end)

hook.Add("Think", "hoodlum_preragdollthink", function()
    for _,ply in player.Iterator() do
        local ragdoll = ply:GetNWEntity("ragdoll")
        if IsValid(ragdoll) then continue end
        
        --[[
        if ply:GetVelocity():Length() > 500 then
            ply:ToggleRagdoll()
        end]]
    end
end)

hook.Add("Think", "sv_hoodlum_ragdoll_cleanup", function()
    local time = CurTime()

    for ragdoll,cleanuptime in pairs(RagdollCleanup) do
        if IsValid(ragdoll) and cleanuptime < time then
            ragdoll:Remove()
            RagdollCleanup[ragdoll] = nil
        end
    end
end)