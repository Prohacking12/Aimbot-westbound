
local UI = {}
local shared
local screenGui, mainFrame
local combatFrame, visualFrame, configFrame
local tabButtons = {}

local function createElement(className, props)
    local element = Instance.new(className)
    for prop, value in pairs(props) do
        if prop ~= "Parent" then
            element[prop] = value
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
    mainFrame.Visible = not mainFrame.Visible
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

    createElement("TextButton", {
        Parent = screenGui,
        Name = "ToggleButton",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -50, 0, 10),
        BackgroundColor3 = colors.accent,
        Text = "★",
        TextColor3 = Color3.new(0, 0, 0),
        Font = Enum.Font.Arcade,
        TextSize = 24,
        ZIndex = 10,
        MouseButton1Click = function()
            UI.toggleGUI()
        end
    })

    mainFrame = createElement("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, 320, 0, 350),  -- Más compacto
        Position = UDim2.new(0.5, -160, 0.5, -175),
        BackgroundColor3 = colors.background,
        BorderSizePixel = 0,
        Visible = true,
        Active = true,
        Draggable = true
    })

    -- Título
    createElement("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = colors.header,
        Text = "HOMELANDER SCRIPT",
        TextColor3 = Color3.fromRGB(255, 50, 50),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BorderSizePixel = 0
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
            TextSize = 12,
            Name = tabName.."Tab"
        })
    end
    
    combatFrame = createElement("ScrollingFrame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -10, 1, -75),
        Position = UDim2.new(0, 5, 0, 70),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 400),
        Visible = true
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
            Text = text,
            TextWrapped = true
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
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
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
            TextSize = 12,
            Name = keyName.."KeyButton"
        })

        keyButton.MouseButton1Click:Connect(function()
            keyButton.Text = "[PRESIONA TECLA]"
            shared.Keybinds.startRebind(function(newKey)
                shared.config.keybinds[keyName] = newKey
                keyButton.Text = tostring(newKey):gsub("Enum.KeyCode.", "")

                shared.Keybinds.unbind(currentKey)
                shared.Keybinds.bind(newKey, shared.config.keybindsCallbacks[keyName])
            end)
        end)
    end

    createCompactButton("Aimbot: "..(shared.config.aimbotEnabled and "ON" or "OFF"), combatFrame, 10, function()
        shared.config.aimbotEnabled = not shared.config.aimbotEnabled
        UI.updateButtons()
    end)

    createCompactButton("Kill Aura", combatFrame, 45, function()
        shared.Combat.activateKillAura()
    end)

    createCompactButton("Lock Target", combatFrame, 80, function()
        shared.Combat.lockClosestTarget()
    end)

    createCompactButton("Equipo: "..shared.config.targetTeamName, combatFrame, 115, function()
        shared.config.targetTeamName = (shared.config.targetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
        UI.updateButtons()
    end)

    createCompactButton("Parte: "..(shared.config.aimAtChest and "Pecho" or "Cabeza"), combatFrame, 150, function()
        shared.config.aimAtChest = not shared.config.aimAtChest
        UI.updateButtons()
    end)

    createCompactButton("Animales: "..(shared.config.animalAimbotEnabled and "ON" or "OFF"), combatFrame, 185, function()
        shared.config.animalAimbotEnabled = not shared.config.animalAimbotEnabled
        UI.updateButtons()
    end)

    createCompactButton("ESP: "..(shared.config.espEnabled and "ON" or "OFF"), visualFrame, 10, function()
        shared.config.espEnabled = not shared.config.espEnabled
        shared.Visual.toggleESP(shared.config.espEnabled)
        UI.updateButtons()
    end)

    createCompactButton("X-Ray: "..(shared.config.xrayEnabled and "ON" or "OFF"), visualFrame, 45, function()
        shared.config.xrayEnabled = not shared.config.xrayEnabled
        shared.Visual.toggleXray(shared.config.xrayEnabled)
        UI.updateButtons()
    end)

    createCompactButton("Fullbright: "..(shared.config.fullbrightEnabled and "ON" or "OFF"), visualFrame, 80, function()
        shared.config.fullbrightEnabled = not shared.config.fullbrightEnabled
        shared.Visual.toggleFullbright(shared.config.fullbrightEnabled)
        UI.updateButtons()
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

    local function createDistanceControl(label, valueName, yOffset)
        local frame = createElement("Frame", {
            Parent = configFrame,
            Size = UDim2.new(1, -10, 0, 25),
            Position = UDim2.new(0, 5, 0, yOffset),
            BackgroundTransparency = 1
        })

        createElement("TextLabel", {
            Parent = frame,
            Size = UDim2.new(0.5, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = label,
            TextColor3 = colors.buttonText,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local textBox = createElement("TextBox", {
            Parent = frame,
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0.55, 0, 0, 0),
            BackgroundColor3 = colors.button,
            Text = tostring(shared.config[valueName]),
            TextColor3 = colors.buttonText,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            ClearTextOnFocus = false
        })

        textBox.FocusLost:Connect(function()
            local val = tonumber(textBox.Text)
            if val and val > 0 then
                shared.config[valueName] = val
            else
                textBox.Text = tostring(shared.config[valueName])
            end
        end)
    end

    createDistanceControl("Jugadores:", "playerMaxDistance", 35)
    createDistanceControl("Animales:", "animalMaxDistance", 65)

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
