DEFINE_BASECLASS("player_hoodlum")

local PLAYER = {}

PLAYER.WalkSpeed = 100
PLAYER.RunSpeed = 200
PLAYER.SlowWalkSpeed = 75
PLAYER.JumpPower = 201

PLAYER.Models = {
    ["demoncompany"] = {
        "models/player/demoncompany/demon 0-1.mdl"
    }
}

PLAYER.Teams = {"demoncompany"}

PLAYER.Items = {
    ["primary"] = {
        "weapon_asval",
        "weapon_mcxspear"
    },
    ["secondary"] = {
        "weapon_p320", -- cant believe i forgot this..
        "weapon_m1911",
    },
}

local function GetRandomItem(tbl)
    local count = #tbl
    local rnd = math.random(1, #tbl)

    return tbl[rnd]
end

function PLAYER:OnRespawn()
    local ply = self.Player

    ply:SetSuppressPickupNotices(true)

    ply:RemoveAllAmmo()
    ply:SetAmmo(9999, "pistol") -- temporary
    ply:Give(GetRandomItem(self.Items["primary"])):SetRandomAttachments()
    ply:Give(GetRandomItem(self.Items["secondary"])):SetRandomAttachments()
    ply:Give("weapon_hands")
    ply:Give("weapon_flashlight")
    ply:Give("consumable_cigarettes")

    local tbl = self.Models[self.Teams[math.random(1, #self.Teams)]]
    local model = GetRandomItem(tbl)
    ply:SetModel(model)

    ply:SetWalkSpeed(self.WalkSpeed)
    ply:SetRunSpeed(self.RunSpeed)
    ply:SetSlowWalkSpeed(self.SlowWalkSpeed)
    ply:SetJumpPower(self.JumpPower)
end

player_manager.RegisterClass("player_demoncompany", PLAYER, "player_hoodlum")