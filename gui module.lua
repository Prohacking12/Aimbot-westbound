local GUI = {}

function GUI.Create(LocalPlayer, CombatConfig, VisualConfig, Keybinds, callbacks)
    local UserInputService = game:GetService("UserInputService")
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

    -- Combate (igual que antes, omito por espacio)

    -- Configuración
    local waitingForKey = nil

    local function createKeybindButton(labelText, keyName, yOffset, setCallback)
        createLabel(labelText, frames["Configuración"], yOffset)
        local btn = Instance.new("TextButton", frames["Configuración"])
        btn.Size = UDim2.new(0.5, -20, 0, 25)
        btn.Position = UDim2.new(0.5, 10, 0, yOffset)
        btn.BackgroundColor3 = Color3.fromRGB(100, 50, 20)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Arcade
        btn.TextScaled = true
        btn.Text = Keybinds.CurrentKeys[keyName] or "..."
        btn.MouseButton1Click:Connect(function()
            btn.Text = "Presiona una tecla..."
            waitingForKey = function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local k = input.KeyCode.Name:upper()
                    btn.Text = k
                    setCallback(k)
                    waitingForKey = nil
                end
            end
        end)
        return btn
    end

    UserInputService.InputBegan:Connect(function(input, processed)
        if waitingForKey and not processed then
            waitingForKey(input)
        end
    end)

    createKeybindButton("Tecla Aimbot:", "Aimbot", 110, function(newKey)
        if callbacks and callbacks.setAimbotKey then
            callbacks.setAimbotKey(newKey)
        end
    end)
    createKeybindButton("Tecla ESP:", "ESP", 140, function(newKey)
        if callbacks and callbacks.setESPKey then
            callbacks.setESPKey(newKey)
        end
    end)
    createKeybindButton("Tecla GUI:", "GUI", 170, function(newKey)
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
