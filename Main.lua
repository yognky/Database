-- Buat script di LocalScript
local player = game.Players.LocalPlayer

local menu = Instance.new("ScreenGui")
menu.Name = "Menu"
menu.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.Parent = menu

local label = Instance.new("TextLabel")
label.Text = "Menu"
label.Size = UDim2.new(1, 0, 0, 20)
label.Parent = frame

local buttonPrank = Instance.new("TextButton")
buttonPrank.Text = "Prank Chat"
buttonPrank.Size = UDim2.new(1, 0, 0, 20)
buttonPrank.Position = UDim2.new(0, 0, 0, 30)
buttonPrank.Parent = frame
buttonPrank.MouseButton1Click:Connect(function()
    -- Fungsi untuk prank chat
    local chat = game:GetService("Chat")
    for _, player in pairs(game.Players:GetPlayers()) do
        chat:Chat(player, "DANGER YOUR ACCOUNT")
    end
end)

local buttonFakeName = Instance.new("TextButton")
buttonFakeName.Text = "Fake Name"
buttonFakeName.Size = UDim2.new(1, 0, 0, 20)
buttonFakeName.Position = UDim2.new(0, 0, 0, 60)
buttonFakeName.Parent = frame
buttonFakeName.MouseButton1Click:Connect(function()
    -- Fungsi untuk fake nama
    player.Character.Humanoid.DisplayName = "Admin"
end)

local buttonNoclip = Instance.new("TextButton")
buttonNoclip.Text = "Noclip"
buttonNoclip.Size = UDim2.new(1, 0, 0, 20)
buttonNoclip.Position = UDim2.new(0, 0, 0, 90)
buttonNoclip.Parent = frame
buttonNoclip.MouseButton1Click:Connect(function()
    -- Fungsi untuk noclip
    local character = player.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
