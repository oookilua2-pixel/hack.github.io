local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

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

local tweenInfo = TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)

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

local function CreateButton(Type,Text,Layorder, Parent)
	if Type == "ButtonSlider" then
		
	elseif Type == "Button" then
		
	elseif Type == "Text" then
		local Textlabel = Instance.new("TextLabel")
		Textlabel.Parent = Parent
		Textlabel.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
		Textlabel.Text = Text
		Textlabel.Font = Enum.Font.FredokaOne
		Textlabel.TextScaled = true
		Textlabel.Visible = true
		Textlabel.TextColor3 = Color3.fromRGB(255,255,255)
		
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
		
	end
end

local function ClearCatagory(Cat)
	for i,v in pairs(Cat:GetChildren()) do
		if not v:IsA("UIGridLayout") then
			v:Destroy()
		end	
	end
end

local function SetCatagory(Name,Parent)
	ClearCatagory(Parent)
	if Name == "PlayerButton" then
		CreateButton("Text","I Love Pizza", 1, Parent)
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
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").TextTransparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").UIStroke.Transparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").Position = UDim2.new(0.5, 0,0.5, 0)
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").AnchorPoint = Vector2.new(0.5,0.5)
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Title").BackgroundTransparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").UIStroke.Transparency = 1
		PlayerGUI:FindFirstChild("StarterScreen"):FindFirstChild("Frame"):FindFirstChild("Percent").TextTransparency = 1
	end	
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
	ScrollingFrame_Main.CanvasSize = UDim2.new(0,0,3,0)
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
	
	local UIGridLayout = Instance.new("UIGridLayout")
	UIGridLayout.Parent = ScrollFrame_Frame
	UIGridLayout.CellPadding = UDim2.new(0,0,0.017,0)
	UIGridLayout.CellSize = UDim2.new(0.8,0,0.07,0)
	UIGridLayout.FillDirection = Enum.FillDirection.Vertical
	UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

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
			SetCatagory(Template.Name,PlayerGUI:FindFirstChild("MainGUI"):FindFirstChild("Frame"):FindFirstChild("HolderFrame"):FindFirstChild("Frame"):FindFirstChild("ScrollFrameMain"):FindFirstChild("ScrollingFrame"):FindFirstChild("Frame"))
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
	Title_Precent.Text = "100%"
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
	CreateLoadingScreen()

	task.wait(1)

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

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	
	if input.KeyCode == toggleKey then
		toggleMouse()
		if PlayerGUI:FindFirstChild("MainGUI") then
			PlayerGUI.MainGUI.Enabled = not PlayerGUI.MainGUI.Enabled
		end
	end
end)

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

StartScript()
