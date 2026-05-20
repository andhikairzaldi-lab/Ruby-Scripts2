-- =======================================================
-- KICK A LUCKY BLOCK - AUTO CLICK WORLD X2 MULTIPLIER (V3)
-- =======================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

_G.AutoClickWorldX2 = true

-- Fungsi untuk mendeteksi dan memicu interaksi pada objek x2 melayang
task.spawn(function()
    print("[Auto-Click x2 v3 Started] Memindai tombol x2 di sekitar karakter...")
    
    while _G.AutoClickWorldX2 do
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            
            -- Memindai objek di Workspace (terutama di sekitar karakter atau folder efek)
            for _, obj in ipairs(Workspace:GetDescendants()) do
                -- Cari objek berupa ClickDetector atau ProximityPrompt yang memiliki unsur nama "2" atau "Mult"
                if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                    local parentName = string.lower(obj.Parent.Name)
                    
                    -- Jika terdeteksi sebagai pemicu tombol x2
                    if string.find(parentName, "2") or string.find(parentName, "mult") or string.find(parentName, "click") or string.find(parentName, "tap") then
                        
                        -- Eksekusi klik berdasarkan jenis trigger-nya
                        if obj:IsA("ClickDetector") then
                            fireclickdetector(obj)
                        elseif obj:IsA("ProximityPrompt") then
                            fireproximityprompt(obj)
                        end
                    end
                end
            end
        end
        task.wait(0.05) -- Jeda tipis agar tidak lag saat memindai objek 3D
    end
end)
