local PLAYER = FindMetaTable("Player")
local friendlyFire = GetConVar("hoodlum_friendlyfire")

util.AddNetworkString("SuppressPlayer")
function PLAYER:Suppress(amount)
    net.Start("SuppressPlayer")
    net.WriteFloat(amount)
    net.Send(self)
end

local suppressionMaxDist = 100

hook.Add("EntityFireBullets", "hoodlum_suppression_entityfirebullets", function(attacker, bullet)
    if not IsValid(attacker) or not attacker:IsPlayer() then return end
    local wep = attacker:GetActiveWeapon()
    if wep.Category ~= "Immersive SWEPs" then return end -- now you can shoot other weapons or something :thumbsup:
    local supp = wep:GetAttachmentEffects()["Suppressed"]
    for _,ply in player.Iterator() do
        if not friendlyFire:GetBool() and IsValid(attacker) and attacker:IsPlayer() then
            local attackerTeam = attacker:GetTeam()
            local victimTeam = ply:GetTeam()
            if attackerTeam and victimTeam and attackerTeam == victimTeam then
                continue
            end
        end
        
        local trace = util.QuickTrace(bullet.Src, bullet.Dir * 4096, attacker)

        local dist = util.DistanceToLine(bullet.Src, trace.HitPos or bullet.Src + bullet.Dir * 4096, ply:EyePos())

        if dist < suppressionMaxDist and attacker ~= ply then
            local mult = dist / suppressionMaxDist
            local amount = 1 - mult

            if supp then
                ply:Suppress(amount * 0.5 * wep.SuppressionMult)
            else
                ply:Suppress(amount * wep.SuppressionMult)
            end
        end
    end
end)
