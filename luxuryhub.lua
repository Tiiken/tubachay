local S = Instance.new("ScreenGui")
S.Parent = game:GetService("CoreGui")

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local M = Instance.new("Frame", S)
local B = Instance.new("TextButton", S)
local T = Instance.new("TextLabel")

local TI = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local hitboxSize = 20
local hitboxTrans = 0.6
local ccLocked = false
local hitboxActive = false
local noclipActive = false
local godmodeActive = false
local aimbotActive = false
local mv = false

-- THIẾT LẬP AIMBOT BẢN TỐI ƯU CHỐNG ĐÌ
local FOV_RADIUS = 40 
local AIM_SPEED = 25 -- Tốc độ hút mượt (tính theo DeltaTime)

-- BIẾN QUẢN LÝ CẢM ỨNG & THỜI GIAN ĐỆM CHỐNG XUNG ĐỘT
local isTouchingRight = false
local lastTouchTime = 0
local activeTouches = {}

-- Hàm trang trí Bo góc & Viền
local function decorate(o, r, col, thick)
    local corner = Instance.new("UICorner", o)
    corner.CornerRadius = UDim.new(0, r or 8)
    if col then 
        local s = Instance.new("UIStroke", o) 
        s.Color = col
        s.Thickness = thick or 1.5 
    end
end

----------------------------------------------------------------------
-- 0. THÔNG BÁO CHÀO MỪNG (ĐÃ CẬP NHẬT NỘI DUNG MỚI)
local function showCustomNotif(titleText, bodyText, duration)
    local NotifFrame = Instance.new("Frame", S)
    NotifFrame.Size = UDim2.new(0, 260, 0, 65)
    NotifFrame.Position = UDim2.new(1, 10, 0.78, 0) 
    NotifFrame.BackgroundColor3 = Color3.fromRGB(248, 250, 255)
    NotifFrame.ClipsDescendants = true
    NotifFrame.ZIndex = 100
    decorate(NotifFrame, 12)

    local Icon = Instance.new("ImageLabel", NotifFrame)
    Icon.Size = UDim2.new(0, 42, 0, 42)
    Icon.Position = UDim2.new(0, 10, 0.5, -21)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://111581247806961"
    Icon.ZIndex = 101
    decorate(Icon, 8)

    local Title = Instance.new("TextLabel", NotifFrame)
    Title.Size = UDim2.new(1, -60, 0, 22)
    Title.Position = UDim2.new(0, 58, 0, 8)
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(0, 122, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.ZIndex = 101

    local Body = Instance.new("TextLabel", NotifFrame)
    Body.Size = UDim2.new(1, -60, 0, 28)
    Body.Position = UDim2.new(0, 58, 0, 28)
    Body.Text = bodyText
    Body.TextColor3 = Color3.fromRGB(60, 70, 85)
    Body.Font = Enum.Font.SourceSans
    Body.TextSize = 13
    Body.TextWrapped = true
    Body.TextXAlignment = Enum.TextXAlignment.Left
    Body.BackgroundTransparency = 1
    Body.ZIndex = 101

    task.delay(0.5, function()
        TS:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -270, 0.78, 0)
        }):Play()

        task.delay(duration or 4, function()
            local hideTween = TS:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 10, 0.78, 0)
            })
            hideTween:Play()
            hideTween.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end)
    end)
end

showCustomNotif("LUXURY HUB 👑", "Chào mừng các con ghệ tới với menu của anh ❄", 4)
----------------------------------------------------------------------

-- 1. NÚT MỞ MENU
B.Size = UDim2.new(0, 0, 0, 0)
B.Position = UDim2.new(0, 32, 0, 32)
B.AnchorPoint = Vector2.new(0.5, 0.5)
B.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
B.Text = "❄️"
B.TextColor3 = Color3.fromRGB(0, 122, 255)
B.Font = Enum.Font.SourceSansBold
B.TextSize = 20
decorate(B, 10, Color3.fromRGB(220, 225, 230))

TS:Create(B, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 45, 0, 45)
}):Play()

