local AutoFarm = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:FindFirstChildWhichIsA("Humanoid")
local running = false
local conn

local HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
local States = player:WaitForChild("States")
local Stats = player:WaitForChild("Stats")

local RobRemote = ReplicatedStorage:WaitForChild("GeneralEvents"):WaitForChild("Rob")
local BagLevel = Stats:WaitForChild("BagSizeLevel"):WaitForChild("CurrentAmount")
local BagAmount = States:WaitForChild("Bag")
local Camp = CFrame.new(1636.62537, 104.349976, -1736.184)

local function CloneHumanoid()
    if humanoid then
        local newHumanoid = humanoid:Clone()
        newHumanoid.Parent = char
        player.Character = nil
        newHumanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        newHumanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        newHumanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        humanoid:Destroy()
        player.Character = char
        camera.CameraSubject = newHumanoid
        camera.CFrame = camera.CFrame
        newHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

        local animate = char:FindFirstChild("Animate")
        if animate then
            animate.Disabled = true
            task.wait()
            animate.Disabled = false
        end

        newHumanoid.Health = newHumanoid.MaxHealth
    end
end

local function TeleportToCamp()
    HumanoidRootPart.CFrame = Camp
end

local function CashRegisterFarm()
    for _, item in ipairs(Workspace:GetChildren()) do
        if BagAmount.Value >= BagLevel.Value then
            TeleportToCamp()
            break
        elseif item:IsA("Model") and item.Name == "CashRegister" then
            local openPart = item:FindFirstChild("Open")
            if openPart then
                HumanoidRootPart.CFrame = openPart.CFrame
                RobRemote:FireServer("Register", {
                    Part = item:FindFirstChild("Union"),
                    OpenPart = openPart,
                    ActiveValue = item:FindFirstChild("Active"),
                    Active = true
                })
            end
        end
    end
end

local function BankFarm()
    for _, item in ipairs(Workspace:GetChildren()) do
        if BagAmount.Value >= BagLevel.Value then
            TeleportToCamp()
            break
        elseif item:IsA("Model") and item.Name == "Safe" and item:FindFirstChild("Amount").Value > 0 then
            local safePart = item:FindFirstChild("Safe")
            if safePart then
                HumanoidRootPart.CFrame = safePart.CFrame
                if item:FindFirstChild("Open").Value then
                    RobRemote:FireServer("Safe", item)
                else
                    item:FindFirstChild("OpenSafe"):FireServer("Completed")
                    RobRemote:FireServer("Safe", item)
                end
            end
        end
    end
end

function AutoFarm.Start()
    if running then return end
    running = true
    CloneHumanoid()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm";
        Text = "Auto Farm Activado";
        Duration = 5;
    })

    conn = RunService.RenderStepped:Connect(function()
        CashRegisterFarm()
        BankFarm()
    end)
end

function AutoFarm.Stop()
    if not running then return end
    running = false
    if conn then conn:Disconnect() end

    game.StarterGui:SetCore("SendNotification", {
        Title = "Auto Farm";
        Text = "Auto Farm Desactivado";
        Duration = 5;
    })
end

return AutoFarm
