local BASE_URL = "https://raw.githubusercontent.com/Prohacking12/Aimbot-westbound/main/Modules/"

local function requireModule(name)
    local src = game:HttpGet(BASE_URL .. name .. ".lua")
    local f, err = loadstring(src)
    if not f then error("Error loading module "..name..": "..err) end
    return f()
end

local combat   = requireModule("combat")
local visuals  = requireModule("visuals")
local gui      = requireModule("gui")
local keybinds = requireModule("keybinds")

if combat.init then combat.init() end
if visuals.init then visuals.init() end
if gui.init then gui.init() end
if keybinds.init then keybinds.init() end
