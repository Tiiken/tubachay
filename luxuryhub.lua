-- =====================================================================
-- TÚ BÁ CHÁY HUB - SMOOTH TOGGLE COLOR ANIMATION (2026)
-- =====================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local GUI_NAME = "TubaChaySmoothToggleGui"
if PlayerGui:FindFirstChild(GUI_NAME) then
    PlayerGui[GUI_NAME]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 9999999
ScreenGui.Parent = PlayerGui

local isMenuOpen = false 

-- HÀM THIẾT KẾ VIỀN XANH THAN
local function applyDesign(element, radius, strokeColor, strokeThickness)
    local corner = Instance.new("UICorner", element)
    corner.CornerRadius = UDim.new(0, radius or 6)
    
    local stroke = Instance.new("UIStroke", element)
    stroke.Color = strokeColor or Color3.fromRGB(35, 65, 100)
    stroke.Thickness = strokeThickness or 1
    stroke.Transparency = 0.2
end

-- NÚT MỞ/ĐÓNG MENU (XANH THAN)
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 0, 0, 0)
ToggleButton.Position = UDim2.new(0, 16, 0, 65)
ToggleButton.BackgroundColor3 = Color3.fromRGB(12, 18, 28)
ToggleButton.Text = ""
ToggleButton.ZIndex = 99999
applyDesign(ToggleButton, 8, Color3.fromRGB(45, 80, 120), 1.5)

TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 36, 0, 36)
}):Play()

local ToggleIcon = Instance.new("TextLabel", ToggleButton)
ToggleIcon.Size = UDim2.new(1, 0, 1, 0)
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Text = "❄️"
ToggleIcon.TextSize = 16
ToggleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.ZIndex = 100000

-- KHUNG MENU CHÍNH (NỀN ĐEN TUYỀN, VIỀN XANH THAN, CĂN NGANG Y = 65)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0, 58, 0, 65)
MainFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
MainFrame.ClipsDescendants = true 
MainFrame.Visible = false
MainFrame.ZIndex = 1000
applyDesign(MainFrame, 10, Color3.fromRGB(35, 65, 100), 1.5)

-- CONTAINER CHỨA NỘI DUNG VÀ HIỆU ỨNG RƠI CHẬM
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(0, 200, 0, 250)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 1001
ContentContainer.ClipsDescendants = true 

-- =====================================================================
-- HỆ THỐNG HIỆU ỨNG RƠI CHẬM KIỂU LÁ BAY (GENTLE FALLING)
-- =====================================================================
local snowFlakes = {}
local maxSnow = 14 

for i = 1, maxSnow do
    local flake = Instance.new("Frame", ContentContainer)
    flake.Size = UDim2.new(0, math.random(3, 5), 0, math.random(3, 5)) 
    flake.BackgroundColor3 = Color3.fromRGB(200, 220, 240)
    flake.BackgroundTransparency = math.random(40, 75) / 100
    flake.BorderSizePixel = 0
    flake.ZIndex = 1002
    
    applyDesign(flake, 2, Color3.fromRGB(255, 255, 255), 0)

    table.insert(snowFlakes, {
        object = flake,
        x = math.random(10, 190),
        y = math.random(-250, 0),
        speed = math.random(8, 16) / 10, 
        amplitude = math.random(15, 30), 
        frequency = math.random(5, 12) / 10  
    })
end

RunService.RenderStepped:Connect(function(dt)
    if not isMenuOpen then return end
    
    for _, flake in ipairs(snowFlakes) do
        flake.y = flake.y + flake.speed * (dt * 60)
        local xOffset = math.sin(tick() * flake.frequency + flake.y * 0.03) * flake.amplitude
        
        if flake.y > 250 then
            flake.y = math.random(-40, 0)
            flake.x = math.random(10, 190)
        end
        
        flake.object.Position = UDim2.new(0, flake.x + xOffset, 0, flake.y)
    end
end)
-- =====================================================================

