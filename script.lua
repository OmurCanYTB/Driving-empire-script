local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Əgər köhnə panel varsa silirik
if CoreGui:FindFirstChild("OmurHubV2") then CoreGui.OmurHubV2:Destroy() end

-- ANA INTERFEYS
local gui = Instance.new("ScreenGui")
gui.Name = "OmurHubV2"
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 320)
frame.Position = UDim2.new(0.5, -140, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "ÖMÜR DRIVING EMPIRE V2"
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- FUNKSIYALAR ÜÇÜN DƏYİŞƏNLƏR
local speedVal = 100
local accelVal = 50
local espActive = false
local instantInteract = false

-- KÖMƏKÇİ FUNKSİYA: DÜYMƏ YARATMAQ
local function createButton(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 240, 0, 35)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = frame
    return btn
end

-- 1. ESP DÜYMƏSİ
local espBtn = createButton("ESP: OFF", UDim2.new(0, 20, 0, 50), Color3.fromRGB(60, 60, 60))
espBtn.MouseButton1Click:Connect(function()
    espActive = not espActive
    espBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            if espActive then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "OmurESP"
                h.FillColor = (p.Team and p.Team.Name == "Police") and Color3.new(0,0,1) or Color3.new(1,0,0)
            else
                if p.Character:FindFirstChild("OmurESP") then p.Character.OmurESP:Destroy() end
            end
        end
    end
end)

-- 2. SÜRƏT (SPEED) ARTIRMA
local speedBtn = createButton("MAX SPEED ARTIR (+500)", UDim2.new(0, 20, 0, 100), Color3.fromRGB(0, 100, 200))
speedBtn.MouseButton1Click:Connect(function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        local seat = char.Humanoid.SeatPart
        if seat:IsA("VehicleSeat") then
            seat.MaxSpeed = 500
            print("Sürət artırıldı!")
        end
    end
end)

-- 3. QALXIŞ (TORQUE) ARTIRMA
local accelBtn = createButton("RAKET QALXIŞ (TORQUE)", UDim2.new(0, 20, 0, 150), Color3.fromRGB(150, 0, 200))
accelBtn.MouseButton1Click:Connect(function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        local seat = char.Humanoid.SeatPart
        if seat:IsA("VehicleSeat") then
            seat.Torque = 10000 -- Çox yüksək fırlanma anı
        end
    end
end)

-- 4. INSTANT INTERACT (ATM/SOYĞUN ÜÇÜN)
local interactBtn = createButton("INSTANT E: OFF", UDim2.new(0, 20, 0, 200), Color3.fromRGB(60, 60, 60))
interactBtn.MouseButton1Click:Connect(function()
    instantInteract = not instantInteract
    interactBtn.Text = instantInteract and "INSTANT E: ON" or "INSTANT E: OFF"
    interactBtn.BackgroundColor3 = instantInteract and Color3.fromRGB(200, 150, 0) or Color3.fromRGB(60, 60, 60)
end)

-- ARXAPLANDA İŞLƏYƏN DÖVR (LOOP)
RunService.Stepped:Connect(function()
    if instantInteract then
        -- Ətrafdakı bütün 'ProximityPrompt'ları tapır və dərhal bitirir
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0 -- Gözləmə vaxtını 0 edir
            end
        end
    end
end)

print("Omur Hub V2 Yükləndi!")
