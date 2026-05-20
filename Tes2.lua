-- =======================================================
-- KICK A LUCKY BLOCK - AUTO CLICK POP-UP x2 BUTTON
-- =======================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Konfigurasi toggle script
_G.AutoClickX2 = true

-- Fungsi utama scan dan klik tombol x2 secara cepat
task.spawn(function()
    print("[Auto-Click x2 Started] Mencari tombol pengganda kekuatan...")
    
    while _G.AutoClickX2 do
        -- Scan seluruh isi PlayerGui untuk mencari tombol/teks bertuliskan "x2"
        for _, guiObject in ipairs(PlayerGui:GetDescendants()) do
            if guiObject:IsA("TextButton") or guiObject:IsA("ImageButton") then
                
                -- Deteksi tombol berdasarkan properti Nama atau Teks di dalamnya
                local textMatch = false
                if guiObject:IsA("TextButton") and (string.find(string.lower(guiObject.Text), "x2") or string.find(string.lower(guiObject.Name), "x2")) then
                    textMatch = true
                elseif string.find(string.lower(guiObject.Name), "x2") or string.find(string.lower(guiObject.Name), "double") then
                    textMatch = true
                end
                
                -- Jika tombol ditemukan dan posisinya terlihat (visible) di layar
                if textMatch and guiObject.Visible and guiObject.AbsoluteSize.X > 0 then
                    -- Metode 1: Simulasikan klik langsung lewat fungsi bawaan Roblox Gui
                    guiObject:Activate()
                    
                    -- Metode 2 (Cadangan): Tembakkan event klik jika metode pertama dilewati
                    local events = {"MouseButton1Click", "MouseButton1Down", "Activated"}
                    for _, eventName in ipairs(events) do
                        if guiObject[eventName] then
                            for _, connection in ipairs(getconnections(guiObject[eventName])) do
                                connection:Fire()
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01) -- Deteksi super cepat setiap 0.01 detik agar tombol tidak terlewat
    end
end)
