local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

if CoreGui:FindFirstChild("OmurUltimate") then CoreGui.OmurUltimate:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "OmurUltimate"
gui.Parent = CoreGui

-- ANA PANEL
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 300)
frame.Position = UDim2.new(0.5, -130, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Yuxarı Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
topBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Ömür Driving Empire VIP"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.SourceSansBold
title.Parent = topBar

-- BAĞLAMA DÜYMƏSİ (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- DÜYMƏ YARATMA FUNKSİYASI
local function createBtn(txt, pos, color, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = pos
    b.Text = txt
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.Parent = frame
    b.MouseButton1Click:Connect(func)
    return b
end

-- 1. SÜRƏT HACK (VELOCITY BASED)
local speedActive = false
createBtn("HIZLI SURUS: OFF", UDim2.new(0, 10, 0, 50), Color3.fromRGB(50, 50, 50), function(self)
    speedActive = not speedActive
    self.Text = speedActive and "HIZLI SURUS: ON" or "HIZLI SURUS: OFF"
    self.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)
end)

-- 2. QALXIŞ BOOST (INSTANT ACCEL)
local boostActive = false
createBtn("INSTANT ACCEL: OFF", UDim2.new(0, 10, 0, 95), Color3.fromRGB(50, 50, 50), function(self)
    boostActive = not boostActive
    self.Text = boostActive and "INSTANT ACCEL: ON" or "INSTANT ACCEL: OFF"
    self.BackgroundColor3 = boostActive and Color3.fromRGB(150, 0, 200) or Color3.fromRGB(50, 50, 50)
end)

-- 3. FULLBRIGHT (GECƏNİ GÜNDÜZ ET)
createBtn("Gunduz Et / Isiqlandir", UDim2.new(0, 10, 0, 140), Color3.fromRGB(200, 150, 0), function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
end)

-- 4. ESP (TEAM BASED)
local espActive = false
createBtn("ESP: OFF", UDim2.new(0, 10, 0, 185), Color3.fromRGB(50, 50, 50), function(self)
    espActive = not espActive
    self.Text = espActive and "ESP: ON" or "ESP: OFF"
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p ~= Players.LocalPlayer then
            if espActive then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = (p.Team and p.Team.Name == "Police") and Color3.new(0,0,1) or Color3.new(1,0,0)
            else
                local h = p.Character:FindFirstChildOfClass("Highlight")
                if h then h:Destroy() end
            end
        end
    end
end)

-- ARXAPLANDA FİZİKA DÖVRÜ
RunService.Stepped:Connect(function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local seat = char.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            -- Sürət artırma (W basanda maşını qabağa itələyir)
            if speedActive and seat.Throttle == 1 then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * 1.5)
            end
            -- Qalxış Boost (Yerindən dərhal fırlanır)
            if boostActive and seat.Throttle == 1 and seat.AssemblyLinearVelocity.Magnitude < 50 then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * 5)
            end
        end
    end
end)

print("Omur Ultimate V3 Yuklendi!")
