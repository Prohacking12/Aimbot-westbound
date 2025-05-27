-- gui module.lua
local UI = {}
local shared
local screenGui, mainFrame
local combatFrame, visualFrame, configFrame
local tabButtons = {}

function UI.init(sharedState)
    shared = sharedState
    UI.createGUI()
end

function UI.toggleGUI()
    mainFrame.Visible = not mainFrame.Visible
end

function UI.updateButtons()
    -- Esta función actualizará todos los botones según la configuración actual
    -- La implementaremos después de crear los botones
end

function UI.createGUI()
    if screenGui then screenGui:Destroy() end
    
    -- Crear la GUI principal
    screenGui = Instance.new("ScreenGui", shared.LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "AimbotGUI"
    screenGui.ResetOnSpawn = false

    -- Botón de toggle
    local toggleGuiButton = Instance.new("TextButton", screenGui)
    toggleGuiButton.Size = UDim2.new(0, 40, 0, 40)
    toggleGuiButton.Position = UDim2.new(1, -50, 0, 10)
    toggleGuiButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    toggleGuiButton.Text = "★"
    toggleGuiButton.TextColor3 = Color3.new(0, 0, 0)
    toggleGuiButton.Font = Enum.Font.Arcade
    toggleGuiButton.TextScaled = true
    toggleGuiButton.MouseButton1Click:Connect(UI.toggleGUI)

    -- Marco principal
    mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 380, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 10)
    mainFrame.BorderSizePixel = 2
    mainFrame.Visible = true
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Título
    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(60, 30, 20)
    title.Text = "Homelander Script"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.Arcade
    title.TextScaled = true

    -- Pestañas
    local tabs = {"Combate", "Visual", "Configuración"}
    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundTransparency = 1

    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton", tabContainer)
        tabButton.Size = UDim2.new(1/#tabs, -2, 1, 0)
        tabButton.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(80, 40, 20)
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Font = Enum.Font.Arcade
        tabButton.Text = tabName
        tabButton.TextScaled = true
        tabButtons[tabName] = tabButton
    end

    -- Frames de contenido
    combatFrame = Instance.new("ScrollingFrame", mainFrame)
    combatFrame.Size = UDim2.new(1, -10, 1, -70)
    combatFrame.Position = UDim2.new(0, 5, 0, 65)
    combatFrame.BackgroundTransparency = 1
    combatFrame.ScrollBarThickness = 5
    combatFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- Permite scroll
    combatFrame.Visible = true

    visualFrame = Instance.new("ScrollingFrame", mainFrame)
    visualFrame.Size = UDim2.new(1, -10, 1, -70)
    visualFrame.Position = UDim2.new(0, 5, 0, 65)
    visualFrame.BackgroundTransparency = 1
    visualFrame.ScrollBarThickness = 5
    visualFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    visualFrame.Visible = false

    configFrame = Instance.new("ScrollingFrame", mainFrame)
    configFrame.Size = UDim2.new(1, -10, 1, -70)
    configFrame.Position = UDim2.new(0, 5, 0, 65)
    configFrame.BackgroundTransparency = 1
    configFrame.ScrollBarThickness = 5
    configFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    configFrame.Visible = false

    -- Función para cambiar pestañas
    local function switchTab(tabName)
        combatFrame.Visible = (tabName == "Combate")
        visualFrame.Visible = (tabName == "Visual")
        configFrame.Visible = (tabName == "Configuración")
        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(120, 60, 30) or Color3.fromRGB(80, 40, 20)
        end
    end

    -- Conectar botones de pestañas
    for name, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end

    -- Crear todos los botones necesarios
    local yOffset = 10
    local buttonHeight = 30
    local buttonSpacing = 5

    -- Botones de Combate
    UI.createButton("Aimbot: "..(shared.config.aimbotEnabled and "ON" or "OFF"), combatFrame, yOffset, function()
        shared.config.aimbotEnabled = not shared.config.aimbotEnabled
        UI.updateButtons()
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("Equipo: "..shared.config.targetTeamName, combatFrame, yOffset, function()
        shared.config.targetTeamName = (shared.config.targetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
        UI.updateButtons()
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("Parte: "..(shared.config.aimAtChest and "Pecho" or "Cabeza"), combatFrame, yOffset, function()
        shared.config.aimAtChest = not shared.config.aimAtChest
        UI.updateButtons()
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("Animales: "..(shared.config.animalAimbotEnabled and "ON" or "OFF"), combatFrame, yOffset, function()
        shared.config.animalAimbotEnabled = not shared.config.animalAimbotEnabled
        UI.updateButtons()
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("Lock: OFF", combatFrame, yOffset, function()
        if shared.Combat.lockClosestTarget then
            shared.Combat.lockClosestTarget()
            UI.updateButtons()
        end
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("ACTIVAR KILL AURA", combatFrame, yOffset, function()
        if shared.Combat.activateKillAura then
            shared.Combat.activateKillAura()
        end
    end)

    -- Botones Visuales
    yOffset = 10
    UI.createButton("Fullbright: "..(shared.config.fullbrightEnabled and "ON" or "OFF"), visualFrame, yOffset, function()
        shared.config.fullbrightEnabled = not shared.config.fullbrightEnabled
        if shared.Visual.toggleFullbright then
            shared.Visual.toggleFullbright(shared.config.fullbrightEnabled)
        end
        UI.updateButtons()
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("X-Ray: "..(shared.config.xrayEnabled and "ON" or "OFF"), visualFrame, yOffset, function()
        shared.config.xrayEnabled = not shared.config.xrayEnabled
        if shared.Visual.toggleXray then
            shared.Visual.toggleXray(shared.config.xrayEnabled)
        end
        UI.updateButtons()
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("ESP: "..(shared.config.espEnabled and "ON" or "OFF"), visualFrame, yOffset, function()
        shared.config.espEnabled = not shared.config.espEnabled
        if shared.Visual.toggleESP then
            shared.Visual.toggleESP(shared.config.espEnabled)
        end
        UI.updateButtons()
    end)

    -- Configuración
    yOffset = 10
    UI.createLabel("Distancia Jugadores:", configFrame, yOffset)
    local playerDistInput = UI.createTextBox(shared.config.playerMaxDistance, configFrame, yOffset)
    playerDistInput.FocusLost:Connect(function()
        local val = tonumber(playerDistInput.Text)
        if val and val > 0 then
            shared.config.playerMaxDistance = val
        else
            playerDistInput.Text = tostring(shared.config.playerMaxDistance)
        end
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createLabel("Distancia Animales:", configFrame, yOffset)
    local animalDistInput = UI.createTextBox(shared.config.animalMaxDistance, configFrame, yOffset)
    animalDistInput.FocusLost:Connect(function()
        local val = tonumber(animalDistInput.Text)
        if val and val > 0 then
            shared.config.animalMaxDistance = val
        else
            animalDistInput.Text = tostring(shared.config.animalMaxDistance)
        end
    end)
    yOffset = yOffset + buttonHeight + buttonSpacing

    UI.createButton("AutoHeal: "..(shared.config.autoHealEnabled and "ON" or "OFF"), configFrame, yOffset, function()
        shared.config.autoHealEnabled = not shared.config.autoHealEnabled
        UI.updateButtons()
    end)

    -- Seleccionar pestaña inicial
    switchTab("Combate")
end

-- Función para crear botones
function UI.createButton(text, parent, yOffset, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, yOffset)
    button.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Arcade
    button.TextScaled = true
    button.Text = text
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Función para crear labels
function UI.createLabel(text, parent, yOffset)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0.4, 0, 0, 25)
    label.Position = UDim2.new(0.05, 0, 0, yOffset)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Arcade
    label.TextScaled = true
    label.Text = text
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Función para crear textboxes
function UI.createTextBox(defaultText, parent, yOffset)
    local textBox = Instance.new("TextBox", parent)
    textBox.Size = UDim2.new(0.4, 0, 0, 25)
    textBox.Position = UDim2.new(0.5, 0, 0, yOffset)
    textBox.BackgroundColor3 = Color3.fromRGB(100, 50, 20)
    textBox.TextColor3 = Color3.new(1, 1, 1)
    textBox.Font = Enum.Font.Arcade
    textBox.TextScaled = true
    textBox.Text = tostring(defaultText)
    textBox.ClearTextOnFocus = false
    return textBox
end

return UI
