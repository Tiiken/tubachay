local S, UIS, TS = Instance.new("ScreenGui", game.CoreGui), game:GetService("UserInputService"), game:GetService("TweenService")
local M, B, T = Instance.new("Frame", S), Instance.new("TextButton", S), Instance.new("TextLabel")
local TI = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
_G.flySpeed, ccLocked, flyActive, noclipActive, mv = 50, false, false, false, false

-- Hàm tạo bo góc và viền dày 4px
local function decorate(o, r, col)
    local k = Instance.new("UICorner", o) k.CornerRadius = UDim.new(0, r or 8)
    if col then local s = Instance.new("UIStroke", o) s.Color = col s.Thickness = 4 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border end
end

-- Hàm khởi tạo cấu trúc nút gạt và thanh kéo
local function createComp(p, txt, pos, isSlider)
    local f = Instance.new("Frame", p) f.Size, f.Position, f.BackgroundTransparency = UDim2.new(0, 160, 0, 30), pos, 1
    local l = Instance.new("TextLabel", f) l.Size, l.Text, l.TextColor3, l.Font, l.TextSize, l.TextXAlignment, l.BackgroundTransparency = UDim2.new(0, 100, 1, 0), txt, Color3.fromRGB(255,255,255), Enum.Font.SourceSansBold, 12, Enum.TextXAlignment.Left, 1
    if not isSlider then
        local bg = Instance.new("TextButton", f) bg.Size, bg.Position, bg.BackgroundColor3, bg.Text = UDim2.new(0, 40, 0, 22), UDim2.new(1, -40, 0.5, -11), Color3.fromRGB(60,60,60), "" decorate(bg, 11)
        local c = Instance.new("Frame", bg) c.Size, c.Position, c.BackgroundColor3 = UDim2.new(0, 18, 0, 18), UDim2.new(0, 2, 0.5, -9), Color3.fromRGB(255,255,255) decorate(c, 9)
        return bg, c
    else
        f.Size = UDim2.new(0, 160, 0, 45) l.Size = UDim2.new(1, 0, 0, 12)
        local bar = Instance.new("Frame", f) bar.Size, bar.Position, bar.BackgroundColor3 = UDim2.new(1, 0, 0, 6), UDim2.new(0, 0, 0, 18), Color3.fromRGB(80,80,80) decorate(bar, 3)
        local btn = Instance.new("TextButton", bar) btn.Size, btn.Position, btn.BackgroundColor3, btn.Text = UDim2.new(0, 14, 0, 14), UDim2.new(0.05, -7, 0.5, -7), Color3.fromRGB(255,255,255), "" decorate(btn, 7)
        return bar, btn, l
    end
end

-- CẤU HÌNH GIAO DIỆN CHUẨN
B.Size, B.Position, B.BackgroundColor3, B.Text, B.TextColor3, B.Font, B.TextSize = UDim2.new(0, 45, 0, 45), UDim2.new(0, 10, 0, 10), Color3.fromRGB(0, 0, 0), "👽", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 20 decorate(B, 10)
M.Size, _G.tP, M.BackgroundColor3, M.Visible, M.ClipsDescendants = UDim2.new(0, 0, 0, 0), UDim2.new(0.5, -95, 0.4, -85) - UDim2.new(0, 0, 0, 15), Color3.fromRGB(20, 20, 20), false, true M.Position = _G.tP decorate(M, 14, Color3.fromRGB(100, 100, 100))
T.Parent, T.Size, T.Position, T.Text, T.TextColor3, T.BackgroundTransparency, T.Font, T.TextSize = M, UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 0), "Tú Bá Cháy 🥵💦", Color3.fromRGB(255, 255, 255), 1, Enum.Font.SourceSansBold, 13

-- Khởi tạo các hàng chức năng
local FlyBG, FlyC = createComp(M, "Auto Fly", UDim2.new(0, 15, 0, 40), false)
local FlyBar, FlyBtn, FlyTxt = createComp(M, "Tốc độ bay: 50", UDim2.new(0, 15, 0, 75), true)
local NoclipBG, NoclipC = createComp(M, "Xuyên Vật Thể", UDim2.new(0, 15, 0, 120), false)
local LockButton = Instance.new("TextButton", M) LockButton.Size, LockButton.Position, LockButton.BackgroundColor3, LockButton.Text, LockButton.TextColor3, LockButton.Font, LockButton.TextSize = UDim2.new(0, 160, 0, 25), UDim2.new(0, 15, 0, 155), Color3.fromRGB(50, 50, 50), "TẮT", Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 12 decorate(LockButton, 6)

