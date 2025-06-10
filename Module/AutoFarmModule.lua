local AutoFarm = {}

function AutoFarm.notify()
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Auto Farm";
            Text = "Auto Farm ejecutado";
            Duration = 5;
        })
    end)
end

function AutoFarm.start()
    local speaker = game.Players.LocalPlayer
    local Cam = workspace.CurrentCamera
    local Pos, Char = Cam.CFrame, speaker.Character
    local Human = Char:FindFirstChildWhichIsA("Humanoid")

    if Human then
        local nHuman = Human:Clone()
        nHuman.Parent = Char
        speaker.Character = nil
        nHuman:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        nHuman:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        nHuman:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        Human:Destroy()
        speaker.Character = Char
        Cam.CameraSubject = nHuman
        Cam.CFrame = Pos
        nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        local AnimateScript = Char:FindFirstChild("Animate")
        if AnimateScript then
            AnimateScript.Disabled = true
            task.wait()
            AnimateScript.Disabled = false
        end

        nHuman.Health = nHuman.MaxHealth
    end

    task.wait(2)
    AutoFarm.run()
end

function AutoFarm.run()
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local States = LocalPlayer:FindFirstChild("States")
    local Stats = LocalPlayer:FindFirstChild("Stats")

    if not (HumanoidRootPart and States and Stats) then return end

    local RobRemote = ReplicatedStorage:FindFirstChild("GeneralEvents") and ReplicatedStorage.GeneralEvents:FindFirstChild("Rob")
    local BagLevel = Stats:FindFirstChild("BagSizeLevel") and Stats.BagSizeLevel:FindFirstChild("CurrentAmount")
    local BagAmount = States:FindFirstChild("Bag")

    local Camp = CFrame.new(1636.62537, 104.349976, -1736.184)

    local function TeleportToCamp()
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = Camp
        end
    end

    local function CashRegisterFarm()
        for _, Item in ipairs(Workspace:GetChildren()) do
            if BagAmount and BagLevel and BagAmount.Value == BagLevel.Value then
                TeleportToCamp()
                break
            elseif Item:IsA("Model") and Item.Name == "CashRegister" then
                local OpenPart = Item:FindFirstChild("Open")
                if OpenPart and HumanoidRootPart then
                    HumanoidRootPart.CFrame = OpenPart.CFrame
                    if RobRemote then
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
    end

    local function BankFarm()
        for _, Item in ipairs(Workspace:GetChildren()) do
            if BagAmount and BagLevel and BagAmount.Value == BagLevel.Value then
                TeleportToCamp()
                break
            elseif Item:IsA("Model") and Item.Name == "Safe" and Item:FindFirstChild("Amount") and Item.Amount.Value > 0 then
                local SafePart = Item:FindFirstChild("Safe")
                if SafePart and HumanoidRootPart then
                    HumanoidRootPart.CFrame = SafePart.CFrame
                    if Item:FindFirstChild("Open") and Item.Open.Value then
                        if RobRemote then
                            RobRemote:FireServer("Safe", Item)
                        end
                    else
                        if Item:FindFirstChild("OpenSafe") then
                            Item.OpenSafe:FireServer("Completed")
                        end
                        if RobRemote then
                            RobRemote:FireServer("Safe", Item)
                        end
                    end
                end
            end
        end
    end

    AutoFarm.connection = RunService.RenderStepped:Connect(function()
        CashRegisterFarm()
        BankFarm()
    end)
end

function AutoFarm.stop()
    if AutoFarm.connection then
        AutoFarm.connection:Disconnect()
        AutoFarm.connection = nil
    end
end

return AutoFarm
