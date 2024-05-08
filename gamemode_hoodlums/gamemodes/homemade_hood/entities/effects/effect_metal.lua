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

    for i = 1, 15 do
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
    end

    local flare = emitter:Add("effects/yellowflare", pos)
    flare:SetDieTime(0.1)
    
    flare:SetStartAlpha(100)
    flare:SetEndAlpha(0)

    flare:SetStartSize(math.random(20, 50))
    flare:SetEndSize(0)

    local light = DynamicLight(self:EntIndex(), false)
    if light then
       light.pos = pos
       light.r = 255
       light.g = 170
       light.b = 50
       light.brightness = 2
       light.decay = 3500
       light.size = 128
       light.dietime = CurTime() + 0.2
    end

    emitter:Finish()
end

function EFFECT:Think()

end

function EFFECT:Render()

end