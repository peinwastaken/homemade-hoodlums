local glass = {
    "effects/fleck_glass1",
    "effects/fleck_glass2",
    "effects/fleck_glass3"
}

function EFFECT:Init(effectdata)
    local pos = effectdata:GetOrigin()
    local normal = effectdata:GetNormal()
    local amount = effectdata:GetMagnitude()

    local emitter = ParticleEmitter(pos)

    for i = 1, 7 do
        local particle = emitter:Add(table.Random(glass), pos)

        particle:SetDieTime(5)

        particle:SetStartAlpha(100)
        particle:SetEndAlpha(0)

        particle:SetStartSize(math.random(1, 2))
        particle:SetEndSize(0)

        particle:SetRoll(math.random(-180, 180))
        particle:SetRollDelta(math.random(-30, 30))

        particle:SetGravity(Vector(0, 0, -500))
        particle:SetVelocity(normal * math.random(30, 150) + VectorRand() * 40)

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