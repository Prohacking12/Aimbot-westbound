local GUI = {}

function GUI.Create(LocalPlayer, CombatConfig, VisualConfig, Keybinds, callbacks)
    local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "AimbotGUI"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 400, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
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
    local tabButtons, frames = {}, {}

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

        local frame = Instance.new("Frame", mainFrame)
        frame.Size = UDim2.new(1, -10, 1, -70)
        frame.Position = UDim2.new(0, 5, 0, 65)
        frame.BackgroundTransparency = 1
        frame.Visible = (i==1)
        frames[tabName] = frame
    end

    local function switchTab(tabName)
        for name, frame in pairs(frames) do
            frame.Visible = (name == tabName)
            tabButtons[name].BackgroundColor3 = (name == tabName) and Color3.fromRGB(120, 60, 30) or Color3.fromRGB(80, 40, 20)
        end
    end
    for name, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end

    local function createButton(text, parent, yOffset)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0, 180, 0, 30)
        b.Position = UDim2.new(0, 10, 0, yOffset)
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
    local function createTextBox(defaultText, parent, yOffset, onChanged)
        local tb = Instance.new("TextBox", parent)
        tb.Size = UDim2.new(0.5, -20, 0, 25)
        tb.Position = UDim2.new(0.5, 10, 0, yOffset)
        tb.BackgroundColor3 = Color3.fromRGB(100, 50, 20)
        tb.TextColor3 = Color3.new(1, 1, 1)
        tb.Font = Enum.Font.Arcade
        tb.TextScaled = true
        tb.Text = tostring(defaultText)
        tb.ClearTextOnFocus = false
        if onChanged then
            tb.FocusLost:Connect(function()
                onChanged(tb.Text)
            end)
        end
        return tb
    end

    -- Combate
    local aimbotBtn = createButton("Aimbot: " .. (CombatConfig.aimbotEnabled and "ON" or "OFF"), frames["Combate"], 10)
    aimbotBtn.MouseButton1Click:Connect(function()
        CombatConfig.aimbotEnabled = not CombatConfig.aimbotEnabled
        aimbotBtn.Text = "Aimbot: " .. (CombatConfig.aimbotEnabled and "ON" or "OFF")
        if callbacks and callbacks.onAimbotToggle then callbacks.onAimbotToggle(CombatConfig.aimbotEnabled) end
    end)

    local animalBtn = createButton("Animal Aimbot: " .. (CombatConfig.animalAimbotEnabled and "ON" or "OFF"), frames["Combate"], 45)
    animalBtn.MouseButton1Click:Connect(function()
        CombatConfig.animalAimbotEnabled = not CombatConfig.animalAimbotEnabled
        animalBtn.Text = "Animal Aimbot: " .. (CombatConfig.animalAimbotEnabled and "ON" or "OFF")
    end)

    local teamBtn = createButton("Equipo: " .. CombatConfig.targetTeamName, frames["Combate"], 80)
    teamBtn.MouseButton1Click:Connect(function()
        CombatConfig.targetTeamName = (CombatConfig.targetTeamName == "Outlaws") and "Cowboys" or "Outlaws"
        teamBtn.Text = "Equipo: " .. CombatConfig.targetTeamName
    end)

    local aimPartBtn = createButton("Parte: " .. (CombatConfig.aimAtChest and "Pecho" or "Cabeza"), frames["Combate"], 115)
    aimPartBtn.MouseButton1Click:Connect(function()
        CombatConfig.aimAtChest = not CombatConfig.aimAtChest
        aimPartBtn.Text = "Parte: " .. (CombatConfig.aimAtChest and "Pecho" or "Cabeza")
    end)

    local lockBtn = createButton("Lock: OFF", frames["Combate"], 150)
    lockBtn.MouseButton1Click:Connect(function()
        CombatConfig.lockedTargetPart = CombatConfig.lockedTargetPart and nil or true
        lockBtn.Text = CombatConfig.lockedTargetPart and "Lock: ON" or "Lock: OFF"
    end)

    local killAuraBtn = createButton("KILL AURA", frames["Combate"], 185)
    killAuraBtn.MouseButton1Click:Connect(function()
        if callbacks and callbacks.onKillAura then
            callbacks.onKillAura()
        end
    end)

    -- Visual
    local fullbrightBtn = createButton("Fullbright: " .. (VisualConfig.fullbrightEnabled and "ON" or "OFF"), frames["Visual"], 10)
    fullbrightBtn.MouseButton1Click:Connect(function()
        VisualConfig.fullbrightEnabled = not VisualConfig.fullbrightEnabled
        fullbrightBtn.Text = "Fullbright: " .. (VisualConfig.fullbrightEnabled and "ON" or "OFF")
        if callbacks and callbacks.onFullbrightToggle then callbacks.onFullbrightToggle(VisualConfig.fullbrightEnabled) end
    end)

    local xrayBtn = createButton("X-Ray: " .. (VisualConfig.xrayEnabled and "ON" or "OFF"), frames["Visual"], 45)
    xrayBtn.MouseButton1Click:Connect(function()
        VisualConfig.xrayEnabled = not VisualConfig.xrayEnabled
        xrayBtn.Text = "X-Ray: " .. (VisualConfig.xrayEnabled and "ON" or "OFF")
        if callbacks and callbacks.onXRayToggle then callbacks.onXRayToggle(VisualConfig.xrayEnabled) end
    end)

    local espBtn = createButton("ESP: " .. (VisualConfig.espEnabled and "ON" or "OFF"), frames["Visual"], 80)
    espBtn.MouseButton1Click:Connect(function()
        VisualConfig.espEnabled = not VisualConfig.espEnabled
        espBtn.Text = "ESP: " .. (VisualConfig.espEnabled and "ON" or "OFF")
        if callbacks and callbacks.onESPToggle then callbacks.onESPToggle(VisualConfig.espEnabled) end
    end)

    -- Configuración
    createLabel("Distancia Jugadores:", frames["Configuración"], 10)
    local playerDistBox = createTextBox(CombatConfig.playerMaxDistance, frames["Configuración"], 10, function(val)
        CombatConfig.playerMaxDistance = tonumber(val) or CombatConfig.playerMaxDistance
    end)

    createLabel("Distancia Animales:", frames["Configuración"], 40)
    local animalDistBox = createTextBox(CombatConfig.animalMaxDistance, frames["Configuración"], 40, function(val)
        CombatConfig.animalMaxDistance = tonumber(val) or CombatConfig.animalMaxDistance
    end)

    local autoHealBtn = createButton("Auto Heal: " .. (CombatConfig.autoHealEnabled and "ON" or "OFF"), frames["Configuración"], 70)
    autoHealBtn.MouseButton1Click:Connect(function()
        CombatConfig.autoHealEnabled = not CombatConfig.autoHealEnabled
        autoHealBtn.Text = "Auto Heal: " .. (CombatConfig.autoHealEnabled and "ON" or "OFF")
    end)

    createLabel("Tecla Aimbot:", frames["Configuración"], 110)
    local aimbotKeyBox = createTextBox(Keybinds.CurrentKeys["Aimbot"] or "F", frames["Configuración"], 110, function(newKey)
        if callbacks and callbacks.setAimbotKey then
            callbacks.setAimbotKey(newKey:upper())
        end
    end)

    createLabel("Tecla ESP:", frames["Configuración"], 140)
    local espKeyBox = createTextBox(Keybinds.CurrentKeys["ESP"] or "G", frames["Configuración"], 140, function(newKey)
        if callbacks and callbacks.setESPKey then
            callbacks.setESPKey(newKey:upper())
        end
    end)

    createLabel("Tecla GUI:", frames["Configuración"], 170)
    local guiKeyBox = createTextBox(Keybinds.CurrentKeys["GUI"] or "RightControl", frames["Configuración"], 170, function(newKey)
        if callbacks and callbacks.setGUIKey then
            callbacks.setGUIKey(newKey)
        end
    end)

    local toggleGuiButton = Instance.new("TextButton", screenGui)
    toggleGuiButton.Size = UDim2.new(0, 40, 0, 40)
    toggleGuiButton.Position = UDim2.new(1, -50, 0, 10)
    toggleGuiButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    toggleGuiButton.Text = "★"
    toggleGuiButton.TextColor3 = Color3.new(0, 0, 0)
    toggleGuiButton.Font = Enum.Font.Arcade
    toggleGuiButton.TextScaled = true
    toggleGuiButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    return mainFrame
end

return GUI
