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
