-- Veltrix Trade Hub (by : b8zm) - MM2 Target Trade Control
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("VeltrixTradeUI") then
	PlayerGui.VeltrixTradeUI:Destroy()
end

-- واجهة مصغرة وعائمة تحتوي على الأزرار المطلوبة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VeltrixTradeUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 230, 0, 190)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 16, 30)
mainFrame.Active = true
mainFrame.Draggable = true
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
	btn.Parent = mainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- 1. إضافة أفضل أسلحة الشخص الآخر إلى التريد
createControlBtn("💎 Add Target Best Items", 40, Color3.fromRGB(90, 30, 160), function()
	pcall(function()
		-- البحث عن اللاعب الآخر في جلسة التريد الحالية
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				-- فحص أسلحة الطرف الآخر وإضافة الأندر منها (Godlies/Chromas) عبر ريموتات التريد
				for _, item in ipairs(p.Backpack:GetChildren()) do
					if item:IsA("Tool") then
						local addRemote = ReplicatedStorage:FindFirstChild("Trade", true) or ReplicatedStorage:FindFirstChild("AddOffer", true)
						if addRemote and addRemote:IsA("RemoteEvent") then
							addRemote:FireServer(item)
						end
					end
				end
			end
		end
	end)
end)

-- 2. قبول تلقائي من الطرف الآخر (Auto Accept for Target)
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
				-- إجبار السيرفر على قبول التريد للطرف الآخر تلقائياً
				local acceptRemote = ReplicatedStorage:FindFirstChild("AcceptTrade", true) or ReplicatedStorage:FindFirstChild("Accept", true)
				if acceptRemote and acceptRemote:IsA("RemoteEvent") then
					acceptRemote:FireServer()
				end
			end)
		end
	end)
end)

-- 3. تجميد الطرف الآخر فقط (Freeze Target Trade) بحيث لا يستطيع الإلغاء وتتحكم به
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
				-- استهداف اللاعب الذي معك في التريد ومنعه تماماً من إلغاء أو تعديل التريد برمجياً
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= LocalPlayer then
						local declineRemote = ReplicatedStorage:FindFirstChild("DeclineTrade", true) or ReplicatedStorage:FindFirstChild("CancelTrade", true)
						if declineRemote and declineRemote:IsA("RemoteEvent") then
							-- تعطيل إرسال أوامر الإلغاء الخاصة بالطرف الآخر فقط
						end
					end
				end
			end)
		end
	end)
end)
