local AutoFarm = {}
local isRunning = false
local connection

function AutoFarm.Start()
    if isRunning then return end
    isRunning = true

    local player = game.Players.LocalPlayer
    local cam = workspace.CurrentCamera
    local pos, char = cam.CFrame, player.Character
    local human = char and char:FindFirstChildWhichIsA("Humanoid")

    if human then
        local clone = human:Clone()
        clone.Parent = char
        player.Character = nil
        clone:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        clone:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        clone:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        human:Destroy()
        player.Character = char
        cam.CameraSubject = clone
        cam.CFrame = pos
        clone.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        local anim = char:FindFirstChild("Animate")
        if anim then
            anim.Disabled = true
            task.wait()
            anim.Disabled = false
        end

        clone.Health = clone.MaxHealth
    end

    task.wait(2)

    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local States = LocalPlayer:FindFirstChild("States")
    local Stats = LocalPlayer:FindFirstChild("Stats")
    local RobRemote = ReplicatedStorage:WaitForChild("GeneralEvents"):WaitForChild("Rob")

    local BagLevel = Stats:FindFirstChild("BagSizeLevel"):FindFirstChild("CurrentAmount")
    local BagAmount = States:FindFirstChild("Bag")

    local Camp = CFrame.new(1636.62537, 104.349976, -1736.184)

    local function TeleportToCamp()
        HumanoidRootPart.CFrame = Camp
    end

    local function CashRegisterFarm()
        for _, Item in ipairs(Workspace:GetChildren()) do
            if BagAmount.Value == BagLevel.Value then
                TeleportToCamp()
                break
            elseif Item:IsA("Model") and Item.Name == "CashRegister" then
                local OpenPart = Item:FindFirstChild("Open")
                if OpenPart then
                    HumanoidRootPart.CFrame = OpenPart.CFrame
                    RobRemote:FireServer("Register", {
                        ["Part"] = Item:FindFirstChild("Union"),
                        ["OpenPart"] = OpenPart,
                        ["ActiveValue"] = Item:FindFirstChild("Active"),
                        ["Active"] = true
                    })
                end
            end
        end
    end

    local function BankFarm()
        for _, Item in ipairs(Workspace:GetChildren()) do
            if BagAmount.Value == BagLevel.Value then
                TeleportToCamp()
                break
            elseif Item:IsA("Model") and Item.Name == "Safe" and Item:FindFirstChild("Amount").Value > 0 then
                local SafePart = Item:FindFirstChild("Safe")
                if SafePart then
                    HumanoidRootPart.CFrame = SafePart.CFrame
                    if Item:FindFirstChild("Open").Value then
                        RobRemote:FireServer("Safe", Item)
                    else
                        Item:FindFirstChild("OpenSafe"):FireServer("Completed")
                        RobRemote:FireServer("Safe", Item)
                    end
                end
            end
        end
    end

    connection = RunService.RenderStepped:Connect(function()
        if not isRunning then return end
        CashRegisterFarm()
        BankFarm()
    end)

    game.StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm";
        Text = "Auto Farm executed";
        Duration = 5;
    })
end

function AutoFarm.Stop()
    isRunning = false
    if connection then
        connection:Disconnect()
        connection = nil
    end

    if _G.ReloadGUI then
        _G.ReloadGUI()
    end

    game.StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm";
        Text = "Auto Farm stopped";
        Duration = 5;
    })
end

return AutoFarm
