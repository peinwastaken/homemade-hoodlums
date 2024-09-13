local binds = {
    ["Ragdoll"] = {
        ["Name"] = "Ragdoll",
        ["Command"] = "hoodlum_ragdoll",
        ["Key"] = 0
    },
    ["Laser"] = {
        ["Name"] = "Laser",
        ["Command"] = "hoodlum_laser_toggle",
        ["Key"] = 0
    },
    ["Flashlight"] = {
        ["Name"] = "Flashlight",
        ["Command"] = "hoodlum_flashlight_toggle",
        ["Key"] = 0
    },
    ["Drop"] = {
        ["Name"] = "Drop",
        ["Command"] = "drop",
        ["Key"] = 0
    },
    ["Zoom"] = {
        ["Name"] = "Scope Zoom",
        ["Command"] = "hoodlum_scope_zoom",
        ["Key"] = 0
    },
}
local bindOrder = {"Ragdoll", "Laser", "Flashlight", "Drop", "Zoom"}

function SaveBinds()
    local bindTable = util.TableToJSON(binds)

    file.CreateDir("hoodlums")
    file.Write("hoodlums/binds.json", bindTable)
end

function LoadBinds()
    local lply = LocalPlayer()
    local bindJson = file.Read("hoodlums/binds.json", nil)

    if bindJson then
        local tbl = util.JSONToTable(bindJson)

        for bind,info in pairs(tbl) do
            if binds[bind] then
                binds[bind] = info
            end
        end
    else
        chat.AddText("Binds not found, set them with !binds or through the console")
    end
end

LoadBinds()

function OpenBindMenu()
    local sizeX, sizeY = 200, 275

    local mainFrame = vgui.Create("DFrame")
    mainFrame:SetPos(ScrW()/2 - sizeX/2, ScrH()/2 - sizeY/2)
    mainFrame:SetSize(sizeX, sizeY)
    mainFrame:SetTitle("Keybinds")
    mainFrame:SetVisible(true)
    mainFrame:SetDraggable(true)
    mainFrame:ShowCloseButton(true)
    mainFrame:MakePopup()
    mainFrame.OnClose = function()
        SaveBinds()
    end

    local clearLabel = vgui.Create("DLabel")
    clearLabel:SetText("press 'Delete' to clear bind")
    clearLabel:SetSize(sizeX, 15)
    local x, y = clearLabel:GetTextSize()
    clearLabel:SetPos(sizeX/2 - x/2, sizeY - 30)
    clearLabel:SetParent(mainFrame)

    --[[ ill figure it out later. yeah... later...
    local grid = vgui.Create("DGrid", mainFrame, "BindGrid")
    grid:SetPos(0, 75)
    grid:SetSize(sizeX, 500)
    grid:SetColWide(sizeX)
    grid:SetCols(1)
    grid.Paint = function()
        draw.RoundedBox(0, 0, 0, 200, 500, Color(134, 134, 134))
    end]]

    for i,bind in ipairs(bindOrder) do
        local y = 35 + (i - 1) * 40
        local bindName = binds[bind]["Name"]

        local name = vgui.Create("DLabel")
        name:SetText(bindName)
        name:SetPos(15, y)
        name:SetParent(mainFrame)

        local button = vgui.Create("DBinder")
        button:SetSize(100, 25)
        button:SetPos(85, y)
        button:SetParent(mainFrame)
        if binds[bind] then
            button:SetSelectedNumber(binds[bind]["Key"])
        else
            button:SetSelectedNumber(0)
        end

        function button:OnChange(newBind)
            if newBind == 73 then 
                binds[bindName]["Key"] = 0
                button:SetSelectedNumber(0)
                return 
            end

            binds[bindName]["Key"] = newBind
        end
    end
end

-- Divine! just kidding, retarded
hook.Add("PlayerButtonDown", "hoodlum_keybinds", function(ply, key)
    if CLIENT then
        if vgui.CursorVisible() then return end

        if IsFirstTimePredicted() then
            -- retarded loop
            for _,bind in pairs(binds) do
                if bind["Key"] == key then
                    RunConsoleCommand(bind["Command"])
                end
            end
        end
    end
end)