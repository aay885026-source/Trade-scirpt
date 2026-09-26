-- Veltrix Trade Hub (by : b8zm) - Final Clean & Movable UI
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("VeltrixTradeUI") then
	PlayerGui.VeltrixTradeUI:Destroy()
end

-- واجهة مصغرة وعائمة تظهر فوق كل شيء وتقدر تسحبها لمكان ما تبيه
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VeltrixTradeUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 999999
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 210, 0, 175)
mainFrame.Position = UDim2.new(0.03, 0, 0.35, 0) -- مكان مرتب ع اليسار ما يخرب رؤية التريد
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
mainFrame.Active = true
mainFrame.Draggable = true -- يقدر اللاعب يسحب المربع ويحركه بأي مكان بالشاشة
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", mainFrame)
mStroke.Color = Color3.fromRGB(130, 50, 220)
mStroke.Thickness = 2

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, 0, 0, 28)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Veltrix Trade | by b8zm"
titleLbl.TextColor3 = Color3.fromRGB(220, 180, 255)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 11
titleLbl.ZIndex = 11
titleLbl.Parent = mainFrame

local function createControlBtn(name, posY, initialColor, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 36)
	btn.Position = UDim2.new(0, 8, 0, posY)
	btn.BackgroundColor3 = initialColor
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.ZIndex = 12
	btn.Parent = mainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Click:Connect(function()
		task.spawn(callback)
	end)
	return btn
end

-- 1. زر إضافة أفضل أسلحة الشخص الآخر
createControlBtn("💎 Add Target Best Items", 35, Color3.fromRGB(90, 30, 160), function()
	pcall(function()
		for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
			if descendant:IsA("RemoteEvent") then
				local n = descendant.Name:lower()
				if n:find("trade") or n:find("offer") or n:find("item") then
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= LocalPlayer and p.Backpack then
							for _, item in ipairs(p.Backpack:GetChildren()) do
								if item:IsA("Tool") then
									descendant:FireServer(item)
								end
							end
						end
					end
				end
			end
		end
	end)
end)

-- 2. زر القبول التلقائي للطرف الآخر
local autoAcceptActive = false
local autoAcceptBtn
autoAcceptBtn = createControlBtn("⚡ Target Auto Accept: OFF", 77, Color3.fromRGB(45, 35, 65), function()
	autoAcceptActive = not autoAcceptActive
	if autoAcceptActive then
		autoAcceptBtn.Text = "⚡ Target Auto Accept: ON"
		autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
	else
		autoAcceptBtn.Text = "⚡ Target Auto Accept: OFF"
		autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
	end
	
	task.spawn(function()
		while autoAcceptActive do
			pcall(function()
				for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
					if descendant:IsA("RemoteEvent") then
						local n = descendant.Name:lower()
						if n:find("accept") or n:find("trade") then
							descendant:FireServer()
						end
					end
				end
			end)
			task.wait(0.3)
		end
	end)
end)

-- 3. زر تجميد الطرف الآخر فقط
local freezeActive = false
local freezeBtn
freezeBtn = createControlBtn("🔒 Freeze Target: OFF", 119, Color3.fromRGB(45, 35, 65), function()
	freezeActive = not freezeActive
	if freezeActive then
		freezeBtn.Text = "🔒 Freeze Target: ON"
		freezeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
	else
		freezeBtn.Text = "🔒 Freeze Target: OFF"
		freezeBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
	end
	
	task.spawn(function()
		while freezeActive do
			pcall(function()
				for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
					if descendant:IsA("RemoteEvent") then
						local n = descendant.Name:lower()
						if n:find("decline") or n:find("cancel") then
							-- تعطيل الإلغاء للطرف الآخر
						end
					end
				end
			end)
			task.wait(0.1)
		end
	end)
end)
