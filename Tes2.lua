local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ButtonTP = Instance.new("TextButton")
local ButtonFarm = Instance.new("TextButton")
local Toggle = false

-- UI Setup (Pastikan parent ke CoreGui biar stabil)
ScreenGui.Parent = game:GetService("CoreGui")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 160, 0, 100)
Frame.Position = UDim2.new(0.5, -80, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true

local function styleBtn(btn, text, pos, color)
    btn.Parent = Frame
    btn.Size = UDim2.new(0.9, 0, 0.4, 0)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
end

styleBtn(ButtonTP, "TELEPORT PLOT", UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(0, 120, 255))
styleBtn(ButtonFarm, "AUTO FARM: OFF", UDim2.new(0.05, 0, 0.55, 0), Color3.fromRGB(200, 0, 0))

-- Ambil Remote Events
local network = game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Packages"):WaitForChild("Network")
local kickEvent = network:WaitForChild("rev_KickEvent")
local trainEvent = network:WaitForChild("rev_TrainEvent") -- Event buat latihan beban

-- 1. TELEPORT MANUAL
ButtonTP.MouseButton1Click:Connect(function()
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(690, 5, 232) end
end)

-- 2. AUTO FARM (Kick + Run + God Mode)
ButtonFarm.MouseButton1Click:Connect(function()
    Toggle = not Toggle
    ButtonFarm.Text = Toggle and "AUTO FARM: ON" or "AUTO FARM: OFF"
    ButtonFarm.BackgroundColor3 = Toggle and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    if Toggle then
        task.spawn(function()
            while Toggle do
                local char = game.Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if root and hum then
                    -- GOD MODE
                    hum.Health = hum.MaxHealth
                    
                    -- AUTO KICK & TRAIN
                    kickEvent:FireServer(1) -- Kick (Perfect)
                    trainEvent:FireServer() -- Auto angkat beban
                    
                    -- AUTO RUN (Balik ke plot kalau kejauhan)
                    if root.Position.X > 500 then
                        task.wait(0.7) -- Delay biar item ke-loot
                        root.CFrame = CFrame.new(690, 5, 232)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- HOOKING UNTUK FORCE PERFECT
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if Toggle and self == kickEvent and method == "FireServer" then
        args[1] = 1 -- Force 1 (Perfect)
        return oldNamecall(self, unpack(args))
    end
    return oldNamecall(self, ...)
end)
