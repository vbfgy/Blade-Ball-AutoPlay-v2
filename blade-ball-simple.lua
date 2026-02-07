--[[
    Blade Ball - Simple Test Version
    Простая версия для проверки работоспособности
]]

-- Ждем загрузки игрока
repeat task.wait() until game.Players.LocalPlayer
local LocalPlayer = game.Players.LocalPlayer
repeat task.wait() until LocalPlayer.Character
task.wait(1)

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

print("🚀 Blade Ball AutoPlay - Loading...")

-- Настройки
local Settings = {
    AutoPlayEnabled = false,
    ParryDistance = 18,
    ParryTiming = 0.55,
}

-- Состояние
local IsParrying = false
local LastParryTime = 0

-- Удаление старого GUI
pcall(function()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    if playerGui:FindFirstChild("BladeBallGUI") then
        playerGui:FindFirstChild("BladeBallGUI"):Destroy()
    end
end)

task.wait(0.5)

-- Создание простого GUI
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeBallGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Title.Text = "⚔️ BLADE BALL - TEST"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Главная кнопка
local AutoPlayBtn = Instance.new("TextButton")
AutoPlayBtn.Size = UDim2.new(1, -40, 0, 60)
AutoPlayBtn.Position = UDim2.new(0, 20, 0, 60)
AutoPlayBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
AutoPlayBtn.Text = "▶️ START AUTO PLAY"
AutoPlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoPlayBtn.TextSize = 18
AutoPlayBtn.Font = Enum.Font.GothamBold
AutoPlayBtn.BorderSizePixel = 0
AutoPlayBtn.Parent = MainFrame

local AutoPlayCorner = Instance.new("UICorner")
AutoPlayCorner.CornerRadius = UDim.new(0, 10)
AutoPlayCorner.Parent = AutoPlayBtn

-- Статус
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 30)
StatusLabel.Position = UDim2.new(0, 20, 0, 140)
StatusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
StatusLabel.Text = "⚪ IDLE - Ready to start"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.BorderSizePixel = 0
StatusLabel.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

-- Функции
local function GetBall()
    local ballsFolder = Workspace:FindFirstChild("Balls")
    if ballsFolder then
        for _, ball in pairs(ballsFolder:GetChildren()) do
            if ball:GetAttribute("realBall") == true or ball:IsA("BasePart") then
                return ball
            end
        end
        if #ballsFolder:GetChildren() > 0 then
            return ballsFolder:GetChildren()[1]
        end
    end
    return nil
end

local function GetDistance(ball)
    if not ball or not LocalPlayer.Character then return math.huge end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return math.huge end
    return (ball.Position - hrp.Position).Magnitude
end

local function IsBallComingToMe(ball)
    if not ball then return false end
    local target = ball:GetAttribute("target")
    return target == LocalPlayer.Name
end

local function Parry()
    if IsParrying then return end
    if tick() - LastParryTime < 0.3 then return end
    
    IsParrying = true
    LastParryTime = tick()
    
    task.spawn(function()
        pcall(function()
            -- Парирование
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            
            print("⚔️ Parried!")
        end)
        
        task.wait(0.3)
        IsParrying = false
    end)
end

local function StartAutoPlay()
    print("✅ AutoPlay STARTED!")
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoPlayEnabled then 
            connection:Disconnect()
            return 
        end
        
        pcall(function()
            local ball = GetBall()
            if not ball then 
                StatusLabel.Text = "⚪ IDLE - No ball found"
                return 
            end
            
            local distance = GetDistance(ball)
            local isComingToMe = IsBallComingToMe(ball)
            
            if isComingToMe then
                StatusLabel.Text = string.format("🎯 Ball coming! Distance: %.0f", distance)
                
                if distance <= Settings.ParryDistance then
                    StatusLabel.Text = "⚔️ PARRYING!"
                    if not IsParrying then
                        Parry()
                    end
                end
            else
                StatusLabel.Text = "👀 Watching ball..."
            end
        end)
    end)
end

local function StopAutoPlay()
    Settings.AutoPlayEnabled = false
    StatusLabel.Text = "⛔ STOPPED"
    print("🛑 AutoPlay STOPPED")
end

-- Обработчик кнопки
AutoPlayBtn.MouseButton1Click:Connect(function()
    Settings.AutoPlayEnabled = not Settings.AutoPlayEnabled
    
    if Settings.AutoPlayEnabled then
        AutoPlayBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        AutoPlayBtn.Text = "⏸️ STOP AUTO PLAY"
        StartAutoPlay()
    else
        AutoPlayBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
        AutoPlayBtn.Text = "▶️ START AUTO PLAY"
        StopAutoPlay()
    end
end)

print("✅ Blade Ball AutoPlay loaded!")
print("📌 Click 'START AUTO PLAY' to begin")