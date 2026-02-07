--[[
    Blade Ball - Verification System (New)
    Discord: https://discord.gg/EFEkgZQFcQ
]]

-- Ждем загрузки игрока
repeat task.wait() until game.Players.LocalPlayer
local LocalPlayer = game.Players.LocalPlayer

local HttpService = game:GetService("HttpService")

-- Настройки верификации
local VerificationSettings = {
    DiscordLink = "https://discord.gg/EFEkgZQFcQ",
    ValidKey = "V67hBYN_189BH",
    SavedKeyFile = "BladeBall_SavedKey.txt",
}

-- Проверка сохраненного ключа
local function GetSavedKey()
    local success, result = pcall(function()
        return readfile(VerificationSettings.SavedKeyFile)
    end)
    if success and result then
        return result
    end
    return nil
end

local function SaveKey(key)
    pcall(function()
        writefile(VerificationSettings.SavedKeyFile, key)
    end)
end

local function ValidateKey(key)
    if not key or key == "" then
        return false
    end
    return key == VerificationSettings.ValidKey
end

-- Проверяем сохраненный ключ
local savedKey = GetSavedKey()
if savedKey and ValidateKey(savedKey) then
    print("✅ Saved key validated! Loading script...")
    -- Загружаем основной скрипт
    local timestamp = tick()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vbfgy/Blade-Ball-AutoPlay-v2/refs/heads/main/blade-ball-simple.lua?t=" .. timestamp))()
    return
end

-- Ждем PlayerGui
repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")
local playerGui = LocalPlayer.PlayerGui

-- Удаляем старый GUI если есть
pcall(function()
    if playerGui:FindFirstChild("VerificationGUI") then
        playerGui:FindFirstChild("VerificationGUI"):Destroy()
    end
end)

task.wait(0.3)

-- Создание GUI верификации
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VerificationGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- Затемнение фона
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 0.5
Overlay.BorderSizePixel = 0
Overlay.Parent = ScreenGui

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 50)
Title.Position = UDim2.new(0, 20, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "⚔️ BLADE BALL - VERIFICATION"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Подзаголовок
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -40, 0, 30)
Subtitle.Position = UDim2.new(0, 20, 0, 70)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Join our Discord to get your key!"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.TextSize = 14
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = MainFrame

-- Discord кнопка
local DiscordBtn = Instance.new("TextButton")
DiscordBtn.Size = UDim2.new(1, -40, 0, 40)
DiscordBtn.Position = UDim2.new(0, 20, 0, 110)
DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordBtn.Text = "📱 JOIN DISCORD SERVER"
DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordBtn.TextSize = 14
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.BorderSizePixel = 0
DiscordBtn.Parent = MainFrame

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 8)
DiscordCorner.Parent = DiscordBtn

-- Поле ввода ключа
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.new(0, 20, 0, 170)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Enter key: V67hBYN_189BH"
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.BorderSizePixel = 0
KeyBox.Parent = MainFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

-- Кнопка верификации
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(1, -40, 0, 40)
VerifyBtn.Position = UDim2.new(0, 20, 0, 220)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
VerifyBtn.Text = "✅ VERIFY KEY"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.TextSize = 16
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.BorderSizePixel = 0
VerifyBtn.Parent = MainFrame

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 8)
VerifyCorner.Parent = VerifyBtn

-- Статус сообщение
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 20)
StatusLabel.Position = UDim2.new(0, 20, 0, 270)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Parent = MainFrame

-- Функция копирования ссылки в буфер обмена
local function CopyToClipboard(text)
    if setclipboard then
        setclipboard(text)
        return true
    end
    return false
end

-- Обработчик Discord кнопки
DiscordBtn.MouseButton1Click:Connect(function()
    if CopyToClipboard(VerificationSettings.DiscordLink) then
        StatusLabel.Text = "✅ Discord link copied to clipboard!"
        StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
    else
        StatusLabel.Text = "📱 Discord: " .. VerificationSettings.DiscordLink
        StatusLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
    end
    
    task.delay(3, function()
        if StatusLabel then
            StatusLabel.Text = ""
        end
    end)
end)

-- Обработчик верификации
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    
    if key == "" then
        StatusLabel.Text = "❌ Please enter a key!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    VerifyBtn.Text = "⏳ VERIFYING..."
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    StatusLabel.Text = "Checking key..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
    
    task.wait(1)
    
    if ValidateKey(key) then
        -- Успешная верификация
        VerifyBtn.Text = "✅ VERIFIED!"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
        StatusLabel.Text = "✅ Key verified! Loading script..."
        StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 100)
        
        -- Сохраняем ключ
        SaveKey(key)
        
        task.wait(1)
        
        -- Удаляем GUI верификации
        ScreenGui:Destroy()
        
        -- Загружаем основной скрипт
        print("✅ Verification successful! Loading Blade Ball AutoPlay...")
        
        -- Загрузка с GitHub (с обходом кэша)
        local timestamp = tick()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vbfgy/Blade-Ball-AutoPlay-v2/refs/heads/main/blade-ball-simple.lua?t=" .. timestamp))()
        
    else
        -- Неверный ключ
        VerifyBtn.Text = "❌ INVALID KEY"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        StatusLabel.Text = "❌ Invalid key! Use: V67hBYN_189BH"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        task.wait(2)
        
        VerifyBtn.Text = "✅ VERIFY KEY"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
    end
end)

-- Обработка Enter в поле ввода
KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyBtn.MouseButton1Click:Fire()
    end
end)

print("🔐 Verification system loaded!")
print("📱 Discord: " .. VerificationSettings.DiscordLink)
print("🔑 Key: V67hBYN_189BH")
