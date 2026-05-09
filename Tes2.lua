local ToggleGod = false
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ButtonTP = Instance.new("TextButton")
local ButtonGod = Instance.new("TextButton")

-- Setup UI
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true

-- Tombol Teleport (Sekali Klik)
ButtonTP.Parent = Frame
ButtonTP.Size = UDim2.new(0.9, 0, 0.4, 0)
ButtonTP.Position = UDim2.new(0.05, 0, 0.05, 0)
ButtonTP.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ButtonTP.Text = "TELEPORT KE KOORDINAT"
ButtonTP.TextScaled = true

-- Tombol Kebal (God Mode)
ButtonGod.Parent = Frame
ButtonGod.Size = UDim2.new(0.9, 0, 0.4, 0)
ButtonGod.Position = UDim2.new(0.05, 0, 0.5, 0)
ButtonGod.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ButtonGod.Text = "KEBAL: OFF"
ButtonGod.TextScaled = true

-- FUNGSI TELEPORT MANUAL (Lebih Aman)
ButtonTP.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(690, 5, 232)
    end
end)
-- FUNGSI KEBAL (Metode State)
ButtonGod.MouseButton1Click:Connect(function()
    ToggleGod = not ToggleGod
    ButtonGod.Text = ToggleGod and "KEBAL: ON" or "KEBAL: OFF"
    ButtonGod.BackgroundColor3 = ToggleGod and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hum then
        if ToggleGod then
            -- Mematikan semua perubahan status (termasuk pengurangan darah)
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            
            -- Mencoba mengunci darah di angka maksimal
            task.spawn(function()
                while ToggleGod do
                    hum.Health = hum.MaxHealth
                    task.wait()
                end
            end)
        else
            -- Mengembalikan fungsi normal
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            char:BreakJoints() -- Reset karakter agar normal kembali
        end
    end
end)
