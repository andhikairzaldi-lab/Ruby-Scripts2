-- Beri jeda/delay agar script tidak membuat game crash
local delayTime = 0.5 
_G.AutoFarm = true -- Mengaktifkan fitur Auto Farm (Ubah ke false untuk mematikan)

-- Memulai perulangan otomatis
task.spawn(function()
    while _G.AutoFarm do
        -- 1. Otomatis Berlatih / Angkat Beban (Gain Strength)
        -- Ganti "TrainRemote" dengan nama RemoteEvent latihan asli di game tersebut
        local trainRemote = game:GetService("ReplicatedStorage"):FindFirstChild("TrainRemote")
        if trainRemote then
            trainRemote:FireServer()
        end
        
        task.wait(delayTime)

        -- 2. Otomatis Menendang Blok (Auto Kick)
        -- Ganti "KickRemote" dengan nama RemoteEvent menendang asli di game tersebut
        local kickRemote = game:GetService("ReplicatedStorage"):FindFirstChild("KickRemote")
        if kickRemote then
            kickRemote:FireServer()
        end

        task.wait(delayTime)
    end
end)
