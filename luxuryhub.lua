-- LUXURY HUB - HEAD SHOT AIMBOT
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("LuxuryHubGui") then
    CoreGui.LuxuryHubGui:Destroy()
end

local S = Instance.new("ScreenGui")
S.Name = "LuxuryHubGui"
S.Parent = CoreGui

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
local aimbotActive = false
local espActive = false
local mv = false

local isDraggingRightSide = false
local touchStartTime = 0
local touchStartPosition = Vector2.zero

----------------------------------------------------------------------
-- THIẾT LẬP AIMBOT: KHÓA CHÍNH XÁC VÀO ĐẦU (HEAD)
----------------------------------------------------------------------
local FOV_RADIUS = 75           
local currentLockedTarget = nil 

local function decorate(o, r, col, thick)
    if not o then return end
    local corner = Instance.new("UICorner", o)
    corner.CornerRadius = UDim.new(0, r or 8)
    if col then 
        local s = Instance.new("UIStroke", o) 
        s.Color = col
        s.Thickness = thick or 1.5 
    end
end

-- Thông báo
local function showCustomNotif(titleText, bodyText, duration)
    pcall(function()
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
            if NotifFrame and NotifFrame.Parent then
                TS:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -270, 0.78, 0)
                }):Play()

                task.delay(duration or 4, function()
                    if NotifFrame and NotifFrame.Parent then
                        local hideTween = TS:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Position = UDim2.new(1, 10, 0.78, 0)
                        })
                        hideTween:Play()
                        hideTween.Completed:Connect(function()
                            NotifFrame:Destroy()
                        end)
                    end
                end)
            end
        end)
    end)
end

showCustomNotif("LUXURY HUB 👑", "Đã tải thành công! 🎯", 4)

-- Giao diện Menu
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

M.Size = UDim2.new(0, 0, 0, 0)
M.BackgroundColor3 = Color3.fromRGB(248, 250, 255)
M.Visible = false
M.ClipsDescendants = true
M.Position = UDim2.new(0.5, -95, 0.25, -85)
decorate(M, 14)

local MenuBg = Instance.new("ImageLabel", M)
MenuBg.Size = UDim2.new(1, 0, 1, 0)
MenuBg.BackgroundTransparency = 1
MenuBg.Image = "rbxassetid://111581247806961"
MenuBg.ScaleType = Enum.ScaleType.Crop
MenuBg.ZIndex = 1
decorate(MenuBg, 14)

local Overlay = Instance.new("Frame", M)
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Overlay.BackgroundTransparency = 0.65
Overlay.ZIndex = 2
decorate(Overlay, 14)

local OuterBorder = Instance.new("UIStroke", M)
OuterBorder.Color = Color3.fromRGB(255, 255, 255)
OuterBorder.Thickness = 2.5

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
local EspBG, EspC = createComp(M, "ESP Chấm Đỏ", UDim2.new(0, 15, 0, 64), false)
local HitboxBG, HitboxC = createComp(M, "HITBOX VIP", UDim2.new(0, 15, 0, 96), false)
local HitboxBar, HitboxBtn, HitboxTxt = createComp(M, "Cỡ Hitbox: 20", UDim2.new(0, 15, 0, 128), true)
local TransBar, TransBtn, TransTxt = createComp(M, "Độ mờ Hitbox: 60%", UDim2.new(0, 15, 0, 168), true)
TransBtn.Position = UDim2.new(0.6, -7, 0.5, -7)

