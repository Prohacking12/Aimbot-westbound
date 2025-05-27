local ESP = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
ESP.espEnabled = false
ESP.espFolder = Instance.new("Folder", workspace)
ESP.espFolder.Name = "ESP_Objects"
ESP.ESPs = {}

function ESP.toggleESP()
    ESP.espEnabled = not ESP.espEnabled
    ESP.refreshESP()
end

function ESP.clearESP()
    for _, v in ipairs(ESP.espFolder:GetChildren()) do
        v:Destroy()
    end
end

function ESP.createESPForCharacter(player)
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    if ESP.ESPs[player] then
        ESP.ESPs[player]:Destroy()
        ESP.ESPs[player] = nil
    end
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP"
    billboardGui.Adornee = head
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 120, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.Parent = ESP.espFolder
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Text = player.Name
    nameLabel.Parent = billboardGui
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.new(0, 1, 0)
    healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.Text = "100 / 100"
    healthLabel.Parent = billboardGui
    ESP.ESPs[player] = billboardGui
end

function ESP.updateESPForPlayer(player)
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local espGui = ESP.ESPs[player]
    if humanoid and espGui then
        local healthLabel
        for _, label in pairs(espGui:GetChildren()) do
            if label:IsA("TextLabel") and label ~= espGui:FindFirstChildOfClass("TextLabel") then
                healthLabel = label
                break
            end
        end
        if healthLabel then
            healthLabel.Text = string.format("%d / %d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
            local ratio = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            healthLabel.TextColor3 = Color3.fromHSV(ratio * 0.33, 1, 1)
        end
        espGui.Enabled = ESP.espEnabled
    end
end

function ESP.refreshESP()
    ESP.clearESP()
    ESP.ESPs = {}
    if not ESP.espEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            ESP.createESPForCharacter(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESP.espEnabled then
            ESP.createESPForCharacter(player)
        end
    end)
end)
Players.PlayerRemoving:Connect(function(player)
    if ESP.ESPs[player] then
        ESP.ESPs[player]:Destroy()
        ESP.ESPs[player] = nil
    end
end)

return ESP
