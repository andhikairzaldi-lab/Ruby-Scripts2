-- =======================================================
-- KICK A LUCKY BLOCK - AUTO CLICK POP-UP x2 MULTIPLIER (V2)
-- =======================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

_G.AutoClickX2 = true

-- Fungsi untuk mengeklik tombol secara paksa bypass restriksi UI
local function forceClick(button)
    -- Metode 1: Aktivasi virtual internal Roblox
    button:Activate()
    
    -- Metode 2: Tembakkan event klik mouse simulator bawaan executor (jika didukung)
    if firesignal then
        firesignal(button.MouseButton1Click)
        firesignal(button.MouseButton1Down)
        firesignal(button.Activated)
    end
    
    -- Metode 3: Panggil koneksi mentah via getconnections (cadangan)
    if getconnections then
        for _, connection in ipairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
        for _, connection in ipairs(getconnections(button.Activated)) do
            connection:Fire()
        end
    end
end

-- Looping pemindaian UI secara agresif
task.spawn(function()
    print("[Auto-Click x2 v2 Started] Mendeteksi pop-up perkalian daya...")
    
    while _G.AutoClickX2 do
        -- Cari di seluruh elemen GUI milik pemain
        for _, obj in ipairs(PlayerGui:GetDescendants()) do
            -- Pastikan objek tersebut adalah tombol klik
            if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                
                -- Deteksi tombol berdasarkan string teks atau nama objek (case-insensitive)
                local isX2Button = false
                
                if obj:IsA("TextButton") then
                    local txt = string.lower(obj.Text)
                    if string.find(txt, "x2") or string.find(txt, "2x") or string.find(txt, "multiplier") then
                        isX2Button = true
                    end
                end
                
                local name = string.lower(obj.Name)
                if string.find(name, "x2") or string.find(name, "multiplier") or string.find(name, "double") or string.find(name, "pop") then
                    isX2Button = true
                end
                
                -- Jika terindikasi tombol x2, eksekusi klik secara instan
                if isX2Button then
                    -- Catatan: Beberapa game menyembunyikan tombol lewat Parent-nya, jadi kita langsung klik saja tanpa cek .Visible
                    forceClick(obj)
                end
            end
        end
        task.wait(0.005) -- Delay super tipis (5 milidetik) agar tidak ada tombol pop-up yang lolos
    end
end)