local NoclipBG, NoclipC = createComp(M, "Xuyên Vật Thể", UDim2.new(0, 15, 0, 210), false)

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
        TS:Create(M, TI, {Size = UDim2.new(0, 190, 0, 278)}):Play() 
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
    if not aimbotActive then currentLockedTarget = nil end
    TS:Create(AimBG, TweenInfo.new(0.12), {BackgroundColor3 = aimbotActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(AimC, TweenInfo.new(0.12), {Position = aimbotActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play() 
end)

EspBG.MouseButton1Click:Connect(function() 
    espActive = not espActive 
    TS:Create(EspBG, TweenInfo.new(0.12), {BackgroundColor3 = espActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(EspC, TweenInfo.new(0.12), {Position = espActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play() 
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

LockButton.MouseButton1Click:Connect(function() 
    ccLocked = not ccLocked 
    LockButton.Text = ccLocked and "Lock Menu" or "Off Lock Menu" 
    LockButton.BackgroundColor3 = ccLocked and Color3.fromRGB(40, 180, 100) or Color3.fromRGB(230, 235, 245) 
    LockButton.TextColor3 = ccLocked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 90, 105) 
end)

----------------------------------------------------------------------
-- LOGIC KIỂM SOÁT BÊN PHẢI MÀN HÌNH
----------------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X >= (Camera.ViewportSize.X / 2) then
            touchStartTime = tick()
            touchStartPosition = Vector2.new(input.Position.X, input.Position.Y)
            isDraggingRightSide = false 
        end
    end
end)

UIS.InputChanged:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X >= (Camera.ViewportSize.X / 2) then
            local currentPos = Vector2.new(input.Position.X, input.Position.Y)
            if (currentPos - touchStartPosition).Magnitude > 10 then
                isDraggingRightSide = true
                currentLockedTarget = nil
            end
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingRightSide = false
    end
end)

-- ESP Chấm đỏ
local function createRedDotESP(player)
    if player == LocalPlayer then return end
    local function applyESP(character)
        if not character then return end
        task.spawn(function()
            local head = character:WaitForChild("Head", 10)
            local hum = character:WaitForChild("Humanoid", 10)
            if not head or not hum then return end
            if head:FindFirstChild("LuxuryRedDotESP") then head.LuxuryRedDotESP:Destroy() end

            local bgui = Instance.new("BillboardGui")
            bgui.Name = "LuxuryRedDotESP"
            bgui.Adornee = head
            bgui.Size = UDim2.new(0, 3, 0, 3)
            bgui.AlwaysOnTop = true
            bgui.ExtentsOffset = Vector3.new(0, 0.5, 0)
            bgui.Parent = head

            local dot = Instance.new("Frame", bgui)
            dot.Size = UDim2.new(1, 0, 1, 0)
            dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            dot.BorderSizePixel = 0
            local corner = Instance.new("UICorner", dot)
            corner.CornerRadius = UDim.new(1, 0)

            local connection
            connection = RS.RenderStepped:Connect(function()
                if not bgui or not bgui.Parent or not character or not character.Parent or hum.Health <= 0 then
                    if bgui then bgui.Enabled = false end
                    if connection then connection:Disconnect() end
                    return
                end
                bgui.Enabled = espActive
            end)
        end)
    end
    if player.Character then applyESP(player.Character) end
    player.CharacterAdded:Connect(applyESP)
end

for _, p in ipairs(Players:GetPlayers()) do createRedDotESP(p) end
Players.PlayerAdded:Connect(createRedDotESP)

----------------------------------------------------------------------
-- HÀM TÌM KIẾM MỤC TIÊU (ĐẦU)
----------------------------------------------------------------------
local function getClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if currentLockedTarget and currentLockedTarget.Parent then
        local character = currentLockedTarget.Parent
        local hum = character:FindFirstChildOfClass("Humanoid")
        local head = character:FindFirstChild("Head")
        
        if hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead and head then
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen and pos.Z > 0 then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist <= (FOV_RADIUS * 1.5) then
                    return head.Position
                end
            end
        end
    end

    currentLockedTarget = nil
    local closestTargetPos, minDist = nil, FOV_RADIUS

    for _, p in ipairs(Players:GetPlayers()) do
        pcall(function()
            if p ~= LocalPlayer and p.Character and p.Character:IsDescendantOf(workspace) then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local head = p.Character:FindFirstChild("Head")
                
                if hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead and head then
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen and pos.Z > 0 then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closestTargetPos = head.Position
                            currentLockedTarget = head
                        end
                    end
                end
            end
        end)
    end

    return closestTargetPos
end

----------------------------------------------------------------------
-- VÒNG LẶP AIMBOT
----------------------------------------------------------------------
RS.RenderStepped:Connect(function(deltaTime)
    if aimbotActive then
        pcall(function()
            if isDraggingRightSide then
                currentLockedTarget = nil
                return
            end

            local targetPosition = getClosestTarget()
            if targetPosition then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)
            else
                currentLockedTarget = nil
            end
        end)
    else
        currentLockedTarget = nil
    end
end)

----------------------------------------------------------------------
-- CÁC TÍNH NĂNG PHỤ TRỢ (NOCLIP & HITBOX)
----------------------------------------------------------------------
RS.Stepped:Connect(function() 
    if noclipActive then 
        pcall(function()
            if LocalPlayer.Character then 
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do 
                    if part:IsA("BasePart") then part.CanCollide = false end 
                end 
            end 
        end)
    end 
end)

task.spawn(function() 
    while task.wait(0.4) do 
        pcall(function() 
            local myChar = LocalPlayer.Character 
            for _, obj in ipairs(workspace:GetDescendants()) do 
                if obj:IsA("Model") and obj ~= myChar then 
                    local root = obj:FindFirstChild("HumanoidRootPart")
                    local hum = obj:FindFirstChildOfClass("Humanoid") 
                    if root and hum and hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Dead then 
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
