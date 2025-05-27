local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")

local combat = require(script.Parent.combat)
local visuals = require(script.Parent.visuals)

local module = {}

-- Referencias de GUI
local screenGui, mainFrame
local tabButtons = {}
local combatFrame, visualFrame, configFrame

-- Botones
local toggleButton, switchButton, aimPartButton, animalButton, lockOnButton, killAuraButton
local fullbrightButton, xrayButton, espButton, autoHealButton

function module.syncButtons()
    -- Combate
    if toggleButton then toggleButton.Text = "Aimbot: " .. (combat.aimbotEnabled and "ON" or "OFF") end
    if switchButton then switchButton.Text = "Equipo: " .. combat.targetTeamName end
    if aimPartButton then aimPartButton.Text = "Parte: " .. (combat.aimAtChest and "Pecho" or "Cabeza") end
    if animalButton then animalButton.Text = "Animales: " .. (combat.animalAimbotEnabled and "ON" or "OFF") end
    if lockOnButton then lockOnButton.Text = "Lock: " .. (combat.lockedTargetPart and "ON" or "OFF") end
    -- Visual
    if fullbrightButton then fullbrightButton.Text = "Fullbright: " .. (visuals.fullbrightEnabled and "ON" or "OFF") end
    if xrayButton then xrayButton.Text = "X-Ray: " .. (visuals.xrayEnabled and "ON" or "OFF") end
    if espButton then espButton.Text = "ESP: " .. (visuals.espEnabled and "ON" or "OFF") end
    -- Config
    if autoHealButton then autoHealButton.Text = "Fastheal: " .. (combat.autoHealEnabled and "ON" or "OFF") end
end

