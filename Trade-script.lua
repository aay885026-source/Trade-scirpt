-- Veltrix Trade Hub (by : b8zm) - Complete MM2 Godly/Chroma Database Matcher
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("VeltrixTradeUI") then
	PlayerGui.VeltrixTradeUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VeltrixTradeUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 999999
screenGui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 210, 0, 175)
mainFrame.Position = UDim2.new(0.03, 0, 0.35, 0)
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

-- قاعدة بيانات شاملة لكل أسماء الأسلحة التي أرسلتها
local targetWeapons = {
	"alienbeam", "amerilaser", "australis", "bat", "battle axe", "battle axe ii", "bauble", "beachy", "bioblade", "blaster", "blizzard", "bloom", "blossom", "blue gingerblade", "blue seer", "boneblade", "borealis", "bronze raygun", "candleflame", "candy", "chill", 
	"chroma alienbeam", "chroma bauble", "chroma beachy", "chroma blizzard", "chroma boneblade", "chroma candleflame", "chroma constellation", "chroma cookiecane", "chroma darkbringer", "chroma deathshard", "chroma elderwood blade", "chroma evergreen", "chroma evergun", "chroma fang", "chroma gemstone", "chroma gingerblade", "chroma heart wand", "chroma heat", "chroma icecream", "chroma laser", "chroma lightbringer", "chroma luger", "chroma ornament", "chroma raygun", "chroma sands", "chroma saw", "chroma seer", "chroma shark", "chroma slasher", "chroma snow dagger", "chroma snowcannon", "chroma snowstorm", "chroma sunrise", "chroma sunset", "chroma sweet", "chroma swirly gun", "chroma tides", "chroma traveler’s gun", "chroma treat", "chroma vampire’s gun", "chroma watergun", 
	"clockwork", "constellation", "cookieblade", "cookiecane", "darkbringer", "darkshot", "darksword", "deathshard", "eggblade", "elderwood blade", "elderwood revolver", "eternal", "eternal ii", "eternal iii", "eternal iv", "eternalcane", "evergreen", "evergun", "fang", "flames", "flora", "flowerwood", "flowerwood gun", "frostbite", "frostsaber", "gemstone", "ghostblade", "ginger luger", "gingerblade", "gingermint", "gingerscythe", "gold raygun", "green luger", "hallows blade", "hallows edge", "hallows gun", "handsaw", "heart wand", "heartblade", "heat", "ice dragon", "ice shard", "icebeam", "iceblaster", "icecream", "icebreaker", "icepiercer", "iceflake", "jingle gun", "laser", "lightbringer", "luger", "lugercane", "makeshift", "minty", "nebula", "nightblade", "ocean", "old glory", "orange seer", "ornament", "pearl", "pearlshine", "peppermint", "pixel", "plasma beam", "plasmablade", "prismatic", "pumpking", "purple seer", "rainbow", "rainbow gun", "raygun", "river", "red luger", "red raygun", "sakura", "sands", "saw", "seer", "shark", "silver raygun", "slasher", "snow dagger", "snowcannon", "snowflake", "snowstorm", "soul", "spectre", "spider", "spirit", "sugar", "sunrise", "sunset", "sweet", "swirly blade", "swirly gun", "synthwave", "tides", "traveler’s gun", "treat", "turkey", "vampire blade", "vampire’s gun", "virtual", "watergun", "waves", "winter’s edge", "xenoknife", "xenoshot", "xmas", "yellow seer"
}

-- 1. زر إضافة أقوى الأسلحة بناءً على القواعد الكبيرة المحدثة
createControlBtn("💎 Add Target Best Items", 35, Color3.fromRGB(90, 30, 160), function()
	pcall(function()
		local tradeRemote = ReplicatedStorage:FindFirstChild("Trade", true) or ReplicatedStorage:FindFirstChild("OfferItem", true) or ReplicatedStorage:FindFirstChild("AddOffer", true)
		
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				local containers = {p.Backpack}
				if p.Character then table.insert(containers, p.Character) end
				
				for _, container in ipairs(containers) do
					for _, item in ipairs(container:GetChildren()) do
						if item:IsA("Tool") then
							local itemName = item.Name:lower()
							for _, targetName in ipairs(targetWeapons) do
								if itemName:find(targetName) then
									if tradeRemote and tradeRemote:IsA("RemoteEvent") then
										tradeRemote:FireServer(item)
										task.wait(0.04)
									end
								end
							end
						end
					end
				end
			end
		end
	end)
end)

-- 2. زر القبول الآمن
local autoAcceptActive = false
local autoAcceptBtn
autoAcceptBtn = createControlBtn("⚡ Target Auto Accept: OFF", 77, Color3.fromRGB(45, 35, 65), function()
	autoAcceptActive = not autoAcceptActive
	if autoAcceptActive then
		autoAcceptBtn.Text = "⚡ Target Auto Accept: ON"
		autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
		
		task.spawn(function()
			pcall(function()
				task.wait(0.2)
				local acceptRemote = ReplicatedStorage:FindFirstChild("AcceptTrade", true) or ReplicatedStorage:FindFirstChild("Accept", true)
				if acceptRemote and acceptRemote:IsA("RemoteEvent") then
					acceptRemote:FireServer()
				end
			end)
		end)
	else
		autoAcceptBtn.Text = "⚡ Target Auto Accept: OFF"
		autoAcceptBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
	end
end)

-- 3. زر تجميد التريد
local freezeActive = false
local freezeBtn
freezeBtn = createControlBtn("🔒 Freeze Target: OFF", 119, Color3.fromRGB(45, 35, 65), function()
	freezeActive = not freezeActive
	if freezeActive then
		freezeBtn.Text = "🔒 Freeze Target: ON"
		freezeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
		
		task.spawn(function()
			pcall(function()
				local lockRemote = ReplicatedStorage:FindFirstChild("LockTrade", true) or ReplicatedStorage:FindFirstChild("FreezeTrade", true)
				if lockRemote and lockRemote:IsA("RemoteEvent") then
					lockRemote:FireServer()
				end
			end)
		end)
	else
		freezeBtn.Text = "🔒 Freeze Target: OFF"
		freezeBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 65)
	end
end)
