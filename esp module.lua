local ESP = {}
ESP.ESPs = {}

function ESP.Clear(espFolder)
    for _, v in ipairs(espFolder:GetChildren()) do
        v:Destroy()
    end
    for k, v in pairs(ESP.ESPs) do
        if v then v:Destroy() end
        ESP.ESPs[k] = nil
    end
end

function ESP.CreateForCharacter(player, espFolder)
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
    billboardGui.Parent = espFolder

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

return ESP
