-- gui module.lua
local UI = {}
local shared
local screenGui, mainFrame
local combatFrame, visualFrame, configFrame
local tabButtons = {}

-- Función para crear elementos UI
local function createElement(className, props)
    local element = Instance.new(className)
    for prop, value in pairs(props) do
        if prop ~= "Parent" and prop ~= "MouseButton1Click" then
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
end

function UI.toggleGUI()
    mainFrame.Visible = not mainFrame.Visible
end

function UI.updateButtons()
    -- Implementar según necesidad
end

function UI.createGUI()
    if screenGui then screenGui:Destroy() end
    
    -- Configuración de estilo
    local colors = {
        background = Color3.fromRGB(40, 40, 40),
        header = Color3.fromRGB(30, 30, 30),
        tabActive = Color3.fromRGB(60, 60, 60),
        tabInactive = Color3.fromRGB(50, 50, 50),
        button = Color3.fromRGB(70, 70, 70),
        buttonText = Color3.new(1, 1, 1),
        accent = Color3.fromRGB(0, 120, 215)
    }

    -- Crear GUI principal
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimbotGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = shared.LocalPlayer:WaitForChild("PlayerGui")

    -- Marco principal con sistema de arrastre manual
    mainFrame = createElement("Frame", {
        Size = UDim2.new(0, 350, 0, 400),
        Position = UDim2.new(0.5, -175, 0.5, -200),
        BackgroundColor3 = colors.background,
        BorderSizePixel = 0,
        Active = true,
        Parent = screenGui
    })

    -- Sistema de arrastre
    local dragStartPos, frameStartPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStartPos = input.Position
            frameStartPos = mainFrame.Position
            game:GetService("UserInputService").MouseIconEnabled = false
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStartPos then
            local delta = input.Position - dragStartPos
            mainFrame.Position = UDim2.new(
                frameStartPos.X.Scale, 
                frameStartPos.X.Offset + delta.X,
                frameStartPos.Y.Scale,
                frameStartPos.Y.Offset + delta.Y
            )
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStartPos = nil
            game:GetService("UserInputService").MouseIconEnabled = true
        end
    end)

    -- Título
    createElement("TextLabel", {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = colors.header,
        Text = "HOMELANDER SCRIPT",
        TextColor3 = colors.buttonText,
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })

    -- Pestañas
    local tabs = {"COMBATE", "VISUAL", "CONFIG"}
    local tabContainer = createElement("Frame", {
        Parent = mainFrame,
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 35),
        BackgroundTransparency = 1
    })

    -- Crear pestañas
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

    -- Frames con scroll
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

    -- Función para cambiar pestañas
    local function switchTab(tabName)
        combatFrame.Visible = (tabName == "COMBATE")
        visualFrame.Visible = (tabName == "VISUAL")
        configFrame.Visible = (tabName == "CONFIG")
        
        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 = (name == tabName) and colors.tabActive or colors.tabInactive
        end
    end

    -- Conectar eventos de pestañas
    for name, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end

    -- Función para crear botones
    local function createButton(text, parent, yOffset, callback)
        local button = createElement("TextButton", {
            Parent = parent,
            Size = UDim2.new(0.9, 0, 0, 30),
            Position = UDim2.new(0.05, 0, 0, yOffset),
            BackgroundColor3 = colors.button,
            TextColor3 = colors.buttonText,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Text = text
        })
        
        button.MouseButton1Click:Connect(callback)
        return button
    end

    -- Función para controles de keybind
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
    createButton("Aimbot: "..(shared.config.aimbotEnabled and "ON" or "OFF"), combatFrame, 10, function()
        shared.config.aimbotEnabled = not shared.config.aimbotEnabled
        shared.saveConfig()
    end)

    createButton("Kill Aura", combatFrame, 45, function()
        shared.Combat.activateKillAura()
    end)

    createButton("Lock Target", combatFrame, 80, function()
        shared.Combat.lockClosestTarget()
    end)

    createButton("Equipo: "..shared.config.targetTeamName, combatFrame, 115, function()
        shared.config.targetTeamName = (shared.config.targetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
        shared.saveConfig()
    end)

    createButton("Parte: "..(shared.config.aimAtChest and "Pecho" or "Cabeza"), combatFrame, 150, function()
        shared.config.aimAtChest = not shared.config.aimAtChest
        shared.saveConfig()
    end)

    createButton("Animales: "..(shared.config.animalAimbotEnabled and "ON" or "OFF"), combatFrame, 185, function()
        shared.config.animalAimbotEnabled = not shared.config.animalAimbotEnabled
        shared.saveConfig()
    end)

    -- CONTENIDO DE PESTAÑA VISUAL
    createButton("ESP: "..(shared.config.espEnabled and "ON" or "OFF"), visualFrame, 10, function()
        shared.config.espEnabled = not shared.config.espEnabled
        shared.Visual.toggleESP(shared.config.espEnabled)
        shared.saveConfig()
    end)

    createButton("X-Ray: "..(shared.config.xrayEnabled and "ON" or "OFF"), visualFrame, 45, function()
        shared.config.xrayEnabled = not shared.config.xrayEnabled
        shared.Visual.toggleXray(shared.config.xrayEnabled)
        shared.saveConfig()
    end)

    createButton("Fullbright: "..(shared.config.fullbrightEnabled and "ON" or "OFF"), visualFrame, 80, function()
        shared.config.fullbrightEnabled = not shared.config.fullbrightEnabled
        shared.Visual.toggleFullbright(shared.config.fullbrightEnabled)
        shared.saveConfig()
    end)

    -- CONTENIDO DE PESTAÑA CONFIG
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

    -- Control de distancia para jugadores
    local playerDistInput = createElement("TextBox", {
        Parent = configFrame,
        Size = UDim2.new(0.9, 0, 0, 25),
        Position = UDim2.new(0.05, 0, 0, 35),
        BackgroundColor3 = colors.button,
        Text = tostring(shared.config.playerMaxDistance),
        TextColor3 = colors.buttonText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        PlaceholderText = "Distancia jugadores"
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

    -- Control de distancia para animales
    local animalDistInput = createElement("TextBox", {
        Parent = configFrame,
        Size = UDim2.new(0.9, 0, 0, 25),
        Position = UDim2.new(0.05, 0, 0, 65),
        BackgroundColor3 = colors.button,
        Text = tostring(shared.config.animalMaxDistance),
        TextColor3 = colors.buttonText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        PlaceholderText = "Distancia animales"
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

    -- Configuración de keybinds
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

    -- Seleccionar pestaña inicial
    switchTab("COMBATE")
end

return UI
