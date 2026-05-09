local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ButtonTP = Instance.new("TextButton")
local ButtonFarm = Instance.new("TextButton")
local SpeedInput = Instance.new("TextBox") 
local Toggle = false
local CurrentSpeed = 50 

-- UI SETUP (Dibuat seaman mungkin)
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 160, 0, 130)
Frame.Position = UDim2.new(0.5, -80, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true

local function styleBtn(btn, text, pos, color)
    btn.Parent = Frame
    btn.Size = UDim2.new(0.9, 0, 0.25, 0)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.BorderSizePixel = 0
end

SpeedInput.Parent = Frame
SpeedInput.Size = UDim2.new(0.9, 0, 0.2, 0)
SpeedInput.Position = UDim2.new(0.05, 0, 0.05, 0)
SpeedInput.PlaceholderText = "Speed (1-200)"
SpeedInput.Text = "50"
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedInput.TextColor3 = Color3.new(1,1,1)

styleBtn(ButtonTP, "TELEPORT", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(0, 100, 200))
styleBtn(ButtonFarm, "FARM: OFF", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(150, 0, 0))

-- Update Speed
SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then CurrentSpeed = math.clamp(val, 1, 200) end
end)

-- FUNGSI TELEPORT
ButtonTP.MouseButton1Click:Connect(function()
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = CFrame.new(690, 5, 232)
    end
end)

-- FUNGSI UTAMA
ButtonFarm.MouseButton1Click:Connect(function()
    Toggle = not Toggle
    ButtonFarm.Text = Toggle and "FARM: ON" or "FARM: OFF"
    ButtonFarm.BackgroundColor3 = Toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if Toggle then
        task.spawn(function()
            -- Ambil folder network langsung di sini biar gak error di awal
            local net = game:GetService("ReplicatedStorage").Shared.Packages.Network
            
            while Toggle do
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart")

                    -- 1. BYPASS SPEED (Dari hasil Spy kamu)
                    net.rev_SPEED:FireServer(CurrentSpeed)
                    hum.WalkSpeed = CurrentSpeed
                    hum:Move(Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z), true)

                    -- 2. KICK & GOD MODE
                    hum.Health = hum.MaxHealth
                    net.rev_KickEvent:FireServer(1)
                end)
                task.wait(0.2) -- Loop tipis biar lancar
            end
        end)
    else
        pcall(function()
            local net = game:GetService("ReplicatedStorage").Shared.Packages.Network
            net.rev_SPEED:FireServer(16)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end)
    end
end)
