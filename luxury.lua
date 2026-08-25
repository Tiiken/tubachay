local S, UIS, TS, RS = Instance.new("ScreenGui", game.CoreGui), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("RunService")
local M, B, T = Instance.new("Frame", S), Instance.new("TextButton", S), Instance.new("TextLabel")
local TI = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local hitboxSize, hitboxTrans, ccLocked, hitboxActive, noclipActive, godmodeActive, mv = 20, 0.6, false, false, false, false, false

-- Hàm tạo bo góc và viền
local function decorate(o, r, col)
    Instance.new("UICorner", o).CornerRadius = UDim.new(0, r or 8)
    if col then 
        local s = Instance.new("UIStroke", o) 
        s.Color, s.Thickness = col, 1.5 
    end
end

-- GIAO DIỆN LIGHT THEME
B.Size, B.Position, B.BackgroundColor3, B.Text, B.TextColor3, B.Font, B.TextSize = UDim2.new(0, 45, 0, 45), UDim2.new(0, 10, 0, 10), Color3.fromRGB(255, 255, 255), "❄️", Color3.fromRGB(0, 122, 255), Enum.Font.SourceSansBold, 20 decorate(B, 10, Color3.fromRGB(220, 225, 230))
M.Size, M.BackgroundColor3, M.Visible, M.ClipsDescendants = UDim2.new(0, 0, 0, 0), Color3.fromRGB(248, 250, 255), false, true M.Position = UDim2.new(0.5, -95, 0.25, -85) decorate(M, 14, Color3.fromRGB(215, 225, 235))

-- Hàm hiển thị thông báo
local function showNotification(msg)
    local notif = Instance.new("Frame", S)
    notif.Size, notif.Position, notif.BackgroundColor3, notif.BackgroundTransparency = UDim2.new(0, 260, 0, 45), UDim2.new(1, 10, 1, -70), Color3.fromRGB(248, 250, 255), 0.1
    notif.ZIndex = 10 decorate(notif, 10, Color3.fromRGB(215, 225, 235))
    
    local lbl = Instance.new("TextLabel", notif)
    lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), 1
    lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize, lbl.ZIndex = msg, Color3.fromRGB(40, 60, 90), Enum.Font.SourceSansBold, 12, 11
    
    local tweenIn = TS:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -275, 1, -65)
    })
    tweenIn:Play()
    
    task.delay(2.0, function()
        if not notif.Parent then return end
        
        local tweenOut = TS:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, -120, 1, -40),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        
        TS:Create(lbl, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            TextTransparency = 1
        }):Play()
        
        tweenOut:Play()
        tweenOut.Completed:Connect(function() 
            notif:Destroy() 
        end)
    end)
end

task.spawn(function()
    task.wait(0.4)
    showNotification("❄ Chào Mừng Bạn Đến Với LUXURY HUB ❄")
end)

-- Hàm khởi tạo cấu trúc nút gạt và thanh kéo
local function createComp(p, txt, pos, isSlider)
    local f = Instance.new("Frame", p) f.Size, f.Position, f.BackgroundTransparency, f.ZIndex = UDim2.new(0, 160, 0, isSlider and 45 or 30), pos, 1, 3
    local l = Instance.new("TextLabel", f) l.Size, l.Text, l.TextColor3, l.Font, l.TextSize, l.TextXAlignment, l.BackgroundTransparency, l.ZIndex = UDim2.new(0, 100, 1, 0), txt, Color3.fromRGB(50, 50, 60), Enum.Font.SourceSansBold, 12, 0, 1, 3
    if not isSlider then
        local bg = Instance.new("TextButton", f) bg.Size, bg.Position, bg.BackgroundColor3, bg.Text, bg.ZIndex = UDim2.new(0, 40, 0, 22), UDim2.new(1, -40, 0.5, -11), Color3.fromRGB(200, 205, 215), "", 3 decorate(bg, 11)
        local c = Instance.new("Frame", bg) c.Size, c.Position, c.BackgroundColor3, c.ZIndex = UDim2.new(0, 18, 0, 18), UDim2.new(0, 2, 0.5, -9), Color3.fromRGB(255, 255, 255), 3 decorate(c, 9)
        return bg, c
    else
        l.Size = UDim2.new(1, 0, 0, 12)
        local bar = Instance.new("Frame", f) bar.Size, bar.Position, bar.BackgroundColor3, bar.ZIndex = UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 0, 18), Color3.fromRGB(210, 215, 225), 3 decorate(bar, 3)
        local btn = Instance.new("TextButton", bar) btn.Size, btn.Position, btn.BackgroundColor3, btn.Text, btn.ZIndex = UDim2.new(0, 14, 0, 14), UDim2.new(0.05, -7, 0.5, -7), Color3.fromRGB(0, 122, 255), "", 3 decorate(btn, 7)
        return bar, btn, l
    end
