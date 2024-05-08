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

local concrete = {
    "effects/fleck_cement1",
    "effects/fleck_cement2"
}

function EFFECT:Init(effectdata)
    local pos = effectdata:GetOrigin()
    local normal = effectdata:GetNormal()
    local amount = effectdata:GetMagnitude()

    local emitter = ParticleEmitter(pos)
    
    for i = 1, 5 do -- impact smoke
        local particle = emitter:Add(table.Random(smoke), pos)
        if particle then
            particle:SetDieTime(2)

            particle:SetStartAlpha(math.random(60, 90))
            particle:SetEndAlpha(0)

            particle:SetStartSize(math.random(3, 7))
            particle:SetEndSize(math.random(20, 50))

            particle:SetRoll(math.random(-180, 180))
            particle:SetRollDelta(math.random(-1, 1))

            particle:SetVelocity(normal * math.random(50, 200) + VectorRand() * 24)

            particle:SetAirResistance(120)

            particle:SetLighting(true)
        end
    end

    for i = 1, 8 do
        local particle = emitter:Add(table.Random(concrete), pos)

        particle:SetDieTime(5)

        particle:SetStartAlpha(255)
        particle:SetEndAlpha(0)

        particle:SetStartSize(math.random(1, 2))
        particle:SetEndSize(0)

        particle:SetRoll(math.random(-180, 180))
        particle:SetRollDelta(math.random(-30, 30))

        particle:SetGravity(Vector(0, 0, -500))
        particle:SetVelocity(normal * math.random(80, 150) + VectorRand() * 40)

        particle:SetCollide(true)
        particle:SetBounce(0.2)

        particle:SetLighting(true)
    end

    emitter:Finish()
end

function EFFECT:Think()

end

function EFFECT:Render()

end