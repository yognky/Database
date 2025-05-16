-- Roblox GUI by Yongky (Fix Fly/Noclip)
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- State flags
local flying = false
local noclip = false
local flySpeed = 5
local UIS = game:GetService("UserInputService")

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

game:GetService("RunService").Stepped:Connect(function()
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

-- Fly
createBtn("Fly [OFF]", function(btn)
    flying = not flying
    btn.Text = "Fly [" .. (flying and "ON" or "OFF") .. "]"

    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero

        local direction = Vector3.zero

        local input = UIS.InputBegan:Connect(function(inputObj)
            if inputObj.UserInputType == Enum.UserInputType.Keyboard then
                local key = inputObj.KeyCode
                if key == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1)
                elseif key == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1)
                elseif key == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0)
                elseif key == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0)
                elseif key == Enum.KeyCode.Space then direction = Vector3.new(0, 1, 0)
                elseif key == Enum.KeyCode.LeftControl then direction = Vector3.new(0, -1, 0)
                end
            end
        end)

        local inputEnd = UIS.InputEnded:Connect(function()
            direction = Vector3.zero
        end)

        task.spawn(function()
            while flying and bv.Parent do
                bv.Velocity = hrp.CFrame:VectorToWorldSpace(direction) * flySpeed
                task.wait()
            end
            bv:Destroy()
            input:Disconnect()
            inputEnd:Disconnect()
        end)
    end
end)