end

-- TIÊU ĐỀ LUXURY HUB
T.Parent, T.Size, T.Position, T.Text, T.TextColor3, T.BackgroundTransparency, T.Font, T.TextSize, T.TextScaled, T.ZIndex = M, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 2), "LUXURY HUB", Color3.fromRGB(40, 60, 90), 1, Enum.Font.SourceSansBold, 11, false, 3

-- HIỆU ỨNG TUYẾT RƠI
local snowContainer = Instance.new("Frame", M)
snowContainer.Size, snowContainer.BackgroundTransparency, snowContainer.ZIndex = UDim2.new(1, 0, 1, 0), 1, 2

task.spawn(function()
    while task.wait(0.35) do
        if mv then
            local flake = Instance.new("TextLabel", snowContainer)
            flake.Size = UDim2.new(0, 12, 0, 12)
            flake.Position = UDim2.new(math.random(), 0, -0.05, 0)
            flake.BackgroundTransparency = 1
            flake.Text = "•"
            flake.TextColor3 = Color3.fromRGB(180, 210, 245)
            flake.TextSize = math.random(8, 14)
            flake.ZIndex = 2

            local fallTime = math.random(4, 7)
            local targetPosX = flake.Position.X.Scale + (math.random(-10, 10) / 100)
            
            local tween = TS:Create(flake, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
                Position = UDim2.new(targetPosX, 0, 1.05, 0),
                TextTransparency = 0.8
            })
            tween:Play()
            tween.Completed:Connect(function() flake:Destroy() end)
        end
    end
end)

local HitboxBG, HitboxC = createComp(M, "HitBox VIP", UDim2.new(0, 15, 0, 38), false)
local HitboxBar, HitboxBtn, HitboxTxt = createComp(M, "Cỡ Hitbox: 20", UDim2.new(0, 15, 0, 72), true)
local TransBar, TransBtn, TransTxt = createComp(M, "Độ mờ Hitbox: 60%", UDim2.new(0, 15, 0, 115), true) TransBtn.Position = UDim2.new(0.6, -7, 0.5, -7)
local NoclipBG, NoclipC = createComp(M, "Xuyên Vật Thể", UDim2.new(0, 15, 0, 158), false)
local GodBG, GodC = createComp(M, "God Mode", UDim2.new(0, 15, 0, 192), false)

local LockButton = Instance.new("TextButton", M) LockButton.Size, LockButton.Position, LockButton.BackgroundColor3, LockButton.Text, LockButton.TextColor3, LockButton.Font, LockButton.TextSize, LockButton.ZIndex = UDim2.new(0, 160, 0, 25), UDim2.new(0, 15, 0, 226), Color3.fromRGB(230, 235, 245), "Off Lock", Color3.fromRGB(80, 90, 105), Enum.Font.SourceSansBold, 12, 3 decorate(LockButton, 6)

B.MouseButton1Click:Connect(function() 
    mv = not mv 
    if mv then 
        M.Visible = true 
        TS:Create(M, TI, {Size = UDim2.new(0, 190, 0, 260)}):Play() 
    else 
        local ct = TS:Create(M, TI, {Size = UDim2.new(0, 0, 0, 0)}) 
        ct:Play() 
        ct.Completed:Connect(function() if not mv then M.Visible = false end end) 
    end 
end)

-- DRAG SYSTEM
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
end; setupDrag(B) setupDrag(M)

