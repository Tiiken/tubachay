local S, UIS, TS, RS = Instance.new("ScreenGui", game.CoreGui), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("RunService")
local M, B, T = Instance.new("Frame", S), Instance.new("TextButton", S), Instance.new("TextLabel")
local TI = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local hitboxSize, hitboxTrans, ccLocked, hitboxActive, noclipActive, mv = 20, 0.6, false, false, false, false

-- Hàm tạo bo góc và viền
local function decorate(o, r, col)
    Instance.new("UICorner", o).CornerRadius = UDim.new(0, r or 8)
    if col then local s = Instance.new("UIStroke", o) s.Color, s.Thickness = col, 4 end
end

-- Hàm khởi tạo cấu trúc nút gạt và thanh kéo
local function createComp(p, txt, pos, isSlider)
    local f = Instance.new("Frame", p) f.Size, f.Position, f.BackgroundTransparency = UDim2.new(0, 160, 0, isSlider and 45 or 30), pos, 1
    local l = Instance.new("TextLabel", f) l.Size, l.Text, l.TextColor3, l.Font, l.TextSize, l.TextXAlignment, l.BackgroundTransparency = UDim2.new(0, 100, 1, 0), txt, Color3.fromRGB(255,255,255), Enum.Font.SourceSansBold, 12, 0, 1
    if not isSlider then
        local bg = Instance.new("TextButton", f) bg.Size, bg.Position, bg.BackgroundColor3, bg.Text = UDim2.new(0, 40, 0, 22), UDim2.new(1, -40, 0.5, -11), Color3.fromRGB(60,60,60), "" decorate(bg, 11)
        local c = Instance.new("Frame", bg) c.Size, c.Position, c.BackgroundColor3 = UDim2.new(0, 18, 0, 18), UDim2.new(0, 2, 0.5, -9), Color3.fromRGB(255,255,255) decorate(c, 9)
        return bg, c
    else
        l.Size = UDim2.new(1, 0, 0, 12)
        local bar = Instance.new("Frame", f) bar.Size, bar.Position, bar.BackgroundColor3 = UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 0, 18), Color3.fromRGB(80,80,80) decorate(bar, 3)
        local btn = Instance.new("TextButton", bar) btn.Size, btn.Position, btn.BackgroundColor3, btn.Text = UDim2.new(0, 14, 0, 14), UDim2.new(0.05, -7, 0.5, -7), Color3.fromRGB(255,255,255), "" decorate(btn, 7)
        return bar, btn, l
    end
end

-- CẤU HÌNH GIAO DIỆN CHUẨN
B.Size, B.Position, B.BackgroundColor3, B.Text, B.TextColor3, B.Font, B.TextSize = UDim2.new(0, 45, 0, 45), UDim2.new(0, 10, 0, 10), Color3.fromRGB(0, 0, 0), "👽", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 20 decorate(B, 10)
M.Size, M.BackgroundColor3, M.Visible, M.ClipsDescendants = UDim2.new(0, 0, 0, 0), Color3.fromRGB(20, 20, 20), false, true M.Position = UDim2.new(0.5, -95, 0.4, -85) decorate(M, 14, Color3.fromRGB(100, 100, 100))
T.Parent, T.Size, T.Position, T.Text, T.TextColor3, T.BackgroundTransparency, T.Font, T.TextSize = M, UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 0), "Tú Bá Cháy 🥵💦", Color3.fromRGB(255, 255, 255), 1, Enum.Font.SourceSansBold, 13

local HitboxBG, HitboxC = createComp(M, "Hitbox VIP", UDim2.new(0, 15, 0, 40), false)
local HitboxBar, HitboxBtn, HitboxTxt = createComp(M, "Cỡ Hitbox: 20", UDim2.new(0, 15, 0, 75), true)
local TransBar, TransBtn, TransTxt = createComp(M, "Độ mờ Hitbox: 60%", UDim2.new(0, 15, 0, 120), true) TransBtn.Position = UDim2.new(0.6, -7, 0.5, -7)
local NoclipBG, NoclipC = createComp(M, "Xuyên Vật Thể", UDim2.new(0, 15, 0, 165), false)
local LockButton = Instance.new("TextButton", M) LockButton.Size, LockButton.Position, LockButton.BackgroundColor3, LockButton.Text, LockButton.TextColor3, LockButton.Font, LockButton.TextSize = UDim2.new(0, 160, 0, 25), UDim2.new(0, 15, 0, 200), Color3.fromRGB(50, 50, 50), "TẮT", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 12 decorate(LockButton, 6)

