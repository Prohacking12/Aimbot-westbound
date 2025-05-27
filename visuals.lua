local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local indicatorCircle
local espFolder = Instance.new("Folder", workspace)
espFolder.Name = "ESP_Objects"
local ESPs = {}

local Homelander = require(script.Parent.Parent)

return {
    createIndicator = function()
        if indicatorCircle then indicatorCircle:Destroy() end
        indicatorCircle = Instance.new("BillboardGui")
        indicatorCircle.Name = "AimbotIndicator"
        indicatorCircle.Adornee = nil
        indicatorCircle.Size = UDim2.new(0, 40, 0, 40)
        indicatorCircle.AlwaysOnTop = true
        
        local circle = Instance.new("ImageLabel")
        circle.Size = UDim2.new(1, 0, 1, 0)
        circle.BackgroundTransparency = 1
        circle.Image = "rbxassetid://3570695787"
        circle.ImageColor3 = Color3.new(1, 0, 0)
        circle.ImageTransparency = 0.5
        circle.Parent = indicatorCircle
        indicatorCircle.Parent = workspace
    end,
    
    updateIndicator = function(targetPart)
        if not indicatorCircle then self.createIndicator() end
        indicatorCircle.Adornee = targetPart or nil
        indicatorCircle.Enabled = targetPart ~= nil
    end,
    
    toggleFullbright = function()
        Homelander.Config.Visual.Fullbright = not Homelander.Config.Visual.Fullbright
        Lighting.Brightness = Homelander.Config.Visual.Fullbright and 5 or 1
        Lighting.Ambient = Homelander.Config.Visual.Fullbright and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Lighting.Ambient
        Lighting.ClockTime = Homelander.Config.Visual.Fullbright and 12 or 14
    end,
    
    toggleXray = function()
        Homelander.Config.Visual.Xray = not Homelander.Config.Visual.Xray
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                local dist = (part.Position - root.Position).Magnitude
                if dist <= 150 then
                    if Homelander.Config.Visual.Xray then
                        if part.Transparency < 0.5 then
                            part:SetAttribute("OriginalTransparency", part.Transparency)
                            part.Transparency = 0.8
                        end
                    else
                        local orig = part:GetAttribute("OriginalTransparency")
                        if orig ~= nil then
                            part.Transparency = orig
                            part:SetAttribute("OriginalTransparency", nil)
                        end
                    end
                end
            end
        end
    end,
    
    clearESP = function()
        for _, v in ipairs(espFolder:GetChildren()) do
            v:Destroy()
        end
        ESPs = {}
    end,
    
    createESPForCharacter = function(player)
        local character = player.Character
        if not character then return end
        
        local head = character:FindFirstChild("Head")
        if not head then return end
        
        if ESPs[player] then
            ESPs[player]:Destroy()
            ESPs[player] = nil
        end
        
        local billboard = Homelander.Utils.createBillboard(
            head,
            Vector2.new(120, 50),
            Vector3.new(0, 2, 0),
            player.Name,
            Homelander.Config.Visual.ESPColor
        )
        
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.TextColor3 = Color3.new(0, 1, 0)
        healthLabel.TextStrokeTransparency = 0
        healthLabel.Font = Enum.Font.SourceSansBold
        healthLabel.Text = "100/100"
        healthLabel.Parent = billboard
        
        ESPs[player] = billboard
        billboard.Parent = espFolder
    end,
    
    updateESP = function()
        for player, esp in pairs(ESPs) do
            if player and esp and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local healthLabel = esp:FindFirstChildOfClass("TextLabel")
                    if healthLabel then
                        healthLabel.Text = string.format("%d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                        local ratio = humanoid.Health / humanoid.MaxHealth
                        healthLabel.TextColor3 = Color3.fromHSV(ratio * 0.33, 1, 1)
                    end
                end
            end
        end
    end
}