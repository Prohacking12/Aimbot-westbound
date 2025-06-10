local GUI = {}

local AutoFarm = require(game:HttpGet("https://raw.githubusercontent.com/Prohacking12/Aimbot-westbound/refs/heads/main/Module/AutoFarmModule.lua", true))

function GUI.create(Aimbot, Visual, ESP, FastRob)
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
    title.Text = "Compound V hub"
    title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.Arcade
    title.TextScaled = true

    local tabs = {"Combate", "Visual", "Misc", "Farm"}
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

    local miscFrame = Instance.new("Frame", mainFrame)
    miscFrame.Size = UDim2.new(1, -10, 1, -70)
    miscFrame.Position = UDim2.new(0, 5, 0, 65)
    miscFrame.BackgroundTransparency = 1
    miscFrame.Visible = false

    local farmFrame = Instance.new("Frame", mainFrame)
    farmFrame.Size = UDim2.new(1, -10, 1, -70)
    farmFrame.Position = UDim2.new(0, 5, 0, 65)
    farmFrame.BackgroundTransparency = 1
    farmFrame.Visible = false

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

    local teamButton = Instance.new("TextButton", combatFrame)
    teamButton.Size = UDim2.new(0, 160, 0, 30)
    teamButton.Position = UDim2.new(0, 10, 0, 50)
    teamButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    teamButton.TextColor3 = Color3.new(1, 1, 1)
    teamButton.Font = Enum.Font.Arcade
    teamButton.TextScaled = true
    teamButton.Text = "Equipo: Outlaws"
    teamButton.MouseButton1Click:Connect(function()
        Aimbot.toggleTeam()
        teamButton.Text = "Equipo: " .. Aimbot.targetTeamName
    end)

    local lockButton = Instance.new("TextButton", combatFrame)
    lockButton.Size = UDim2.new(0, 160, 0, 30)
    lockButton.Position = UDim2.new(0, 10, 0, 90)
    lockButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    lockButton.TextColor3 = Color3.new(1, 1, 1)
    lockButton.Font = Enum.Font.Arcade
    lockButton.TextScaled = true
    lockButton.Text = "Lock: OFF"
    lockButton.MouseButton1Click:Connect(function()
        Aimbot.toggleLock()
        lockButton.Text = "Lock: " .. (Aimbot.lockedTargetPart and "ON" or "OFF")
    end)

    local aimPartButton = Instance.new("TextButton", combatFrame)
    aimPartButton.Size = UDim2.new(0, 110, 0, 30)
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

    local killAuraButton = Instance.new("TextButton", combatFrame)
    killAuraButton.Size = UDim2.new(0, 110, 0, 30)
    killAuraButton.Position = UDim2.new(0, 130, 0, 130)
    killAuraButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    killAuraButton.TextColor3 = Color3.new(1, 1, 1)
    killAuraButton.Font = Enum.Font.Arcade
    killAuraButton.TextScaled = true
    killAuraButton.Text = "KILL AURA"
    killAuraButton.MouseButton1Click:Connect(function()
        Aimbot.activateKillAura()
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

    local fastHealButton = Instance.new("TextButton", combatFrame)
    fastHealButton.Size = UDim2.new(0, 110, 0, 30)
    fastHealButton.Position = UDim2.new(0, 130, 0, 170)
    fastHealButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    fastHealButton.TextColor3 = Color3.new(1, 1, 1)
    fastHealButton.Font = Enum.Font.Arcade
    fastHealButton.TextScaled = true
    fastHealButton.Text = "FastHeal: OFF"
    fastHealButton.MouseButton1Click:Connect(function()
        if Aimbot.toggleAutoHeal then
            Aimbot.toggleAutoHeal()
            fastHealButton.Text = "FastHeal: " .. (Aimbot.autoHealEnabled and "ON" or "OFF")
        end
    end)

    local playerDistLabel = Instance.new("TextLabel", combatFrame)
    playerDistLabel.Size = UDim2.new(0, 120, 0, 25)
    playerDistLabel.Position = UDim2.new(0, 200, 0, 10)
    playerDistLabel.BackgroundTransparency = 1
    playerDistLabel.TextColor3 = Color3.new(1, 1, 1)
    playerDistLabel.Font = Enum.Font.Arcade
    playerDistLabel.TextScaled = true
    playerDistLabel.Text = "Dist Jugadores:"

    local playerDistInput = Instance.new("TextBox", combatFrame)
    playerDistInput.Size = UDim2.new(0, 60, 0, 25)
    playerDistInput.Position = UDim2.new(0, 320, 0, 10)
    playerDistInput.BackgroundColor3 = Color3.fromRGB(100, 50, 20)
    playerDistInput.TextColor3 = Color3.new(1, 1, 1)
    playerDistInput.Font = Enum.Font.Arcade
    playerDistInput.TextScaled = true
    playerDistInput.Text = tostring(Aimbot.playerMaxDistance)
    playerDistInput.ClearTextOnFocus = false
    playerDistInput.FocusLost:Connect(function()
        local val = tonumber(playerDistInput.Text)
        if val then
            Aimbot.playerMaxDistance = val
        end
    end)

    local animalDistLabel = Instance.new("TextLabel", combatFrame)
    animalDistLabel.Size = UDim2.new(0, 120, 0, 25)
    animalDistLabel.Position = UDim2.new(0, 200, 0, 40)
    animalDistLabel.BackgroundTransparency = 1
    animalDistLabel.TextColor3 = Color3.new(1, 1, 1)
    animalDistLabel.Font = Enum.Font.Arcade
    animalDistLabel.TextScaled = true
    animalDistLabel.Text = "Dist Animales:"

    local animalDistInput = Instance.new("TextBox", combatFrame)
    animalDistInput.Size = UDim2.new(0, 60, 0, 25)
    animalDistInput.Position = UDim2.new(0, 320, 0, 40)
    animalDistInput.BackgroundColor3 = Color3.fromRGB(100, 50, 20)
    animalDistInput.TextColor3 = Color3.new(1, 1, 1)
    animalDistInput.Font = Enum.Font.Arcade
    animalDistInput.TextScaled = true
    animalDistInput.Text = tostring(Aimbot.animalMaxDistance)
    animalDistInput.ClearTextOnFocus = false
    animalDistInput.FocusLost:Connect(function()
        local val = tonumber(animalDistInput.Text)
        if val then
            Aimbot.animalMaxDistance = val
        end
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

    local fastrobButton = Instance.new("TextButton", miscFrame)
    fastrobButton.Size = UDim2.new(0, 200, 0, 50)
    fastrobButton.Position = UDim2.new(0, 20, 0, 20)
    fastrobButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    fastrobButton.TextColor3 = Color3.new(1, 1, 1)
    fastrobButton.TextSize = 20
    fastrobButton.Font = Enum.Font.SourceSansBold
    fastrobButton.Text = "Activar Robo Rápido"
    fastrobButton.MouseButton1Click:Connect(function()
        if FastRob.toggle then FastRob.toggle() end
        if FastRob.Enabled then
            fastrobButton.Text = "Desactivar Robo Rápido"
        else
            fastrobButton.Text = "Activar Robo Rápido"
        end
    end)

    local farmToggleButton = Instance.new("TextButton", farmFrame)
    farmToggleButton.Size = UDim2.new(0, 160, 0, 30)
    farmToggleButton.Position = UDim2.new(0, 10, 0, 10)
    farmToggleButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    farmToggleButton.TextColor3 = Color3.new(1, 1, 1)
    farmToggleButton.Font = Enum.Font.Arcade
    farmToggleButton.TextScaled = true
    farmToggleButton.Text = "Auto Farm: OFF"

    local autoFarmEnabled = false

    farmToggleButton.MouseButton1Click:Connect(function()
        autoFarmEnabled = not autoFarmEnabled
        if autoFarmEnabled then
            farmToggleButton.Text = "Auto Farm: ON"
            farmToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            AutoFarm.Start()
        else
            farmToggleButton.Text = "Auto Farm: OFF"
            farmToggleButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
            AutoFarm.Stop()
        end
    end)

    local function switchTab(tabName)
        combatFrame.Visible = (tabName == "Combate")
        visualFrame.Visible = (tabName == "Visual")
        miscFrame.Visible = (tabName == "Misc")
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

    GUI.mainFrame = mainFrame
end

return GUI
