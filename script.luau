local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local PhysicsService = game:GetService("PhysicsService")
local Mouse = Players.LocalPlayer:GetMouse()

local gradient = nil
local player = Players.LocalPlayer

local PlayerGUI = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

local FrameOn = "Nothing"
local mouseLocked = true
local toggleKey = Enum.KeyCode.F
local savedCameraCFrame
local hrp

local positions = {0.0, 0.333, 0.5, 0.668, 1.0}
local endValues = {0.9, 0.2, 0.2, 0.2, 0.9}

local startValues = {1, 1, 1, 1, 1}

local driver = Instance.new("NumberValue")
driver.Value = 0

local I = 0
local Y_Void = -20
local Layorder_v = 0

local tweenInfo = TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)

local NoClip = false

local WalkSpeedNIL = false
local JumpPowerNIL = false

game:GetService("Workspace"):WaitForChild(player.Name):WaitForChild("Humanoid").UseJumpPower = true
local WalkSpeedDefault = game:GetService("Workspace"):WaitForChild(player.Name):WaitForChild("Humanoid").WalkSpeed or 16
local JumpPowerDefault = game:GetService("Workspace"):WaitForChild(player.Name):WaitForChild("Humanoid").JumpPower or 7.68

local WalkSpeed = 0
local JumpPower = 0

local c = 0
local LastJumpPowerSlider = 0
local LastWalkSpeedSlider = 0

local Fly = false
local Shifting = false
local IsOnASlider = false
local InfinityJumping = false
local canJump = true

local AntiGrab = false
local AntiExplode = false
local AntiKick = false
local AntiFire = false
local AntiFling = false
local AntiLag = false
local AntiVoid = false

local IsHeld = false

local MaxValue = 0.7 or 70/100
local StartingValue = 0.4 or 40/100

local CanSafeExplode = true
local MapWith = 1200
local MaxFlingDis = 1000                                                                                                                                                                    + MapWith

local TemplatesTabel = {
	["1_Num"] = {
		Image = "rbxassetid://121360723582316",
		Text = "Player",
		NormalImage = true,
		lay = 1
	},
	["2_Num"] = {
		Image = "rbxassetid://75056661503527",
		Text = "Grab",
		NormalImage = true,
		lay = 2
	},
	["3_Num"] = {
		Image = "rbxassetid://123882327453349",
		Text = "Loop Players",
		NormalImage = true,
		lay = 3
	},
	["4_Num"] = {
		Image = "rbxassetid://96830428755097",
		Text = "Aura",
		NormalImage = true,
		lay = 4
	},
	["5_Num"] = {
		Image = "rbxassetid://117334701771111",
		Text = "Houses",	
		NormalImage = true,
		lay = 5
	},
	["6_Num"] = {
		Image = "rbxassetid://86261480709496",
		Text = "Teleport",
		NormalImage = true,
		lay = 6
	},
	["7_Num"] = {
		Image = "rbxassetid://130851511369681",
		Text = "Troll",
		NormalImage = true,
		lay = 7
	},
	["8_Num"] = {
		Image = "rbxassetid://130851511369681",
		Text = "Kick",
		NormalImage = false,
		ImageText = "🦶",
		lay = 8
	},
	["9_Num"] = {
		Image = "rbxassetid://87403748556978",
		Text = "Destroy Server",
		NormalImage = true,
		lay = 9
	},
	["10_Num"] = {
		Image = "rbxassetid://96632282683571",
		Text = "Costume             Line",
		NormalImage = true,
		lay = 10
	},
	["11_Num"] = {
		Image = "rbxassetid://89070622933780",
		Text = "Settings",
		NormalImage = true,
		lay = 11
	},
	["12_Num"] = {
		Image = "rbxassetid://126424328834382",
		Text = "Misk",
		NormalImage = true,
		lay = 12
	},
	["13_Num"] = {
		Image = "rbxassetid://112897493994788",
		Text = "Update& Owners",
		NormalImage = true,
		lay = 13
	}
}

local SlidersMax =  {
	["WalkSpeed"] = {
		Max = 1000,
	}
}

local TweenInfo_Slider = TweenInfo.new(0.5,Enum.EasingStyle.Exponential)