-- SLIDER SYSTEM
local function setupSlider(btn, bar, cb)
    local sDrag = false 
    btn.InputBegan:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then sDrag = true end end)
    UIS.InputEnded:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then sDrag = false end end)
    UIS.InputChanged:Connect(function(ip) 
        if sDrag and ip.Position.X then 
            local pct = math.clamp((ip.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1) 
            btn.Position = UDim2.new(pct, -7, 0.5, -7) 
            cb(pct) 
        end 
    end)
end
setupSlider(HitboxBtn, HitboxBar, function(pct) hitboxSize = math.floor(10 + (pct * 40)) HitboxTxt.Text = "Cỡ Hitbox: " .. hitboxSize end)
setupSlider(TransBtn, TransBar, function(pct) hitboxTrans = pct TransTxt.Text = "Độ mờ Hitbox: " .. math.floor(pct * 100) .. "%" end)

HitboxBG.MouseButton1Click:Connect(function() 
    hitboxActive = not hitboxActive 
    TS:Create(HitboxBG, TweenInfo.new(0.12), {BackgroundColor3 = hitboxActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(HitboxC, TweenInfo.new(0.12), {Position = hitboxActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play() 
end)

NoclipBG.MouseButton1Click:Connect(function() 
    noclipActive = not noclipActive 
    TS:Create(NoclipBG, TweenInfo.new(0.12), {BackgroundColor3 = noclipActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(NoclipC, TweenInfo.new(0.12), {Position = noclipActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play() 
end)

GodBG.MouseButton1Click:Connect(function() 
    godmodeActive = not godmodeActive 
    TS:Create(GodBG, TweenInfo.new(0.12), {BackgroundColor3 = godmodeActive and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(200, 205, 215)}):Play() 
    TS:Create(GodC, TweenInfo.new(0.12), {Position = godmodeActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play() 
end)

LockButton.MouseButton1Click:Connect(function() 
    ccLocked = not ccLocked 
    LockButton.Text = ccLocked and "Lock" or "Off Lock" 
    LockButton.BackgroundColor3 = ccLocked and Color3.fromRGB(40, 180, 100) or Color3.fromRGB(230, 235, 245) 
    LockButton.TextColor3 = ccLocked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 90, 105)
end)

-- NOCLIP
RS.Stepped:Connect(function()
    if noclipActive then
        local plr = game:GetService("Players").LocalPlayer
        if plr and plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = false 
                end
            end
        end
    end
end)

-- GOD MODE CHỐNG CHẾT (ADVANCED GOD MODE FOR ARSENAL)
RS.PreSimulation:Connect(function()
    if godmodeActive then
        pcall(function()
            local plr = game:GetService("Players").LocalPlayer
            local char = plr.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- Khóa trạng thái không cho Humanoid chuyển sang Dead
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    
                    -- Nếu máu tụt xuống mức nguy hiểm, lập tức khóa máu tối đa
                    if hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                end
            end
        end)
    end
end)

-- HITBOX LOGIC (CẢ CẬN CHIẾN LẪN TẦM XA)
task.spawn(function()
    local players = game:GetService("Players")
    while task.wait(0.05) do 
        pcall(function()
            local lPlayer = players.LocalPlayer
            local targets = {}
            
            for _, p in ipairs(players:GetPlayers()) do 
                if p ~= lPlayer and p.Character then 
                    table.insert(targets, p.Character) 
                end 
            end
            
            if workspace:FindFirstChild("Enemies") then 
                for _, e in ipairs(workspace.Enemies:GetChildren()) do 
                    table.insert(targets, e) 
                end 
            end
            
            for _, model in ipairs(targets) do
                local root = model:FindFirstChild("HumanoidRootPart")
                local hum = model:FindFirstChildOfClass("Humanoid")
                
                if root and hum and hum.Health > 0 then
                    if hitboxActive then
                        root.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        root.Transparency = hitboxTrans
                        root.Color = Color3.fromRGB(255, 0, 0)
                        root.Material = Enum.Material.Neon
                        root.CanCollide = true
                        root.Massless = true
                        
                        for _, part in ipairs(model:GetChildren()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.CanTouch = true
                            end
                        end
                    else
                        root.Size = Vector3.new(2, 2, 1)
                        root.Transparency = 1
                        root.CanCollide = true
                    end
                end
            end
        end)
    end
end)
