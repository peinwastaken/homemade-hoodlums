local PLAYER = FindMetaTable("Player")

PropagationTable = {
    ["Head"] = {
        ["Torso"] = 0.2
    },
    ["Torso"] = {
        ["Head"] = 0.1,
        ["RightArm"] = 0.4,
        ["LeftArm"] = 0.4,
        ["RightLeg"] = 0.4,
        ["LeftLeg"] = 0.4,
    },
    ["RightArm"] = {
        ["Head"] = 0.2,
        ["Torso"] = 0.4,
        ["LeftArm"] = 0.2,
        ["RightLeg"] = 0.2,
        ["LeftLeg"] = 0.2,
    },
    ["LeftArm"] = {
        ["Head"] = 0.2,
        ["Torso"] = 0.4,
        ["RightArm"] = 0.2,
        ["RightLeg"] = 0.2,
        ["LeftLeg"] = 0.2,
    },
    ["RightLeg"] = {
        ["Head"] = 0.2,
        ["Torso"] = 0.4,
        ["RightArm"] = 0.2,
        ["LeftArm"] = 0.2,
        ["LeftLeg"] = 0.2,
    },
    ["LeftLeg"] = {
        ["Head"] = 0.2,
        ["Torso"] = 0.4,
        ["RightArm"] = 0.2,
        ["LeftArm"] = 0.2,
        ["RightLeg"] = 0.2,
    }
}

defaultLimbHealth = {
    ["Head"] = 40,
    ["Torso"] = 150,
    ["RightArm"] = 60,
    ["LeftArm"] = 60,
    ["RightLeg"] = 50,
    ["LeftLeg"] = 50,
}

LimbBrokenHealth = {
    ["Head"] = 0,
    ["Torso"] = 0,
    ["RightArm"] = 3,
    ["LeftArm"] = 3,
    ["RightLeg"] = 5,
    ["LeftLeg"] = 5,
}

BoneToHitGroup = {
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

HitGroupToLimb = {
    [HITGROUP_HEAD] = "Head",
    [HITGROUP_CHEST] = "Torso",
    [HITGROUP_STOMACH] = "Torso",
    [HITGROUP_RIGHTARM] = "RightArm",
    [HITGROUP_LEFTARM] = "LeftArm",
    [HITGROUP_RIGHTLEG] = "RightLeg",
    [HITGROUP_LEFTLEG] = "LeftLeg"
}

function PLAYER:GetLimbData()
    return self.LimbData
end

function PLAYER:GetLimb(limb)
    return self.LimbData[limb]
end

function PLAYER:GetTotalLimbHealth()
    local limbData = self:GetLimbData()

    local totalHealth = 0
    for _,health in pairs(limbData) do
        totalHealth = totalHealth + health
    end

    return totalHealth
end

function PLAYER:LimbBroken(limb)
    return self:GetLimb(limb) < LimbBrokenHealth[limb]
end

hook.Add("SetupMove", "limbhealth_setupmove", function(ply, mv, cmd)
    local limbData = ply:GetLimbData()
    local alcohol = ply:GetAlcohol()

    if not limbData then return end

    if (limbData.RightLeg < LimbBrokenHealth["RightLeg"] or limbData.LeftLeg < LimbBrokenHealth["LeftLeg"]) and alcohol < 0.3 then
        local maxSpeed = ply:GetMaxSpeed()
        mv:SetMaxClientSpeed(maxSpeed * 0.5)
    end
end)

if CLIENT then
    hook.Add("StartCommand", "limbhealth_startcommand", function(ply, cmd)
        local lply = LocalPlayer()
        local limbData = lply:GetLimbData()
        local alcohol = lply:GetAlcohol()

        if not limbData then return end

        if (limbData.RightArm < LimbBrokenHealth["RightArm"] or limbData.LeftArm < LimbBrokenHealth["LeftArm"]) and alcohol < 0.3 then
            local viewangles = cmd:GetViewAngles()

            local shakeAmt = 0.1
            local shakeX = math.Rand(-shakeAmt, shakeAmt)
            local shakeY = math.Rand(-shakeAmt, shakeAmt) * 1.5

            local shakeasd = math.sin(SysTime()) * FrameTime()

            local aimlerp = math.Clamp(GetAimLerp() + 0.5, 0, 1)

            cmd:SetViewAngles(viewangles + Angle(shakeX + shakeasd, -shakeY - shakeasd, 0) * aimlerp)
        end
    end)
end