local function DeleteDrop(NameOfThing)
	local RS = game:GetService("ReplicatedStorage")
	
	RS.MenuToys.DestroyToy:FireServer(workspace[player.Name .. "SpawnedInToys"]:GetChildren()[#workspace[player.Name .. "SpawnedInToys"]:GetChildren()])
end

local function SpawnDrop(NameOfThing, Position, Rotation)
	local RS = game:GetService("ReplicatedStorage")
	task.spawn(function()
		local Position_Set = CFrame.new(Position)
		local Rotation_Set = Vector3.new(-100,0,0)
		RS.MenuToys.SpawnToyRemoteFunction:InvokeServer(NameOfThing, Position_Set, Rotation_Set)
	end)
	task.wait(0.4)
	DeleteDrop(NameOfThing)
end

local function DoMovementFaster()
	local Character = game.Players.LocalPlayer.Character
	local Humanoid = Character:FindFirstChild("Humanoid") 
	
	if WalkSpeedNIL == true and Shifting then
		Humanoid.WalkSpeed = WalkSpeed
	elseif WalkSpeedNIL == false or not Shifting then
		Humanoid.WalkSpeed = WalkSpeedDefault
	end
	if JumpHightNIL == true and Shifting then
		Humanoid.JumpPower = JumpPower
	elseif JumpHightNIL == false or not Shifting then
		Humanoid.JumpPower = JumpPowerDefault
	end
end

local function onSeated(isSeated)
	if isSeated then
		Shifting = false
	end
end

local function onJumpRequest()
	if InfinityJumping and Shifting then
		if canJump then
			game:GetService("Workspace"):FindFirstChild(player.Name):FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			canJump = false
			task.wait(0.05)
			canJump = true
		end
	end
end

local player = game.Players.LocalPlayer

local function TeleportPlayerFling()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local origin = hrp.Position
	local step, radius = 10, 10000000

	local ignoreList = {char}
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(ignoreList, p.Character)
		end
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = ignoreList
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local closestHit, closestDist = nil, math.huge

	for pitch = -90, 90, step do
		for yaw = 0, 360, step do
			local dir = CFrame.Angles(math.rad(pitch), math.rad(yaw), 0).LookVector
			local result = workspace:Raycast(origin, dir * radius, raycastParams)
			if result then
				local dist = (result.Position - origin).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestHit = result
				end
			end
		end
	end

	if closestHit then
		local newPos = closestHit.Position + Vector3.new(0, 3, 0)
		hrp.CFrame = CFrame.new(newPos, hrp.CFrame.LookVector + newPos)
		print("Teleported to nearest ground at:", newPos)
	else
		warn("No nearby ground detected within search radius.")
	end
end

local function DoAntiMapFling()
	if not AntiFling then return end
	local Character = game:GetService("Players").LocalPlayer.Character
	local ZeroPoint = game:GetService("Workspace"):FindFirstChild("ZeroPoint")

	local RootPart = Character:FindFirstChild("HumanoidRootPart")

	local Dis = (RootPart.Position - ZeroPoint.Position).Magnitude

	if Dis == MaxFlingDis or Dis >= MaxFlingDis then
		Character:MoveTo(ZeroPoint.Position)
		game:GetService("ReplicatedStorage").GameCorrectionEvents.StopAllVelocity:FireServer()	
		for _,Part in Character:GetChildren() do
			if Part:IsA("BasePart") then
				Part.Anchored = true
			end
		end
		task.wait(0.1)
		for _,Part in Character:GetChildren() do
			if Part:IsA("BasePart") then
				Part.Anchored = false
			end
		end
	end
end

local function DoAntiFling()
	local Ragdolled = player.Character:FindFirstChild("Humanoid"):FindFirstChild("Ragdolled")
	
	if AntiFling then
		for _,Player in game:GetService("Players") do
			local Character = game:GetService("Workspace"):FindFirstChild(Player.Name) 
			for _,Part in Character:GetChildren() do
				if Part:IsA("BasePart") then
					Part.CanCollide = false
				end
			end
		end
		if Ragdolled.Value == true  then
			warn("Player is ragdolled")
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			
			while Ragdolled.Value == true or IsHeld do
				ReplicatedStorage.GameCorrectionEvents.StopAllVelocity:FireServer()
				TeleportPlayerFling()
				for Number, Objects in ipairs(player.Character:GetChildren()) do
					if Objects:IsA("BasePart") then
						Objects.Anchored = true
					end
				end
				task.wait(0)
			end
			for Number, Objects in ipairs(player.Character:GetChildren()) do
				if Objects:IsA("BasePart") then
					Objects.Anchored = false
				end
			end
		end
	elseif not AntiFling then
		for _,Player in game:GetService("Players") do
			local Character = game:GetService("Workspace"):FindFirstChild(Player.Name) 
			for _,Part in Character:GetChildren() do
				if Part:IsA("BasePart") then
					Part.CanCollide = true
				end
			end
		end
	end
end

local function DoAntiVoid()
	local Character = game.Players.LocalPlayer.Character
	if not Character then return end
	local RootPart = Character:FindFirstChild("HumanoidRootPart")
	
	while AntiVoid do
		wait(0)
		if RootPart then
			if RootPart.Position.Y < Y_Void then
				warn("Player is in void")
				Character:MoveTo(game:GetService("Workspace"):FindFirstChild("ZeroPoint").Position)
				game:GetService("ReplicatedStorage").GameCorrectionEvents.StopAllVelocity:FireServer()
			end
		end
	end
end

local function DoAntiFire()
	local Character = game.Players.LocalPlayer.Character
	if not Character then return end
	local RootPart = Character:FindFirstChild("HumanoidRootPart")
	if not RootPart then return end
	local FirePlayerPart = RootPart:FindFirstChild("FirePlayerPart")
	if not FirePlayerPart then return end
	local CanBurn = FirePlayerPart:FindFirstChild("CanBurn")
	
	if AntiFire then
		if CanBurn.Value then
			warn("Player is on fire")
			SpawnDrop("FireExtinguisher", Vector3.new(RootPart.Position.X,RootPart.Position.Y + 4,RootPart.Position.Z + 22))
		end
	end
end

local function DoAntiGrab()
	local Character = game.Players.LocalPlayer.Character
	if not Character then return end
	local Humanoid = Character:FindFirstChild("Humanoid")
	if not Humanoid then return end
	local RootPart = Character:FindFirstChild("HumanoidRootPart")
	if not RootPart then return end
	
	local Character_Head = Character.Head
	local PartOwner = Character_Head:FindFirstChild("PartOwner")
	if AntiGrab then
		if PartOwner then
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
			local Struggle = CharacterEvents:WaitForChild("Struggle")
			
			Struggle:FireServer()
			ReplicatedStorage.GameCorrectionEvents.StopAllVelocity:FireServer()
		end
		if IsHeld then
			RootPart.Anchored = true
		elseif not IsHeld then
			RootPart.Anchored = false
		end
	end
end

local function DoAntiExplosive()	
	local Ragdolled = player.Character:WaitForChild("Humanoid"):FindFirstChild("Ragdolled")
	if Ragdolled then
		if Ragdolled.Value then
			for Number, Objects in ipairs(player.Character:GetChildren()) do
				if Objects:IsA("BasePart") then
					Objects.Anchored = true
				end
			end	
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			ReplicatedStorage.GameCorrectionEvents.StopAllVelocity:FireServer()
		else
			CanSafeExplode = true
			for Number, Objects in ipairs(player.Character:GetChildren()) do
				if Objects:IsA("BasePart") then
					Objects.Anchored = false
				end
			end
		end
	end
end

local function onTouched(part)
	if not part:IsA("BasePart") then return end
	if not part.Anchored then return end
	if not player.Character then return end

	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if part.Position.Y < (hrp.Position.Y - hrp.Size.Y) then return end

	part.CanCollide = not NoClip
end

local function ToggleAntiVoid(Button,Text,Toggle)
	if Toggle then
		AntiVoid = not AntiVoid
	end
	if AntiVoid then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not AntiVoid then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleAntiFling(Button,Text,Toggle)
	if Toggle then
		AntiFling = not AntiFling
	end
	if AntiFling then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not AntiFling then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleAntiExplosive(Button,Text,Toggle)
	if Toggle then 
		AntiExplode = not AntiExplode
	end
	if AntiExplode then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not AntiExplode then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleAntiFire(Button,Text,Toggle)
	if Toggle then 
		AntiFire = not AntiFire
	end
	if AntiFire then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not AntiFire then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleAntiGrab(Button,Text,Toggle)
	if Toggle then 
		AntiGrab = not AntiGrab
	end
	if AntiGrab then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not AntiGrab then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleNoClip(Button,Text,Toggle)
	if Toggle then 
		NoClip = not NoClip
	end
	
	if NoClip then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not NoClip then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleWalkSpeed(Button,Text,Toggle)
	if Toggle then
		WalkSpeedNIL = not WalkSpeedNIL
	end
	if WalkSpeedNIL then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not WalkSpeedNIL then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleJumpHight(Button,Text,Toggle)
	if Toggle then
		JumpHightNIL = not JumpHightNIL
	end
	if JumpHightNIL then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not JumpHightNIL then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function ToggleInfintyJumping(Button,Text,Toggle)
	if Toggle then
		InfinityJumping = not InfinityJumping
	end
	if InfinityJumping then
		Button.BackgroundColor3 = Color3.fromRGB(67, 255, 64)
		Text.Text = "ON"
	elseif not InfinityJumping then
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Text.Text = "OFF"
	end
end

local function SetValueSlider(Slider,OutPutValue,Fill,OutputText,Name)
	local output = 0 

	if Name == "WalkSpeed" then
		output = LastWalkSpeedSlider
	elseif Name == "JumpPower" then
		output = LastJumpPowerSlider
	end

	local outputClamped = StartingValue + (output * (MaxValue - StartingValue))

	Fill.Size = UDim2.fromScale(output,1)
	print(Fill)

	OutPutValue.Value = outputClamped
	OutputText.Text = tostring(math.round(Fill.Size.X.Scale * 100))
end

local function UpdateSlider(Slider,OutPutValue,Fill,OutputText,Name)
	local output = math.clamp(((Vector2.new(Mouse.X,Mouse.Y)-Slider.AbsolutePosition)/Slider.AbsoluteSize).X,0,1)

	local outputClamped = StartingValue + (output*(MaxValue-StartingValue))

	if OutPutValue.Value ~= outputClamped then
		TweenService:Create(Fill,TweenInfo_Slider,{Size = UDim2.fromScale(output,1)}):Play()
	end
	
	if Name == "WalkSpeed" then
		LastWalkSpeedSlider = output
	elseif Name == "JumpHight" then
		LastJumpPowerSlider = output
	end
	
	OutPutValue.Value = outputClamped
	OutputText.Text = tostring(math.round(Fill.Size.X.Scale*100))
end

local function SetButtons(Button,Textlabel,Toggle)
	if Button.Name == "NoClip" then
		ToggleNoClip(Button,Textlabel,Toggle)
	elseif Button.Name == "WalkSpeedChange" then
		ToggleWalkSpeed(Button,Textlabel,Toggle)
	elseif Button.Name == "JumpHightChange" then
		ToggleJumpHight(Button,Textlabel,Toggle)
	elseif Button.Name == "InfintyJumpingChange" then
		ToggleInfintyJumping(Button,Textlabel,Toggle)
	elseif Button.Name == "AntiGrabChange" then
		ToggleAntiGrab(Button,Textlabel,Toggle)
	elseif Button.Name == "AntiExplodeChange" then
		ToggleAntiExplosive(Button,Textlabel,Toggle)
	elseif Button.Name == "AntiFireChange" then
		ToggleAntiFire(Button,Textlabel,Toggle)
	elseif Button.Name == "AntiFlingChange" then
		ToggleAntiFling(Button,Textlabel,Toggle)
	elseif Button.Name == "AntiVoidChange" then
		ToggleAntiVoid(Button,Textlabel,Toggle)
	end 
end

local function CreateButton(Type,Text,Parent,Name)
	Layorder_v += 1
	if Type == "Space" then
		local Frame = Instance.new("Frame")
		Frame.Parent = Parent
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundTransparency = 1
		Frame.LayoutOrder = Layorder_v
		Frame.Name = Name
		Frame.Size = UDim2.new(0,0,0,0)

	elseif Type == "SliderButton" then
		local Frame_Main = Instance.new("Frame")
		Frame_Main.Parent = Parent
		Frame_Main.BackgroundColor3 = Color3.fromRGB(9,9,9)
		Frame_Main.Visible = true
		Frame_Main.Name = "Frame_"..Name
		Frame_Main.LayoutOrder = Layorder_v
		Frame_Main.Size = UDim2.new(0.8,0,0.04,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Frame_Main
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0.025,0)
		UICorner.Parent = Frame_Main

		local UIListLayout_Hold = Instance.new("UIListLayout")
		UIListLayout_Hold.Parent = Frame_Main
		UIListLayout_Hold.Padding = UDim.new(0.05, 0)
		UIListLayout_Hold.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_Hold.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_Hold.Wraps = false
		UIListLayout_Hold.HorizontalAlignment = Enum.HorizontalAlignment.Left
		UIListLayout_Hold.HorizontalFlex = Enum.UIFlexAlignment.None
		UIListLayout_Hold.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
		UIListLayout_Hold.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout_Hold.VerticalFlex = Enum.UIFlexAlignment.None

		local Textlabel = Instance.new("TextLabel")
		Textlabel.Parent = Frame_Main
		Textlabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		Textlabel.BackgroundTransparency = 1
		Textlabel.Text = Text
		Textlabel.Font = Enum.Font.FredokaOne
		Textlabel.TextScaled = true
		Textlabel.Visible = true
		Textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		Textlabel.Name = "Text_"..Layorder_v
		Textlabel.Position = UDim2.new(0.5,0,0.5,0)
		Textlabel.AnchorPoint = Vector2.new(0.5,0.5)
		Textlabel.ZIndex = 2
		Textlabel.Size = UDim2.new(0.5,0,0.9,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Textlabel
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local Frame = Instance.new("Frame")
		Frame.Parent = Frame_Main
		Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		Frame.Visible = true
		Frame.Name = "FrameSlider"
		Frame.LayoutOrder = Layorder_v
		Frame.Size = UDim2.new(0.425,0,0.8,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Frame
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local Frame_BackGround = Instance.new("Frame")
		Frame_BackGround.Parent = Frame
		Frame_BackGround.BackgroundColor3 = Color3.fromRGB(0, 145, 255)
		Frame_BackGround.Visible = true
		Frame_BackGround.Name = "Fill"
		Frame_BackGround.LayoutOrder = 0
	--	Frame_BackGround.Size = UDim2.new(1,0,1,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Frame_BackGround
		UIStroke.Thickness = 3
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local Textlabel = Instance.new("TextLabel")
		Textlabel.Parent = Frame
		Textlabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		Textlabel.BackgroundTransparency = 1
		Textlabel.Text = Text
		Textlabel.Font = Enum.Font.FredokaOne
		Textlabel.TextScaled = true
		Textlabel.Visible = true
		Textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		Textlabel.Name = "Label"
		Textlabel.Position = UDim2.new(0.5,0,0.5,0)
		Textlabel.AnchorPoint = Vector2.new(0.5,0.5)
		Textlabel.ZIndex = 100
		Textlabel.Size = UDim2.new(0.9,0,0.9,0)
		Textlabel.Selectable = false
		Textlabel.Interactable = false

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Textlabel
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local TextButton = Instance.new("TextButton")
		TextButton.Parent = Frame
		TextButton.Text = ""
		TextButton.Size = UDim2.new(1,0,1,0)
		TextButton.Position = UDim2.new(0.5,0,0.5,0)
		TextButton.ZIndex = 2
		TextButton.BackgroundTransparency = 1
		TextButton.BorderSizePixel = 0
		TextButton.AutoButtonColor = false
		TextButton.AnchorPoint = Vector2.new(0.5,0.5)
		TextButton.Name = "Trigger"

		local OutputValue = Instance.new("NumberValue")
		OutputValue.Parent = Frame
		OutputValue.Name = "OutputValue"
		OutputValue.Value = 0
		
		SetValueSlider(Frame,OutputValue,Frame_BackGround,Textlabel,Name)
		
		if OutputValue.Value <= 0.40 then Frame_BackGround:FindFirstChild("UIStroke").Thickness = 0 Frame_BackGround.BackgroundTransparency = 1 elseif OutputValue.Value >= 0.40 then Frame_BackGround:FindFirstChild("UIStroke").Thickness = 2 Frame_BackGround.BackgroundTransparency = 0 end

		local RealNumber = 0

		TextButton.MouseButton1Down:Connect(function()
			IsOnASlider = true
			while IsOnASlider do
				wait()
				UpdateSlider(Frame,OutputValue,Frame_BackGround,Textlabel,Name)
			end
		end)

		UserInputService.InputChanged:Connect(function()
			if Name == "WalkSpeed" then
				WalkSpeed = math.round(Frame_BackGround.Size.X.Scale*100)
			elseif Name == "JumpHight" then
				JumpPower = math.round(Frame_BackGround.Size.X.Scale*100)
			end
		end)

		Frame_BackGround:GetPropertyChangedSignal("Size"):Connect(function()
			Textlabel.Text = tostring(math.round(Frame_BackGround.Size.X.Scale*100))
			if OutputValue.Value <= 0.40 then
				Frame_BackGround:FindFirstChild("UIStroke").Thickness = 0
				Frame_BackGround.BackgroundTransparency = 1
			elseif OutputValue.Value >= 0.40 then
				Frame_BackGround:FindFirstChild("UIStroke").Thickness = 2
				Frame_BackGround.BackgroundTransparency = 0
			end
		end)

	elseif Type == "Button" then
		local Button = Instance.new("TextButton")
		Button.Parent = Parent
		Button.Text = ""
		Button.BackgroundColor3 = Color3.fromRGB(9,9,9)
		Button.Visible = true
		Button.Name = Name
		Button.LayoutOrder = Layorder_v
		Button.Size = UDim2.new(0.8,0,0.04,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Button
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0.025,0)
		UICorner.Parent = Button

		local Textlabel = Instance.new("TextLabel")
		Textlabel.Parent = Button
		Textlabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		Textlabel.BackgroundTransparency = 1
		Textlabel.Text = Text
		Textlabel.Font = Enum.Font.FredokaOne
		Textlabel.TextScaled = true
		Textlabel.Visible = true
		Textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		Textlabel.Name = "Text_"..Layorder_v
		Textlabel.Position = UDim2.new(0.5,0,0.5,0)
		Textlabel.AnchorPoint = Vector2.new(0.5,0.5)
		Textlabel.ZIndex = 2
		Textlabel.Size = UDim2.new(0.9,0,0.9,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Textlabel
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)
	elseif Type == "Text" then
		local Textlabel = Instance.new("TextLabel")
		Textlabel.Parent = Parent
		Textlabel.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
		Textlabel.Text = Text
		Textlabel.Font = Enum.Font.FredokaOne
		Textlabel.TextScaled = true
		Textlabel.Visible = true
		Textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		Textlabel.Name = Name
		Textlabel.LayoutOrder = Layorder_v
		Textlabel.BackgroundTransparency = 0
		Textlabel.RichText = true
		Textlabel.Size = UDim2.new(0.8,0,0.04,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Textlabel
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Textlabel
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0.025,0)
		UICorner.Parent = Textlabel
	elseif Type == "ToggleButton" then
		local Frame = Instance.new("Frame")
		Frame.Parent = Parent
		Frame.BackgroundColor3 = Color3.fromRGB(9,9,9)
		Frame.Visible = true
		Frame.Name = "Frame_"..Name
		Frame.LayoutOrder = Layorder_v
		Frame.Size = UDim2.new(0.8,0,0.04,0)

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0.025,0)
		UICorner.Parent = Frame

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Frame
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local Textlabel = Instance.new("TextLabel")
		Textlabel.Parent = Frame
		Textlabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		Textlabel.Text = Text
		Textlabel.Font = Enum.Font.FredokaOne
		Textlabel.TextScaled = true
		Textlabel.Visible = true
		Textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		Textlabel.Name = "TextLabel"
		Textlabel.BackgroundTransparency = 1
		Textlabel.ZIndex = 2
		Textlabel.Size = UDim2.new(0.65,0,0.9,0)
		Textlabel.LayoutOrder = -999

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Textlabel
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local Button = Instance.new("TextButton")
		Button.Parent = Frame
		Button.Text = ""
		Button.BackgroundColor3 = Color3.fromRGB(255, 96, 96)
		Button.Visible = true
		Button.Size = UDim2.new(0.25,0,0.75,0)
		Button.Name = Name
		Button.LayoutOrder = 999

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0.2,0)
		UICorner.Parent = Button

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Button
		UIStroke.Thickness = 4
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local Textlabel = Instance.new("TextLabel")
		Textlabel.Parent = Button
		Textlabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		Textlabel.Text = "OFF"
		Textlabel.Font = Enum.Font.FredokaOne
		Textlabel.TextScaled = true
		Textlabel.Visible = true
		Textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		Textlabel.Name = "TextLabel"
		Textlabel.LayoutOrder = Layorder_v
		Textlabel.BackgroundTransparency = 1
		Textlabel.ZIndex = 2
		Textlabel.Size = UDim2.new(0.9,0,0.9,0)
		Textlabel.Position = UDim2.new(0.5,0,0.5,0)
		Textlabel.AnchorPoint = Vector2.new(0.5,0.5)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Textlabel
		UIStroke.Thickness = 2
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		UIStroke.Transparency = 0
		UIStroke.Color = Color3.fromRGB(0,0,0)

		local UIListLayout_Hold = Instance.new("UIListLayout")
		UIListLayout_Hold.Parent = Frame
		UIListLayout_Hold.Padding = UDim.new(0.05, 0)
		UIListLayout_Hold.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_Hold.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_Hold.Wraps = false
		UIListLayout_Hold.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_Hold.HorizontalFlex = Enum.UIFlexAlignment.None
		UIListLayout_Hold.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
		UIListLayout_Hold.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout_Hold.VerticalFlex = Enum.UIFlexAlignment.None
		
		SetButtons(Button,Textlabel,false)

		Button.MouseButton1Click:Connect(function()
			SetButtons(Button,Textlabel,true)
		end)
	end
end

local function ClearCatagory(Cat)
	for i,v in pairs(Cat:GetChildren()) do
		if not v:IsA("UIListLayout") then
			v:Destroy()
		end	
	end
end

local function SetCatagory(Name,Parent,Scrolling)
	ClearCatagory(Parent)
	Layorder_v = 0
	if Name == "PlayerButton" then
		CreateButton("Text","⚡ Movement Player ⚡", Parent,"Title")

		CreateButton("SliderButton","WalkSpeed:", Parent,"WalkSpeed")
		CreateButton("ToggleButton","Speed:", Parent,"WalkSpeedChange")

		CreateButton("Space","SpaceBetwin", Parent,"Space")

		CreateButton("SliderButton","JumpHight:", Parent,"JumpHight")
		CreateButton("ToggleButton","Jump:", Parent,"JumpHightChange")
		CreateButton("ToggleButton","InfintyJump:", Parent,"InfintyJumpingChange")

		CreateButton("Space","SpaceBetwin", Parent,"Space")

		CreateButton("Text","💪 Powers 💪", Parent,"Title")

		CreateButton("ToggleButton","NoClip:", Parent,"NoClip")

		CreateButton("Space","SpaceBetwin", Parent,"Space")

		CreateButton("ToggleButton","Anti Grab:", Parent,"AntiGrabChange")
		CreateButton("ToggleButton","Anti Explode:", Parent,"AntiExplodeChange")
		CreateButton("ToggleButton","Anti Fire:", Parent,"AntiFireChange")
		CreateButton("ToggleButton","Anti Fling:", Parent,"AntiFlingChange")
		CreateButton("ToggleButton","Anti Lag:", Parent,"AntiLagChange")
		CreateButton("ToggleButton","Anti Void:", Parent,"AntiVoidChange")
		CreateButton("ToggleButton","Anti Kick:", Parent,"AntiKickChange")
		
		CreateButton("Space","SpaceBetwin", Parent,"Space")
		
		CreateButton("Text","if grabed torment way", Parent,"Title")
		CreateButton("ToggleButton","torment:", Parent,"torment")
	end
end

local function SetSettings(Type)
	if Type == "Start" then
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").TextTransparency = 0
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").UIStroke.Transparency = 0
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").Position = UDim2.new(1.4, 0,0.5, 0)
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").AnchorPoint = Vector2.new(0.5,0.5)
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").BackgroundTransparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").UIStroke.Transparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").TextTransparency = 1
	elseif Type == "End" then
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("UIGradient").Enabled = true
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").TextTransparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").UIStroke.Transparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").Position = UDim2.new(0.5, 0,0.5, 0)
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").AnchorPoint = Vector2.new(0.5,0.5)
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").BackgroundTransparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").UIStroke.Transparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").TextTransparency = 1
	end	
