local muzzle = {
    "effects/muzzleflash_evil/muzzleflash1",
    "effects/muzzleflash_evil/muzzleflash2",
    "effects/muzzleflash_evil/muzzleflash3",
}

function EFFECT:Init(effectdata)
    local pos = effectdata:GetOrigin()
    local normal = effectdata:GetNormal()
    local amount = effectdata:GetMagnitude()
    local ent = effectdata:GetEntity()
    local scale = effectdata:GetScale()
    local flags = effectdata:GetFlags()
    local attachment = effectdata:GetAttachment()

    local emitter = ParticleEmitter(pos)
    
    local particle = emitter:Add(table.Random(muzzle), pos)

    particle:SetDieTime(0.05)

    particle:SetStartAlpha(255)
    particle:SetEndAlpha(0)

    particle:SetStartSize(math.random(5, 7) * scale)
    particle:SetEndSize(0)

    particle:SetRoll(math.random(-180, 180))
    particle:SetRollDelta(math.random(-30, 30))

    particle:SetGravity(Vector(0, 0, 0))

    particle:SetCollide(true)
    particle:SetBounce(0.2)

    particle:SetThinkFunction(function(p)
        if not IsValid(ent) then return end
        local att = ent:GetAttachment(attachment)
        p:SetPos(att.Pos)
    end)

    emitter:Finish()

    if CLIENT then
        local light = DynamicLight(self:EntIndex(), false)
        if light then
           light.pos = pos
           light.r = 255
           light.g = 15
           light.b = 15
           light.brightness = 5
           light.decay = 5000
           light.size = 500
           light.dietime = CurTime() + 0.02
        end
    end
end

function EFFECT:Think()

end

function EFFECT:Render()

end