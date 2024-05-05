local effectlist = {
    [MAT_METAL] = "effect_metal",
    [MAT_CONCRETE] = "effect_concrete",
    [MAT_WOOD] = "effect_wood",
    [MAT_GLASS] = "effect_glass",
    [MAT_FLESH] = "effect_blood"
}

function CreateImpactEffect(pos, normal, mat)
    local data = EffectData()
    data:SetOrigin(pos)
    data:SetNormal(normal)

    if mat == MAT_DEFAULT then return end

    if effectlist[mat] then
        util.Effect(effectlist[mat], data)
    else
        util.Effect("effect_concrete", data)
    end
end

hook.Add("PostEntityFireBullets", "postfire_effect", function(ent, data)
    local trace = data.Trace
    local pos, normal, mat = trace.HitPos, trace.HitNormal, trace.MatType

    CreateImpactEffect(pos, normal, mat)
end) 