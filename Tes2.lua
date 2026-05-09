local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ButtonTP = Instance.new("TextButton")
local ButtonFarm = Instance.new("TextButton")
local SpeedInput = Instance.new("TextBox") 
local Toggle = false
local CurrentSpeed = 50 

-- UI Setup
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

SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        CurrentSpeed = math.clamp(val, 1, 200)
        SpeedInput.Text = tostring(CurrentSpeed)
    end
end)

-- Remotes
local network = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local kickEvent = network:WaitForChild("rev_KickEvent")
local speedEvent = network:WaitForChild("rev_SPEED")

ButtonTP.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(690, 5, 232) end
end)

ButtonFarm.MouseButton1Click:Connect(function()
    Toggle = not Toggle
    ButtonFarm.Text = Toggle and "FARM: ON" or "FARM: OFF"
    ButtonFarm.BackgroundColor3 = Toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if Toggle then
        -- THREAD 1: JALAN + BYPASS SPEED SERVER
        task.spawn(function()
            while Toggle do
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    -- Tembak remote ke server biar diizinkan kencang
                    speedEvent:FireServer(CurrentSpeed)
                    
                    hum.WalkSpeed = CurrentSpeed
                    hum:Move(Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z), true)
                end
                task.wait(0.1) -- Jeda tipis biar nggak spam berlebihan tapi tetep kencang
            end
        end)

        -- THREAD 2: KICK & GOD MODE
        task.spawn(function()
            while Toggle do
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    hum.Health = hum.MaxHealth
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    kickEvent:FireServer(1)
                end
                task.wait(1.5) 
            end
        end)
    else
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then 
            hum.WalkSpeed = 16 
            speedEvent:FireServer(16) -- Balikin speed server ke normal
        end
    end
end)

-- HOOKING UNTUK PERFECT
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if Toggle and self == kickEvent and method == "FireServer" then
        args[1] = 1 
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)
