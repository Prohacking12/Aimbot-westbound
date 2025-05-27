local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local screenGui, mainFrame
local toggleGuiButton, combatFrame, visualFrame, configFrame
local tabButtons = {}

local Homelander = require(script.Parent.Parent)

local function createButton(parent, text, position, size)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 160, 0, 30)
    button.Position = position or UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Arcade
    button.TextScaled = true
    button.Text = text
    button.Parent = parent
    return button
end

return {
    create = function()
        if screenGui then screenGui:Destroy() end
        
        screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
        screenGui.Name = "HomelanderGUI"
        screenGui.ResetOnSpawn = false
        
        -- Botón de toggle
        toggleGuiButton = createButton(screenGui, "★", UDim2.new(1, -50, 0, 10), UDim2.new(0, 40, 0, 40))
        toggleGuiButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        
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
        local tabs = {"Combate", "Visual", "Config"}
        local tabContainer = Instance.new("Frame", mainFrame)
        tabContainer.Size = UDim2.new(1, 0, 0, 30)
        tabContainer.Position = UDim2.new(0, 0, 0, 30)
        tabContainer.BackgroundTransparency = 1
        
        for i, tabName in ipairs(tabs) do
            local tabButton = createButton(tabContainer, tabName, UDim2.new((i-1)/#tabs, 0, 0, 0), UDim2.new(1/#tabs, -2, 1, 0))
            tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(120, 60, 30) or Color3.fromRGB(80, 40, 20)
            tabButtons[tabName] = tabButton
        end
        
        -- Frames de pestañas
        combatFrame = Instance.new("Frame", mainFrame)
        combatFrame.Size = UDim2.new(1, -10, 1, -70)
        combatFrame.Position = UDim2.new(0, 5, 0, 65)
        combatFrame.BackgroundTransparency = 1
        combatFrame.Visible = true
        
        visualFrame = Instance.new("Frame", mainFrame)
        visualFrame.Size = combatFrame.Size
        visualFrame.Position = combatFrame.Position
        visualFrame.BackgroundTransparency = 1
        visualFrame.Visible = false
        
        configFrame = Instance.new("Frame", mainFrame)
        configFrame.Size = combatFrame.Size
        configFrame.Position = combatFrame.Position
        configFrame.BackgroundTransparency = 1
        configFrame.Visible = false
        
        -- Botones de Combate
        local yOffset = 10
        createButton(combatFrame, "Aimbot: "..(Homelander.Config.Aimbot.Enabled and "ON" or "OFF"), UDim2.new(0, 10, 0, yOffset)).MouseButton1Click:Connect(function()
            Homelander.Config.Aimbot.Enabled = not Homelander.Config.Aimbot.Enabled
            self.updateButtons()
        end)
        
        yOffset = yOffset + 35
        createButton(combatFrame, "Equipo: "..Homelander.Config.Aimbot.TargetTeamName, UDim2.new(0, 10, 0, yOffset)).MouseButton1Click:Connect(function()
            Homelander.TargetSystem.switchTargetTeam()
        end)
        
        yOffset = yOffset + 35
        createButton(combatFrame, "Parte: "..(Homelander.Config.Aimbot.AimAtChest and "Pecho" or "Cabeza"), UDim2.new(0, 10, 0, yOffset)).MouseButton1Click:Connect(function()
            Homelander.Config.Aimbot.AimAtChest = not Homelander.Config.Aimbot.AimAtChest
            self.updateButtons()
        end)
        
        -- Botones de Visual
        yOffset = 10
        createButton(visualFrame, "Fullbright: "..(Homelander.Config.Visual.Fullbright and "ON" or "OFF"), UDim2.new(0, 10, 0, yOffset)).MouseButton1Click:Connect(function()
            Homelander.Visuals.toggleFullbright()
            self.updateButtons()
        end)
        
        yOffset = yOffset + 35
        createButton(visualFrame, "X-Ray: "..(Homelander.Config.Visual.Xray and "ON" or "OFF"), UDim2.new(0, 10, 0, yOffset)).MouseButton1Click:Connect(function()
            Homelander.Visuals.toggleXray()
            self.updateButtons()
        end)
        
        -- Botones de Config
        yOffset = 10
        createButton(configFrame, "AutoHeal: "..(Homelander.Config.Combat.AutoHeal and "ON" or "OFF"), UDim2.new(0, 10, 0, yOffset)).MouseButton1Click:Connect(function()
            Homelander.Combat.toggleAutoHeal()
        end)
        
        -- Conexión de eventos
        toggleGuiButton.MouseButton1Click:Connect(function()
            self.toggle()
        end)
        
        for name, button in pairs(tabButtons) do
            button.MouseButton1Click:Connect(function()
                self.switchTab(name)
            end)
        end
    end,
    
    toggle = function()
        if mainFrame then
            mainFrame.Visible = not mainFrame.Visible
        end
    end,
    
    switchTab = function(tabName)
        combatFrame.Visible = (tabName == "Combate")
        visualFrame.Visible = (tabName == "Visual")
        configFrame.Visible = (tabName == "Config")
        
        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(120, 60, 30) or Color3.fromRGB(80, 40, 20)
        end
    end,
    
    updateButtons = function()
        -- Actualizar textos de los botones según la configuración actual
        for _, child in ipairs(combatFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Text:find("Aimbot:") then
                    child.Text = "Aimbot: "..(Homelander.Config.Aimbot.Enabled and "ON" or "OFF")
                elseif child.Text:find("Equipo:") then
                    child.Text = "Equipo: "..Homelander.Config.Aimbot.TargetTeamName
                elseif child.Text:find("Parte:") then
                    child.Text = "Parte: "..(Homelander.Config.Aimbot.AimAtChest and "Pecho" or "Cabeza")
                end
            end
        end
        
        for _, child in ipairs(visualFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Text:find("Fullbright:") then
                    child.Text = "Fullbright: "..(Homelander.Config.Visual.Fullbright and "ON" or "OFF")
                elseif child.Text:find("X-Ray:") then
                    child.Text = "X-Ray: "..(Homelander.Config.Visual.Xray and "ON" or "OFF")
                end
            end
        end
    end
}