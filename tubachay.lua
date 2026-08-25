local SG = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Btn = Instance.new("TextButton", SG)
local MM = Instance.new("Frame", SG)
local Tgl = Instance.new("TextButton", MM)
local SB = Instance.new("Frame", Tgl)
local Tgl2 = Instance.new("TextButton", MM)
local SB2 = Instance.new("Frame", Tgl2)

local L1 = Instance.new("TextLabel", MM)
local S1 = Instance.new("TextButton", MM)
local F1 = Instance.new("Frame", S1)
local B1 = Instance.new("Frame", S1)

local L2 = Instance.new("TextLabel", MM)
local S2 = Instance.new("TextButton", MM)
local F2 = Instance.new("Frame", S2)
local B2 = Instance.new("Frame", S2)

local L3 = Instance.new("TextLabel", MM)
local S3 = Instance.new("TextButton", MM)
local F3 = Instance.new("Frame", S3)
local B3 = Instance.new("Frame", S3)

-- Cấu hình Menu chính (ĐÃ FIX RA GIỮA MÀN HÌNH)
Btn.Size, Btn.Position, Btn.BackgroundColor3, Btn.Text, Btn.TextColor3, Btn.Font, Btn.Draggable = UDim2.new(0,45,0,45), UDim2.new(0.05,0,0.2,0), Color3.fromRGB(20,20,20), "HX", Color3.fromRGB(255,255,255), Enum.Font.SourceSansBold, true
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1,0)

-- Căn giữa màn hình bằng cách trừ đi một nửa kích thước chiều rộng (220/2 = 110) và chiều cao (350/2 = 175)
MM.Size, MM.Position, MM.BackgroundColor3, MM.Visible, MM.Draggable = UDim2.new(0,220,0,350), UDim2.new(0.5,-110,0.5,-175), Color3.fromRGB(12,12,12), false, true
Instance.new("UICorner", MM).CornerRadius = UDim.new(0,16)
Instance.new("UIStroke", MM).Color = Color3.fromRGB(45,45,45)

local T = Instance.new("TextLabel", MM); T.Size, T.Text, T.TextColor3, T.Font, T.BackgroundTransparency = UDim2.new(1,0,0,40), "HX STEAL AN EGG FIX", Color3.fromRGB(255,255,255), Enum.Font.SourceSansBold, 1
Btn.MouseButton1Click:Connect(function() MM.Visible = not MM.Visible end)

-- Nút gạt 1: Hitbox
local L0 = Instance.new("TextLabel", MM); L0.Size, L0.Position, L0.Text, L0.TextColor3, L0.TextXAlignment, L0.BackgroundTransparency = UDim2.new(0,100,0,30), UDim2.new(0,15,0,45), "Bật Hitbox", Color3.fromRGB(220,220,220), 0, 1
Tgl.Size, Tgl.Position, Tgl.BackgroundColor3, Tgl.Text = UDim2.new(0,50,0,26), UDim2.new(0,150,0,47), Color3.fromRGB(35,35,35), ""
Instance.new("UICorner", Tgl).CornerRadius = UDim.new(1,0)
SB.Size, SB.Position, SB.BackgroundColor3 = UDim2.new(0,20,0,20), UDim2.new(0,3,0,3), Color3.fromRGB(255,255,255)
Instance.new("UICorner", SB).CornerRadius = UDim.new(1,0)

-- Nút gạt 2: Auto Steal
local L02 = Instance.new("TextLabel", MM); L02.Size, L02.Position, L02.Text, L02.TextColor3, L02.TextXAlignment, L02.BackgroundTransparency = UDim2.new(0,100,0,30), UDim2.new(0,15,0,85), "Auto Steal", Color3.fromRGB(220,220,220), 0, 1
Tgl2.Size, Tgl2.Position, Tgl2.BackgroundColor3, Tgl2.Text = UDim2.new(0,50,0,26), UDim2.new(0,150,0,87), Color3.fromRGB(35,35,35), ""
Instance.new("UICorner", Tgl2).CornerRadius = UDim.new(1,0)
SB2.Size, SB2.Position, SB2.BackgroundColor3 = UDim2.new(0,20,0,20), UDim2.new(0,3,0,3), Color3.fromRGB(255,255,255)
Instance.new("UICorner", SB2).CornerRadius = UDim.new(1,0)

