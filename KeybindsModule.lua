local Keybinds = {}

Keybinds.Bindings = {}
Keybinds.CurrentKeys = {}

function Keybinds.BindKey(key, callback)
    Keybinds.Bindings[key:upper()] = callback
end

function Keybinds.UnbindKey(key)
    Keybinds.Bindings[key:upper()] = nil
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
        local cb = Keybinds.Bindings[input.KeyCode.Name:upper()]
        if cb then
            cb()
        end
    end)
end

return Keybinds
