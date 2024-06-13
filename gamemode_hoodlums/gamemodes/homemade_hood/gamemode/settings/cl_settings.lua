local settings = {
    ["Fov"] = {
        ["Name"] = "Field of View",
        ["Type"] = "Float",
        ["Value"] = 100,
        ["ConVars"] = {"hoodlum_fov"}
    },
    ["CamSmooth"] = {
        ["Name"] = "Camera Speed",
        ["Type"] = "Float",
        ["Value"] = 8,
        ["ConVars"] = {"hoodlum_cam_smooth"},
        ["ToolTip"] = "Changes camera turn speed."
    },
    ["InvisHead"] = {
        ["Name"] = "Invisible Head",
        ["Type"] = "Bool",
        ["Value"] = true,
        ["ConVars"] = {"hoodlum_invishead"},
        ["ToolTip"] = "Makes your head small so it doesn't block the camera."
    },
    ["Taa"] = {
        ["Name"] = "Temporal Anti-Aliasing",
        ["Type"] = "Bool",
        ["Value"] = false,
        ["ConVars"] = {"cl_taa"},
        ["ToolTip"] = "Gets rid of jagged edges and shimmering."
    },
    ["Sharpen"] = {
        ["Name"] = "Sharpen",
        ["Type"] = "Float",
        ["Value"] = false,
        ["ConVars"] = {"cl_sharpen"},
        ["ToolTip"] = "Sharpen filter to mitigate loss of detail caused by TAA."
    },
    ["SwayMult"] = {
        ["Name"] = "Sway Amount",
        ["Type"] = "Float",
        ["Value"] = false,
        ["ConVars"] = {"hoodlum_weaponsway_amount"},
        ["ToolTip"] = "Weapon sway amount."
    },
    ["SwaySpeed"] = {
        ["Name"] = "Sway Speed",
        ["Type"] = "Float",
        ["Value"] = false,
        ["ConVars"] = {"hoodlum_weaponsway_speed"},
        ["ToolTip"] = "Weapon sway speed."
    },
    ["LaserColor"] = {
        ["Name"] = "Laser Color",
        ["Type"] = "Color",
        ["Color"] = Color(5, 89, 144),
        ["ConVars"] = {"hoodlum_laser_r", "hoodlum_laser_g", "hoodlum_laser_b", "hoodlum_laser_a"}
    },
}

local settingOrder = {"Fov", "CamSmooth", "InvisHead", "Taa", "Sharpen", "SwayMult", "SwaySpeed", "LaserColor"}

function OpenSettingsMenu()
    local sizeX, sizeY = 300, 425

    local mainFrame = vgui.Create("DFrame")
    mainFrame:SetPos(ScrW()/2 - sizeX/2, ScrH()/2 - sizeY/2)
    mainFrame:SetSize(sizeX, sizeY)
    mainFrame:SetTitle("Settings")
    mainFrame:SetVisible(true)
    mainFrame:SetDraggable(true)
    mainFrame:ShowCloseButton(true)
    mainFrame:MakePopup()
    mainFrame.OnClose = function()
        SaveBinds()
    end

    for i,setting in ipairs(settingOrder) do
        local y = 35 + (i - 1) * 25
        local set = settings[setting]
        local settingName = set["Name"]

        local name = vgui.Create("DLabel")
        name:SetText(settingName)
        name:SetPos(25, y)
        name:SetSize(200, 15)
        name:SetParent(mainFrame)

        if set["Type"] == "Float" then
            local slider = vgui.Create("DNumSlider", mainFrame)
            slider:SetPos(50, y + 5)
            slider:SetSize(220, 10)
            slider:SetMin(GetConVar(set["ConVars"][1]):GetMin())
            slider:SetMax(GetConVar(set["ConVars"][1]):GetMax())
            slider:SetDecimals(0)
            slider:SetConVar(set["ConVars"][1])

            if set["ToolTip"] then
                slider:SetTooltip(set["ToolTip"])
            end
        elseif set["Type"] == "Bool" then
            local bool = vgui.Create("DCheckBox", mainFrame)
            bool:SetPos(150, y + 5)
            bool:SetSize(12, 12)
            bool:SetChecked(GetConVar(set["ConVars"][1]):GetBool())

            if set["ToolTip"] then
                bool:SetTooltip(set["ToolTip"])
            end

            function bool:OnChange(state)
                if state then
                    RunConsoleCommand(set["ConVars"][1], 1)
                else
                    RunConsoleCommand(set["ConVars"][1], 0)
                end
            end
        elseif set["Type"] == "Color" then
            local mixer = vgui.Create("DColorMixer", mainFrame)
            mixer:SetPos(25, y + 25)
            mixer:SetSize(250, 150)
            mixer:SetPalette(false)
            mixer:SetAlphaBar(false)
            mixer:SetColor(set["Color"])
            mixer:SetConVarR("hoodlum_laser_r")
            mixer:SetConVarG("hoodlum_laser_g")
            mixer:SetConVarB("hoodlum_laser_b")
        end
    end
end

hook.Add("OnPlayerChat", "hoodlum_bindmenucmd", function(ply, text, teamChat, isDead)
    local lply = LocalPlayer()

    if ply ~= lply then return end

    if text == "!binds" then
        OpenBindMenu()
    elseif text == "!settings" then
        OpenSettingsMenu()
    end 
end)