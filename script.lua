-- [[ ÖMÜR HUB V12.5 - FULL MOD MENU ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Köhnə interfeysləri təmizlə
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "OmurMenu" or v.Name == "OmurV11" or v.Name == "OmurV12_Fixed" then
        v:Destroy()
    end
end

-- GUI YARADILMASI
local gui = Instance.new("ScreenGui")
gui.Name = "OmurMenu"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- ANA ÇƏRÇİVƏ
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 320)
Main.Position = UDim2.new(0.5, -190, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(28, 29, 32)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- SOL PANEL (TABS)
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 110, 1, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(35, 36, 40)
Tabs.BorderSizePixel = 0
Tabs.Parent = Main
Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0, 12)

-- SƏHİFƏLƏR (PAGES)
local Pages = Instance.new("Frame")
Pages.Size = UDim2.new(1, -120, 1, -10)
Pages.Position = UDim2.new(0, 115, 0, 5)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local PlayerPage = Instance.new("ScrollingFrame")
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.ScrollBarThickness = 0
PlayerPage.Visible = true
PlayerPage.Parent = Pages

local WorldPage = Instance.new("ScrollingFrame")
WorldPage.Size = UDim2.new(1, 0, 1, 0)
WorldPage.BackgroundTransparency = 1
WorldPage.ScrollBarThickness = 0
WorldPage.Visible = false
WorldPage.Parent = Pages

Instance.new("UIListLayout", PlayerPage).Padding = UDim.new(0, 6)
Instance.new("UIListLayout", WorldPage).Padding = UDim.new(0, 6)

-- AYARLAR (CONFIG)
local config = { speed = false, brake = true, turn = true, esp = false, noFog = false }

-- DÜYMƏ YARATMA FUNKSİYASI
local function makeToggle(name, parent, key)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 38)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(45, 46, 50)
    b.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

    b.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        b.Text = name .. (config[key] and ": ON" or ": OFF")
        b.BackgroundColor3 = config[key] and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(45, 46, 50)
        b.TextColor3 = config[key] and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
    end)
end

-- TAB DÜYMƏLƏRİ
local function makeTab(name, pos, page)
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(1, -10, 0, 45)
    t.Position = pos
    t.Text = name
    t.BackgroundColor3 = Color3.fromRGB(45, 46, 50)
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = Enum.Font.GothamBold
    t.Parent = Tabs
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 8)

    t.MouseButton1Click:Connect(function()
        PlayerPage.Visible = false
        WorldPage.Visible = false
        page.Visible = true
    end)
end

makeTab("PLAYER", UDim2.new(0, 5, 0, 10), PlayerPage)
makeTab("WORLD", UDim2.new(0, 5, 0, 60), WorldPage)

-- DÜYMƏLƏRİ ƏLAVƏ ET
makeToggle("ESP NAME/BOX", PlayerPage, "esp")
makeToggle("HIZLI SÜRÜŞ (W)", WorldPage, "speed")
makeToggle("SMART TORMOZ (S)", WorldPage, "brake")
makeToggle("RAHAT DÖNMƏ (A/D)", WorldPage, "turn")
makeToggle("DUMANI SİL", WorldPage, "noFog")

-- FİZİKA DÖNGÜSÜ (SMART BRAKE & SPEED)
RunService.Heartbeat:Connect(function()
    local lp = Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local seat = lp.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            -- Speed Hack (W)
            if config.speed and seat.Throttle == 1 then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * 1.8)
            end
            
            -- Smart Brake & Reversing (S)
            if config.brake and seat.Throttle == -1 then
                local localVel = seat.CFrame:VectorToObjectSpace(seat.AssemblyLinearVelocity)
                if localVel.Z < -3 then -- Maşın hələ də irəli gedir
                    seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity * 0.96 -- Yumşaq Tormoz
                end
                -- Maşın dayanıbsa (localVel.Z > -3), tormoz müdaxilə etmir və geriyə gedir.
            end

            -- Rahat Dönmə
            if config.turn and seat.Steer ~= 0 then
                seat.AssemblyAngularVelocity = seat.AssemblyAngularVelocity + Vector3.new(0, -seat.Steer * 0.1, 0)
            end
        end
    end
    if config.noFog then Lighting.FogEnd = 100000 end
end)

-- ESP SİSTEMİ
RunService.RenderStepped:Connect(function()
    if config.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("OmurESP") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "OmurESP"
                    h.FillColor = (p.Team and p.Team.Name == "Police") and Color3.new(0,0,1) or Color3.new(1,0,0)
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("OmurESP") then
                p.Character.OmurESP:Destroy()
            end
        end
    end
end)

-- GİZLƏ/AÇ (K DÜYMƏSİ)
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then
        Main.Visible = not Main.Visible
    end
end)

print("Ömür Hub V12.5 Yükləndi! Gizlətmək üçün 'K' basın.")
