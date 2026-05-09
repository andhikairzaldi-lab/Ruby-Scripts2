local Toggle = false
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ButtonFarm = Instance.new("TextButton")

-- UI Setup Rapi
ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0.5, -75, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true

ButtonFarm.Parent = Frame
ButtonFarm.Size = UDim2.new(0.9, 0, 0.8, 0)
ButtonFarm.Position = UDim2.new(0.05, 0, 0.1, 0)
ButtonFarm.Text = "AUTO FARM: OFF"
ButtonFarm.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
ButtonFarm.TextColor3 = Color3.new(1,1,1)
ButtonFarm.TextSize = 12

-- Koordinat (Silakan sesuaikan koordinat BASE kamu)
local posBalok = Vector3.new(690, 5, 232)
local posBase = Vector3.new(650, 5, 232) -- GANTI dengan koordinat base kamu yang benar

local network = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local kickEvent = network:WaitForChild("rev_KickEvent")

ButtonFarm.MouseButton1Click:Connect(function()
    Toggle = not Toggle
    ButtonFarm.Text = Toggle and "AUTO FARM: ON" or "AUTO FARM: OFF"
    ButtonFarm.BackgroundColor3 = Toggle and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if Toggle then
        task.spawn(function()
            while Toggle do
                local char = game.Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if root and hum and hum.Health > 0 then
                    -- GOD MODE
                    hum.Health = hum.MaxHealth
                    
                    -- 1. PERGI KE BALOK
                    root.CFrame = CFrame.new(posBalok)
                    task.wait(0.5)
                    
                    -- 2. NENDANG (AUTO PERFECT)
                    kickEvent:FireServer(1)
                    task.wait() -- Tunggu balok hancur/terpental
                    
                    -- 3. BALIK KE BASE (PENTING BIAR GAK KICK)
                    root.CFrame = CFrame.new(posBase)
                    task.wait(1) -- Jeda sebentar biar server yakin kamu sudah di base
                    
                    -- 4. BARU AMBIL HADIAH
                    kickCollect:FireServer()
                    
                    task.wait() -- Jeda antar putaran
                end
            end
        end)
    end
end)

-- HOOKING PERFECT (Tetap aktif)
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