-- TIÊU ĐỀ
local TitleLabel = Instance.new("TextLabel", ContentContainer)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Position = UDim2.new(0, 0, 0, 2)
TitleLabel.Text = "TÚ BÁ CHÁY HUB"
TitleLabel.TextColor3 = Color3.fromRGB(130, 180, 230)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 12
TitleLabel.BackgroundTransparency = 1
TitleLabel.ZIndex = 1005

-- HÀM TẠO COMPONENT
local function createComponent(parent, text, posY, isSlider, initialPercentage)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(0, isSlider and 176 or 172, 0, isSlider and 38 or 26)
    container.Position = UDim2.new(0, 14, 0, posY)
    container.BackgroundTransparency = 1
    container.ZIndex = 1003

    local labelButton = Instance.new("TextButton", container)
    labelButton.Size = UDim2.new(0, 110, 1, 0)
    labelButton.Text = text
    labelButton.TextColor3 = Color3.fromRGB(170, 190, 210)
    labelButton.Font = Enum.Font.GothamSemibold
    labelButton.TextSize = 11
    labelButton.TextXAlignment = Enum.TextXAlignment.Left
    labelButton.BackgroundTransparency = 1
    labelButton.ZIndex = 1010
    labelButton.AutoButtonColor = false

    if not isSlider then
        local toggleBg = Instance.new("TextButton", container)
        toggleBg.Size = UDim2.new(0, 34, 0, 18)
        toggleBg.Position = UDim2.new(1, -34, 0.5, -9)
        toggleBg.BackgroundColor3 = Color3.fromRGB(14, 20, 32)
        toggleBg.Text = ""
        toggleBg.ZIndex = 1004
        applyDesign(toggleBg, 6, Color3.fromRGB(35, 65, 100), 1)

        local toggleCircle = Instance.new("Frame", toggleBg)
        toggleCircle.Size = UDim2.new(0, 12, 0, 12)
        toggleCircle.Position = UDim2.new(0, 3, 0.5, -6)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(50, 110, 170)
        toggleCircle.ZIndex = 1005
        applyDesign(toggleCircle, 4, Color3.fromRGB(100, 160, 220), 1)
        
        return toggleBg, toggleCircle, labelButton
    else
        labelButton.Size = UDim2.new(1, 0, 0, 10)
        labelButton.Active = false
        
        local sliderBar = Instance.new("Frame", container)
        sliderBar.Size = UDim2.new(1, 0, 0, 4)
        sliderBar.Position = UDim2.new(0, 0, 0, 20)
        sliderBar.BackgroundColor3 = Color3.fromRGB(14, 20, 32)
        sliderBar.ZIndex = 1020 
        applyDesign(sliderBar, 2, Color3.fromRGB(35, 65, 100), 1)

        local sliderBtn = Instance.new("TextButton", sliderBar)
        sliderBtn.Size = UDim2.new(0, 12, 0, 12)
        sliderBtn.AnchorPoint = Vector2.new(0.5, 0.5)
        sliderBtn.Position = UDim2.new(initialPercentage, 0, 0.5, 0)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(50, 110, 170)
        sliderBtn.Text = ""
        sliderBtn.ZIndex = 1025 
        applyDesign(sliderBtn, 4, Color3.fromRGB(100, 160, 220), 1)
        
        return sliderBar, sliderBtn, labelButton
    end
end

-- KHỞI TẠO NÚT BẤM VÀ SLIDER
local Btn1_BG, Btn1_Circle, Btn1_Text = createComponent(ContentContainer, "NÚT BẤM 1", 34, false, 0)
local Btn2_BG, Btn2_Circle, Btn2_Text = createComponent(ContentContainer, "NÚT BẤM 2", 64, false, 0)
local Btn3_BG, Btn3_Circle, Btn3_Text = createComponent(ContentContainer, "NÚT BẤM 3", 94, false, 0)

local Slider1_Bar, Slider1_Btn, Slider1_Text = createComponent(ContentContainer, "Slider 1: 0%", 126, true, 0)
local Slider2_Bar, Slider2_Btn, Slider2_Text = createComponent(ContentContainer, "Slider 2: 0%", 168, true, 0)

