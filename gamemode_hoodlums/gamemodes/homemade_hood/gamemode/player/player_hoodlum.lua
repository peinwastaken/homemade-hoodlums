DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.WalkSpeed = 100
PLAYER.RunSpeed = 200
PLAYER.SlowWalkSpeed = 75

PLAYER.Models = {
    "models/player/bloodz/slow_1.mdl", 
    "models/player/bloodz/slow_2.mdl", 
    "models/player/bloodz/slow_3.mdl", 
    "models/player/cripz/slow_1.mdl", 
    "models/player/cripz/slow_2.mdl", 
    "models/player/cripz/slow_3.mdl", 
}

PLAYER.Items = {
    ["primary"] = {
        "weapon_m4",
        "weapon_m4_new",
        "weapon_draco",
        "weapon_mpx",
        "weapon_remington700",
        "weapon_aks74u"
    },
    ["secondary"] = {
        "weapon_m1911",
        "weapon_glock",
        "weapon_sawedoff",
        "weapon_p320"
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
    ply:Give("weapon_hands")
end

function PLAYER:SetModel()
    local ply = self.Player

    ply:SetModel(self.Models[math.random(1, #self.Models)])
end

player_manager.RegisterClass("player_hoodlum", PLAYER, "player_default")