-- [[ ÖMÜR ULTIMATE V13 - ESP & REVERSE FIX ]] --
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Köhnə interfeysləri tam təmizlə
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "OmurV13" then v:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "OmurV13"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- ANA PANEL
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 350)
Main.Position = UDim2.new(0.5, -200, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- SOL PANEL (TABS)
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(0, 110, 1, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Tabs.BorderSizePixel = 0
Tabs.Parent = Main
Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0, 10)

-- SƏHİFƏLƏR
local PlayerPage = Instance.new("ScrollingFrame")
PlayerPage.Size = UDim2.new(1, -120, 1, -20)
PlayerPage.Position = UDim2.new(0, 115, 0, 10)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = true
PlayerPage.Parent = Main

local WorldPage = Instance.new("ScrollingFrame")
WorldPage.Size = UDim2.new(1, -120, 1, -20)
WorldPage.Position = UDim2.new(0, 115, 0, 10)
WorldPage.BackgroundTransparency = 1
WorldPage.Visible = false
WorldPage.Parent = Main

Instance.new("UIListLayout", PlayerPage).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", WorldPage).Padding = UDim.new(0, 5)

-- AYARLAR
local config = {
    espName = false, espBox = false, espLine = false,
    speed = false, brake = true, turn = true, noFog = false
}

-- FUNKSİYA: DÜYMƏ YARATMA
local function makeToggle(name, parent, key)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 35)
    b.Text = name .. ": OFF"
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        config[key] = not config[key]
        b.Text = name .. (config[key] and ": ON" or ": OFF")
        b.BackgroundColor3 = config[key] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(45, 45, 45)
    end)
end

-- TABLAR
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

-- DÜYMƏLƏR
makeToggle("ESP NAME", PlayerPage, "espName")
makeToggle("ESP BOX", PlayerPage, "espBox")
makeToggle("ESP LINE", PlayerPage, "espLine")

makeToggle("HIZLI SURUS", WorldPage, "speed")
makeToggle("AKILLI TORMOZ", WorldPage, "brake")
makeToggle("RAHAT DONME", WorldPage, "turn")
makeToggle("DUMANI SIL", WorldPage, "noFog")

-- ESP MOTORU (Name, Box, Line)
local function createESP(plr)
    local line = Drawing.new("Line")
    local box = Drawing.new("Square")
    local text = Drawing.new("Text")

    RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr ~= Players.LocalPlayer then
            local hrp = plr.Character.HumanoidRootPart
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
            
            local color = (plr.Team and plr.Team.Name == "Police") and Color3.new(0, 0, 1) or Color3.new(1, 0, 0)

            -- LINE ESP
            if config.espLine and onScreen then
                line.Visible = true
                line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                line.To = Vector2.new(pos.X, pos.Y)
                line.Color = color
            else line.Visible = false end

            -- BOX ESP
            if config.espBox and onScreen then
                box.Visible = true
                box.Size = Vector2.new(2000 / pos.Z, 2500 / pos.Z)
                box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                box.Color = color
                box.Thickness = 2
            else box.Visible = false end

            -- NAME ESP
            if config.espName and onScreen then
                text.Visible = true
                text.Text = plr.Name
                text.Position = Vector2.new(pos.X, pos.Y - (2500 / pos.Z) / 2 - 15)
                text.Color = color
                text.Center = true
                text.Outline = true
            else text.Visible = false end
        else
            line.Visible = false box.Visible = false text.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

-- FİZİKA (SPEED & REVERSE FIX)
RunService.Heartbeat:Connect(function()
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
                seat.AssemblyAngularVelocity = seat.AssemblyAngularVelocity + Vector3.new(0, -seat.Steer * 0.1, 0)
            end
        end
    end
    if config.noFog then Lighting.FogEnd = 100000 end
end)

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then Main.Visible = not Main.Visible end
end)
