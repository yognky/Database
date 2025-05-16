-- Roblox GUI FPS/Noclip/Fly by Yongky
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local flying = false
local noclip = false
local flySpeed = 5

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0, 30, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Yongky FPS Tools"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.VerticalAlignment = Enum.VerticalAlignment.Center

local function createBtn(text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Boost FPS
createBtn("Boost FPS", function()
    for _, v in pairs(game.Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 1000000
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
end)

-- Noclip Toggle
createBtn("Noclip [OFF]", function(btn)
    noclip = not noclip
    btn.Text = "Noclip ["..(noclip and "ON" or "OFF").."]"
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly Toggle
createBtn("Fly [OFF]", function(btn)
    flying = not flying
    btn.Text = "Fly ["..(flying and "ON" or "OFF").."]"

    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"
        bv.Velocity = Vector3.new()
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

        local input = game:GetService("UserInputService")
        local flyDir = Vector3.new()

        local con1 = input.InputBegan:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.W then flyDir = Vector3.new(0, 0, -1)
            elseif i.KeyCode == Enum.KeyCode.S then flyDir = Vector3.new(0, 0, 1)
            elseif i.KeyCode == Enum.KeyCode.A then flyDir = Vector3.new(-1, 0, 0)
            elseif i.KeyCode == Enum.KeyCode.D then flyDir = Vector3.new(1, 0, 0)
            elseif i.KeyCode == Enum.KeyCode.Space then flyDir = Vector3.new(0, 1, 0)
            elseif i.KeyCode == Enum.KeyCode.LeftControl then flyDir = Vector3.new(0, -1, 0)
            end
        end)

        local con2 = input.InputEnded:Connect(function()
            flyDir = Vector3.new()
        end)

        spawn(function()
            while flying and bv.Parent do
                bv.Velocity = (plr.Character.HumanoidRootPart.CFrame:VectorToWorldSpace(flyDir)) * flySpeed
                wait()
            end
            bv:Destroy()
            con1:Disconnect()
            con2:Disconnect()
        end)
    end
end)
