local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local Config = require(ReplicatedStorage.Shared.GameConfig)
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local stateEvent = remotes:WaitForChild("StateChanged")
local toastEvent = remotes:WaitForChild("Toast")

local gui = Instance.new("ScreenGui")
gui.Name = "NeonCourierHUD"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(310, 150)
panel.Position = UDim2.fromOffset(24, 24)
panel.BackgroundColor3 = Color3.fromRGB(12, 18, 38)
panel.BackgroundTransparency = 0.08
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local boostButton = Instance.new("TextButton")
boostButton.Size = UDim2.fromOffset(170, 30)
boostButton.Position = UDim2.new(1, -184, 0, 12)
boostButton.BackgroundColor3 = Color3.fromRGB(255, 190, 74)
boostButton.Font = Enum.Font.GothamBold
boostButton.Text = "GET 2X BOOST"
boostButton.TextColor3 = Color3.fromRGB(26, 22, 38)
boostButton.TextSize = 12
boostButton.Parent = panel
Instance.new("UICorner", boostButton).CornerRadius = UDim.new(0, 8)
boostButton.Visible = Config.BoostProductId > 0
boostButton.Activated:Connect(function()
	if Config.BoostProductId > 0 then
		MarketplaceService:PromptProductPurchase(player, Config.BoostProductId)
	end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -28, 0, 32)
title.Position = UDim2.fromOffset(14, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = Config.Title
title.TextColor3 = Color3.fromRGB(91, 232, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local stats = Instance.new("TextLabel")
stats.Size = UDim2.new(1, -28, 0, 70)
stats.Position = UDim2.fromOffset(14, 47)
stats.BackgroundTransparency = 1
stats.Font = Enum.Font.GothamMedium
stats.TextColor3 = Color3.fromRGB(236, 242, 255)
stats.TextSize = 16
stats.TextXAlignment = Enum.TextXAlignment.Left
stats.TextYAlignment = Enum.TextYAlignment.Top
stats.Text = "Connecting..."
stats.Parent = panel

local timer = Instance.new("TextLabel")
timer.Size = UDim2.new(1, -28, 0, 22)
timer.Position = UDim2.fromOffset(14, 119)
timer.BackgroundTransparency = 1
timer.Font = Enum.Font.GothamBold
timer.TextColor3 = Color3.fromRGB(255, 192, 92)
timer.TextSize = 14
timer.TextXAlignment = Enum.TextXAlignment.Left
timer.Parent = panel

local toast = Instance.new("TextLabel")
toast.Size = UDim2.fromOffset(460, 48)
toast.Position = UDim2.new(0.5, -230, 1, -86)
toast.BackgroundColor3 = Color3.fromRGB(20, 28, 55)
toast.BackgroundTransparency = 1
toast.Font = Enum.Font.GothamBold
toast.TextColor3 = Color3.fromRGB(255, 255, 255)
toast.TextSize = 18
toast.TextTransparency = 1
toast.Parent = gui
Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)

local roundEndsAt = 0

stateEvent.OnClientEvent:Connect(function(profile, endsAt)
	roundEndsAt = endsAt or roundEndsAt
	local boost = profile.boostUntil and profile.boostUntil > os.time() and "  |  2X BOOST" or ""
	stats.Text = string.format("Cores: %d / %d\nCredits: %d%s", profile.carried, Config.CoreGoal, profile.credits, boost)
end)

toastEvent.OnClientEvent:Connect(function(message, color)
	toast.Text = message
	toast.TextColor3 = color or Color3.new(1, 1, 1)
	TweenService:Create(toast, TweenInfo.new(0.2), {TextTransparency = 0, BackgroundTransparency = 0.1}):Play()
	task.delay(2.8, function()
		TweenService:Create(toast, TweenInfo.new(0.35), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
	end)
end)

task.spawn(function()
	while true do
		local remaining = math.max(0, roundEndsAt - os.time())
		timer.Text = string.format("RUN TIME  %02d:%02d  •  Deliver at the pink reactor", math.floor(remaining / 60), remaining % 60)
		task.wait(1)
	end
end)
