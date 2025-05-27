local UI = {}
local shared
local screenGui, mainFrame
local combatFrame, visualFrame, configFrame
local tabButtons = {}

local function createElement(className, props)
    local element = Instance.new(className)
    for prop, value in pairs(props) do
        if prop ~= "Parent" and prop ~= "MouseButton1Click" then
            if pcall(function() return element[prop] end) then
                element[prop] = value
            end
        end
    end
    
    if props.Parent then
        element.Parent = props.Parent
    end
    
    return element
end

function UI.init(sharedState)
    shared = sharedState
    UI.createGUI()
end

function UI.toggleGUI()
    if mainFrame then
        mainFrame.Visible = not mainFrame.Visible
    end
end

function UI.updateButtons()
    
end

function UI.createGUI()
    if screenGui then screenGui:Destroy() end
    
    
    local colors = {
        background = Color3.fromRGB(40, 20, 10),
        header = Color3.fromRGB(60, 30, 20),
        tabActive = Color3.fromRGB(120, 60, 30),
        tabInactive = Color3.fromRGB(80, 40, 20),
        button = Color3.fromRGB(139, 69, 19),
        buttonText = Color3.new(1, 1, 1),
        accent = Color3.fromRGB(255, 215, 0)
    }

    
    screenGui = createElement("ScreenGui", {
        Parent = shared.LocalPlayer:WaitForChild("PlayerGui"),
        Name = "AimbotGUI",
        ResetOnSpawn = false
    })

    
    local toggleButton = createElement("TextButton", {
        Parent = screenGui,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -50, 0, 10),
        BackgroundColor3 = colors.accent,
        Text = "★",
        TextColor3 = Color3.new(0, 0, 0),
        Font = Enum.Font.Arcade,
        TextSize = 24
    })
    toggleButton.MouseButton1Click:Connect(UI.toggleGUI)

    
    mainFrame = createElement("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, 320, 0, 350),
        Position = UDim2.new(0.5, -160, 0.5, -175),
        BackgroundColor3 = colors.background,
        BorderSizePixel = 0
    })


    createElement("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = colors.header,
        Text = "HOMELANDER SCRIPT",
        TextColor3 = Color3.fromRGB(255, 50, 50),
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })


    local tabs = {"COMBATE", "VISUAL", "CONFIG"}
    local tabContainer = createElement("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 35),
        BackgroundTransparency = 1
    })

    
    for i, tabName in ipairs(tabs) do
        tabButtons[tabName] = createElement("TextButton", {
            Parent = tabContainer,
            Size = UDim2.new(1/#tabs, -4, 1, 0),
            Position = UDim2.new((i-1)/#tabs, 0, 0, 0),
            BackgroundColor3 = i == 1 and colors.tabActive or colors.tabInactive,
            Text = tabName,
            TextColor3 = colors.buttonText,
            Font = Enum.Font.Gotham,
            TextSize = 12
        })
    end

    
    combatFrame = createElement("ScrollingFrame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -10, 1, -75),
        Position = UDim2.new(0, 5, 0, 70),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 400)
    })

    visualFrame = createElement("ScrollingFrame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -10, 1, -75),
        Position = UDim2.new(0, 5, 0, 70),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 200),
        Visible = false
    })

    configFrame = createElement("ScrollingFrame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -10, 1, -75),
        Position = UDim2.new(0, 5, 0, 70),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 300),
        Visible = false
    })

    local function switchTab(tabName)
        combatFrame.Visible = (tabName == "COMBATE")
        visualFrame.Visible = (tabName == "VISUAL")
        configFrame.Visible = (tabName == "CONFIG")
        
        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 = (name == tabName) and colors.tabActive or colors.tabInactive
        end
    end


    for name, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end
    

    local function createCompactButton(text, parent, yOffset, callback)
        local button = createElement("TextButton", {
            Parent = parent,
            Size = UDim2.new(0.48, 0, 0, 28),
            Position = UDim2.new(0, 5, 0, yOffset),
            BackgroundColor3 = colors.button,
            TextColor3 = colors.buttonText,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Text = text
        })
        
        button.MouseButton1Click:Connect(callback)
        return button
    end

    local function createKeybindControl(name, keyName, currentKey, parent, yOffset)
        local frame = createElement("Frame", {
            Parent = parent,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, yOffset),
            BackgroundTransparency = 1
        })

        createElement("TextLabel", {
            Parent = frame,
            Size = UDim2.new(0.6, 0, 1, 0),
            Text = name,
            TextColor3 = colors.buttonText,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local keyButton = createElement("TextButton", {
            Parent = frame,
            Size = UDim2.new(0.35, 0, 1, 0),
            Position = UDim2.new(0.6, 0, 0, 0),
            BackgroundColor3 = colors.button,
            Text = tostring(currentKey):gsub("Enum.KeyCode.", ""),
            TextColor3 = colors.buttonText,
            Font = Enum.Font.Gotham,
            TextSize = 12
        })

        keyButton.MouseButton1Click:Connect(function()
            keyButton.Text = "[PRESIONA TECLA]"
            shared.Keybinds.startRebind(function(newKey)
                shared.config.keybinds[keyName] = newKey
                keyButton.Text = tostring(newKey):gsub("Enum.KeyCode.", "")
                shared.Keybinds.unbind(currentKey)
                shared.Keybinds.bind(newKey, shared.config.keybindsCallbacks[keyName])
                shared.saveConfig()
            end)
        end)
    end

    -- CONTENIDO DE PESTAÑA COMBATE
    createCompactButton("Aimbot: "..(shared.config.aimbotEnabled and "ON" or "OFF"), combatFrame, 10, function()
        shared.config.aimbotEnabled = not shared.config.aimbotEnabled
        shared.saveConfig()
    end)

    createCompactButton("Kill Aura", combatFrame, 45, function()
        if shared.Combat.activateKillAura then
            shared.Combat.activateKillAura()
        end
    end)

    createCompactButton("Lock Target", combatFrame, 80, function()
        if shared.Combat.lockClosestTarget then
            shared.Combat.lockClosestTarget()
        end
    end)

    createCompactButton("Equipo: "..shared.config.targetTeamName, combatFrame, 115, function()
        shared.config.targetTeamName = (shared.config.targetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
        shared.saveConfig()
    end)

    createCompactButton("Parte: "..(shared.config.aimAtChest and "Pecho" or "Cabeza"), combatFrame, 150, function()
        shared.config.aimAtChest = not shared.config.aimAtChest
        shared.saveConfig()
    end)

    createCompactButton("Animales: "..(shared.config.animalAimbotEnabled and "ON" or "OFF"), combatFrame, 185, function()
        shared.config.animalAimbotEnabled = not shared.config.animalAimbotEnabled
        shared.saveConfig()
    end)


    createCompactButton("ESP: "..(shared.config.espEnabled and "ON" or "OFF"), visualFrame, 10, function()
        shared.config.espEnabled = not shared.config.espEnabled
        if shared.Visual.toggleESP then
            shared.Visual.toggleESP(shared.config.espEnabled)
        end
        shared.saveConfig()
    end)

    createCompactButton("X-Ray: "..(shared.config.xrayEnabled and "ON" or "OFF"), visualFrame, 45, function()
        shared.config.xrayEnabled = not shared.config.xrayEnabled
        if shared.Visual.toggleXray then
            shared.Visual.toggleXray(shared.config.xrayEnabled)
        end
        shared.saveConfig()
    end)

    createCompactButton("Fullbright: "..(shared.config.fullbrightEnabled and "ON" or "OFF"), visualFrame, 80, function()
        shared.config.fullbrightEnabled = not shared.config.fullbrightEnabled
        if shared.Visual.toggleFullbright then
            shared.Visual.toggleFullbright(shared.config.fullbrightEnabled)
        end
        shared.saveConfig()
    end)

    
    createElement("TextLabel", {
        Parent = configFrame,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 10),
        BackgroundTransparency = 1,
        Text = "DISTANCIAS:",
        TextColor3 = colors.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    
    local playerDistFrame = createElement("Frame", {
        Parent = configFrame,
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 5, 0, 35),
        BackgroundTransparency = 1
    })

    createElement("TextLabel", {
        Parent = playerDistFrame,
        Size = UDim2.new(0.5, 0, 1, 0),
        Text = "Jugadores:",
        TextColor3 = colors.buttonText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local playerDistInput = createElement("TextBox", {
        Parent = playerDistFrame,
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0.55, 0, 0, 0),
        BackgroundColor3 = colors.button,
        Text = tostring(shared.config.playerMaxDistance),
        TextColor3 = colors.buttonText,
        Font = Enum.Font.Gotham,
        TextSize = 12
    })

    playerDistInput.FocusLost:Connect(function()
        local val = tonumber(playerDistInput.Text)
        if val and val > 0 then
            shared.config.playerMaxDistance = val
            shared.saveConfig()
        else
            playerDistInput.Text = tostring(shared.config.playerMaxDistance)
        end
    end)

    
    local animalDistFrame = createElement("Frame", {
        Parent = configFrame,
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 5, 0, 65),
        BackgroundTransparency = 1
    })

    createElement("TextLabel", {
        Parent = animalDistFrame,
        Size = UDim2.new(0.5, 0, 1, 0),
        Text = "Animales:",
        TextColor3 = colors.buttonText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local animalDistInput = createElement("TextBox", {
        Parent = animalDistFrame,
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0.55, 0, 0, 0),
        BackgroundColor3 = colors.button,
        Text = tostring(shared.config.animalMaxDistance),
        TextColor3 = colors.buttonText,
        Font = Enum.Font.Gotham,
        TextSize = 12
    })

    animalDistInput.FocusLost:Connect(function()
        local val = tonumber(animalDistInput.Text)
        if val and val > 0 then
            shared.config.animalMaxDistance = val
            shared.saveConfig()
        else
            animalDistInput.Text = tostring(shared.config.animalMaxDistance)
        end
    end)


    createElement("TextLabel", {
        Parent = configFrame,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 100),
        BackgroundTransparency = 1,
        Text = "TECLAS:",
        TextColor3 = colors.accent,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    createKeybindControl("Mostrar Menú", "toggleMenu", shared.config.keybinds.toggleMenu, configFrame, 130)
    createKeybindControl("Aimbot", "toggleAimbot", shared.config.keybinds.toggleAimbot, configFrame, 165)
    createKeybindControl("ESP", "toggleESP", shared.config.keybinds.toggleESP, configFrame, 200)
    createKeybindControl("X-Ray", "toggleXray", shared.config.keybinds.toggleXray, configFrame, 235)
    createKeybindControl("Lock Target", "lockTarget", shared.config.keybinds.lockTarget, configFrame, 270)

    
    switchTab("COMBATE")
end

return UI
