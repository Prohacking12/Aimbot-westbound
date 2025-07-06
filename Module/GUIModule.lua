local GUI = {}

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
    mainFrame.Size = UDim2.new(0, 380, 0, 330) -- altura ajustada para botón extra
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -165)
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

    local tabs = {"Combate", "Visual", "Misc"}
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
    combatFrame.Size = UDim2.new(1, -10, 1, -90)
    combatFrame.Position = UDim2.new(0, 5, 0, 65)
    combatFrame.BackgroundTransparency = 1
    combatFrame.Visible = true

    local visualFrame = Instance.new("Frame", mainFrame)
    visualFrame.Size = UDim2.new(1, -10, 1, -90)
    visualFrame.Position = UDim2.new(0, 5, 0, 65)
    visualFrame.BackgroundTransparency = 1
    visualFrame.Visible = false

    local miscFrame = Instance.new("Frame", mainFrame)
    miscFrame.Size = UDim2.new(1, -10, 1, -90)
    miscFrame.Position = UDim2.new(0, 5, 0, 65)
    miscFrame.BackgroundTransparency = 1
    miscFrame.Visible = false

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

    local allPlayersButton = Instance.new("TextButton", combatFrame)
    allPlayersButton.Size = UDim2.new(0, 160, 0, 30)
    allPlayersButton.Position = UDim2.new(0, 10, 0, 170)
    allPlayersButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    allPlayersButton.TextColor3 = Color3.new(1, 1, 1)
    allPlayersButton.Font = Enum.Font.Arcade
    allPlayersButton.TextScaled = true
    allPlayersButton.Text = "All Players: OFF"
    allPlayersButton.MouseButton1Click:Connect(function()
        Aimbot.toggleAimAllPlayers()
        allPlayersButton.Text = "All Players: " .. (Aimbot.aimAllPlayers and "ON" or "OFF")
    end)

    local killAuraButton = Instance.new("TextButton", combatFrame)
    killAuraButton.Size = UDim2.new(0, 110, 0, 30)
    killAuraButton.Position = UDim2.new(0, 180, 0, 130)
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
    animalButton.Position = UDim2.new(0, 180, 0, 170)
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
    fastHealButton.Position = UDim2.new(0, 180, 0, 210)
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

    local function switchTab(tabName)
        combatFrame.Visible = (tabName == "Combate")
        visualFrame.Visible = (tabName == "Visual")
        miscFrame.Visible = (tabName == "Misc")
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