-- HỆ THỐNG KÉO THẢ (DRAG)
local function setupDrag(g)
    local d, s, p g.InputBegan:Connect(function(ip) if (ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch) and not ccLocked then d, s, p = true, ip.Position, g.Position end end)
    UIS.InputChanged:Connect(function(ip) if d and (ip.UserInputType == Enum.UserInputType.MouseMovement or ip.UserInputType == Enum.UserInputType.Touch) and not ccLocked then local dl = ip.Position - s g.Position = UDim2.new(p.X.Scale, p.X.Offset + dl.X, p.Y.Scale, p.Y.Offset + dl.Y) end end)
    UIS.InputEnded:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then d = false end end)
end; setupDrag(B) setupDrag(M)

-- HỆ THỐNG THANH TRƯỢT SLIDER
local function setupSlider(btn, bar, cb)
    local sDrag = false btn.InputBegan:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then sDrag = true end end)
    UIS.InputEnded:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then sDrag = false end end)
    UIS.InputChanged:Connect(function(ip) if sDrag and ip.Position.X then local pct = math.clamp((ip.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1) btn.Position = UDim2.new(pct, -7, 0.5, -7) cb(pct) end end)
end
setupSlider(HitboxBtn, HitboxBar, function(pct) hitboxSize = math.floor(10 + (pct * 40)) HitboxTxt.Text = "Cỡ Hitbox: " .. hitboxSize end)
setupSlider(TransBtn, TransBar, function(pct) hitboxTrans = pct TransTxt.Text = "Độ mờ Hitbox: " .. math.floor(pct * 100) .. "%" end)

-- ĐÓNG MỞ MENU
B.MouseButton1Click:Connect(function() mv = not mv if mv then M.Visible = true TS:Create(M, TI, {Size = UDim2.new(0, 190, 0, 240)}):Play() else local ct = TS:Create(M, TI, {Size = UDim2.new(0, 0, 0, 0)}) ct:Play() ct.Completed:Connect(function() if not mv then M.Visible = false end end) end end)

-- XỬ LÝ NÚT BẤM CÔNG TẮC
HitboxBG.MouseButton1Click:Connect(function() hitboxActive = not hitboxActive TS:Create(HitboxBG, TweenInfo.new(0.12), {BackgroundColor3 = hitboxActive and Color3.fromRGB(10, 132, 255) or Color3.fromRGB(60, 60, 60)}):Play() TS:Create(HitboxC, TweenInfo.new(0.12), {Position = hitboxActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play() end)
NoclipBG.MouseButton1Click:Connect(function() noclipActive = not noclipActive TS:Create(NoclipBG, TweenInfo.new(0.12), {BackgroundColor3 = noclipActive and Color3.fromRGB(10, 132, 255) or Color3.fromRGB(60, 60, 60)}):Play() TS:Create(NoclipC, TweenInfo.new(0.12), {Position = noclipActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play() end)
LockButton.MouseButton1Click:Connect(function() ccLocked = not ccLocked LockButton.Text = ccLocked and "BẬT" or "TẮT" LockButton.BackgroundColor3 = ccLocked and Color3.fromRGB(16, 124, 65) or Color3.fromRGB(50, 50, 50) end)

-- 🛠️ SỬA LỖI: Chạy Xuyên Tường mượt bằng luồng Stepped tốc độ cao, triệt tiêu hoàn toàn giật đứng hình
RS.Stepped:Connect(function()
    if noclipActive then
        local char = game:GetService("Players").LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then 
                    part.CanCollide = false 
                end
            end
        end
    end
end)

-- HỆ THỐNG QUÉT KHỐI HITBOX VIP (Chạy độc lập để giảm tải cho game)
task.spawn(function()
    local players = game:GetService("Players")
    while task.wait(0.2) do 
        local lPlayer = players.LocalPlayer
        local targets = {}
        
        for _, p in ipairs(players:GetPlayers()) do 
            if p ~= lPlayer and p.Character then table.insert(targets, p.Character) end 
        end
        if workspace:FindFirstChild("Enemies") then 
            for _, e in ipairs(workspace.Enemies:GetChildren()) do table.insert(targets, e) end 
        end
        
        for _, model in ipairs(targets) do
            local root = model:FindFirstChild("HumanoidRootPart")
            if root then
                if hitboxActive then
                    root.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    root.Transparency = hitboxTrans
                    root.Color = Color3.fromRGB(255, 0, 0)
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                else
                    root.Size = Vector3.new(2, 2, 1)
                    root.Transparency = 1
                    root.CanCollide = true
                end
            end
        end
    end
end)
