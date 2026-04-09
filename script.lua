-- ÖMÜR HUB V12 - ABSOLUTE FIX
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- 1. BÜTÜN KÖHNƏ SKRİPTLƏRİ TAMAMİLE SİLİRİK
local function Cleanup()
    for _, child in pairs(CoreGui:GetChildren()) do
        if child.Name:find("Omur") or child.Name == "ScreenGui" then
            if child:FindFirstChild("Frame") then -- Bizim menuya bənzəyirsə sil
                child:Destroy()
            end
        end
    end
end
Cleanup()

-- 2. YENİ GUI YARADIRIQ
local gui = Instance.new("ScreenGui")
gui.Name = "OmurV12_Fixed"
gui.Parent = CoreGui
gui.IgnoreGuiInset = true -- Ekranın hər yerini əhatə etsin
gui.ResetOnSpawn = false

-- ANA PANEL
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 360, 0, 320)
main.Position = UDim2.new(0.5, -180, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = true
main.Parent = gui

-- Dizayn üçün künclər
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- SOL PANEL (TABS)
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(0, 100, 1, 0)
tabs.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabs.BorderSizePixel = 0
tabs.Parent = main
Instance.new("UICorner", tabs).CornerRadius = UDim.new(0, 10)

-- SƏHİFƏLƏR
local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, -110, 1, -10)
pages.Position = UDim2.new(0, 105, 0, 5)
pages.BackgroundTransparency = 1
pages.Parent = main

local playerPage = Instance.new("ScrollingFrame")
playerPage.Size = UDim2.new(1, 0, 1, 0)
playerPage.BackgroundTransparency = 1
playerPage.Visible = true
playerPage.Parent = pages

local worldPage = Instance.new("ScrollingFrame")
worldPage.Size = UDim2.new(1, 0, 1, 0)
worldPage.BackgroundTransparency = 1
worldPage.Visible = false
worldPage.Parent = pages

Instance.new("UIListLayout", playerPage).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", worldPage).Padding = UDim.new(0, 5)

-- AYARLAR
local config = { speed = false, brake = true, turn = true, esp = false }

-- DÜYMƏ YARATMA
local function makeToggle(name, parent, key)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 35)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        b.Text = name .. (config[key] and ": ON" or ": OFF")
        b.BackgroundColor3 = config[key] and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(50, 50, 50)
    end)
end

-- TAB KEÇİDLƏRİ
local pBtn = Instance.new("TextButton")
pBtn.Size = UDim2.new(1, -10, 0, 40)
pBtn.Position = UDim2.new(0, 5, 0, 10)
pBtn.Text = "PLAYER"
pBtn.Parent = tabs

local wBtn = Instance.new("TextButton")
wBtn.Size = UDim2.new(1, -10, 0, 40)
wBtn.Position = UDim2.new(0, 5, 0, 55)
wBtn.Text = "WORLD"
wBtn.Parent = tabs

pBtn.MouseButton1Click:Connect(function() playerPage.Visible = true worldPage.Visible = false end)
wBtn.MouseButton1Click:Connect(function() playerPage.Visible = false worldPage.Visible = true end)

-- DÜYMƏLƏRİ ƏLAVƏ ET
makeToggle("ESP", playerPage, "esp")
makeToggle("HIZLI SURUS", worldPage, "speed")
makeToggle("AKILLI TORMOZ", worldPage, "brake")
makeToggle("RAHAT DONME", worldPage, "turn")

-- FİZİKA (ARXAYA GETMƏ FIX)
RunService.Heartbeat:Connect(function()
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local seat = char.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            -- Sürət
            if config.speed and seat.Throttle == 1 then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * 1.8)
            end
            -- Tormoz (Smart Brake)
            if config.brake and seat.Throttle == -1 then
                local localVel = seat.CFrame:VectorToObjectSpace(seat.AssemblyLinearVelocity)
                if localVel.Z < -2 then -- Yalnız irəli gedəndə tormozla
                    seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity * 0.95
                end
            end
            -- Dönmə
            if config.turn and seat.Steer ~= 0 then
                seat.AssemblyAngularVelocity = seat.AssemblyAngularVelocity + Vector3.new(0, -seat.Steer * 0.1, 0)
            end
        end
    end
end)

-- GİZLƏ/AÇ (K)
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)

print("Ömür Hub V12 Məcburi Yükləndi!")