-- 2. KHUNG MENU CHÍNH
M.Size = UDim2.new(0, 0, 0, 0)
M.BackgroundColor3 = Color3.fromRGB(248, 250, 255)
M.Visible = false
M.ClipsDescendants = true
M.Position = UDim2.new(0.5, -95, 0.25, -85)
decorate(M, 14)

local MenuBg = Instance.new("ImageLabel", M)
MenuBg.Size = UDim2.new(1, 0, 1, 0)
MenuBg.Position = UDim2.new(0, 0, 0, 0)
MenuBg.BackgroundTransparency = 1
MenuBg.Image = "rbxassetid://111581247806961"
MenuBg.ScaleType = Enum.ScaleType.Crop
MenuBg.ZIndex = 1
decorate(MenuBg, 14)

local Overlay = Instance.new("Frame", M)
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.Position = UDim2.new(0, 0, 0, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Overlay.BackgroundTransparency = 0.65
Overlay.ZIndex = 2
decorate(Overlay, 14)

local OuterBorder = Instance.new("UIStroke", M)
OuterBorder.Color = Color3.fromRGB(255, 255, 255)
OuterBorder.Transparency = 0
OuterBorder.Thickness = 2.5
OuterBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

T.Parent = M
T.Size = UDim2.new(1, 0, 0, 30)
T.Position = UDim2.new(0, 0, 0, 4)
T.Text = "LUXURY HUB"
T.TextColor3 = Color3.fromRGB(40, 60, 90)
T.BackgroundTransparency = 1
T.Font = Enum.Font.SourceSansBold
T.TextSize = 11
T.ZIndex = 6

local function createComp(p, txt, pos, isSlider)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(0, 160, 0, isSlider and 45 or 28)
    f.Position = pos
    f.BackgroundTransparency = 1
    f.ZIndex = 6

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0, 100, 1, 0)
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(30, 40, 50)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    l.ZIndex = 6

    if not isSlider then
        local bg = Instance.new("TextButton", f)
        bg.Size = UDim2.new(0, 40, 0, 20)
        bg.Position = UDim2.new(1, -40, 0.5, -10)
        bg.BackgroundColor3 = Color3.fromRGB(200, 205, 215)
        bg.Text = ""
        bg.ZIndex = 6
        decorate(bg, 11)

        local c = Instance.new("Frame", bg)
        c.Size = UDim2.new(0, 16, 0, 16)
        c.Position = UDim2.new(0, 2, 0.5, -8)
        c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        c.ZIndex = 6
        decorate(c, 8)

        return bg, c
    else
        l.Size = UDim2.new(1, 0, 0, 12)
        local bar = Instance.new("Frame", f)
        bar.Size = UDim2.new(1, 0, 0, 6)
        bar.Position = UDim2.new(0, 0, 0, 18)
        bar.BackgroundColor3 = Color3.fromRGB(190, 200, 215)
        bar.ZIndex = 6
        decorate(bar, 3)

        local btn = Instance.new("TextButton", bar)
        btn.Size = UDim2.new(0, 14, 0, 14)
        btn.Position = UDim2.new(0.05, -7, 0.5, -7)
        btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        btn.Text = ""
        btn.ZIndex = 6
        decorate(btn, 7)

        return bar, btn, l
    end
end

local AimBG, AimC = createComp(M, "AIMBOT", UDim2.new(0, 15, 0, 32), false)
local HitboxBG, HitboxC = createComp(M, "HITBOX VIP", UDim2.new(0, 15, 0, 64), false)
local HitboxBar, HitboxBtn, HitboxTxt = createComp(M, "Cỡ Hitbox: 20", UDim2.new(0, 15, 0, 96), true)
local TransBar, TransBtn, TransTxt = createComp(M, "Độ mờ Hitbox: 60%", UDim2.new(0, 15, 0, 136), true)
TransBtn.Position = UDim2.new(0.6, -7, 0.5, -7)

local NoclipBG, NoclipC = createComp(M, "Xuyên Vật Thể", UDim2.new(0, 15, 0, 178), false)
local GodBG, GodC = createComp(M, "God Mode", UDim2.new(0, 15, 0, 210), false)

