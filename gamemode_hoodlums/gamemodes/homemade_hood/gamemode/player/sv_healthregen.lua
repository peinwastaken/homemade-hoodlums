hook.Add("EntityTakeDamage", "resethealthtime", function(ent, dmginfo)
    if ent:IsPlayer() and ent:Alive() then
        ent:SetNWFloat("LastDamage", CurTime())
    end
end)

hook.Add("Think", "healthregen", function()
    for _,ply in player.Iterator() do
        local lastdamage = ply:GetNWFloat("LastDamage", 0)
        local lastheal = ply:GetNWFloat("LastHeal", 0)

        local timesincedamage = CurTime() - lastdamage
        local timesinceheal = CurTime() - lastheal

        if timesincedamage > 5 and timesinceheal > 0.5 and ply:Health() < ply:GetMaxHealth() and ply:Alive() then
            local health = math.min(ply:Health() + 1, 100)
            ply:SetHealth(health)
            ply:SetNWFloat("LastHeal", CurTime())
        end
    end
end)