function module.init()
    if screenGui then screenGui:Destroy() end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HomelanderGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Toggle GUI Button
    local toggleGuiButton = Instance.new("TextButton", screenGui)
    toggleGuiButton.Size = UDim2.new(0, 40, 0, 40)
    toggleGuiButton.Position = UDim2.new(1, -50, 0, 10)
    toggleGuiButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    toggleGuiButton.Text = "★"
    toggleGuiButton.TextColor3 = Color3.new(0, 0, 0)
    toggleGuiButton.Font = Enum.Font.Arcade
    toggleGuiButton.TextScaled = true

    mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 380, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 20, 10)
    mainFrame.BorderSizePixel = 2
    mainFrame.Visible = true
    mainFrame.Active = true
    mainFrame.Draggable = true

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(60, 30, 20)
    title.Text = "Homelander Script"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.Arcade
    title.TextScaled = true

    -- Tabs
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

    -- Frames de pestañas
    combatFrame = Instance.new("Frame", mainFrame)
    combatFrame.Size = UDim2.new(1, -10, 1, -70)
    combatFrame.Position = UDim2.new(0, 5, 0, 65)
    combatFrame.BackgroundTransparency = 1
    combatFrame.Visible = true

    visualFrame = Instance.new("Frame", mainFrame)
    visualFrame.Size = UDim2.new(1, -10, 1, -70)
    visualFrame.Position = UDim2.new(0, 5, 0, 65)
    visualFrame.BackgroundTransparency = 1
    visualFrame.Visible = false

    configFrame = Instance.new("Frame", mainFrame)
    configFrame.Size = UDim2.new(1, -10, 1, -70)
    configFrame.Position = UDim2.new(0, 5, 0, 65)
    configFrame.BackgroundTransparency = 1
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
    for name, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end

    -- Función para crear botones
    local function createButton(text, parent, yOffset, xOffset)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0, 160, 0, 30)
        b.Position = UDim2.new(0, xOffset or 10, 0, yOffset)
        b.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.Arcade
        b.TextScaled = true
        b.Text = text
        return b
    end

    -- Combate
    toggleButton = createButton("Aimbot: ON", combatFrame, 10)
    switchButton = createButton("Equipo: " .. combat.targetTeamName, combatFrame, 45)
    aimPartButton = createButton("Parte: Cabeza", combatFrame, 80)
    animalButton = createButton("Animales: ON", combatFrame, 115)
    lockOnButton = createButton("Lock: OFF", combatFrame, 150)
    killAuraButton = createButton("ACTIVAR KILL AURA", combatFrame, 185, 10)

    toggleButton.MouseButton1Click:Connect(function()
        combat.aimbotEnabled = not combat.aimbotEnabled
        module.syncButtons()
    end)
    switchButton.MouseButton1Click:Connect(function()
        combat.targetTeamName = (combat.targetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
        combat.lockedTargetPart = nil
        module.syncButtons()
    end)
    aimPartButton.MouseButton1Click:Connect(function()
        combat.aimAtChest = not combat.aimAtChest
        module.syncButtons()
    end)
    animalButton.MouseButton1Click:Connect(function()
        combat.animalAimbotEnabled = not combat.animalAimbotEnabled
        module.syncButtons()
    end)
    lockOnButton.MouseButton1Click:Connect(function()
        if combat.lockedTargetPart then
            combat.lockedTargetPart = nil
        else
            combat.lockedTargetPart = combat.getClosestEnemy()
        end
        module.syncButtons()
    end)
    killAuraButton.MouseButton1Click:Connect(function()
        combat.activateKillAura()
    end)

    -- Visual
    fullbrightButton = createButton("Fullbright: OFF", visualFrame, 10)
    xrayButton = createButton("X-Ray: OFF", visualFrame, 45)
    espButton = createButton("ESP: OFF", visualFrame, 80)

    fullbrightButton.MouseButton1Click:Connect(function()
        visuals.toggleFullbright()
        module.syncButtons()
    end)
    xrayButton.MouseButton1Click:Connect(function()
        visuals.toggleXray()
        module.syncButtons()
    end)
    espButton.MouseButton1Click:Connect(function()
        visuals.espEnabled = not visuals.espEnabled
        module.syncButtons()
    end)

    -- Configuración
    local function createLabel(text, parent, yOffset)
        local l = Instance.new("TextLabel", parent)
        l.Size = UDim2.new(0.5, -10, 0, 25)
        l.Position = UDim2.new(0, 10, 0, yOffset)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.new(1, 1, 1)
        l.Font = Enum.Font.Arcade
        l.TextScaled = true
        l.Text = text
        l.TextXAlignment = Enum.TextXAlignment.Left
        return l
    end

    local function createTextBox(defaultText, parent, yOffset)
        local tb = Instance.new("TextBox", parent)
        tb.Size = UDim2.new(0.5, -20, 0, 25)
        tb.Position = UDim2.new(0.5, 10, 0, yOffset)
        tb.BackgroundColor3 = Color3.fromRGB(100, 50, 20)
        tb.TextColor3 = Color3.new(1, 1, 1)
        tb.Font = Enum.Font.Arcade
        tb.TextScaled = true
        tb.Text = tostring(defaultText)
        tb.ClearTextOnFocus = false
        return tb
    end

    createLabel("Distancia Jugadores:", configFrame, 10)
    local playerDistanceInput = createTextBox(combat.playerMaxDistance, configFrame, 10)
    createLabel("Distancia Animales:", configFrame, 40)
    local animalDistanceInput = createTextBox(combat.animalMaxDistance, configFrame, 40)
    autoHealButton = createButton("Fastheal: OFF", configFrame, 70)

    playerDistanceInput.FocusLost:Connect(function()
        local val = tonumber(playerDistanceInput.Text)
        if val then
            combat.playerMaxDistance = val
        end
    end)
    animalDistanceInput.FocusLost:Connect(function()
        local val = tonumber(animalDistanceInput.Text)
        if val then
            combat.animalMaxDistance = val
        end
    end)
    autoHealButton.MouseButton1Click:Connect(function()
        combat.autoHealEnabled = not combat.autoHealEnabled
        module.syncButtons()
    end)

    -- Toggle GUI
    toggleGuiButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    -- Sincronizar botones al inicio
    module.syncButtons()
end

return module
