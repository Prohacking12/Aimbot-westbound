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
    -- Actualiza los botones según la configuración
end

function UI.updateLockButton(locked)
    -- Actualiza el botón de lock
end

function UI.createGUI()
    if screenGui then screenGui:Destroy() end
    screenGui = Instance.new("ScreenGui", shared.LocalPlayer:WaitForChild("PlayerGui"))
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
    toggleGuiButton.MouseButton1Click:Connect(UI.toggleGUI)

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

    -- Botones de Combate
    local toggleButton = UI.createButton("Aimbot: " .. (shared.config.aimbotEnabled and "ON" or "OFF"), combatFrame, 10)
    toggleButton.MouseButton1Click:Connect(function()
        shared.config.aimbotEnabled = not shared.config.aimbotEnabled
        toggleButton.Text = "Aimbot: " .. (shared.config.aimbotEnabled and "ON" or "OFF")
    end)

    -- ... (resto de la interfaz como en tu código original)
end

function UI.createButton(text, parent, yOffset, xOffset)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0, 160, 0, 30)
    button.Position = UDim2.new(0, xOffset or 10, 0, yOffset)
    button.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Arcade
    button.TextScaled = true
    button.Text = text
    return button
end

return UI
