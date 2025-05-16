-- Roblox GUI by Yongky (Fly/Noclip/FPS FIXED)
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- State flags
local flying = false
local noclip = false
local flySpeed = 60
local flyVelocity
local inputDir = {
    forward = false,
    back = false,
    left = false,
    right = false,
    up = false,
    down = false
}

-- GUI
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
title.Text = "Yongky Panel"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.VerticalAlignment = Enum.VerticalAlignment.Center

local function createBtn(text, func)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    btn.MouseButton1Click:Connect(function()
        func(btn)
    end)
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

-- Noclip
createBtn("Noclip [OFF]", function(btn)
    noclip = not noclip
    btn.Text = "Noclip [" .. (noclip and "ON" or "OFF") .. "]"
end)

RS.Stepped:Connect(function()
    if noclip then
        local character = plr.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fly system
local function updateDirection()
    local dir = Vector3.zero
    if inputDir.forward then dir += Vector3.new(0, 0, -1) end
    if inputDir.back then dir += Vector3.new(0, 0, 1) end
    if inputDir.left then dir += Vector3.new(-1, 0, 0) end
    if inputDir.right then dir += Vector3.new(1, 0, 0) end
    if inputDir.up then dir += Vector3.new(0, 1, 0) end
    if inputDir.down then dir += Vector3.new(0, -1, 0) end
    return dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

local function startFly()
    if flying then return end
    flying = true

    flyVelocity = Instance.new("BodyVelocity", hrp)
    flyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyVelocity.P = 1e4
    flyVelocity.Velocity = Vector3.zero

    RS:BindToRenderStep("FlyMove", Enum.RenderPriority.Character.Value + 1, function()
        local dir = updateDirection()
        flyVelocity.Velocity = hrp.CFrame:VectorToWorldSpace(dir) * flySpeed
    end)
end

local function stopFly()
    flying = false
    RS:UnbindFromRenderStep("FlyMove")
    if flyVelocity then flyVelocity:Destroy() flyVelocity = nil end
end

-- Fly button
createBtn("Fly [OFF]", function(btn)
    if flying then
        stopFly()
        btn.Text = "Fly [OFF]"
    else
        startFly()
        btn.Text = "Fly [ON]"
    end
end)

-- Input keys
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then inputDir.forward = true
    elseif kc == Enum.KeyCode.S then inputDir.back = true
    elseif kc == Enum.KeyCode.A then inputDir.left = true
    elseif kc == Enum.KeyCode.D then inputDir.right = true
    elseif kc == Enum.KeyCode.Space then inputDir.up = true
    elseif kc == Enum.KeyCode.LeftControl then inputDir.down = true
    end
end)

UIS.InputEnded:Connect(function(input)
    local kc = input.KeyCode
    if kc == Enum.KeyCode.W then inputDir.forward = false
    elseif kc == Enum.KeyCode.S then inputDir.back = false
    elseif kc == Enum.KeyCode.A then inputDir.left = false
    elseif kc == Enum.KeyCode.D then inputDir.right = false
    elseif kc == Enum.KeyCode.Space then inputDir.up = false
    elseif kc == Enum.KeyCode.LeftControl then inputDir.down = false
    end
end)
