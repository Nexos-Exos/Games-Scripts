-- // NEO ForestX \\

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Fluent_Toggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nexos-Exos/Returns/refs/heads/main/Fluent%20Toggle.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
  Title = "NEO ForestX " .. Fluent.Version,
  SubTitle = "by Aakuenjeru",
  TabWidth = 160,
  Size = UDim2.fromOffset(480, 380),
  Acrylic = true,
  Theme = "Dark",
  MinimizeKey = Enum.KeyCode.LeftControl
})
local Options = Fluent.Options
local Tabs = {
  Main = Window:AddTab({ Title = "Farm", Icon = "" }),
  Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ SERVICES ]] --
local FirePrompt = fireproximityprompt
local twait = task.wait
local tspawn = task.spawn
local game = game
local GetService = game.GetService
local HttpGetAsync = game.HttpGetAsync
local QueryDescendants = game.QueryDescendants
local FindFirstChild = game.FindFirstChild
local Workspace = workspace or FindFirstChild(game, "Workspace")
local Chests = Workspace.FX
local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA
local RunService = FindFirstChildWhichIsA(game, "RunService")

local InAction = false
local CFrame = CFrame
local CFrameNew = CFrame.new
local Positions = {
  CFrameNew(-2973, 365, 4355),
  CFrameNew(-2973, 365, 4355),
  CFrameNew(-2131, 445, 465),
  CFrameNew(-1141, 22, 1181),
  CFrameNew(-2090, -664, -436),
  CFrameNew(920, -82, -987),
  CFrameNew(-1604, -251, 3946),
  CFrameNew(-1893, -666, -1553),
  CFrameNew(-1191, 196, -60),
  CFrameNew(-2241, -81, 5689),
  CFrameNew(-2106, 361, 302),
  CFrameNew(-2221, 478, -21),
  CFrameNew(-2375, 297, 1467),
  CFrameNew(-3049, 322, 4861),
  CFrameNew(-2497, 339, 853),
  CFrameNew(-2960, -195, 3095),
  CFrameNew(-3066, -188, 4023),
  CFrameNew(-3297, 474, 4149),
  CFrameNew(-3065, 322, 4358),
  CFrameNew(-3430, 363, 4446),
  CFrameNew(-3815, 479, 4277),
  CFrameNew(-2542, 332, 5606),
  CFrameNew(-2229, 337, 809),
  CFrameNew(-2496, 358, 582),
  CFrameNew(-2579, -2, 1222),
  CFrameNew(-3482, 407, 3951)
}

local Place_ID = game.PlaceId
local Server_ID = game.JobId

local Virtual_Input = GetService(game, "VirtualInputManager")
local UI_Service = FindFirstChildWhichIsA(game, "GuiService")
local Http_Service = FindFirstChildWhichIsA(game, "HttpService")
local Teleport_Service = FindFirstChildWhichIsA(game, "TeleportService")

local Players = FindFirstChildWhichIsA(game, "Players")
local Player = Players.LocalPlayer

local PlayerGui = Player.PlayerGui
local Backpack = Player.Backpack

local Character = Player.Character
local Humanoid = Character.Humanoid
local RootPart = Character.HumanoidRootPart

local MainUI = PlayerGui.MainGui.FmMain
local InventoryUI = MainUI.FmInventory
local ItemInfo = InventoryUI.FmCharacter.FmItemInfo

local ItemsUI = InventoryUI.FmItems.FmContainer.SfScroller
local DeleteBtn = ItemInfo.FmBottombar.BfDelete.TextButton
local ConfirmBtn = ItemInfo.FmDelete.FmBottombar.BfConfirm.TextButton

-- [[ Essential Functions & Instances ]]

Player.CharacterAdded:Connect(function()
  twait(1)
  local New_Char = Player.Character or Player.CharacterAdded:Wait()
  
  InAction = false
  
  PlayerGui = Player["PlayerGui"]
  Backpack = Player["Backpack"]
  Character = New_Char
  Humanoid = FindFirstChild(Character, "Humanoid")
  RootPart = FindFirstChild(Character, "HumanoidRootPart")

  MainUI = PlayerGui.MainGui.FmMain
  InventoryUI = MainUI.FmInventory
  ItemInfo = InventoryUI.FmCharacter.FmItemInfo

  ItemsUI = InventoryUI.FmItems.FmContainer.SfScroller
  DeleteBtn = ItemInfo.FmBottombar.BfDelete.TextButton
  ConfirmBtn = ItemInfo.FmDelete.FmBottombar.BfConfirm.TextButton
    
  print('Character Variables Updated')
end)

local Farm = false
local Noclip = false
local Fly = Instance.new("BodyVelocity")
Fly.Name = "Float"
Fly.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
Fly.P = 1250
Fly.Velocity = Vector3.new(0, 0, 0)