local LockButton = Instance.new("TextButton", M)
LockButton.Size = UDim2.new(0, 160, 0, 24)
LockButton.Position = UDim2.new(0, 15, 0, 244)
LockButton.BackgroundColor3 = Color3.fromRGB(230, 235, 245)
LockButton.Text = "Off Lock Menu"
LockButton.TextColor3 = Color3.fromRGB(80, 90, 105)
LockButton.Font = Enum.Font.SourceSansBold
LockButton.TextSize = 12
LockButton.ZIndex = 6
decorate(LockButton, 6)

B.MouseButton1Click:Connect(function() 
    mv = not mv 
    if mv then 
        M.Visible = true 
        TS:Create(M, TI, {Size = UDim2.new(0, 190, 0, 280)}):Play() 
    else 
        local ct = TS:Create(M, TI, {Size = UDim2.new(0, 0, 0, 0)}) 
        ct:Play() 
        ct.Completed:Connect(function() 
            if not mv then M.Visible = false end 
        end) 
    end 
end)

local function setupDrag(g)
    local d, s, p
    g.InputBegan:Connect(function(ip) 
        if (ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch) and not ccLocked then 
            d, s, p = true, ip.Position, g.Position 
        end 
    end)
    UIS.InputChanged:Connect(function(ip) 
        if d and (ip.UserInputType == Enum.UserInputType.MouseMovement or ip.UserInputType == Enum.UserInputType.Touch) and not ccLocked then 
            local dl = ip.Position - s 
            g.Position = UDim2.new(p.X.Scale, p.X.Offset + dl.X, p.Y.Scale, p.Y.Offset + dl.Y) 
        end 
    end)
    UIS.InputEnded:Connect(function(ip) 
        if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then 
            d = false 
        end 
    end)
end
setupDrag(B)
setupDrag(M)

