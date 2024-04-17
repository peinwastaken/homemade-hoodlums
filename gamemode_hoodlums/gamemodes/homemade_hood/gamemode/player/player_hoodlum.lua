DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.WalkSpeed = 100
PLAYER.RunSpeed = 200
PLAYER.SlowWalkSpeed = 75

PLAYER.Models = {
    ["bloods"] = {
        "models/player/bloodz/slow_1.mdl", 
        "models/player/bloodz/slow_2.mdl", 
        "models/player/bloodz/slow_3.mdl", 
    },
    ["crips"] = {
        "models/player/cripz/slow_1.mdl", 
        "models/player/cripz/slow_2.mdl", 
        "models/player/cripz/slow_3.mdl",
    }
}

PLAYER.Teams = {"bloods", "crips"}

PLAYER.Items = {
    ["primary"] = {
        "weapon_m4",
        "weapon_m4_new",
        "weapon_draco",
        "weapon_mpx",
        "weapon_remington700",
        "weapon_aks74u",
        "weapon_remington870",
        "weapon_uzi",
    },
    ["secondary"] = {
        "weapon_m1911",
        "weapon_glock",
        "weapon_sawedoff",
        "weapon_p320"
    },
    ["melee"] = {
        "melee_bat"
    },
    ["consumable"] = {
        "consumable_liquor"
    }
}

local function GetRandomItem(tbl)
    local count = #tbl
    local rnd = math.random(1, #tbl)

    return tbl[rnd]
end

function PLAYER:Loadout()
    -- :(
end

function PLAYER:GetAlliance()
    local ply = self.Player
    local model = ply:GetModel()

    for t, tbl in pairs(self.Models) do -- why cant i just call it team... gotta call it t instead gg
        for _,mdl in pairs(tbl) do
            if mdl == model then
                return t
            end
        end
    end

    return nil
end

function PLAYER:OnRespawn()
    local ply = self.Player

    ply:SetSuppressPickupNotices(true)

    ply:RemoveAllAmmo()
    ply:SetAmmo(9999, "pistol") -- temporary
    ply:Give(GetRandomItem(self.Items["primary"])):SetRandomAttachments()
    ply:Give(GetRandomItem(self.Items["secondary"])):SetRandomAttachments()
    ply:Give(GetRandomItem(self.Items["melee"]))
    ply:Give("weapon_hands")
    ply:Give("weapon_flashlight")

    local tbl = self.Models[self.Teams[math.random(1, #self.Teams)]]
    local model = GetRandomItem(tbl)
    ply:SetModel(model)
end

function PLAYER:SetModel()

end

player_manager.RegisterClass("player_hoodlum", PLAYER, "player_default")