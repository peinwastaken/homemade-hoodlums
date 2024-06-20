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

local shrapnel = {
    "effects/fleck_cement1",
    "effects/fleck_cement2"
}

function EFFECT:Init(effectdata)
    local pos = effectdata:GetOrigin()
    local amount = effectdata:GetMagnitude()

    local emitter = ParticleEmitter(pos)

    -- smoke circle
    local smokeAmount = 32
    for i = 1, smokeAmount do
        local particle = emitter:Add(table.Random(smoke), pos)
        if particle then
            local angle = math.rad(i * (360 / smokeAmount))
            particle:SetDieTime(8)

            particle:SetStartAlpha(math.random(50, 130))
            particle:SetEndAlpha(0)

            particle:SetStartSize(math.random(20, 50))
            particle:SetEndSize(math.random(180, 350))

            particle:SetRoll(math.random(-180, 180))
            particle:SetRollDelta(-0.1)

            local vel = Vector(math.sin(angle), - math.cos(angle), 0) * math.random(400, 1400)
            particle:SetVelocity(vel)

            particle:SetAirResistance(100)

            particle:SetLighting(true)
            particle:SetCollide(true)
        end
    end

    -- smoke puff
    for i = 1, 8 do
        local particle = emitter:Add(table.Random(smoke), pos)
        if particle then
            local angle = math.rad(i * (360 / smokeAmount))
            particle:SetDieTime(6)

            particle:SetStartAlpha(math.random(50, 130))
            particle:SetEndAlpha(0)

            particle:SetStartSize(math.random(80, 200))
            particle:SetEndSize(math.random(300, 200))

            particle:SetRoll(math.random(-180, 180))
            particle:SetRollDelta(-0.1)
            
            particle:SetVelocity(Vector(0, 0, 1) * math.random(50, 400))

            particle:SetAirResistance(60)

            particle:SetLighting(true)
            particle:SetCollide(true)
        end
    end

    -- random debris
    for i = 1, 32 do
        local particle = emitter:Add(table.Random(shrapnel), pos)
        if particle then
            particle:SetDieTime(3)

            particle:SetStartAlpha(255)
            particle:SetEndAlpha(0)

            particle:SetStartSize(math.random(3, 8))
            particle:SetEndSize(0)

            particle:SetRoll(math.random(-180, 180))

            particle:SetGravity(Vector(0, 0, -900))
            particle:SetVelocity(Vector(math.Rand(-2, 2), math.Rand(-2, 2), math.Rand(0.5, 3)) * math.random(200, 600))

            particle:SetCollide(true)
            particle:SetBounce(0.2)

            particle:SetLighting(true)
        end
    end

    -- shrapnel sparks or something???? idfk
    for i = 1, 32 do
        local particle = emitter:Add("effects/spark", pos)

        particle:SetDieTime(math.random() * 0.2)

        particle:SetStartAlpha(255)
        particle:SetEndAlpha(0)

        particle:SetStartSize(math.random(3, 8))
        particle:SetEndSize(0)

        particle:SetStartLength(0)
        particle:SetEndLength(math.random(40, 100))

        particle:SetGravity(Vector(0, 0, -100))
        particle:SetVelocity(Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(0.1, 0.6)) * math.random(800, 1600))

        particle:SetCollide(true)
        particle:SetBounce(1)
    end

    -- blast decal
    util.Decal("Scorch", pos, pos + Vector(0, 0, -5))
end

function EFFECT:Think()

end

function EFFECT:Render()

end