-- HỆ THỐNG KÉO THẢ (DRAG) - Đcard ĐÃ NÂNG CẤP KHÓA CẢ BẢNG MENU VÀ NÚT 👽
local function setupDrag(g)
    local d, s, p g.InputBegan:Connect(function(ip) 
        if (ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch) then 
            -- Nếu đang bật chế độ Khóa, chặn không cho kéo cả bảng Menu (M) lẫn nút mở (B)
            if ccLocked then return end 
            d, s, p = true, ip.Position, g.Position 
        end 
    end)
    UIS.InputChanged:Connect(function(ip) 
        if d and (ip.UserInputType == Enum.UserInputType.MouseMovement or ip.UserInputType == Enum.UserInputType.Touch) then 
            if ccLocked then d = false return end 
            local dl = ip.Position - s 
            g.Position = UDim2.new(p.X.Scale, p.X.Offset + dl.X, p.Y.Scale, p.Y.Offset + dl.Y) 
            if g == M then _G.tP = g.Position end 
        end 
    end)
    UIS.InputEnded:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then d = false end end)
end
setupDrag(B) setupDrag(M)

-- Xử lý thanh Slider kéo tăng giảm chỉ số bay
local function setupSlider(btn, bar)
    local sDrag = false btn.InputBegan:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then sDrag = true end end)
    UIS.InputEnded:Connect(function(ip) if ip.UserInputType == Enum.UserInputType.MouseButton1 or ip.UserInputType == Enum.UserInputType.Touch then sDrag = false end end)
    UIS.InputChanged:Connect(function(ip) if sDrag and ip.Position.X then
        local pct = math.clamp((ip.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1) btn.Position = UDim2.new(pct, -7, 0.5, -7)
        _G.flySpeed = math.floor(10 + (pct * 240)) FlyTxt.Text = "Tốc độ bay: " .. _G.flySpeed
    end end)
end
setupSlider(FlyBtn, FlyBar)

-- Đóng mở Menu chính mượt mà
B.MouseButton1Click:Connect(function() mv = not mv if mv then M.Visible = true TS:Create(M, TI, {Size = UDim2.new(0, 190, 0, 195)}):Play() else local ct = TS:Create(M, TI, {Size = UDim2.new(0, 0, 0, 0)}) ct:Play() ct.Completed:Connect(function() if not mv then M.Visible = false end end) end end)

-- XỬ LÝ BẬT TẮT CÔNG TẮC FLY, NOCLIP VÀ NÚT KHÓA TOÀN BỘ GIAO DIỆN
FlyBG.MouseButton1Click:Connect(function() flyActive = not flyActive TS:Create(FlyBG, TweenInfo.new(0.12), {BackgroundColor3 = flyActive and Color3.fromRGB(10, 132, 255) or Color3.fromRGB(60, 60, 60)}):Play() TS:Create(FlyC, TweenInfo.new(0.12), {Position = flyActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play() end)
NoclipBG.MouseButton1Click:Connect(function() noclipActive = not noclipActive TS:Create(NoclipBG, TweenInfo.new(0.12), {BackgroundColor3 = noclipActive and Color3.fromRGB(10, 132, 255) or Color3.fromRGB(60, 60, 60)}):Play() TS:Create(NoclipC, TweenInfo.new(0.12), {Position = noclipActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play() end)
LockButton.MouseButton1Click:Connect(function() ccLocked = not ccLocked LockButton.Text = ccLocked and "BẬT" or "TẮT" LockButton.BackgroundColor3 = ccLocked and Color3.fromRGB(16, 124, 65) or Color3.fromRGB(50, 50, 50) end)

-- HỆ THỐNG LIÊN TỤC CHẠY NGẦM FLY & NOCLIP
task.spawn(function()
    local players, cam = game:GetService("Players"), workspace.CurrentCamera
    while task.wait() do
        local char = players.LocalPlayer.Character
        local r = char and char:FindFirstChild("HumanoidRootPart")
        local h = char and char:FindFirstChildOfClass("Humanoid")
        
        if char and r and h then
            -- 1. XỬ LÝ MÃ NOCLIP (ĐI XUYÊN VẬT THỂ)
            if noclipActive then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end

            -- 2. XỬ LÝ MÃ AUTO FLY
            local bv, bg = r:FindFirstChild("FlyVelocity"), r:FindFirstChild("FlyGyro")
            if flyActive then
                if not bv then bv = Instance.new("BodyVelocity") bv.Name, bv.MaxForce, bv.Parent = "FlyVelocity", Vector3.new(9e9, 9e9, 9e9), r end
                if not bg then bg = Instance.new("BodyGyro") bg.Name, bg.MaxTorque, bg.Parent = "FlyGyro", Vector3.new(9e9, 9e9, 9e9), r bg.CFrame = r.CFrame end
                bv.Velocity = h.MoveDirection.Magnitude > 0 and cam.CFrame.LookVector * (h.MoveDirection.Magnitude * _G.flySpeed) or Vector3.new(0, 0, 0) bg.CFrame = cam.CFrame
            else 
                if bv then bv:Destroy() end 
                if bg then bg:Destroy() end 
            end
        end
    end
end)
