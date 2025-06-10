local GUI = {}
function GUI.create(Aimbot, Visual, ESP, AutoFarm)
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

    local tabs = {"Combate", "Visual", "Configuración", "Farm"}
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

    local farmFrame = Instance.new("Frame", mainFrame)
    farmFrame.Size = UDim2.new(1, -10, 1, -70)
    farmFrame.Position = UDim2.new(0, 5, 0, 65)
    farmFrame.BackgroundTransparency = 1
    farmFrame.Visible = false

    local function switchTab(tabName)
        combatFrame.Visible = (tabName == "Combate")
        visualFrame.Visible = (tabName == "Visual")
        configFrame.Visible = (tabName == "Configuración")
        farmFrame.Visible = (tabName == "Farm")
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

    local toggleButton = Instance.new("TextButton", combatFrame)
    toggleButton.Size = UDim2.new(0, 160, 0, 30)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    toggleButton.TextColor3 = Color3.new(1, 1, 1)
    toggleButton.Font = Enum.Font.Arcade
    toggleButton.TextScaled = true
    toggleButton.Text = "Aimbot: ON"
    toggleButton.MouseButton1Click:Connect(function()
        Aimbot.toggleAimbot()
        toggleButton.Text = "Aimbot: " .. (Aimbot.aimbotEnabled and "ON" or "OFF")
    end)

    local lockButton = Instance.new("TextButton", combatFrame)
    lockButton.Size = UDim2.new(0, 160, 0, 30)
    lockButton.Position = UDim2.new(0, 10, 0, 50)
    lockButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    lockButton.TextColor3 = Color3.new(1, 1, 1)
    lockButton.Font = Enum.Font.Arcade
    lockButton.TextScaled = true
    lockButton.Text = "Lock: OFF"
    lockButton.MouseButton1Click:Connect(function()
        Aimbot.toggleLock()
        lockButton.Text = "Lock: " .. (Aimbot.lockedTargetPart and "ON" or "OFF")
    end)

    local teamButton = Instance.new("TextButton", combatFrame)
    teamButton.Size = UDim2.new(0, 160, 0, 30)
    teamButton.Position = UDim2.new(0, 10, 0, 90)
    teamButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    teamButton.TextColor3 = Color3.new(1, 1, 1)
    teamButton.Font = Enum.Font.Arcade
    teamButton.TextScaled = true
    teamButton.Text = "Equipo: Outlaws"
    teamButton.MouseButton1Click:Connect(function()
        Aimbot.toggleTeam()
        teamButton.Text = "Equipo: " .. Aimbot.targetTeamName
    end)

    local aimPartButton = Instance.new("TextButton", combatFrame)
    aimPartButton.Size = UDim2.new(0, 160, 0, 30)
    aimPartButton.Position = UDim2.new(0, 10, 0, 130)
    aimPartButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    aimPartButton.TextColor3 = Color3.new(1, 1, 1)
    aimPartButton.Font = Enum.Font.Arcade
    aimPartButton.TextScaled = true
    aimPartButton.Text = "Parte: Cabeza"
    aimPartButton.MouseButton1Click:Connect(function()
        Aimbot.toggleAimPart()
        aimPartButton.Text = "Parte: " .. (Aimbot.aimAtChest and "Pecho" or "Cabeza")
    end)

    local animalButton = Instance.new("TextButton", combatFrame)
    animalButton.Size = UDim2.new(0, 160, 0, 30)
    animalButton.Position = UDim2.new(0, 10, 0, 170)
    animalButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    animalButton.TextColor3 = Color3.new(1, 1, 1)
    animalButton.Font = Enum.Font.Arcade
    animalButton.TextScaled = true
    animalButton.Text = "Animales: ON"
    animalButton.MouseButton1Click:Connect(function()
        Aimbot.toggleAnimalAimbot()
        animalButton.Text = "Animales: " .. (Aimbot.animalAimbotEnabled and "ON" or "OFF")
    end)

    local killAuraButton = Instance.new("TextButton", combatFrame)
    killAuraButton.Size = UDim2.new(0, 160, 0, 30)
    killAuraButton.Position = UDim2.new(0, 10, 0, 210)
    killAuraButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    killAuraButton.TextColor3 = Color3.new(1, 1, 1)
    killAuraButton.Font = Enum.Font.Arcade
    killAuraButton.TextScaled = true
    killAuraButton.Text = "ACTIVAR KILL AURA"
    killAuraButton.MouseButton1Click:Connect(function()
        Aimbot.activateKillAura()
    end)

    local fullbrightButton = Instance.new("TextButton", visualFrame)
    fullbrightButton.Size = UDim2.new(0, 160, 0, 30)
    fullbrightButton.Position = UDim2.new(0, 10, 0, 10)
    fullbrightButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    fullbrightButton.TextColor3 = Color3.new(1, 1, 1)
    fullbrightButton.Font = Enum.Font.Arcade
    fullbrightButton.TextScaled = true
    fullbrightButton.Text = "Fullbright: OFF"
    fullbrightButton.MouseButton1Click:Connect(function()
        Visual.toggleFullbright()
        fullbrightButton.Text = Visual.fullbrightEnabled and "Fullbright: ON" or "Fullbright: OFF"
    end)

    local xrayButton = Instance.new("TextButton", visualFrame)
    xrayButton.Size = UDim2.new(0, 160, 0, 30)
    xrayButton.Position = UDim2.new(0, 10, 0, 50)
    xrayButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    xrayButton.TextColor3 = Color3.new(1, 1, 1)
    xrayButton.Font = Enum.Font.Arcade
    xrayButton.TextScaled = true
    xrayButton.Text = "X-Ray: OFF"
    xrayButton.MouseButton1Click:Connect(function()
        Visual.toggleXray()
        xrayButton.Text = Visual.xrayEnabled and "X-Ray: ON" or "X-Ray: OFF"
    end)

    local espButton = Instance.new("TextButton", visualFrame)
    espButton.Size = UDim2.new(0, 160, 0, 30)
    espButton.Position = UDim2.new(0, 10, 0, 90)
    espButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    espButton.TextColor3 = Color3.new(1, 1, 1)
    espButton.Font = Enum.Font.Arcade
    espButton.TextScaled = true
    espButton.Text = "ESP: OFF"
    espButton.MouseButton1Click:Connect(function()
        ESP.toggleESP()
        espButton.Text = ESP.espEnabled and "ESP: ON" or "ESP: OFF"
    end)

    local playerDistLabel = Instance.new("TextLabel", configFrame)
    playerDistLabel.Size = UDim2.new(0, 200, 0, 20)
    playerDistLabel.Position = UDim2.new(0, 10, 0, 10)
    playerDistLabel.BackgroundTransparency = 1
    playerDistLabel.TextColor3 = Color3.new(1, 1, 1)
    playerDistLabel.Font = Enum.Font.Arcade
    playerDistLabel.TextScaled = true
    playerDistLabel.Text = "Distancia jugadores:"

    local playerDistInput = Instance.new("TextBox", configFrame)
    playerDistInput.Size = UDim2.new(0, 200, 0, 20)
    playerDistInput.Position = UDim2.new(0, 10, 0, 35)
    playerDistInput.BackgroundColor3 = Color3.fromRGB(80, 40, 20)
    playerDistInput.TextColor3 = Color3.new(1, 1, 1)
    playerDistInput.Font = Enum.Font.Arcade
    playerDistInput.TextScaled = true
    playerDistInput.Text = tostring(Aimbot.maxDistance or 200)
    playerDistInput.FocusLost:Connect(function(enter)
        if enter then
            local input = tonumber(playerDistInput.Text)
            if input then
                Aimbot.maxDistance = input
                playerDistInput.Text = tostring(Aimbot.maxDistance)
            else
                playerDistInput.Text = tostring(Aimbot.maxDistance)
            end
        end
    end)

    local animalDistLabel = Instance.new("TextLabel", configFrame)
    animalDistLabel.Size = UDim2.new(0, 200, 0, 20)
    animalDistLabel.Position = UDim2.new(0, 10, 0, 65)
    animalDistLabel.BackgroundTransparency = 1
    animalDistLabel.TextColor3 = Color3.new(1, 1, 1)
    animalDistLabel.Font = Enum.Font.Arcade
    animalDistLabel.TextScaled = true
    animalDistLabel.Text = "Distancia animales:"

    local animalDistInput = Instance.new("TextBox", configFrame)
    animalDistInput.Size = UDim2.new(0, 200, 0, 20)
    animalDistInput.Position = UDim2.new(0, 10, 0, 90)
    animalDistInput.BackgroundColor3 = Color3.fromRGB(80, 40, 20)
    animalDistInput.TextColor3 = Color3.new(1, 1, 1)
    animalDistInput.Font = Enum.Font.Arcade
    animalDistInput.TextScaled = true
    animalDistInput.Text = tostring(Aimbot.maxAnimalDistance or 200)
    animalDistInput.FocusLost:Connect(function(enter)
        if enter then
            local input = tonumber(animalDistInput.Text)
            if input then
                Aimbot.maxAnimalDistance = input
                animalDistInput.Text = tostring(Aimbot.maxAnimalDistance)
            else
                animalDistInput.Text = tostring(Aimbot.maxAnimalDistance)
            end
        end
    end)

    local healButton = Instance.new("TextButton", configFrame)
    healButton.Size = UDim2.new(0, 200, 0, 30)
    healButton.Position = UDim2.new(0, 10, 0, 120)
    healButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    healButton.TextColor3 = Color3.new(1, 1, 1)
    healButton.Font = Enum.Font.Arcade
    healButton.TextScaled = true
    healButton.Text = "FAST HEAL"
    healButton.MouseButton1Click:Connect(function()
        if Aimbot.fastHeal then
            Aimbot.fastHeal()
        end
    end)

    local farmToggle = Instance.new("TextButton", farmFrame)
    farmToggle.Size = UDim2.new(0, 200, 0, 40)
    farmToggle.Position = UDim2.new(0, 10, 0, 10)
    farmToggle.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    farmToggle.TextColor3 = Color3.new(1, 1, 1)
    farmToggle.Font = Enum.Font.Arcade
    farmToggle.TextScaled = true
    farmToggle.Text = "AutoFarm: OFF"

    local farmEnabled = false
    farmToggle.MouseButton1Click:Connect(function()
        farmEnabled = not farmEnabled
        if farmEnabled then
            if AutoFarm.notify then AutoFarm.notify() end
            if AutoFarm.start then AutoFarm.start() end
            farmToggle.Text = "AutoFarm: ON"
            farmToggle.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
        else
            if AutoFarm.stop then AutoFarm.stop() end
            farmToggle.Text = "AutoFarm: OFF"
            farmToggle.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
        end
    end)

    GUI.mainFrame = mainFrame
end
return GUI
