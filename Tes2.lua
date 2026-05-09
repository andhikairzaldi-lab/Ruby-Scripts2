local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ButtonTP = Instance.new("TextButton")
local ButtonFarm = Instance.new("TextButton")
local SpeedInput = Instance.new("TextBox") -- Kolom Speed
local Toggle = false
local CurrentSpeed = 50 -- Default awal

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

-- Input Speed (Kolom)
SpeedInput.Parent = Frame
SpeedInput.Size = UDim2.new(0.9, 0, 0.2, 0)
SpeedInput.Position = UDim2.new(0.05, 0, 0.05, 0)
SpeedInput.PlaceholderText = "Speed (1-200)"
SpeedInput.Text = "50"
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedInput.TextColor3 = Color3.new(1,1,1)

styleBtn(ButtonTP, "TELEPORT", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(0, 100, 200))
styleBtn(ButtonFarm, "FARM: OFF", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(150, 0, 0))

-- Update Speed dari Kolom
SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        CurrentSpeed = math.clamp(val, 1, 200)
        SpeedInput.Text = tostring(CurrentSpeed)
    end
end)

local network = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local kickEvent = network:WaitForChild("rev_KickEvent")

-- 1. TELEPORT MANUAL
ButtonTP.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(690, 5, 232) end
end)

-- 2. FARM LOGIC
ButtonFarm.MouseButton1Click:Connect(function()
    Toggle = not Toggle
    ButtonFarm.Text = Toggle and "FARM: ON" or "FARM: OFF"
    ButtonFarm.BackgroundColor3 = Toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if Toggle then
        -- THREAD 1: KHUSUS JALAN (BIAR MULUS)
        task.spawn(function()
            while Toggle do
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    hum.WalkSpeed = CurrentSpeed
                    -- Karakter selalu mencoba maju ke depan posisi dia menghadap
                    hum:Move(root.CFrame.LookVector) 
                end
                task.wait() 
            end
        end)

        -- THREAD 2: KHUSUS KICK & GOD MODE
        task.spawn(function()
            while Toggle do
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.Health = hum.MaxHealth
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    kickEvent:FireServer(1)
                end
                task.wait(1.5) -- Jeda tendangan tidak mengganggu jalan
            end
        end)
    else
        -- Reset saat OFF
        local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
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