RunService.Stepped:Connect(function()
  if Noclip then
    for i, v in next, QueryDescendants(Character, "BasePart") do
      v.CanCollide = false
    end
  end
end)

-- [[ FUNCTIONS ]] --
do
  function Click()
    Virtual_Input:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    twait(0.5)
    Virtual_Input:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    twait(0.5)
  end
  
  function DeleteItem(Item_Name: string)
    if not MainUI.Visible then MainUI.Visible = true end
    
    for _, Items in next, QueryDescendants(ItemsUI, "Frame") do
      if Items.Name == Item_Name and Items:FindFirstChild("TextButton") then
        local Button = Items:FindFirstChildOfClass("TextButton")

        Button.Visible = true
        UI_Service.SelectedObject = Button
        Click()
        
        DeleteBtn.Visible = true
        UI_Service.SelectedObject = DeleteBtn
        Click()
        
        ConfirmBtn.Visible = true
        UI_Service.SelectedObject = ConfirmBtn
        Click()
        
        UI_Service.SelectedObject = nil
      end
    end
  end
  
  function GetDistance(Part1, Part2)
    local Distance = (Part1.CFrame.Position - Part2.CFrame.Position).Magnitude
    
    return Distance
  end
  
  function FireNearestPrompt()
    for i, v in QueryDescendants(Workspace.FX, "ProximityPrompt") do
      local Handle = v.Parent
      local Distance = GetDistance(RootPart, Handle)
      
      if Distance <= 13 then
        FirePrompt(v)
      end
    end
  end
  
  function GetChest()
    if not RootPart or RootPart == nil then end
    if Fly.Parent ~= RootPart then Fly.Parent = RootPart end
    
    InAction = true
    
    for i, Pos in ipairs(Positions) do
      RootPart.CFrame = Pos - Vector3.new(0, 5, 0)
      twait(3)
      FireNearestPrompt()
      
      if i == 26 then
        Serverhop()
      end
    end
  end
  
  function Serverhop()
    local Servers_IDS = {}
    local Servers_Url = "https://games.roblox.com/v1/games/" .. Place_ID .. "/servers/Public?sortOrder=Asc&limit=100"
    local Servers_Data = Http_Service:JSONDecode(game:HttpGetAsync(Servers_Url)).data
    
    for _, Value in ipairs(Servers_Data) do
      if type(Value) == "table" and
      Value.maxPlayers > Value.playing and
      Value.id ~= Server_ID then
        table.insert(Servers_IDS, Value.id)
  	  end
  	end
  	  
  	if #Servers_IDS > 0 then
  	  Teleport_Service:TeleportToPlaceInstance(
  	    Place_ID,
  	    Servers_IDS[ math.random(1, #Servers_IDS) ]
  	    )
    end
  end
end

-- [[ Farm Section ]]

local Chests_Toggle = Tabs.Main:AddToggle("Toggle1", {
  Title = "Farm Chests",
  Default = false
})
Chests_Toggle:OnChanged(function(Value)
  getgenv().ChestToggle = Value
  warn("Chest Toggle:", Value)
  
  if Value then
    Noclip = true
    Fly.Parent = RootPart
    else
      Noclip = false
      Fly.Parent = nil
  end
end)

local Scythe_Toggle = Tabs.Main:AddToggle("Toggle2", {
  Title = "Delete Scythes",
  Default = false
})
Scythe_Toggle:OnChanged(function(Value)
  getgenv().ScytheToggle = Value
  warn("Scythe Toggle:", Value)
end)

-- [[ Farm Loops ]]

tspawn(function()
  while twait(2.5) do
    if getgenv().ChestToggle and not InAction then
      GetChest()
    end
  end
end)

tspawn(function()
  while twait(6.5) do
    if getgenv().ScytheToggle then
      DeleteItem("Grass Cutter Scythe")
    end
  end
end)

tspawn(function()
  while twait(520) do
    Serverhop()
  end
end)

-- [[ UI Library Data Manager]] --
do
  SaveManager:SetIgnoreIndexes({})
  
  SaveManager:SetLibrary(Fluent)
  InterfaceManager:SetLibrary(Fluent)
  
  SaveManager:IgnoreThemeSettings()
  
  InterfaceManager:SetFolder("FluentScriptHub")
  SaveManager:SetFolder("FluentScriptHub/specific-game")
  
  InterfaceManager:BuildInterfaceSection(Tabs.Settings)
  SaveManager:BuildConfigSection(Tabs.Settings)
  
  Window:SelectTab(1)
  
  Fluent_Toggle:Init()
  
  Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
  })
  
  SaveManager:LoadAutoloadConfig()
end
