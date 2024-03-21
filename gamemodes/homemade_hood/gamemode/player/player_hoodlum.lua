DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.WalkSpeed = 100
PLAYER.RunSpeed = 200
PLAYER.SlowWalkSpeed = 75

PLAYER.Models = {"models/player/Group03/female_01.mdl"}

PLAYER.Items = {
    ["primary"] = {
        "weapon_m4",
        "weapon_aks74u"
    },
    ["secondary"] = {
        "weapon_m1911",
        "weapon_glock"
    }
}

local function GetRandomItem(tbl)
    local count = #tbl
    local rnd = math.random(1, #tbl)

    return tbl[rnd]
end

function PLAYER:Loadout()
    local ply = self.Player

    ply:RemoveAllAmmo()
    ply:Give(GetRandomItem(self.Items["primary"]))
    ply:Give(GetRandomItem(self.Items["secondary"]))
end

function PLAYER:SetModel()
    local ply = self.Player
    local selected = self.Models[math.random(1, #self.Models)]

    ply:SetModel(selected)
end

player_manager.RegisterClass("player_hoodlum", PLAYER, "player_default")