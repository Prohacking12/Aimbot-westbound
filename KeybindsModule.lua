local Keybinds = {}

Keybinds.Bindings = {}
Keybinds.CurrentKeys = {} -- {Aimbot = "F", ESP = "G", GUI = "RightControl"}

function Keybinds.BindKey(key, callback)
    Keybinds.Bindings[key] = callback
end

function Keybinds.UnbindKey(key)
    Keybinds.Bindings[key] = nil
end

function Keybinds.SetKey(name, newKey, callback)
    local oldKey = Keybinds.CurrentKeys[name]
    if oldKey then
        Keybinds.UnbindKey(oldKey)
    end
    Keybinds.CurrentKeys[name] = newKey
    Keybinds.BindKey(newKey, callback)
end

function Keybinds.Listen()
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        local cb = Keybinds.Bindings[input.KeyCode.Name]
        if cb then
            cb()
        end
    end)
end

return Keybinds
