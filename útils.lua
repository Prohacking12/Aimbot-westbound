local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return {
    getTargetPart = function(model, aimAtChest)
        if not model then return nil end
        return model:FindFirstChild(aimAtChest and "HumanoidRootPart" or "Head") or model:FindFirstChild("ChestPart")
    end,
    
    isValidTarget = function(character)
        if not character then return false end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return false end
        if character:FindFirstChild("Knocked") and character.Knocked.Value == true then return false end
        return true
    end,
    
    raycastCheck = function(startPos, endPos, ignoreList)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = ignoreList or {LocalPlayer.Character}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local direction = (endPos - startPos)
        local result = workspace:Raycast(startPos, direction.Unit * direction.Magnitude, params)
        return not result or (result.Instance and result.Instance:IsDescendantOf(character))
    end,
    
    createBillboard = function(parent, size, offset, text, color)
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, size.X, 0, size.Y)
        billboard.StudsOffset = offset or Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = parent
        billboard.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = color or Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard
        
        return billboard
    end
}