local Btn4_BG, Btn4_Circle, Btn4_Text = createComponent(ContentContainer, "NÚT BẤM 4", 210, false, 0)

-- SỰ KIỆN MỞ/ĐÓNG VỚI HIỆU ỨNG ĐỔI MÀU NÚT BẬT/TẮT CỰC KỲ MƯỢT MÀ (SINE)
local openTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local closeTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
-- Dùng Sine để màu chuyển đổi lướt thướt, êm ái hơn
local smoothColorTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

ToggleButton.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, openTweenInfo, {
            Size = UDim2.new(0, 200, 0, 250)
        }):Play()
        -- Nút bật tắt đổi sang màu xanh sáng mượt mà
        TweenService:Create(ToggleButton, smoothColorTweenInfo, {BackgroundColor3 = Color3.fromRGB(28, 55, 95)}):Play()
    else
        local tw = TweenService:Create(MainFrame, closeTweenInfo, {
            Size = UDim2.new(0, 0, 0, 0)
        })
        tw:Play()
        tw.Completed:Connect(function()
            if not isMenuOpen then MainFrame.Visible = false end
        end)
        -- Nút bật tắt từ từ đổi lại màu tối ban đầu rất êm
        TweenService:Create(ToggleButton, smoothColorTweenInfo, {BackgroundColor3 = Color3.fromRGB(12, 18, 28)}):Play()
    end
end)

-- HIỆU ỨNG GẠT NÚT XANH THAN
local function animateToggle(background, circle, state)
    TweenService:Create(background, TweenInfo.new(0.15), {
        BackgroundColor3 = state and Color3.fromRGB(30, 70, 120) or Color3.fromRGB(14, 20, 32)
    }):Play()
    TweenService:Create(circle, TweenInfo.new(0.15), {
        Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), 
        BackgroundColor3 = state and Color3.fromRGB(180, 220, 255) or Color3.fromRGB(50, 110, 170)
    }):Play()
end

local state1, state2, state3, state4 = false, false, false, false
Btn1_BG.MouseButton1Click:Connect(function() state1 = not state1 animateToggle(Btn1_BG, Btn1_Circle, state1) end)
Btn2_BG.MouseButton1Click:Connect(function() state2 = not state2 animateToggle(Btn2_BG, Btn2_Circle, state2) end)
Btn3_BG.MouseButton1Click:Connect(function() state3 = not state3 animateToggle(Btn3_BG, Btn3_Circle, state3) end)
Btn4_BG.MouseButton1Click:Connect(function() state4 = not state4 animateToggle(Btn4_BG, Btn4_Circle, state4) end)

-- SLIDER LOGIC
local activeSliderButton = nil

local function updateSlider(input, sliderBtn, sliderBar, textLabel, prefix)
    pcall(function()
        local percentage = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        sliderBtn.Position = UDim2.new(percentage, 0, 0.5, 0)
        local value = math.floor(percentage * 100)
        textLabel.Text = prefix .. ": " .. value .. "%"
    end)
end

local function initSliderEvents(sliderBtn, sliderBar, textLabel, prefix)
    sliderBtn.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and activeSliderButton == nil then 
            activeSliderButton = sliderBtn
        end
    end)
    
    sliderBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and activeSliderButton == nil then
            activeSliderButton = sliderBtn
            updateSlider(input, sliderBtn, sliderBar, textLabel, prefix)
        end
    end)
end

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        activeSliderButton = nil 
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if activeSliderButton and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        if activeSliderButton == Slider1_Btn then
            updateSlider(input, Slider1_Btn, Slider1_Bar, Slider1_Text, "Slider 1")
        elseif activeSliderButton == Slider2_Btn then
            updateSlider(input, Slider2_Btn, Slider2_Bar, Slider2_Text, "Slider 2")
        end
    end
end)

initSliderEvents(Slider1_Btn, Slider1_Bar, Slider1_Text, "Slider 1")
initSliderEvents(Slider2_Btn, Slider2_Bar, Slider2_Text, "Slider 2")

print("[TubaHub] Smooth Toggle Color Animation Loaded Successfully!")
