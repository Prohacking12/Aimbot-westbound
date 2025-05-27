local Visual = {}
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

Visual.fullbrightEnabled = false
Visual.xrayEnabled = false

function Visual.toggleFullbright()
    Visual.fullbrightEnabled = not Visual.fullbrightEnabled
    Lighting.Brightness = Visual.fullbrightEnabled and 5 or 1
    Lighting.Ambient = Visual.fullbrightEnabled and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5)
    Lighting.OutdoorAmbient = Lighting.Ambient
    Lighting.ClockTime = Visual.fullbrightEnabled and 12 or 14
end

function Visual.toggleXray()
    Visual.xrayEnabled = not Visual.xrayEnabled
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
            local dist = (part.Position - root.Position).Magnitude
            if dist <= 150 then
                if Visual.xrayEnabled then
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

return Visual
