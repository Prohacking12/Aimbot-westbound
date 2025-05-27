local GUI = {}

function GUI.create(Aimbot, Visual, ESP)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "AimbotGUI"
    screenGui.ResetOnSpawn = false

    local toggleGuiButton = Instance.new("TextButton", screenGui)
    toggleGuiButton.Size = UDim2.new(0, 40, 0, 40)
    toggleGuiButton.Position = UDim2.new(1, -50, 0, 10)
    toggleGuiButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    toggleGuiButton.Text = "★"
    toggleGuiButton.TextColor3 = Color3.new(0, 0, 0)
    toggleGuiButton.Font = Enum.Font.Arcade
    toggleGuiButton.TextScaled = true

    local mainFrame = Instance.new("Frame", screenGui)
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

    local tabs = {"Combate", "Visual", "Configuración"}
    local tabContainer = Instance.new("Frame", mainFrame)
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundTransparency = 1
    local tabButtons = {}

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

    local combatFrame = Instance.new("Frame", mainFrame)
    combatFrame.Size = UDim2.new(1, -10, 1, -70)
    combatFrame.Position = UDim2.new(0, 5, 0, 65)
    combatFrame.BackgroundTransparency = 1
    combatFrame.Visible = true

    local visualFrame = Instance.new("Frame", mainFrame)
    visualFrame.Size = UDim2.new(1, -10, 1, -70)
    visualFrame.Position = UDim2.new(0, 5, 0, 65)
    visualFrame.BackgroundTransparency = 1
    visualFrame.Visible = false

    local configFrame = Instance.new("Frame", mainFrame)
    configFrame.Size = UDim2.new(1, -10, 1, -70)
    configFrame.Position = UDim2.new(0, 5, 0, 65)
    configFrame.BackgroundTransparency = 1
    configFrame.Visible = false

    -- Helpers
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

    -- Combate
    local toggleButton = createButton("Aimbot: ON", combatFrame, 10)
    local switchButton = createButton("Equipo: " .. (Aimbot.targetTeamName or "Outlaws"), combatFrame, 45)
    local aimPartButton = createButton("Parte: Cabeza", combatFrame, 80)
    local animalButton = createButton("Animales: ON", combatFrame, 115)
    local lockOnButton = createButton("Lock: OFF", combatFrame, 150)
    local killAuraButton = createButton("ACTIVAR KILL AURA", combatFrame, 185, 10)

    toggleButton.MouseButton1Click:Connect(function()
        if Aimbot.toggleAimbot then Aimbot.toggleAimbot() end
        toggleButton.Text = "Aimbot: " .. (Aimbot.aimbotEnabled and "ON" or "OFF")
    end)
    switchButton.MouseButton1Click:Connect(function()
        if Aimbot.toggleTeam then Aimbot.toggleTeam() end
        switchButton.Text = "Equipo: " .. (Aimbot.targetTeamName or "Outlaws")
        lockOnButton.Text = "Lock: OFF"
    end)
    aimPartButton.MouseButton1Click:Connect(function()
        if Aimbot.toggleAimPart then Aimbot.toggleAimPart() end
        aimPartButton.Text = "Parte: " .. (Aimbot.aimAtChest and "Pecho" or "Cabeza")
    end)
    animalButton.MouseButton1Click:Connect(function()
        if Aimbot.toggleAnimalAimbot then Aimbot.toggleAnimalAimbot() end
        animalButton.Text = "Animales: " .. (Aimbot.animalAimbotEnabled and "ON" or "OFF")
    end)
    lockOnButton.MouseButton1Click:Connect(function()
        if Aimbot.toggleLock then Aimbot.toggleLock() end
        lockOnButton.Text = "Lock: " .. (Aimbot.lockedTargetPart and "ON" or "OFF")
    end)
    killAuraButton.MouseButton1Click:Connect(function()
        if Aimbot.activateKillAura then Aimbot.activateKillAura() end
    end)

    -- Visual
    local fullbrightButton = createButton("Fullbright: OFF", visualFrame, 10)
    local xrayButton = createButton("X-Ray: OFF", visualFrame, 45)
    local espButton = createButton("ESP: OFF", visualFrame, 80)

    fullbrightButton.MouseButton1Click:Connect(function()
        if Visual.toggleFullbright then Visual.toggleFullbright() end
        fullbrightButton.Text = Visual.fullbrightEnabled and "Fullbright: ON" or "Fullbright: OFF"
    end)
    xrayButton.MouseButton1Click:Connect(function()
        if Visual.toggleXray then Visual.toggleXray() end
        xrayButton.Text = Visual.xrayEnabled and "X-Ray: ON" or "X-Ray: OFF"
    end)
    espButton.MouseButton1Click:Connect(function()
        if ESP.toggleESP then ESP.toggleESP() end
        espButton.Text = ESP.espEnabled and "ESP: ON" or "ESP: OFF"
    end)

    -- Configuración
    createLabel("Distancia Jugadores:", configFrame, 10)
    local playerDistanceInput = createTextBox(Aimbot.playerMaxDistance, configFrame, 10)
    createLabel("Distancia Animales:", configFrame, 40)
    local animalDistanceInput = createTextBox(Aimbot.animalMaxDistance, configFrame, 40)
    local autoHealButton = createButton("FastHeal: " .. (Aimbot.autoHealEnabled and "ON" or "OFF"), configFrame, 70)

    playerDistanceInput.FocusLost:Connect(function()
        local val = tonumber(playerDistanceInput.Text)
        if val then
            Aimbot.playerMaxDistance = val
        end
    end)
    animalDistanceInput.FocusLost:Connect(function()
        local val = tonumber(animalDistanceInput.Text)
        if val then
            Aimbot.animalMaxDistance = val
        end
    end)
    autoHealButton.MouseButton1Click:Connect(function()
        if Aimbot.toggleAutoHeal then
            Aimbot.toggleAutoHeal()
            autoHealButton.Text = "FastHeal: " .. (Aimbot.autoHealEnabled and "ON" or "OFF")
        end
    end)

    -- Tabs
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

    toggleGuiButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    GUI.mainFrame = mainFrame
end

return GUI
