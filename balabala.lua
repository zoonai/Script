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

-- Background with modern gradient
local bg = Instance.new("Frame", main)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
bg.BackgroundTransparency = 0.1
bg.BorderSizePixel = 0

-- Modern rounded corners
local corner = Instance.new("UICorner", bg)
corner.CornerRadius = UDim.new(0, 20)

-- Subtle stroke
local stroke = Instance.new("UIStroke", bg)
stroke.Color = Color3.fromRGB(60, 160, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.5

-- Gradient effect
local gradient = Instance.new("UIGradient", bg)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
gradient.Rotation = 45

-- Title with icon
local title = Instance.new("TextLabel", bg)
title.Text = "SansMobaHub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 25, 0, 20)
title.Size = UDim2.new(1, -50, 0, 25)
title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
local subtitle = Instance.new("TextLabel", bg)
subtitle.Text = "Premium Access"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.TextColor3 = Color3.fromRGB(150, 180, 255)
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 25, 0, 45)
subtitle.Size = UDim2.new(1, -50, 0, 18)
subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Status Text
local msg = Instance.new("TextLabel", bg)
msg.Text = "Initializing..."
msg.Font = Enum.Font.Gotham
msg.TextSize = 14
msg.TextColor3 = Color3.fromRGB(200, 200, 200)
msg.BackgroundTransparency = 1
msg.Position = UDim2.new(0, 25, 0, 80)
msg.Size = UDim2.new(1, -50, 0, 20)
msg.TextXAlignment = Enum.TextXAlignment.Left

-- Progress Bar Container
local barBG = Instance.new("Frame", bg)
barBG.Position = UDim2.new(0, 25, 1, -35)
barBG.Size = UDim2.new(1, -50, 0, 6)
barBG.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
barBG.BackgroundTransparency = 0
barBG.BorderSizePixel = 0
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)

-- Progress Fill
local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
barFill.BorderSizePixel = 0
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

-- Scale animation for entrance
local targetSize = UDim2.new(0, 340, 0, 140)
TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = targetSize
}):Play()

-- Progress bar animation
local fillTween = TweenService:Create(
    barFill,
    TweenInfo.new(4.5, Enum.EasingStyle.Sine),
    { Size = UDim2.new(1, 0, 1, 0) }
)

-- Update status text during loading
task.spawn(function()
    local messages = {
        "Connecting to server...",
        "Loading resources...",
        "Initializing scripts...",
        "Almost ready..."
    }
    
    for i, text in ipairs(messages) do
        msg.Text = text
        task.wait(1.1)
    end
end)

task.wait(0.3)
fillTween:Play()

-- Completion
fillTween.Completed:Connect(function()
    msg.Text = "Ready! ✓"
    msg.TextColor3 = Color3.fromRGB(100, 255, 150)
    
    task.wait(0.5)

    -- Exit animation
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
        Size = 0
    }):Play()

    task.wait(0.5)
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
    safeLoad("https://pastebin.com/raw/3nxCf55f")
end)
