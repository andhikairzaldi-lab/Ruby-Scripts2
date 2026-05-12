local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ButtonTP = Instance.new("TextButton")
local ButtonFarm = Instance.new("TextButton")
local Toggle = false
local ButtonAutoKick = Instance.new("TextButton")
local AutoKickToggle = false

-- UI Setup (Lebih Kecil & Rapi)
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 150, 0, 90) -- Ukuran diperkecil
Frame.Position = UDim2.new(0.5, -75, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Frame.Size = UDim2.new(0, 150, 0, 135) -- Frame diperbesar buat tombol baru
styleBtn(ButtonAutoKick, "AUTO KICK: OFF", UDim2.new(0.05, 0, 0.70, 0), Color3.fromRGB(100, 0, 150))

local function styleBtn(btn, text, pos, color)
    btn.Parent = Frame
    btn.Size = UDim2.new(0.9, 0, 0.4, 0)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.BorderSizePixel = 0
end

styleBtn(ButtonTP, "TELEPORT", UDim2.new(0.05, 0, 0.07, 0), Color3.fromRGB(0, 100, 200))
styleBtn(ButtonFarm, "FARM: OFF", UDim2.new(0.05, 0, 0.53, 0), Color3.fromRGB(150, 0, 0))
ButtonAutoKick.MouseButton1Click:Connect(function()
    AutoKickToggle = not AutoKickToggle
    ButtonAutoKick.Text = AutoKickToggle and "AUTO KICK: ON" or "AUTO KICK: OFF"
    ButtonAutoKick.BackgroundColor3 = AutoKickToggle and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 0, 150)

    if AutoKickToggle then
        task.spawn(function()
            while AutoKickToggle do
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                -- Cek apakah karakter masih hidup & tegap (biar gak ngebug pas respawn)
                if char and hum and hum.Health > 0 then
                    -- Trigger Kick Event
                    kickEvent:FireServer(1) -- Angka 1 karena sudah di-hook jadi Perfect
                    
                    -- JEDA SANGAT PENTING: Kasih waktu block berubah/meledak
                    -- Coba di angka 0.5 - 1.2 detik tergantung lag game-nya
                    task.wait(0.8) 
                else
                    task.wait(1) -- Tunggu respawn selesai
                end
            end
        end)
    end
end)

-- 1. TELEPORT MANUAL
ButtonTP.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(690, 5, 232) end
end)

-- 2. GABUNGAN GOD MODE + AUTO PERFECT
local network = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local kickEvent = network:WaitForChild("rev_KickEvent")

ButtonFarm.MouseButton1Click:Connect(function()
    Toggle = not Toggle
    ButtonFarm.Text = Toggle and "FARM: ON" or "FARM: OFF"
    ButtonFarm.BackgroundColor3 = Toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if Toggle then
        task.spawn(function()
            while Toggle do
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- GOD MODE (Isi darah terus biar selamat dari Tsunami)
                    hum.Health = hum.MaxHealth
                    if hum:GetStateEnabled(Enum.HumanoidStateType.Dead) then
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- HOOKING UNTUK PERFECT (Hanya aktif saat FARM ON)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if Toggle and self == kickEvent and method == "FireServer" then
        args[1] = 1 -- Paksa data tendangan jadi 1 (Perfect)
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)
