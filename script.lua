-- ==========================================
-- ÖMÜR ÜÇÜN SADƏLƏŞDİRİLMİŞ PANEL (EXECUTOR DOSTU)
-- ==========================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui") -- PlayerGui əvəzinə CoreGui istifadə edirik

-- Əgər köhnə panel qalıbsa onu silək (təkrarlanmasın)
if CoreGui:FindFirstChild("OmurPanel") then
    CoreGui.OmurPanel:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "OmurPanel"
gui.Parent = CoreGui -- Kodu birbaşa Robloxun ana sisteminə bağlayırıq

-- ANA QUTU
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true 
frame.Parent = gui

-- BAŞLIQ
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Ömür's Hub"
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- ESP DÜYMƏSİ
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 180, 0, 40)
btn.Position = UDim2.new(0, 10, 0, 45)
btn.Text = "ESP AKTİV ET"
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Parent = frame

-- ESP FUNKSİYASI
btn.MouseButton1Click:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            local highlight = Instance.new("Highlight")
            highlight.Parent = p.Character
            highlight.FillColor = Color3.new(1, 1, 1) -- Hamını ağ rəngdə göstərsin (yoxlamaq üçün)
            highlight.FillTransparency = 0.5
        end
    end
    btn.Text = "ESP İŞLƏYİR!"
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
end)

print("Panel yükləndi!")