-- Thanh trượt 1 (Độ mờ)
L1.Size, L1.Position, L1.Text, L1.TextColor3, L1.TextXAlignment, L1.BackgroundTransparency = UDim2.new(0,150,0,20), UDim2.new(0,15,0,135), "Độ mờ vùng: 50%", Color3.fromRGB(220,220,220), 0, 1
S1.Size, S1.Position, S1.BackgroundColor3, S1.Text = UDim2.new(0,190,0,6), UDim2.new(0,15,0,160), Color3.fromRGB(35,35,35), ""
Instance.new("UICorner", S1).CornerRadius = UDim.new(1,0)
F1.Size, F1.BackgroundColor3 = UDim2.new(0.5,0,1,0), Color3.fromRGB(255,255,255)
Instance.new("UICorner", F1).CornerRadius = UDim.new(1,0)
B1.Size, B1.Position, B1.BackgroundColor3 = UDim2.new(0,12,0,12), UDim2.new(0.5,-6,0,-3), Color3.fromRGB(255,255,255)
Instance.new("UICorner", B1).CornerRadius = UDim.new(1,0)

-- Thanh trượt 2 (Kích thước Hitbox)
L2.Size, L2.Position, L2.Text, L2.TextColor3, L2.TextXAlignment, L2.BackgroundTransparency = UDim2.new(0,150,0,20), UDim2.new(0,15,0,200), "Kích thước: 15", Color3.fromRGB(220,220,220), 0, 1
S2.Size, S2.Position, S2.BackgroundColor3, S2.Text = UDim2.new(0,190,0,6), UDim2.new(0,15,0,225), Color3.fromRGB(35,35,35), ""
Instance.new("UICorner", S2).CornerRadius = UDim.new(1,0)
F2.Size, F2.BackgroundColor3 = UDim2.new(0.5,0,1,0), Color3.fromRGB(255,255,255)
Instance.new("UICorner", F2).CornerRadius = UDim.new(1,0)
B2.Size, B2.Position, B2.BackgroundColor3 = UDim2.new(0,12,0,12), UDim2.new(0.5,-6,0,-3), Color3.fromRGB(255,255,255)
Instance.new("UICorner", B2).CornerRadius = UDim.new(1,0)

-- Thanh trượt 3 (Tốc độ)
L3.Size, L3.Position, L3.Text, L3.TextColor3, L3.TextXAlignment, L3.BackgroundTransparency = UDim2.new(0,150,0,20), UDim2.new(0,15,0,265), "Tốc độ chạy: 100", Color3.fromRGB(220,220,220), 0, 1
S3.Size, S3.Position, S3.BackgroundColor3, S3.Text = UDim2.new(0,190,0,6), UDim2.new(0,15,0,290), Color3.fromRGB(35,35,35), ""
Instance.new("UICorner", S3).CornerRadius = UDim.new(1,0)
F3.Size, F3.BackgroundColor3 = UDim2.new(0.4,0,1,0), Color3.fromRGB(255,255,255)
Instance.new("UICorner", F3).CornerRadius = UDim.new(1,0)
B3.Size, B3.Position, B3.BackgroundColor3 = UDim2.new(0,12,0,12), UDim2.new(0.4,-6,0,-3), Color3.fromRGB(255,255,255)
Instance.new("UICorner", B3).CornerRadius = UDim.new(1,0)

----------------------------------------------------------------
-- LOGIC HỆ THỐNG
----------------------------------------------------------------
local H_On, Steal_On, H_Trans, H_Size, Steal_Speed = false, false, 0.5, 15, 100
local drag1, drag2, drag3 = false, false, false
local UIS = game:GetService("UserInputService")
local Plr = game:GetService("Players").LocalPlayer

Tgl.MouseButton1Click:Connect(function()
    H_On = not H_On
    Tgl:TweenBackgroundColor3(H_On and Color3.fromRGB(48,209,88) or Color3.fromRGB(35,35,35), 0.1)
    SB:TweenPosition(H_On and UDim2.new(0,27,0,3) or UDim2.new(0,3,0,3), "Out", "Quad", 0.1)
end)

