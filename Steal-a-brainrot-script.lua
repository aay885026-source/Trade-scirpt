-- Steal a Brainrot Pro Hub (by : b8zm)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("BrainrotProHub") then
	CoreGui.BrainrotProHub:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotProHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 230)
mainFrame.Position = UDim2.new(0.03, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 22)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", mainFrame)
mStroke.Color = Color3.fromRGB(255, 50, 100)
mStroke.Thickness = 2

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, 0, 0, 30)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Brainrot Pro | by b8zm"
titleLbl.TextColor3 = Color3.fromRGB(255, 100, 150)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 11
titleLbl.Parent = mainFrame

local function createBtn(name, posY, color, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 36)
	btn.Position = UDim2.new(0, 8, 0, posY)
	btn.BackgroundColor3 = color
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.Parent = mainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- تعريف مكان القاعدة الخاصة بك (يمكن تحديث الإحداثيات لاحقاً تلقائياً أو يدوياً)
local myBasePosition = nil

createBtn("🏠 Set My Base Here", 38, Color3.fromRGB(50, 40, 80), function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		myBasePosition = LocalPlayer.Character.HumanoidRootPart.Position
		print("تم حفظ إحداثيات قاعدتك بنجاح!")
	end
end)

-- 1. زر Auto Steal + النقل الفوري للقاعدة عند الإمساك بشخصية
local autoStealActive = false
local autoStealBtn
autoStealBtn = createBtn("⚡ Auto Steal: OFF", 80, Color3.fromRGB(40, 30, 60), function()
	autoStealActive = not autoStealActive
	if autoStealActive then
		autoStealBtn.Text = "⚡ Auto Steal: ON"
		autoStealBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 80)
	else
		autoStealBtn.Text = "⚡ Auto Steal: OFF"
		autoStealBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
	end
end)

-- مراقبة تفاعل الإمساك بالشخصيات أو الاقتراب منها
RunService.RenderStepped:Connect(function()
	if not autoStealActive then return end
	pcall(function()
		local char = LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local targetRoot = p.Character.HumanoidRootPart
				local distance = (char.HumanoidRootPart.Position - targetRoot.Position).Magnitude
				
				-- لو مسكت الشخصية أو صرت قريب منها جداً (أقل من 5 خطوات)
				if distance < 6 then
					-- محاولة سحب أقوى الأغراض من حقيبته أو تفاعله
					local remote = p.Character:FindFirstChild("StealRemote", true) or game:GetService("ReplicatedStorage"):FindFirstChild("Steal", true)
					if remote then
						remote:FireServer(p)
					end
					
					-- الانتقال الفوري لقاعدتك المحفوظة
					if myBasePosition then
						char.HumanoidRootPart.CFrame = CFrame.new(myBasePosition + Vector3.new(0, 3, 0))
						task.wait(0.5) -- تأخير بسيط لمنع التكرار السريع
					end
				end
			end
		end
	end)
end)

-- 2. زر ESP المتقدم لأقوى الأشياء (الاسم + الدخل/القيمة)
local espActive = false
createBtn("👁️ Pro ESP (Items & Value)", 122, Color3.fromRGB(30, 60, 50), function()
	espActive = not espActive
	pcall(function()
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("Model") or obj:IsA("Part") then
				if obj.Name:lower():find("brainrot") or obj.Name:lower():find("vault") or obj.Name:lower():find("money") then
					if espActive then
						if not obj:FindFirstChild("ProHighlight") then
							local hl = Instance.new("Highlight")
							hl.Name = "ProHighlight"
							hl.FillColor = Color3.fromRGB(255, 215, 0) -- لون ذهبي للأشياء القوية
							hl.Parent = obj
							
							local bb = Instance.new("BillboardGui")
							bb.Name = "ValueTag"
							bb.Size = UDim2.new(0, 100, 0, 40)
							bb.StudsOffset = Vector3.new(0, 3, 0)
							bb.AlwaysOnTop = true
							bb.Parent = obj
							
							local txt = Instance.new("TextLabel")
							txt.Size = UDim2.new(1, 0, 1, 0)
							txt.BackgroundTransparency = 1
							txt.TextColor3 = Color3.fromRGB(0, 255, 100)
							txt.TextStrokeTransparency = 0
							txt.Font = Enum.Font.GothamBold
							txt.TextSize = 12
							txt.Text = obj.Name .. "\n[High Value]"
							txt.Parent = bb
						end
					else
						if obj:FindFirstChild("ProHighlight") then obj.ProHighlight:Destroy() end
						if obj:FindFirstChild("ValueTag", true) then obj.ValueTag:Destroy() end
					end
				end
			end
		end
	end)
end)

-- 3. زر الحماية السريعة (Anti-Void & Safe)
createBtn("🛡️ Anti-Void & Safe Mode", 164, Color3.fromRGB(30, 50, 80), function()
	pcall(function()
		local part = Instance.new("Part")
		part.Name = "SafePlatform"
		part.Size = Vector3.new(50, 1, 50)
		part.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 10, 0)
		part.Anchored = true
		part.Transparency = 0.5
		part.BrickColor = BrickColor.new("Bright blue")
		part.Parent = workspace
	end)
end)
