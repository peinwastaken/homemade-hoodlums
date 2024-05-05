function EFFECT:Init(effectdata)
    local pos = effectdata:GetOrigin()
    local normal = effectdata:GetNormal()
    local amount = effectdata:GetMagnitude()

    local emitter = ParticleEmitter(pos)

    local particle = emitter:Add("effects/spark", pos)

    particle:SetDieTime(math.random() * 0.2)

    particle:SetStartAlpha(255)
    particle:SetEndAlpha(0)

    particle:SetStartSize(math.random(2, 3))
    particle:SetEndSize(0)

    particle:SetStartLength(0)
    particle:SetEndLength(math.random(10, 40))

    particle:SetGravity(Vector(0, 0, -100))
    particle:SetVelocity(normal * math.random(100, 200) + VectorRand() * 80)

    particle:SetCollide(true)
    particle:SetBounce(1)

    emitter:Finish()

    local light = DynamicLight(self:EntIndex(), false)
    if light then
       light.pos = pos
       light.r = 255
       light.g = 170
       light.b = 50
       light.brightness = 0.2
       light.decay = 3500
       light.size = 128
       light.dietime = CurTime() + 0.2
    end
end

function EFFECT:Think()

end

function EFFECT:Render()

end