Tgl2.MouseButton1Click:Connect(function()
    Steal_On = not Steal_On
    Tgl2:TweenBackgroundColor3(Steal_On and Color3.fromRGB(48,209,88) or Color3.fromRGB(35,35,35), 0.1)
    SB2:TweenPosition(Steal_On and UDim2.new(0,27,0,3) or UDim2.new(0,3,0,3), "Out", "Quad", 0.1)
end)

local function SetupSlider(S, F, B, mode)
    local function update(input)
        local pct = math.clamp((input.Position.X - S.AbsolutePosition.X) / S.AbsoluteSize.X, 0, 1)
        F.Size = UDim2.new(pct, 0, 1, 0)
        B.Position = UDim2.new(pct, -6, 0, -3)
        if mode == 1 then H_Trans = 1 - pct L1.Text = "Độ mờ vùng: " .. math.floor(pct * 100) .. "%"
        elseif mode == 2 then H_Size = math.floor(2 + (pct * 38)) L2.Text = "Kích thước: " .. H_Size 
        else Steal_Speed = math.floor(30 + (pct * 270)) L3.Text = "Tốc độ chạy: " .. Steal_Speed end
    end
    S.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then if mode==1 then drag1=true elseif mode==2 then drag2=true else drag3=true end update(i) end end)
    UIS.InputChanged:Connect(function(i) if (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then if mode==1 and drag1 then update(i) elseif mode==2 and drag2 then update(i) elseif mode==3 and drag3 then update(i) end end end)
end
SetupSlider(S1, F1, B1, 1)
SetupSlider(S2, F2, B2, 2)
SetupSlider(S3, F3, B3, 3)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag1, drag2, drag3 = false, false, false end end)

local function GetPlayerBase()
    local name = Plr.Name
    local targets = {workspace, workspace:FindFirstChild("Bases"), workspace:FindFirstChild("Plots"), workspace:FindFirstChild("Tycoons")}
    for _, folder in pairs(targets) do
        if folder then
            local b = folder:FindFirstChild(name) or folder:FindFirstChild(name .. "Base") or folder:FindFirstChild(name .. "Plot")
            if b and b:IsA("BasePart") then return b
            elseif b then local p = b:FindFirstChild("EggDrop") or b:FindFirstChild("Drop") or b:FindFirstChildOfClass("BasePart") or b:FindFirstChild("Main") or b:FindFirstChild("Part")
                if p then return p end
            end
        end
    end
    return nil
end

-- VÒNG LẶP CHÍNH
game:GetService("RunService").RenderStepped:Connect(function()
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p ~= Plr and p.Character then
            pcall(function()
                local parts = {p.Character:FindFirstChild("HumanoidRootPart"), p.Character:FindFirstChild("Torso"), p.Character:FindFirstChild("Head")}
                for _, root in pairs(parts) do
                    if root then
                        if H_On then
                            root.Size = Vector3.new(H_Size, H_Size, H_Size)
                            root.Transparency = H_Trans
                            root.Color, root.Material, root.CanCollide = Color3.fromRGB(255, 0, 0), Enum.Material.Neon, false
                        else
                            if root.Name == "HumanoidRootPart" then root.Size = Vector3.new(2, 2, 1) else root.Size = Vector3.new(1, 1, 1) end
                            root.Transparency = (root.Name == "HumanoidRootPart") and 1 or 0
                        end
                    end
                end
            end)
        end
    end

    if Steal_On and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            local char = Plr.Character
            local root = char.HumanoidRootPart
            local base = GetPlayerBase()
            local hasEgg = char:FindFirstChild("Egg") or char:FindFirstChildOfClass("Tool") or root:FindFirstChild("EggGrip")
            
            if hasEgg and base then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
local targetPos = base.Position + Vector3.new(0, 4, 0)if (targetPos - root.Position).Magnitude > 6 thenroot.Velocity = (targetPos - root.Position).Unit * Steal_Speedelseroot.Velocity = Vector3.new(0, 0, 0)endendend)endend)
