local PLAYER = FindMetaTable("Player")

util.AddNetworkString("SuppressPlayer")
function PLAYER:Suppress(amount, pos)
    net.Start("SuppressPlayer")
    net.WriteFloat(amount)
    net.Send(self)
end

local suppressionMaxDist = 100

hook.Add("EntityFireBullets", "hoodlum_suppression_entityfirebullets", function(attacker, bullet)
    local wep = attacker:GetActiveWeapon()
    local supp = wep:GetAttachmentEffects()["Suppressed"]
    for _,ply in player.Iterator() do
        local trace = util.QuickTrace(bullet.Src, bullet.Dir * 4096, attacker)

        local dist = util.DistanceToLine(bullet.Src, trace.HitPos or bullet.Src + bullet.Dir * 4096, ply:EyePos())

        if dist < suppressionMaxDist and attacker ~= ply then
            local mult = dist / suppressionMaxDist
            local amount = 1 - mult

            if supp then
                ply:Suppress(amount * 0.5)
            else
                ply:Suppress(amount)
            end
        end
    end
end)