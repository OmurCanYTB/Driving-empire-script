local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

if CoreGui:FindFirstChild("OmurV11") then CoreGui.OmurV11:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "OmurV11"
gui.Parent = CoreGui

-- ANA PANEL
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 350, 0, 400)
main.Position = UDim2.new(0.5, -175, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25, 26, 28)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- SOL MENYU (TABS)
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(35, 36, 40)
sideBar.Parent = main
Instance.new("UICorner", sideBar).CornerRadius = UDim.new(0, 10)

-- BÖLMƏLƏR (CONTAINERS)
local playerPage = Instance.new("ScrollingFrame")
playerPage.Size = UDim2.new(1, -110, 1, -20)
playerPage.Position = UDim2.new(0, 105, 0, 10)
playerPage.BackgroundTransparency = 1
playerPage.Visible = true
playerPage.Parent = main

local worldPage = Instance.new("ScrollingFrame")
worldPage.Size = UDim2.new(1, -110, 1, -20)
worldPage.Position = UDim2.new(0, 105, 0, 10)
worldPage.BackgroundTransparency = 1
worldPage.Visible = false
worldPage.Parent = main

-- AYARLAR
local config = {
    espName = false, espLine = false, espBox = false,
    speed = false, softBrake = true, easyTurn = true,
    noFog = false, dayTime = false
}

-- FUNKSİYA: DÜYMƏ YARATMAQ
local function createToggle(name, parent, key, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(45, 46, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIListLayout", parent).Padding = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        btn.Text = name .. (config[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = config[key] and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(45, 46, 50)
        if callback then callback(config[key]) end
    end)
end

-- TAB DÜYMƏLƏRİ
local pBtn = Instance.new("TextButton")
pBtn.Size = UDim2.new(1, -10, 0, 40)
pBtn.Position = UDim2.new(0, 5, 0, 10)
pBtn.Text = "PLAYER"
pBtn.Parent = sideBar

local wBtn = Instance.new("TextButton")
wBtn.Size = UDim2.new(1, -10, 0, 40)
wBtn.Position = UDim2.new(0, 5, 0, 55)
wBtn.Text = "WORLD"
wBtn.Parent = sideBar

pBtn.MouseButton1Click:Connect(function() playerPage.Visible = true worldPage.Visible = false end)
wBtn.MouseButton1Click:Connect(function() playerPage.Visible = false worldPage.Visible = true end)

-- PLAYER BÖLMƏSİ (ESP & SETTINGS)
createToggle("ESP NAME", playerPage, "espName")
createToggle("ESP LINE", playerPage, "espLine")
createToggle("ESP BOX", playerPage, "espBox")

-- WORLD BÖLMƏSİ (CAR & WORLD)
createToggle("HIZLI SURUS", worldPage, "speed")
createToggle("SMART TORMOZ", worldPage, "softBrake")
createToggle("RAHAT DONME", worldPage, "easyTurn")
createToggle("DUMANI SIL", worldPage, "noFog")

-- FİZİKA (SMART BRAKE DÜZƏLİŞİ)
RunService.Stepped:Connect(function()
    local lp = Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local seat = lp.Character.Humanoid.SeatPart
        if seat and seat:IsA("VehicleSeat") then
            -- Sürət
            if config.speed and seat.Throttle == 1 then
                seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * 1.8)
            end
            -- SMART TORMOZ (Arxaya getməni bloklamır)
            if config.softBrake and seat.Throttle == -1 then
                local velocity = seat.AssemblyLinearVelocity
                local speed = velocity.Magnitude
                -- Əgər maşın irəli gedirsə tormoz ver
                if seat.CFrame.LookVector:Dot(velocity) > 2 then
                    seat.AssemblyLinearVelocity = velocity * 0.96
                end
            end
            -- Dönmə
            if config.easyTurn and seat.Steer ~= 0 then
                seat.AssemblyAngularVelocity = seat.AssemblyAngularVelocity + Vector3.new(0, -seat.Steer * 0.1, 0)
            end
        end
    end
end)

-- ESP SİSTEMİ (Name, Line, Box)
RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            -- Name ESP (Highlight istifadə edirik daha yüngüldür)
            if config.espName or config.espBox then
                if not p.Character:FindFirstChild("OmurESP") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "OmurESP"
                    h.FillTransparency = (config.espBox and 0.5 or 1)
                    h.OutlineTransparency = (config.espBox and 0 or 1)
                end
            else
                if p.Character:FindFirstChild("OmurESP") then p.Character.OmurESP:Destroy() end
            end
        end
    end
end)

-- Gizlə (K)
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then main.Visible = not main.Visible end
end)