end

local function CreateZeroPoint()
	local ZeroPoint = Instance.new("Part")
	ZeroPoint.Parent = workspace
	ZeroPoint.Size = Vector3.new(1,1,1)
	ZeroPoint.Position = Vector3.new(0,20,0)
	ZeroPoint.Anchored = true
	ZeroPoint.Color = Color3.new(1, 0, 0)
	ZeroPoint.CanCollide = false
	ZeroPoint.Transparency = 0.5
	ZeroPoint.Name = "ZeroPoint"
end

local function CreateGUI()
	if PlayerGUI:FindFirstChild("MainGUI") then
		PlayerGUI:FindFirstChild("MainGUI"):Destroy()
	end

	local MainGUI = Instance.new("ScreenGui")
	MainGUI.Parent = PlayerGUI
	MainGUI.IgnoreGuiInset = true
	MainGUI.ResetOnSpawn = false
	MainGUI.Name = "MainGUI"
	MainGUI.Enabled = true
	MainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
	MainGUI.DisplayOrder = 999999999

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = MainGUI
	MainFrame.Position = UDim2.new(0.5, 0, 0.294, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Size = UDim2.new(0.4, 0, 0.07, 0)
	MainFrame.BackgroundTransparency = 1
	MainFrame.Interactable = true
	MainFrame.ZIndex = math.huge

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = MainFrame
	UIAspectRatioConstraint.Name = "Resize"
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
	UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	UIAspectRatioConstraint.AspectRatio = 10.432

	local UiDragDetector = Instance.new("UIDragDetector")
	UiDragDetector.Parent = MainFrame
	UiDragDetector.DragRelativity = Enum.UIDragDetectorDragRelativity.Absolute
	UiDragDetector.DragSpace = Enum.UIDragDetectorDragSpace.Parent
	UiDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale
	UiDragDetector.SelectionModeDragSpeed = UDim2.new(0, 0, 0, 0)
	UiDragDetector.SelectionModeRotateSpeed = 90
	UiDragDetector.UIDragSpeedAxisMapping = Enum.UIDragSpeedAxisMapping.XY

	local HolderFrame = Instance.new("Frame")
	HolderFrame.Parent = MainFrame
	HolderFrame.Size = UDim2.new(1, 0, 6, 0)
	HolderFrame.Position = UDim2.new(0.5, 0, 4, 0)
	HolderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	HolderFrame.Name = "HolderFrame"
	HolderFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

	local UICorner_Hold = Instance.new("UICorner")
	UICorner_Hold.Parent = HolderFrame
	UICorner_Hold.CornerRadius = UDim.new(0.025, 0)

	local UIStroke_Hold = Instance.new("UIStroke")
	UIStroke_Hold.Parent = HolderFrame
	UIStroke_Hold.Enabled = true
	UIStroke_Hold.Color = Color3.fromRGB(0, 0, 0)
	UIStroke_Hold.Thickness = 5
	UIStroke_Hold.Transparency = 0
	UIStroke_Hold.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke_Hold.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local UIListLayout_Hold = Instance.new("UIListLayout")
	UIListLayout_Hold.Parent = HolderFrame
	UIListLayout_Hold.Padding = UDim.new(0.01, 0)
	UIListLayout_Hold.FillDirection = Enum.FillDirection.Vertical
	UIListLayout_Hold.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_Hold.Wraps = false
	UIListLayout_Hold.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_Hold.HorizontalFlex = Enum.UIFlexAlignment.None
	UIListLayout_Hold.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	UIListLayout_Hold.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout_Hold.VerticalFlex = Enum.UIFlexAlignment.None

	local Frame = Instance.new("Frame")
	Frame.Parent = HolderFrame
	Frame.Size = UDim2.new(1, 0, 0.825, 0)
	Frame.AnchorPoint = Vector2.new(0, 0)
	Frame.Name = "Frame"
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1
	Frame.LayoutOrder = 999

	local UIListLayout_Frame = Instance.new("UIListLayout")
	UIListLayout_Frame.Parent = Frame
	UIListLayout_Frame.Padding = UDim.new(0.02, 0)
	UIListLayout_Frame.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_Frame.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_Frame.Wraps = false
	UIListLayout_Frame.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_Frame.HorizontalFlex = Enum.UIFlexAlignment.None
	UIListLayout_Frame.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	UIListLayout_Frame.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout_Frame.VerticalFlex = Enum.UIFlexAlignment.None

	local ButtonsFrame = Instance.new("Frame")
	ButtonsFrame.Parent = Frame
	ButtonsFrame.Size = UDim2.new(0.3, 0, 1, 0)
	ButtonsFrame.AnchorPoint = Vector2.new(0, 0)
	ButtonsFrame.Name = "ButtonsFrame"
	ButtonsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	ButtonsFrame.BackgroundTransparency = 0
	ButtonsFrame.LayoutOrder = 0

	local UICorner_ButtonsFrame = Instance.new("UICorner")
	UICorner_ButtonsFrame.Parent = ButtonsFrame
	UICorner_ButtonsFrame.CornerRadius = UDim.new(0.05, 0)

	local UIStroke_ButtonsFrame = Instance.new("UIStroke")
	UIStroke_ButtonsFrame.Parent = ButtonsFrame
	UIStroke_ButtonsFrame.Enabled = true
	UIStroke_ButtonsFrame.Color = Color3.fromRGB(0, 0, 0)
	UIStroke_ButtonsFrame.Thickness = 4
	UIStroke_ButtonsFrame.Transparency = 0
	UIStroke_ButtonsFrame.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke_ButtonsFrame.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local ScrollFrameMain = Instance.new("Frame")
	ScrollFrameMain.Parent = Frame
	ScrollFrameMain.Size = UDim2.new(0.68, 0, 1, 0)
	ScrollFrameMain.AnchorPoint = Vector2.new(0, 0)
	ScrollFrameMain.Name = "ScrollFrameMain"
	ScrollFrameMain.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	ScrollFrameMain.BackgroundTransparency = 0
	ScrollFrameMain.LayoutOrder = 0

	local UICorner_ScrollFrameMain = Instance.new("UICorner")
	UICorner_ScrollFrameMain.Parent = ScrollFrameMain
	UICorner_ScrollFrameMain.CornerRadius = UDim.new(0.025, 0)

	local UIStroke_ScrollFrameMain = Instance.new("UIStroke")
	UIStroke_ScrollFrameMain.Parent = ScrollFrameMain
	UIStroke_ScrollFrameMain.Enabled = true
	UIStroke_ScrollFrameMain.Color = Color3.fromRGB(0, 0, 0)
	UIStroke_ScrollFrameMain.Thickness = 4
	UIStroke_ScrollFrameMain.Transparency = 0
	UIStroke_ScrollFrameMain.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke_ScrollFrameMain.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local ScrollingFrame_Main = Instance.new("ScrollingFrame")
	ScrollingFrame_Main.Parent =	ScrollFrameMain
	ScrollingFrame_Main.Archivable = true
	ScrollingFrame_Main.Active = true
	ScrollingFrame_Main.AnchorPoint = Vector2.new(0.5,0.5)
	ScrollingFrame_Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
	ScrollingFrame_Main.BackgroundTransparency = 1
	ScrollingFrame_Main.Interactable = true
	ScrollingFrame_Main.Name = "ScrollingFrame"
	ScrollingFrame_Main.Position = UDim2.new(0.5,0,0.5,0)
	ScrollingFrame_Main.Rotation = 0
	ScrollingFrame_Main.Size = UDim2.new(0.97,0,0.98,0)
	ScrollingFrame_Main.Visible = true
	ScrollingFrame_Main.CanvasSize = UDim2.new(0,0,6,0)
	ScrollingFrame_Main.ScrollingDirection = Enum.ScrollingDirection.Y
	ScrollingFrame_Main.ScrollBarThickness = 6 -- 6
	ScrollingFrame_Main.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	ScrollingFrame_Main.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
	ScrollingFrame_Main.Selectable = false

	local ScrollFrame_Frame = Instance.new("Frame")
	ScrollFrame_Frame.Parent = ScrollingFrame_Main
	ScrollFrame_Frame.Size = UDim2.new(0.95, 0, 0.98, 0)
	ScrollFrame_Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollFrame_Frame.Position = UDim2.new(0.5,0,0.5,0)
	ScrollFrame_Frame.Name = "Frame"
	ScrollFrame_Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollFrame_Frame.BackgroundTransparency = 1
	ScrollFrame_Frame.LayoutOrder = 0

	local UIListLayout_Template = Instance.new("UIListLayout")
	UIListLayout_Template.Parent = ScrollFrame_Frame
	UIListLayout_Template.Padding = UDim.new(0.007, 0)
	UIListLayout_Template.FillDirection = Enum.FillDirection.Vertical
	UIListLayout_Template.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_Template.Wraps = false
	UIListLayout_Template.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout_Template.HorizontalFlex = Enum.UIFlexAlignment.None
	UIListLayout_Template.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	UIListLayout_Template.VerticalAlignment = Enum.VerticalAlignment.Top
	UIListLayout_Template.VerticalFlex = Enum.UIFlexAlignment.None

	local Title_HolderFrame = Instance.new("TextLabel")
	Title_HolderFrame.Parent = HolderFrame
	Title_HolderFrame.Active = false
	Title_HolderFrame.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
	Title_HolderFrame.BackgroundTransparency = 0
	Title_HolderFrame.LayoutOrder = -999
	Title_HolderFrame.Size = UDim2.new(1, 0, 0.15, 0)
	Title_HolderFrame.Font = Enum.Font.FredokaOne
	Title_HolderFrame.RichText = false
	Title_HolderFrame.Text = "Ki-Lua-Script"
	Title_HolderFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title_HolderFrame.TextScaled = true
	Title_HolderFrame.TextWrapped = true
	Title_HolderFrame.TextXAlignment = Enum.TextXAlignment.Center
	Title_HolderFrame.TextYAlignment = Enum.TextYAlignment.Center
	Title_HolderFrame.Name = "Title"

	local UICorner_Title_Holder = Instance.new("UICorner")
	UICorner_Title_Holder.Parent = Title_HolderFrame
	UICorner_Title_Holder.CornerRadius = UDim.new(0.1, 0)

	local UIStroke_Title_Holder = Instance.new("UIStroke")
	UIStroke_Title_Holder.Parent = Title_HolderFrame
	UIStroke_Title_Holder.Enabled = true
	UIStroke_Title_Holder.Color = Color3.fromRGB(0, 0, 0)
	UIStroke_Title_Holder.Thickness = 4
	UIStroke_Title_Holder.Transparency = 0
	UIStroke_Title_Holder.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke_Title_Holder.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual

	local UIStroke_Title_Holder_2 = Instance.new("UIStroke")
	UIStroke_Title_Holder_2.Parent = Title_HolderFrame
	UIStroke_Title_Holder_2.Enabled = true
	UIStroke_Title_Holder_2.Color = Color3.fromRGB(0, 0, 0)
	UIStroke_Title_Holder_2.Thickness = 4
	UIStroke_Title_Holder_2.Transparency = 0
	UIStroke_Title_Holder_2.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke_Title_Holder_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local ScrollingFrame = Instance.new("ScrollingFrame")
	ScrollingFrame.Parent =	ButtonsFrame
	ScrollingFrame.Archivable = true
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5,0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.Interactable = true
	ScrollingFrame.Name = "ScrollingFrame"
	ScrollingFrame.Position = UDim2.new(0.5,0,0.5,0)
	ScrollingFrame.Rotation = 0
	ScrollingFrame.Size = UDim2.new(0.97,0,0.95,0)
	ScrollingFrame.Visible = true
	ScrollingFrame.CanvasSize = UDim2.new(0,0,3,0)
	ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	ScrollingFrame.ScrollBarThickness = 4 -- 6
	ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
	ScrollingFrame.Selectable = false

	local MainFrame_ScrollingFrame = Instance.new("Frame")
	MainFrame_ScrollingFrame.Parent = ScrollingFrame
	MainFrame_ScrollingFrame.AnchorPoint = Vector2.new(0.5,0.5)
	MainFrame_ScrollingFrame.Position = UDim2.new(0.48, 0, 0.5, 0)
	MainFrame_ScrollingFrame.Size = UDim2.new(0.9, 0, 0.98, 0)
	MainFrame_ScrollingFrame.Name = "Frame"
	MainFrame_ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrame_ScrollingFrame.BackgroundTransparency = 1
	MainFrame_ScrollingFrame.LayoutOrder = 0

	local UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.Parent = MainFrame_ScrollingFrame
	UIGridLayout.CellPadding = UDim2.new(0,0,0.017,0)
	UIGridLayout.CellSize = UDim2.new(0.98,0,0.06,0)
	UIGridLayout.FillDirection = Enum.FillDirection.Vertical
	UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

	for _,Table_Num in pairs(TemplatesTabel) do
		local Template = Instance.new("TextButton")
		Template.Parent = MainFrame_ScrollingFrame
		Template.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
		Template.Text = ""
		Template.Name = Table_Num.Text.."Button"
		Template.LayoutOrder = Table_Num.lay

		local UICorner_Template = Instance.new("UICorner")
		UICorner_Template.Parent = Template
		UICorner_Template.CornerRadius = UDim.new(0.15, 0)

		local UIStroke_Template = Instance.new("UIStroke")
		UIStroke_Template.Parent = Template
		UIStroke_Template.Enabled = true
		UIStroke_Template.Color = Color3.fromRGB(0, 0, 0)
		UIStroke_Template.Thickness = 4
		UIStroke_Template.Transparency = 0
		UIStroke_Template.LineJoinMode = Enum.LineJoinMode.Round
		UIStroke_Template.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		local UIListLayout_Template = Instance.new("UIListLayout")
		UIListLayout_Template.Parent = Template
		UIListLayout_Template.Padding = UDim.new(0.07, 0)
		UIListLayout_Template.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_Template.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_Template.Wraps = false
		UIListLayout_Template.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_Template.HorizontalFlex = Enum.UIFlexAlignment.None
		UIListLayout_Template.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
		UIListLayout_Template.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout_Template.VerticalFlex = Enum.UIFlexAlignment.None

		local Type_Image = nil

		if Table_Num.NormalImage == true then
			local Imagelabel = Instance.new("ImageLabel")
			Imagelabel.Parent = Template
			Imagelabel.Size = UDim2.new(0.26,0,0.8,0)
			Imagelabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
			Imagelabel.ScaleType = Enum.ScaleType.Fit
			Imagelabel.Image = Table_Num.Image
			Imagelabel.LayoutOrder = 0

			Type_Image = Imagelabel

		elseif Table_Num.NormalImage == false then
			local Title_Imagelabel = Instance.new("TextLabel")
			Title_Imagelabel.Parent = Template
			Title_Imagelabel.Active = false
			Title_Imagelabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
			Title_Imagelabel.BackgroundTransparency = 1
			Title_Imagelabel.LayoutOrder = 0
			Title_Imagelabel.Size = UDim2.new(0.26, 0, 0.8, 0)
			Title_Imagelabel.Font = Enum.Font.FredokaOne
			Title_Imagelabel.RichText = false
			Title_Imagelabel.Text =Table_Num.ImageText
			Title_Imagelabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title_Imagelabel.TextScaled = true
			Title_Imagelabel.TextWrapped = true
			Title_Imagelabel.TextXAlignment = Enum.TextXAlignment.Center
			Title_Imagelabel.TextYAlignment = Enum.TextYAlignment.Center
			Title_Imagelabel.Name = "Image"
			Title_Imagelabel.Selectable = false

			Type_Image = Title_Imagelabel			
		end

		local UICorner_Imagelabel = Instance.new("UICorner")
		UICorner_Imagelabel.Parent = Type_Image
		UICorner_Imagelabel.CornerRadius = UDim.new(0.15, 0)

		local UIStroke_Imagelabel = Instance.new("UIStroke")
		UIStroke_Imagelabel.Parent = Type_Image
		UIStroke_Imagelabel.Enabled = true
		UIStroke_Imagelabel.Color = Color3.fromRGB(0, 0, 0)
		UIStroke_Imagelabel.Thickness = 3
		UIStroke_Imagelabel.Transparency = 0
		UIStroke_Imagelabel.LineJoinMode = Enum.LineJoinMode.Round
		UIStroke_Imagelabel.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		local Title_Template = Instance.new("TextLabel")
		Title_Template.Parent = Template
		Title_Template.Active = false
		Title_Template.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		Title_Template.BackgroundTransparency = 1
		Title_Template.LayoutOrder = 999
		Title_Template.Size = UDim2.new(0.55, 0, 1, 0)
		Title_Template.Font = Enum.Font.FredokaOne
		Title_Template.RichText = false
		Title_Template.Text =Table_Num.Text
		Title_Template.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title_Template.TextScaled = true
		Title_Template.TextWrapped = true
		Title_Template.TextXAlignment = Enum.TextXAlignment.Center
		Title_Template.TextYAlignment = Enum.TextYAlignment.Center
		Title_Template.Name = "Title"
		Title_Template.Selectable = false

		Template.MouseButton1Down:Connect(function()
			SetCatagory(Template.Name,PlayerGUI:FindFirstChild("MainGUI"):FindFirstChild("Frame"):FindFirstChild("HolderFrame"):FindFirstChild("Frame"):FindFirstChild("ScrollFrameMain"):FindFirstChild("ScrollingFrame"):FindFirstChild("Frame"),PlayerGUI:FindFirstChild("MainGUI"):FindFirstChild("Frame"):FindFirstChild("HolderFrame"):FindFirstChild("Frame"):FindFirstChild("ScrollFrameMain"):FindFirstChild("ScrollingFrame"))
		end)
	end
end

local function CreateLoadingScreen()
	if PlayerGUI:FindFirstChild("StarterScreen") then PlayerGUI:FindFirstChild("StarterScreen"):Destroy() end

	local StarterScreen = Instance.new("ScreenGui")
	StarterScreen.Parent = PlayerGUI
	StarterScreen.IgnoreGuiInset = true
	StarterScreen.ResetOnSpawn = false
	StarterScreen.Name = "StarterScreen"
	StarterScreen.Enabled = true
	StarterScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local Frame = Instance.new("Frame")
	Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame.AnchorPoint = Vector2.new(0.5,0.5)
	Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Frame.Size = UDim2.new(1,0,0.2,0)
	Frame.Visible = true
	Frame.Parent = StarterScreen

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = Frame
	UIAspectRatioConstraint.Name = "Resize"
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
	UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	UIAspectRatioConstraint.AspectRatio = 11.344

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Parent = Frame
	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(16, 16, 16)),ColorSequenceKeypoint.new(1,Color3.fromRGB(16, 16, 16))}
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.9),NumberSequenceKeypoint.new(0.333,0.2),NumberSequenceKeypoint.new(0.5,0.2),NumberSequenceKeypoint.new(0.668,0.2),NumberSequenceKeypoint.new(1,0.9)}
	UIGradient.Rotation = 0
	UIGradient.Offset = Vector2.new(0,0)
	UIGradient.Enabled = true
	UIGradient.Archivable = true

	gradient = UIGradient

	local Title_Frame = Instance.new("TextLabel")
	Title_Frame.Parent = Frame
	Title_Frame.Position = UDim2.new(0.5,0,0.5,0)
	Title_Frame.AnchorPoint = Vector2.new(0.5,0.5)
	Title_Frame.Active = false
	Title_Frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_Frame.BackgroundTransparency = 1
	Title_Frame.LayoutOrder = 999
	Title_Frame.TextTransparency = 1
	Title_Frame.Size = UDim2.new(0.8,0,0.8,0)
	Title_Frame.Font = Enum.Font.FredokaOne
	Title_Frame.RichText = false
	Title_Frame.Text = "Ki-Lua-Script"
	Title_Frame.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title_Frame.TextScaled = true
	Title_Frame.TextWrapped = true
	Title_Frame.TextXAlignment = Enum.TextXAlignment.Center
	Title_Frame.TextYAlignment = Enum.TextYAlignment.Center
	Title_Frame.Name = "Title"

	local UIStroke_Title_Holder = Instance.new("UIStroke")
	UIStroke_Title_Holder.Parent = Title_Frame
	UIStroke_Title_Holder.Enabled = true
	UIStroke_Title_Holder.Color = Color3.fromRGB(0,0,0)
	UIStroke_Title_Holder.Thickness = 3
	UIStroke_Title_Holder.Transparency = 0
	UIStroke_Title_Holder.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke_Title_Holder.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	UIStroke_Title_Holder.Transparency = 1

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Parent = Frame
	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255, 255, 255))}
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.199,0.506),NumberSequenceKeypoint.new(0.413,0.144),NumberSequenceKeypoint.new(0.485,0.137),NumberSequenceKeypoint.new(0.505,0.0562),NumberSequenceKeypoint.new(0.517,0.137),NumberSequenceKeypoint.new(0.585,0.131),NumberSequenceKeypoint.new(0.8,0.494),NumberSequenceKeypoint.new(1,1)}
	UIGradient.Rotation = 0
	UIGradient.Offset = Vector2.new(0,0)
	UIGradient.Enabled = true
	UIGradient.Archivable = true

	local Title_Precent = Instance.new("TextLabel")
	Title_Precent.Parent = Frame
	Title_Precent.Position = UDim2.new(0.5,0,0.985,0)
	Title_Precent.AnchorPoint = Vector2.new(0.5,0.5)
	Title_Precent.Active = false
	Title_Precent.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_Precent.BackgroundTransparency = 1
	Title_Precent.TextTransparency = 1
	Title_Precent.LayoutOrder = 999
	Title_Precent.Size = UDim2.new(0.4,0,0.4,0)
	Title_Precent.Font = Enum.Font.FredokaOne
	Title_Precent.RichText = false
	Title_Precent.Text = "0%"
	Title_Precent.TextColor3 = Color3.fromRGB(255,179,0)
	Title_Precent.TextScaled = true
	Title_Precent.TextWrapped = true
	Title_Precent.TextXAlignment = Enum.TextXAlignment.Center
	Title_Precent.TextYAlignment = Enum.TextYAlignment.Center
	Title_Precent.Name = "Percent"

	local UIStroke_Title_Holder_2 = Instance.new("UIStroke")
	UIStroke_Title_Holder_2.Parent = Title_Precent
	UIStroke_Title_Holder_2.Enabled = true
	UIStroke_Title_Holder_2.Color = Color3.fromRGB(0,0,0)
	UIStroke_Title_Holder_2.Thickness = 3
	UIStroke_Title_Holder_2.Transparency = 0
	UIStroke_Title_Holder_2.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke_Title_Holder_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	UIStroke_Title_Holder_2.Transparency = 1

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Parent = Title_Precent
	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255, 255, 255))}
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.199,0.506),NumberSequenceKeypoint.new(0.413,0.144),NumberSequenceKeypoint.new(0.485,0.137),NumberSequenceKeypoint.new(0.505,0.0562),NumberSequenceKeypoint.new(0.517,0.137),NumberSequenceKeypoint.new(0.585,0.131),NumberSequenceKeypoint.new(0.8,0.494),NumberSequenceKeypoint.new(1,1)}
	UIGradient.Rotation = 0
	UIGradient.Offset = Vector2.new(0,0)
	UIGradient.Enabled = true
	UIGradient.Archivable = true
