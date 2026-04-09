-- [[ ÖMÜR DARK HUB V14 - LOGIN & KEYBIND SYSTEM ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Köhnə interfeysləri təmizlə
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "DarkLogin" or v.Name == "OmurV13" or v.Name == "OmurV14" then v:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "OmurV14"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- DEYİŞƏNLƏR
local currentKey = Enum.KeyCode.K -- Default düymə
local isAuthorized = false

-- LOGIN PANELİ
local loginFrame = Instance.new("Frame")
loginFrame.Name = "DarkLogin"
loginFrame.Size = UDim2.new(0, 300, 0, 150)
loginFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
loginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loginFrame.BorderSizePixel = 0
loginFrame.Parent = gui
Instance.new("UICorner", loginFrame)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 40)
loginTitle.Text = "DARK HUB LOGIN"
loginTitle.TextColor3 = Color3.new(1, 1, 1)
loginTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
loginTitle.Parent = loginFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0, 200, 0, 35)
keyInput.Position = UDim2.new(0.5, -100, 0.5, -10)
keyInput.PlaceholderText = "Kodu yazın..."
keyInput.Text = ""
keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyInput.TextColor3 = Color3.new(1, 1, 1)
keyInput.Parent = loginFrame

local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(0, 100, 0, 30)
loginBtn.Position = UDim2.new(0.5, -50, 0.8, 0)
loginBtn.Text = "Giriş"
loginBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
loginBtn.TextColor3 = Color3.new(1, 1, 1)
loginBtn.Parent = loginFrame

-- ANA MENU (Girişdən sonra görünəcək)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 420, 0, 380)
Main.Position = UDim2.new(0.5, -210, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Main.Parent = gui
Instance.new("UICorner", Main)

-- BÖLMƏLƏR VƏ DÜYMƏLƏR (V13-dəki sistem)
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 110, 1, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Tabs.Parent = Main
Instance.new("UICorner", Tabs)

local PlayerPage = Instance.new("ScrollingFrame")
PlayerPage.Size = UDim2.new(1, -120, 1, -60)
PlayerPage.Position = UDim2.new(0, 115, 0, 10)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = true
PlayerPage.Parent = Main

local WorldPage = Instance.new("ScrollingFrame")
WorldPage.Size = UDim2.new(1, -120, 1, -60)
WorldPage.Position = UDim2.new(0, 115, 0, 10)
WorldPage.BackgroundTransparency = 1
WorldPage.Visible = false
WorldPage.Parent = Main

Instance.new("UIListLayout", PlayerPage).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", WorldPage).Padding = UDim.new(0, 5)

-- AYARLAR SİSTEMİ
local config = { espName = false, espBox = false, espLine = false, speed = false, brake = true, turn = true, noFog = false }

local function makeToggle(name, parent, key)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 35)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Parent = parent
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        b.Text = name .. (config[key] and ": ON" or ": OFF")
        b.BackgroundColor3 = config[key] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 45)
    end)
end

-- KEYBIND DÜYMƏSİ (Düyməni dəyişmək üçün)
local bindBtn = Instance.new("TextButton")
bindBtn.Size = UDim2.new(1, -20, 0, 40)
bindBtn.Position = UDim2.new(0, 115, 1, -50)
bindBtn.Text = "MENU DÜYMƏSİ: K"
bindBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
bindBtn.TextColor3 = Color3.new(1, 1, 1)
bindBtn.Parent = Main
Instance.new("UICorner", bindBtn)

bindBtn.MouseButton1Click:Connect(function()
    bindBtn.Text = "Düyməni basın..."
    local connection
    connection = UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = i.KeyCode
            bindBtn.Text = "MENU DÜYMƏSİ: " .. i.KeyCode.Name
            connection:Disconnect()
        end
    end)
end)

-- GİRİŞ MƏNTİQİ
loginBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == "dark" then
        isAuthorized = true
        loginFrame.Visible = false
        Main.Visible = true
        print("Giriş uğurlu!")
    else
        keyInput.Text = ""
        keyInput.PlaceholderText = "SƏHV KOD!"
    end
end)

-- TAB KEÇİDLƏRİ
local pBtn = Instance.new("TextButton")
pBtn.Size = UDim2.new(1, -10, 0, 40)
pBtn.Position = UDim2.new(0, 5, 0, 10)
pBtn.Text = "PLAYER"
pBtn.Parent = Tabs

local wBtn = Instance.new("TextButton")
wBtn.Size = UDim2.new(1, -10, 0, 40)
wBtn.Position = UDim2.new(0, 5, 0, 55)
wBtn.Text = "WORLD"
wBtn.Parent = Tabs

pBtn.MouseButton1Click:Connect(function() PlayerPage.Visible = true WorldPage.Visible = false end)
wBtn.MouseButton1Click:Connect(function() PlayerPage.Visible = false WorldPage.Visible = true end)

-- FUNKSİYALARIN QOŞULMASI
makeToggle("ESP NAME", PlayerPage, "espName")
makeToggle("ESP BOX", PlayerPage, "espBox")
makeToggle("ESP LINE", PlayerPage, "espLine")
makeToggle("HIZLI SURUS", WorldPage, "speed")
makeToggle("AKILLI TORMOZ", WorldPage, "brake")
makeToggle("RAHAT DONME", WorldPage, "turn")
makeToggle("DUMANI SIL", WorldPage, "noFog")

-- ESP VƏ FİZİKA (V13-dəki eyni stabil kod)
RunService.Heartbeat:Connect(function()
    if not isAuthorized then return end
    local lp = Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local seat = lp.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            if config.speed and seat.Throttle == 1 then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * 1.8)
            end
            if config.brake and seat.Throttle == -1 then
                local localVel = seat.CFrame:VectorToObjectSpace(seat.AssemblyLinearVelocity)
                if localVel.Z < -2 then seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity * 0.96 end
            end
            if config.turn and seat.Steer ~= 0 then
                seat.AssemblyAngularVelocity = seat.AssemblyAngularVelocity + Vector3.new(0, -seat.Steer * 0.12, 0)
            end
        end
    end
    if config.noFog then Lighting.FogEnd = 100000 end
end)

-- GİZLƏ/AÇ (Özün seçdiyin düymə)
UserInputService.InputBegan:Connect(function(i, g)
    if isAuthorized and not g and i.KeyCode == currentKey then
        Main.Visible = not Main.Visible
    end
end)

print("Dark Hub V14 Hazırdır. Kod: dark")
