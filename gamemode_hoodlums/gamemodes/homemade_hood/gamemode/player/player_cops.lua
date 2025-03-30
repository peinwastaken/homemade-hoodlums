DEFINE_BASECLASS("player_hoodlum")

local PLAYER = {}

PLAYER.WalkSpeed = 100
PLAYER.RunSpeed = 200
PLAYER.SlowWalkSpeed = 75
PLAYER.JumpPower = 201

PLAYER.Models = {
    ["cops"] = {
        "models/player/cops/lapd1.mdl"
    }
}

PLAYER.Teams = {"cops"}

PLAYER.Items = {
    ["primary"] = {
        "weapon_m4",
        "weapon_remington870",
    },
    ["secondary"] = {
        "weapon_p320",
        "weapon_m1911",
        "weapon_glock"
    },
}

local weaponAtts = {
    ["weapon_glock"] = {
        ["underbarrel"] = "flashlight"
    },
    ["weapon_p320"] = {
        ["underbarrel"] = "flashlight"
    },
    ["weapon_m1911"] = {},
}

local function GetRandomItem(tbl)
    local count = #tbl
    local rnd = math.random(1, #tbl)

    return tbl[rnd]
end

function PLAYER:OnRespawn()
    local ply = self.Player

    ply:SetSuppressPickupNotices(true)

    local secondary = GetRandomItem(self.Items["secondary"])

    ply:RemoveAllAmmo()
    ply:Give(GetRandomItem(self.Items["primary"]))
    ply:Give(secondary)
    ply:Give("weapon_hands")
    ply:Give("weapon_flashlight")
    ply:Give("consumable_cigarettes")

    local wep = ply:GetWeapon(secondary)
    if IsValid(wep) then
        for k,v in pairs(weaponAtts[secondary]) do
            wep:SetAttachmentSlot(k, v)
        end
    end

    local tbl = self.Models[self.Teams[math.random(1, #self.Teams)]]
    local model = GetRandomItem(tbl)
    ply:SetModel(model)

    ply:SetWalkSpeed(self.WalkSpeed)
    ply:SetRunSpeed(self.RunSpeed)
    ply:SetSlowWalkSpeed(self.SlowWalkSpeed)
    ply:SetJumpPower(self.JumpPower)
end

player_manager.RegisterClass("player_cops", PLAYER, "player_hoodlum")