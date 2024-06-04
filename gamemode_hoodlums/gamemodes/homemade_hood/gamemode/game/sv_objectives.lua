local objectiveDelay, nextObjective = 1, CurTime()
local maxObjectives = CreateConVar("hoodlum_objectives_max", 3, FCVAR_NONE, "Hoodlums max objectives count. 0 to disable objectives.", 0, 100)

function KILL_EVERY_OBJECTIVE_THERE_IS_ON_RELOAD_PLEASE_THANKS()
    for _,ent in ents.Iterator() do
        if ent:GetClass() == "ent_objective" then
            ent:Remove()
        end
    end
end
KILL_EVERY_OBJECTIVE_THERE_IS_ON_RELOAD_PLEASE_THANKS()

hook.Add("Think", "spawnobjectives", function()
    --retarded loop shit, if you see this in the future change it !!!!!
    local objs = ents.FindByClass("ent_objective")
    if #objs >= maxObjectives:GetInt() then return end
    if nextObjective > CurTime() then return end
    nextObjective = CurTime() + 0.2

    local spawnpos = Vector(0, 0, 0)
    local tries = 0
    local maxtries = 30
    local navpoints = navmesh.GetAllNavAreas()
    local size = Vector(16, 16, 16)
    local offset = Vector(0, 0, 16)
    if #navpoints > 0 then
        repeat
            tries = tries + 1

            local pos = GetRandomNavPoint()
            local trace = util.TraceHull({
                start = pos + offset,
                endpos = pos + offset + Vector(0, 0, 256),
                maxs = size,
                mins = -size,
                filter = ply,
                ignoreworld = false
            })

            if not trace.Hit then
                found = true
                spawnpos = pos

                local obj = ents.Create("ent_objective")
                obj:SetPos(pos + offset)
                obj:Spawn()
            end
        until found or tries >= maxtries
    end
end)