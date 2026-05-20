-- =======================================================
-- KICK A LUCKY BLOCK - SCREEN POSITION AUTO CLICKER (V4)
-- =======================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

_G.AutoClickScreenX2 = true

-- Fungsi simulasikan ketukan jari / klik mouse asli pada koordinat layar tertentu
local function realClickScreen(x, y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.01)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

task.spawn(function()
    print("[Auto-Click x2 v4 Started] Melacak koordinat layar tombol melayang...")
    
    while _G.AutoClickScreenX2 do
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            
            -- Memindai semua objek fisik yang menempel/melayang di karaktermu
            for _, child in ipairs(Workspace:GetDescendants()) do
                -- Mencari folder, part, atau billboard yang memuat visual tombol ungu x2
                if child:IsA("BasePart") or child:IsA("BillboardGui") then
                    local name = string.lower(child.Name)
                    
                    -- Filter objek berdasarkan nama pemicu x2
                    if string.find(name, "2") or string.find(name, "mult") or string.find(name, "click") or string.find(name, "tap") then
                        
                        -- Ambil posisi 3D objek di dunia game
                        local targetPart = child:IsA("BasePart") and child or child.Adornee or child.Parent
                        if targetPart and targetPart:IsA("BasePart") then
                            
                            -- Ubah posisi 3D dunia game menjadi koordinat 2D di layar monitor kamu
                            local screenPosition, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                            
                            -- Jika tombolnya muncul di dalam layar monitor, langsung klik titik tersebut!
                            if onScreen then
                                realClickScreen(screenPosition.X, screenPosition.Y)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.02) -- Cek secepat kilat setiap 20 milidetik
    end
end)