end

local function UpdateButtonOn(ButtonName)
	if FrameOn == ButtonName then return end
	FrameOn = ButtonName
end

local function lockMouse()
	mouseLocked = true
	if not player.Character then return end
	hrp = player.Character:FindFirstChild("HumanoidRootPart")
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if not hrp or not humanoid then return end
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = humanoid
	player.CameraMode = Enum.CameraMode.LockFirstPerson
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	UserInputService.MouseIconEnabled = false
end

local function unlockMouse()
	mouseLocked = false
	if not player.Character then return end
	hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	savedCameraCFrame = camera.CFrame
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CameraSubject = nil
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	UserInputService.MouseIconEnabled = true
end

local function toggleMouse()
	if mouseLocked then
		unlockMouse()
	else
		lockMouse()
	end
end

local function StartPercentage()
	PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").Text = "0%"
	I = 0
	while I <= 100 do
		task.wait(0.01) -- 0.05
		if math.random(-100,100) == 0 then
			I += 1 
			task.wait(1)
		else
			I += 1 
		end
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").Text = I.."%"
	end
	PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").Text = "100%"
	task.wait(1)
	local tween_Text_Countiue = TweenService:Create(PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title"), tweenInfo, {Position = UDim2.new(-0.401, 0,0.5, 0)})
	local tween_Done = TweenService:Create(driver, tweenInfo, {Value = 0})
	local tween_percent_text = TweenService:Create(PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent"),tweenInfo,{TextTransparency = 1})
	local tween_precent_text_UI_Stroke_2 = TweenService:Create(PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").UIStroke,tweenInfo,{Transparency = 1})

	tween_Text_Countiue:Play()
	tween_Done:Play()
	tween_percent_text:Play()
	tween_precent_text_UI_Stroke_2:Play()
	task.wait(2)
	SetSettings("End")
	unlockMouse()
	CreateGUI()
end

local function StartScript()
	print("Started")
	CreateZeroPoint()
	CreateLoadingScreen()

	task.wait(0)
	SetSettings("Start")

	local tween = TweenService:Create(driver, tweenInfo, {Value = 1})
	local tween_precent_text_2 = TweenService:Create(PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent"),tweenInfo,{TextTransparency = 0})
	local tween_Text_Pause = TweenService:Create(PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title"), tweenInfo, {Position = UDim2.new(0.5, 0,0.5, 0)})
	local tween_precent_text_UI_Stroke = TweenService:Create(PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").UIStroke,tweenInfo,{Transparency = 0})

	tween_precent_text_2:Play()
	tween:Play()
	tween_Text_Pause:Play()
	tween_precent_text_UI_Stroke:Play()
	StartPercentage()
end

driver:GetPropertyChangedSignal("Value"):Connect(function()
	local t = driver.Value
	local keypoints = {}

	for i = 1, #positions do
		local val = startValues[i] + (endValues[i] - startValues[i]) * t
		table.insert(keypoints, NumberSequenceKeypoint.new(positions[i], val))
	end

	gradient.Transparency = NumberSequence.new(keypoints)
end)

RunService.RenderStepped:Connect(function()
	if not mouseLocked and hrp and savedCameraCFrame then
		local camPos = hrp.Position + Vector3.new(0, 1.7, 0)
		camera.CFrame = CFrame.new(camPos) * CFrame.fromMatrix(Vector3.zero, savedCameraCFrame.RightVector, savedCameraCFrame.UpVector)
	end
end)

local function CheckShifting()
	local character = player.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	local hipHeight = humanoid.HipHeight

	if hipHeight < -1.5 then
		Shifting = true
	elseif hipHeight > -0.5 then
		Shifting = false
	else
		print("HipHeight in transition range:", hipHeight)
	end
end

game:GetService("Workspace"):WaitForChild(player.Name):WaitForChild("HumanoidRootPart").Touched:Connect(onTouched)
game:GetService("Workspace"):WaitForChild(player.Name):WaitForChild("Humanoid").Seated:Connect(onSeated)

if game:GetService("Players").LocalPlayer:FindFirstChild("IsHeld") then
	game:GetService("Players").LocalPlayer:FindFirstChild("IsHeld"):GetPropertyChangedSignal("Value"):Connect(function() 
		if game:GetService("Players").LocalPlayer:FindFirstChild("IsHeld").Value == true then
			IsHeld = true
		elseif game:GetService("Players").LocalPlayer:FindFirstChild("IsHeld").Value == false then
			IsHeld = false
		end
	end)
end

game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(function()
	Shifting = false
end)

game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)

if player.Character:WaitForChild("Humanoid"):FindFirstChild("Ragdolled") then
	player.Character:WaitForChild("Humanoid"):FindFirstChild("Ragdolled"):GetPropertyChangedSignal("Value"):Connect(function()
		if AntiExplode then
			DoAntiExplosive()
		elseif AntiFling then
			DoAntiFling()
		end
	end)
end

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		IsOnASlider = false
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == toggleKey then
		toggleMouse()
		if PlayerGUI:FindFirstChild("MainGUI") then
			PlayerGUI.MainGUI.Enabled = not PlayerGUI.MainGUI.Enabled
		end
	end
end)

--UserInputService.InputBegan:Connect(function(input)
--	if WalkSpeedNIL then
--		if input.KeyCode == Enum.KeyCode.LeftControl then
--			print("Shifting")
--			Shifting = not Shifting
--		end
--	end
--end)

RunService.RenderStepped:Connect(function()
	CheckShifting()
end)
RunService.RenderStepped:Connect(function()
	DoMovementFaster()
end)
RunService.RenderStepped:Connect(function()
	DoAntiGrab()
end)
RunService.RenderStepped:Connect(function()
	DoAntiFire()
end)
RunService.RenderStepped:Connect(function()
	DoAntiVoid()
end)
RunService.RenderStepped:Connect(function()
	DoAntiMapFling()
end)

StartScript()