local function setupSlider(btn, bar, cb)
    local sDrag = false 
    btn.InputBegan:Connect(function(ip) 
        if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then 
            sDrag = true 
        end 
    end)
    UIS.InputEnded:Connect(function(ip) 
        if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then 
            sDrag = false 
        end 
    end)
    UIS.InputChanged:Connect(function(ip) 
        if sDrag and ip.Position.X then 
            local pct = math.clamp((ip.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1) 
            btn.Position = UDim2.new(pct, -7, 0.5, -7) 
            cb(pct) 
        end 
    end)
end

setupSlider(HitboxBtn, HitboxBar, function(pct) 
    hitboxSize = math.floor(10 + (pct * 50)) 
    HitboxTxt.Text = "Cỡ Hitbox: " .. hitboxSize 
end)

setupSlider(TransBtn, TransBar, function(pct) 
    hitboxTrans = pct 
    TransTxt.Text = "Độ mờ Hitbox: " .. math.floor(pct * 100) .. "%" 
end)

AimBG.MouseButton1Click:Connect(function() 
    aimbotActive = not aimbotActive 
    TS:Create(AimBG, TweenInfo.new(0.12), {BackgroundColor3 = aimbotActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(AimC, TweenInfo.new(0.12), {Position = aimbotActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play() 
end)

HitboxBG.MouseButton1Click:Connect(function() 
    hitboxActive = not hitboxActive 
    TS:Create(HitboxBG, TweenInfo.new(0.12), {BackgroundColor3 = hitboxActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(HitboxC, TweenInfo.new(0.12), {Position = hitboxActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play() 
end)

NoclipBG.MouseButton1Click:Connect(function() 
    noclipActive = not noclipActive 
    TS:Create(NoclipBG, TweenInfo.new(0.12), {BackgroundColor3 = noclipActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(NoclipC, TweenInfo.new(0.12), {Position = noclipActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play() 
end)

GodBG.MouseButton1Click:Connect(function() 
    godmodeActive = not godmodeActive 
    TS:Create(GodBG, TweenInfo.new(0.12), {BackgroundColor3 = godmodeActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(GodC, TweenInfo.new(0.12), {Position = godmodeActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play() 
end)

LockButton.MouseButton1Click:Connect(function() 
    ccLocked = not ccLocked 
    LockButton.Text = ccLocked and "Lock Menu" or "Off Lock Menu" 
    LockButton.BackgroundColor3 = ccLocked and Color3.fromRGB(40, 180, 100) or Color3.fromRGB(230, 235, 245) 
    LockButton.TextColor3 = ccLocked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 90, 105) 
end)

----------------------------------------------------------------------
-- BỘ NHẬN DIỆN CẢM ỨNG CÓ TÍNH NĂNG NHẢ LỰC LẬP TỨC
local function updateTouchState(ip, isBegan)
    local screenWidth = Camera.ViewportSize.X
    if ip.Position.X >= (screenWidth / 2) then
        if isBegan then
            activeTouches[ip] = true
            isTouchingRight = true
            lastTouchTime = tick()
        else
            activeTouches[ip] = nil
            if next(activeTouches) == nil then
                isTouchingRight = false
                lastTouchTime = tick()
            end
        end
    end
end

UIS.InputBegan:Connect(function(ip, gameProcessed)
    if gameProcessed then return end
    if ip.UserInputType == Enum.UserInputType.Touch or ip.UserInputType == Enum.UserInputType.MouseButton1 then
        updateTouchState(ip, true)
    end
end)

UIS.InputChanged:Connect(function(ip, gameProcessed)
    if gameProcessed then return end
    if ip.UserInputType == Enum.UserInputType.Touch or ip.UserInputType == Enum.UserInputType.MouseMovement then
        if activeTouches[ip] then
            lastTouchTime = tick()
        end
    end
end)

UIS.InputEnded:Connect(function(ip)
    if ip.UserInputType == Enum.UserInputType.Touch or ip.UserInputType == Enum.UserInputType.MouseButton1 then
        updateTouchState(ip, false)
    end
end)

----------------------------------------------------------------------
-- LOGIC AIMBOT MƯỢT MÀ - KHÔNG CHÈN ÉP THAO TÁC TAY
local function getClosestTarget()
    local closest, minDist = nil, FOV_RADIUS
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local targetPart = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and targetPart then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = targetPart
                    end
                end
            end
        end
    end
    return closest
end

-- VÒNG LẶP AIMBOT CHỐNG ĐÌ TAY
RS.RenderStepped:Connect(function(deltaTime)
    if aimbotActive and not isTouchingRight and (tick() - lastTouchTime > 0.08) then
        local target = getClosestTarget()
        if target then
            local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, math.clamp(AIM_SPEED * deltaTime, 0, 0.95))
        end
    end
end)

-- NOCLIP LOGIC
RS.Stepped:Connect(function() 
    if noclipActive and LocalPlayer.Character then 
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do 
            if part:IsA("BasePart") then part.CanCollide = false end 
        end 
    end 
end)

-- GOD MODE LOGIC
RS.Heartbeat:Connect(function()
    if godmodeActive then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum then
                    hum.Health = hum.MaxHealth
                    hum.PlatformStanding = false
                    hum.Sit = false
                    if hum:GetState() == Enum.HumanoidStateType.Ragdoll or hum:GetState() == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
                if root then
                    root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    end
end)

-- HITBOX LOGIC
task.spawn(function() 
    while task.wait(0.3) do 
        pcall(function() 
            local myChar = LocalPlayer.Character 
            for _, obj in ipairs(workspace:GetDescendants()) do 
                if obj:IsA("Model") and obj ~= myChar then 
                    local root, hum = obj:FindFirstChild("HumanoidRootPart"), obj:FindFirstChildOfClass("Humanoid") 
                    if root and hum and hum.Health > 0 then 
                        if hitboxActive then 
                            local scaledSize = hitboxSize * 2.5 
                            root.Size = Vector3.new(scaledSize, scaledSize, scaledSize) 
                            root.Transparency = hitboxTrans 
                            root.Color = Color3.fromRGB(255, 0, 0) 
                            root.Material = Enum.Material.Neon 
                            root.CanCollide = false 
                            root.CanTouch = true 
                        else 
                            root.Size = Vector3.new(2, 2, 1) 
                            root.Transparency = 1 
                            root.CanCollide = false 
                        end 
                    end 
                end 
            end 
        end) 
    end 
end)
