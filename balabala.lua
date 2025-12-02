-- 🔗 Daftar link raw berisi username (satu username per baris)
local rawLinks = {
    "https://raw.githubusercontent.com/zoonai/Script/refs/heads/main/list.txt"
}

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local myName = string.lower(localPlayer.Name)

-- 📝 Fungsi untuk ambil semua username dari rawlinks
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
-- Modern Centered Notification UI ✨
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

TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
    Size = 10
}):Play()

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "SansMobaHub_NotifEX"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = CoreGui

-- Main Frame (Centered with scale for mobile/desktop)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 0, 0, 0) -- Start from 0 for scale animation
main.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center position
main.AnchorPoint = Vector2.new(0.5, 0.5) -- Center anchor
main.BackgroundTransparency = 1
main.Parent = gui

-- Simple background
local bg = Instance.new("Frame", main)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
bg.BackgroundTransparency = 0.05
bg.BorderSizePixel = 0

-- Rounded corners
local corner = Instance.new("UICorner", bg)
corner.CornerRadius = UDim.new(0, 16)

-- Title
local title = Instance.new("TextLabel", bg)
title.Text = "SansMobaHub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 0, 0, 20)
title.Size = UDim2.new(1, 0, 0, 22)
title.TextXAlignment = Enum.TextXAlignment.Center

-- Status Text
local msg = Instance.new("TextLabel", bg)
msg.Text = "Loading..."
msg.Font = Enum.Font.Gotham
msg.TextSize = 14
msg.TextColor3 = Color3.fromRGB(180, 180, 180)
msg.BackgroundTransparency = 1
msg.Position = UDim2.new(0, 0, 0, 50)
msg.Size = UDim2.new(1, 0, 0, 20)
msg.TextXAlignment = Enum.TextXAlignment.Center

-- Progress Bar Container
local barBG = Instance.new("Frame", bg)
barBG.Position = UDim2.new(0, 30, 1, -30)
barBG.Size = UDim2.new(1, -60, 0, 4)
barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
barBG.BorderSizePixel = 0
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)

-- Progress Fill
local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

-- Scale animation for entrance
local targetSize = UDim2.new(0, 280, 0, 110)
TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = targetSize
}):Play()

-- Progress bar animation
local fillTween = TweenService:Create(
    barFill,
    TweenInfo.new(3, Enum.EasingStyle.Linear),
    { Size = UDim2.new(1, 0, 1, 0) }
)

task.wait(0.3)
fillTween:Play()

-- Completion
fillTween.Completed:Connect(function()
    msg.Text = "Complete"
    
    task.wait(0.3)

    -- Exit animation
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(blur, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        Size = 0
    }):Play()

    task.wait(0.4)
    gui:Destroy()
    blur:Destroy()

    -- Safe load function
    local function safeLoad(url)
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet(url))()
            end)
        end)
    end

    -- 🔥 Load scripts
    safeLoad("https://paste.monster/KAThKHPYzcmE/raw/")
    safeLoad("https://paste.monster/Bc43d7EeHiyt/raw/")
    task.wait(8)
    safeLoad("https://raw.githubusercontent.com/zoonai/Script/refs/heads/main/main.lua")
end)
