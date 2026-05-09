local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PlayerGui = LP:FindFirstChildOfClass("PlayerGui")

-- Hapus UI lama agar tidak menumpuk
if PlayerGui:FindFirstChild("SimpleSpyFix") then PlayerGui.SimpleSpyFix:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleSpyFix"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 140)
Frame.Position = UDim2.new(0.5, -90, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Active = true
Frame.Draggable = true -- Pastikan executor mendukung Draggable
Frame.Parent = ScreenGui

local function createBtn(name, text, pos, color)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(0.9, 0, 0.22, 0)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.ZIndex = 5 -- Pastikan tombol di atas Frame
    b.Parent = Frame
    return b
end

local btnTP = createBtn("TP", "TP KE PLOT", UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(0, 120, 255))
local btnFarm = createBtn("Farm", "AUTO FARM: OFF", UDim2.new(0.05, 0, 0.30, 0), Color3.fromRGB(200, 0, 0))
local btnTrain = createBtn("Train", "AUTO TRAIN: OFF", UDim2.new(0.05, 0, 0.55, 0), Color3.fromRGB(120, 0, 180))
local btnStatus = createBtn("Status", "CHECK REMOTES", UDim2.new(0.05, 0, 0.80, 0), Color3.fromRGB(50, 50, 50))

local ToggleFarm = false
local ToggleTrain = false

-- Cari Remote Event (Kadang nama atau lokasinya berubah setelah update)
local network = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local kickEvent = network:FindFirstChild("rev_KickEvent") or network:FindFirstChild("KickEvent")
local trainEvent = network:FindFirstChild("rev_TrainEvent") or network:FindFirstChild("TrainEvent")

-- Tombol Status untuk cek apakah script menemukan remote game
btnStatus.MouseButton1Down:Connect(function()
    if kickEvent and trainEvent then
        btnStatus.Text = "REMOTES: FOUND ✅"
    else
        btnStatus.Text = "REMOTES: NOT FOUND ❌"
    end
end)

-- Tombol Teleport
btnTP.MouseButton1Down:Connect(function()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(690, 5, 232) end
end)

-- Auto Farm (Auto Kick + Auto Return)
btnFarm.MouseButton1Down:Connect(function()
    ToggleFarm = not ToggleFarm
    btnFarm.Text = ToggleFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    btnFarm.BackgroundColor3 = ToggleFarm and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
    
    if ToggleFarm then
        task.spawn(function()
            while ToggleFarm do
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and kickEvent then
                    kickEvent:FireServer(1) -- Kirim sinyal tendang (1 = Perfect)
                    
                    -- Logika Auto Jalan/Balik: Jika karakter menjauh dari plot
                    if root.Position.X > 500 then
                        task.wait(0.8) -- Kasih waktu buat ambil item
                        root.CFrame = CFrame.new(690, 5, 232)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Auto Train (Latihan Beban)
btnTrain.MouseButton1Down:Connect(function()
    ToggleTrain = not ToggleTrain
    btnTrain.Text = ToggleTrain and "TRAIN: ON" or "TRAIN: OFF"
    btnTrain.BackgroundColor3 = ToggleTrain and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(120, 0, 180)
    
    if ToggleTrain then
        task.spawn(function()
            while ToggleTrain do
                if trainEvent then trainEvent:FireServer() end
                task.wait(0.1)
            end
        end)
    end
end)
