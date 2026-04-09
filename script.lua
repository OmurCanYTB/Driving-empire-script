local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Köhnə panelləri təmizləyirik (Xəta verməməsi üçün mütləqdir)
if CoreGui:FindFirstChild("OmurV11") then CoreGui.OmurV11:Destroy() end
if CoreGui:FindFirstChild("OmurProV6") then CoreGui.OmurProV6:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "OmurV11"
gui.Parent = CoreGui
gui.ResetOnSpawn = false -- Öləndə menunun silinməməsi üçün

-- ANA PANEL
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 300)
main.Position = UDim2.new(0.5, -175, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 21, 24)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = true -- Görünən olduğundan əmin oluruq
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- SOL MENYU (TABS)
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(30, 31, 35)
sideBar.BorderSizePixel = 0
sideBar.Parent = main
Instance.new("UICorner", sideBar).CornerRadius = UDim.new(0, 10)

-- PLAYER VƏ WORLD SƏHİFƏLƏRİ
local playerPage = Instance.new("ScrollingFrame")
playerPage.Size = UDim2.new(1, -110, 1, -20)
playerPage.Position = UDim2.new(0, 105, 0, 10)
playerPage.BackgroundTransparency = 1
playerPage.ScrollBarThickness = 2
playerPage.Visible = true
playerPage.Parent = main

local worldPage = Instance.new("ScrollingFrame")
worldPage.Size = UDim2.new(1, -110, 1, -20)
worldPage.Position = UDim2.new(0, 105, 0, 10)
worldPage.BackgroundTransparency = 1
worldPage.ScrollBarThickness = 2
worldPage.Visible = false
worldPage.Parent = main

Instance.new("UIListLayout", playerPage).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", worldPage).Padding = UDim.new(0, 5)

-- AYARLAR
local config = { speed = false, softBrake = true, easyTurn = true, esp = false, noFog = false }

-- DÜYMƏ YARATMA FUNKSİYASI
local function createToggle(name, parent, key)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45, 46, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        btn.Text = name .. (config[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = config[key] and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(45, 46, 50)
    end)
end

-- TABLAR ARASI KEÇİD
local pTab = Instance.new("TextButton")
pTab.Size = UDim2.new(1, -10, 0, 40)
pTab.Position = UDim2.new(0, 5, 0, 10)
pTab.Text = "PLAYER"
pTab.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
pTab.TextColor3 = Color3.new(1, 1, 1)
pTab.Parent = sideBar
Instance.new("UICorner", pTab).CornerRadius = UDim.new(0, 6)

local wTab = Instance.new("TextButton")
wTab.Size = UDim2.new(1, -10, 0, 40)
wTab.Position = UDim2.new(0, 5, 0, 55)
wTab.Text = "WORLD"
wTab.BackgroundColor3 = Color3.fromRGB(45, 46, 50)
wTab.TextColor3 = Color3.new(1, 1, 1)
wTab.Parent = sideBar
Instance.new("UICorner", wTab).CornerRadius = UDim.new(0, 6)

pTab.MouseButton1Click:Connect(function() 
    playerPage.Visible = true worldPage.Visible = false
    pTab.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    wTab.BackgroundColor3 = Color3.fromRGB(45, 46, 50)
end)
wTab.MouseButton1Click:Connect(function() 
    playerPage.Visible = false worldPage.Visible = true
    wTab.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    pTab.BackgroundColor3 = Color3.fromRGB(45, 46, 50)
end)

-- PLAYER & WORLD DÜYMƏLƏRİ
createToggle("ESP NAME/BOX", playerPage, "esp")
createToggle("HIZLI SURUS", worldPage, "speed")
createToggle("SMART TORMOZ", worldPage, "softBrake")
createToggle("RAHAT DONME", worldPage, "easyTurn")
createToggle("DUMANI SIL", worldPage, "noFog")

-- FİZİKA (ARXAYA GETMƏ DÜZƏLİŞİ)
RunService.Stepped:Connect(function()
    local lp = Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local seat = lp.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            -- Sürət (W)
            if config.speed and seat.Throttle == 1 then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * 1.8)
            end
            -- SMART TORMOZ (Yalnız irəli gedəndə S-ə basılsa işləyir)
            if config.softBrake and seat.Throttle == -1 then
                local relativeVelocity = seat.CFrame:VectorToObjectSpace(seat.AssemblyLinearVelocity)
                if relativeVelocity.Z < -5 then -- Maşın irəli gedir (Z mənfidir)
                    seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity * 0.95
                end
            end
            -- DÖNMƏ
            if config.easyTurn and seat.Steer ~= 0 then
                seat.AssemblyAngularVelocity = seat.AssemblyAngularVelocity + Vector3.new(0, -seat.Steer * 0.08, 0)
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
                if not p.Character:FindFirstChild("OmurHighlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "OmurHighlight"
                    h.FillColor = (p.Team and p.Team.Name == "Police") and Color3.new(0,0,1) or Color3.new(1,0,0)
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("OmurHighlight") then
                p.Character.OmurHighlight:Destroy()
            end
        end
    end
end)

-- GİZLƏ (K)
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)

print("Ömür Hub Fix Yükləndi!")
