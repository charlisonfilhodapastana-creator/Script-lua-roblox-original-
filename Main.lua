
--==================================================
--          CHARLIZIN_MODS V2.4
--          MENU MOBILE / PC
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- REMOVE VERSAO ANTERIOR
local oldGui = playerGui:FindFirstChild("CharlizinMods")
if oldGui then
    oldGui:Destroy()
end

-- CONFIGURACOES
local themes = {
    Color3.fromRGB(150, 70, 255),
    Color3.fromRGB(40, 150, 255),
    Color3.fromRGB(40, 200, 120),
    Color3.fromRGB(255, 100, 100),
    Color3.fromRGB(255, 170, 40)
}

local currentTheme = 1
local flySpeed = 48
local menuWidth = 600
local menuHeight = 420
local opened = true
local busy = false

-- INTERFACE
local gui = Instance.new("ScreenGui")
gui.Name = "CharlizinMods"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100
gui.Parent = playerGui

local scale = Instance.new("UIScale")
scale.Parent = gui

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.fromOffset(menuWidth, menuHeight)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local outline = Instance.new("UIStroke")
outline.Thickness = 2
outline.Color = themes[currentTheme]
outline.Parent = frame

-- CABECALHO
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = themes[currentTheme]
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "charlizin_mods"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(42, 36)
closeButton.Position = UDim2.new(1, -47, 0, 6)
closeButton.Text = "×"
closeButton.TextSize = 25
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundTransparency = 1
closeButton.Parent = header

-- BOTAO REABRIR
local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.fromOffset(115, 38)
reopenButton.Position = UDim2.new(0, 12, 0.5, -19)
reopenButton.Text = "ABRIR MENU"
reopenButton.TextColor3 = Color3.new(1, 1, 1)
reopenButton.TextSize = 13
reopenButton.Font = Enum.Font.GothamBold
reopenButton.BackgroundColor3 = themes[currentTheme]
reopenButton.Visible = false
reopenButton.Parent = gui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 8)
reopenCorner.Parent = reopenButton

-- CONTEUDO
local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(12, 60)
content.Size = UDim2.new(1, -24, 1, -72)
content.BackgroundTransparency = 1
content.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

-- CRIAR BOTOES
local function createButton(text, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.BackgroundColor3 = Color3.fromRGB(38, 38, 47)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.Text = text
    button.LayoutOrder = order
    button.Parent = content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    return button
end

local speedButton = createButton("Velocidade do voo: 48", 1)
local themeButton = createButton("Mudar tema", 2)
local saveButton = createButton("Salvar configurações", 3)
local loadButton = createButton("Carregar configurações", 4)

-- ESCALA RESPONSIVA
local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize

    scale.Scale = math.max(0.45, math.min(
        1,
        viewport.X / menuWidth,
        viewport.Y / menuHeight
    ))
end

local function applyTheme(index)
    if not themes[index] then return end

    currentTheme = index

    outline.Color = themes[index]
    header.BackgroundColor3 = themes[index]
    reopenButton.BackgroundColor3 = themes[index]
end

-- VELOCIDADE
local function updateSpeed()
    speedButton.Text = "Velocidade do voo: " .. flySpeed
end

speedButton.Activated:Connect(function()
    flySpeed += 8

    if flySpeed > 200 then
        flySpeed = 10
    end

    updateSpeed()
end)

-- TEMA
themeButton.Activated:Connect(function()
    local nextTheme = currentTheme + 1

    if nextTheme > #themes then
        nextTheme = 1
    end

    applyTheme(nextTheme)
end)

-- ABRIR E FECHAR
local function setMenuVisible(state)
    opened = state
    frame.Visible = state
    reopenButton.Visible = not state
end

closeButton.Activated:Connect(function()
    setMenuVisible(false)
end)

reopenButton.Activated:Connect(function()
    setMenuVisible(true)
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightControl then
        setMenuVisible(not opened)
    end
end)

-- CONFIGURACOES LOCAIS
local function getConfig()
    return {
        ThemeIndex = currentTheme,
        FlySpeed = flySpeed,
        MenuWidth = menuWidth,
        MenuHeight = menuHeight
    }
end

local function applyConfig(config)
    if typeof(config) ~= "table" then return false end

    if typeof(config.ThemeIndex) ~= "number"
        or config.ThemeIndex % 1 ~= 0
        or not themes[config.ThemeIndex] then
        return false
    end

    if typeof(config.FlySpeed) ~= "number"
        or config.FlySpeed < 10
        or config.FlySpeed > 200 then
        return false
    end

    if typeof(config.MenuWidth) ~= "number"
        or config.MenuWidth < 560
        or config.MenuWidth > 850 then
        return false
    end

    if typeof(config.MenuHeight) ~= "number"
        or config.MenuHeight < 360
        or config.MenuHeight > 600 then
        return false
    end

    currentTheme = config.ThemeIndex
    flySpeed = config.FlySpeed
    menuWidth = config.MenuWidth
    menuHeight = config.MenuHeight

    applyTheme(currentTheme)
    updateSpeed()

    frame.Size = UDim2.fromOffset(menuWidth, menuHeight)
    updateScale()

    return true
end

-- SALVAR E CARREGAR NO SERVIDOR
local remote = ReplicatedStorage:WaitForChild(
    "CharlizinConfig",
    10
)

local function saveConfig()
    if busy then return end
    busy = true

    saveButton.Text = "SALVANDO..."

    if not remote or not remote:IsA("RemoteFunction") then
        saveButton.Text = "SERVIDOR INDISPONIVEL"
        task.wait(1.5)
        saveButton.Text = "Salvar configurações"
        busy = false
        return
    end

    local callOK, success, result = pcall(function()
        return remote:InvokeServer("Save", getConfig())
    end)

    saveButton.Text = callOK and success
        and "CONFIGURAÇÕES SALVAS!"
        or "ERRO AO SALVAR"

    if not callOK then
        warn("[Charlizin]", success)
    elseif not success then
        warn("[Charlizin]", result)
    end

    task.wait(1.5)
    saveButton.Text = "Salvar configurações"
    busy = false
end

local function loadConfig()
    if busy then return end
    busy = true

    loadButton.Text = "CARREGANDO..."

    if not remote or not remote:IsA("RemoteFunction") then
        loadButton.Text = "SERVIDOR INDISPONIVEL"
        task.wait(1.5)
        loadButton.Text = "Carregar configurações"
        busy = false
        return
    end

    local callOK, success, result = pcall(function()
        return remote:InvokeServer("Load")
    end)

    if callOK and success and applyConfig(result) then
        loadButton.Text = "CONFIGURAÇÕES CARREGADAS!"
    else
        loadButton.Text = "ERRO AO CARREGAR"
        warn("[Charlizin] Falha ao carregar:", result)
    end

    task.wait(1.5)
    loadButton.Text = "Carregar configurações"
    busy = false
end

saveButton.Activated:Connect(saveConfig)
loadButton.Activated:Connect(loadConfig)

-- CAMERA
local cameraConnection

local function updateCamera()
    if cameraConnection then
        cameraConnection:Disconnect()
        cameraConnection = nil
    end

    local camera = workspace.CurrentCamera

    if camera then
        cameraConnection =
            camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end

    updateScale()
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateCamera)
updateCamera()

-- CARREGAMENTO AUTOMATICO
task.delay(2, function()
    if gui.Parent then
        loadConfig()
    end
end)

-- ABERTURA INICIAL
setMenuVisible(true)

print("[Charlizin] charlizin_mods v2.4 carregado!")
