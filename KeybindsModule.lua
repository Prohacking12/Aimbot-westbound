local Keybinds = {}
local binds = {}
local waitingForInput = false
local currentRebindCallback = nil

function Keybinds.init(sharedState)
    
end

function Keybinds.bind(key, callback)
    binds[key] = callback
end

function Keybinds.unbind(key)
    binds[key] = nil
end

function Keybinds.startRebind(callback)
    if waitingForInput then return end
    waitingForInput = true
    currentRebindCallback = callback
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if waitingForInput then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentRebindCallback(input.KeyCode)
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            currentRebindCallback(Enum.KeyCode.MouseButton1)
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            currentRebindCallback(Enum.KeyCode.MouseButton2)
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            currentRebindCallback(Enum.KeyCode.MouseButton3)
        end
        waitingForInput = false
        currentRebindCallback = nil
        return
    end
    
    for key, callback in pairs(binds) do
        if input.KeyCode == key then
            callback()
        end
    end
end)

return Keybinds
