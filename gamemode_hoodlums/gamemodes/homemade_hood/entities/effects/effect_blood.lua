local smoke = {
    "particle/smokesprites_0001",
    "particle/smokesprites_0002",
    "particle/smokesprites_0003",
    "particle/smokesprites_0004",
    "particle/smokesprites_0005",
    "particle/smokesprites_0006",
    "particle/smokesprites_0007",
    "particle/smokesprites_0008",
    "particle/smokesprites_0009"
}

function EFFECT:Init(effectdata)
    local pos = effectdata:GetOrigin()
    local normal = effectdata:GetNormal()
    local amount = effectdata:GetMagnitude()

    local emitter = ParticleEmitter(pos)
    
    for i = 1, 5 do
        local particle = emitter:Add(table.Random(smoke), pos)
        if particle then
            particle:SetDieTime(1)

            particle:SetColor(100, 0, 0)

            particle:SetStartAlpha(math.random(30, 60))
            particle:SetEndAlpha(0)

            particle:SetStartSize(math.random(3, 7))
            particle:SetEndSize(math.random(10, 20))

            particle:SetRoll(math.random(-180, 180))
            particle:SetRollDelta(math.random(-1, 1))

            particle:SetGravity(Vector(0, 0, -40))
            particle:SetVelocity(normal * math.random(10, 50) + VectorRand() * 24)

            particle:SetAirResistance(100)

            particle:SetLighting(true)
        end
    end

    emitter:Finish()
end

function EFFECT:Think()

end

function EFFECT:Render()

end