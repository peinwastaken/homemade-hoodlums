local PLAYER = FindMetaTable("Player")

util.AddNetworkString("SuppressPlayer")
function PLAYER:Suppress(amount, pos)
    net.Start("SuppressPlayer")
    net.WriteFloat(amount)
    net.Send(self)
end

local suppressionMaxDist = 100

hook.Add("EntityFireBullets", "hoodlum_suppression_entityfirebullets", function(attacker, bullet)
    for _,ply in player.Iterator() do
        local trace = util.QuickTrace(bullet.Src, bullet.Dir * 1024, attacker)

        local dist = util.DistanceToLine(bullet.Src, trace.HitPos or bullet.Src + bullet.Dir * 1024, ply:EyePos())

        if dist < suppressionMaxDist and attacker ~= ply then
            local mult = dist / suppressionMaxDist
            local amount = 1 - mult

            ply:Suppress(amount)
        end
    end
end)