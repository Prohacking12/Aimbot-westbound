local Visual = {}
local shared
local ESPs = {}

function Visual.init(sharedState)
    shared = sharedState
end

function Visual.createIndicator()
    local indicatorCircle = Instance.new("BillboardGui")
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
    return indicatorCircle
end

function Visual.updateIndicator(targetPart)
    if not shared.indicatorCircle then
        shared.indicatorCircle = Visual.createIndicator()
    end
    shared.indicatorCircle.Adornee = targetPart or nil
    shared.indicatorCircle.Enabled = targetPart ~= nil
end

function Visual.clearESP()
    for _, v in ipairs(shared.espFolder:GetChildren()) do
        v:Destroy()
    end
end

function Visual.createESPForCharacter(player)
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    if ESPs[player] then
        ESPs[player]:Destroy()
        ESPs[player] = nil
    end
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "ESP"
    billboardGui.Adornee = head
    billboardGui.AlwaysOnTop = true
    billboardGui.Size = UDim2.new(0, 120, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.Parent = shared.espFolder
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
    ESPs[player] = billboardGui
end

function Visual.updateESPForPlayer(player)
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local espGui = ESPs[player]
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
        espGui.Enabled = shared.config.espEnabled
    end
end

function Visual.refreshESP()
    Visual.clearESP()
    ESPs = {}
    if not shared.config.espEnabled then return end
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player ~= shared.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            Visual.createESPForCharacter(player)
        end
    end
end

function Visual.toggleESP(enabled)
    shared.config.espEnabled = enabled
    Visual.refreshESP()
end

function Visual.toggleXray(enabled)
    shared.config.xrayEnabled = enabled
    local root = shared.LocalPlayer.Character and shared.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(shared.LocalPlayer.Character) then
            local dist = (part.Position - root.Position).Magnitude
            if dist <= 150 then
                if enabled then
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
end

function Visual.toggleFullbright(enabled)
    shared.config.fullbrightEnabled = enabled
    Lighting.Brightness = enabled and 5 or 1
    Lighting.Ambient = enabled and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5)
    Lighting.OutdoorAmbient = Lighting.Ambient
    Lighting.ClockTime = enabled and 12 or 14
end

function Visual.update()
    if shared.config.espEnabled then
        for player, _ in pairs(ESPs) do
            Visual.updateESPForPlayer(player)
        end
    end
end

return Visual
