local muzzle = {
    "effects/muzzleflash1",
    "effects/muzzleflash2",
    "effects/muzzleflash3",
    "effects/muzzleflash4"
}

function EFFECT:Init(effectdata)
    local pos = effectdata:GetOrigin()
    local normal = effectdata:GetNormal()
    local amount = effectdata:GetMagnitude()

    local emitter = ParticleEmitter(pos)

    for i = 1, 1 do
        local particle = emitter:Add(table.Random(muzzle), pos)

        particle:SetDieTime(0.05)

        particle:SetStartAlpha(255)
        particle:SetEndAlpha(0)

        particle:SetStartSize(math.random(5, 7))
        particle:SetEndSize(0)

        particle:SetRoll(math.random(-180, 180))
        particle:SetRollDelta(math.random(-30, 30))

        particle:SetGravity(Vector(0, 0, 0))
        particle:SetVelocity(normal * math.random(80, 150) + VectorRand() * 10)

        particle:SetCollide(true)
        particle:SetBounce(0.2)
    end

    emitter:Finish()
end

function EFFECT:Think()

end

function EFFECT:Render()

end