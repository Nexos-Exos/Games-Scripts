-- [[ UI Library ]] --
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Fluent_Toggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nexos-Exos/Returns/refs/heads/main/Fluent%20Toggle.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
  Title = "R-Forest",
  SubTitle = "by 001",
  TabWidth = 160,
  Size = UDim2.fromOffset(480, 380),
  Acrylic = true,
  Theme = "Dark",
  MinimizeKey = Enum.KeyCode.LeftControl
})
local Tabs = {
  Main = Window:AddTab({ Title = "Main", Icon = "" }),
  Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ SERVICES ]] --
local FirePrompt = fireproximityprompt
local twait = task.wait
local tspawn = task.spawn
local game = game
local HttpGetAsync = game.HttpGetAsync
local QueryDescendants = game.QueryDescendants
local FindFirstChild = game.FindFirstChild
local Workspace = workspace or FindFirstChild(game, "Workspace")
local Chests = Workspace.FX
local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA
local RunService = FindFirstChildWhichIsA(game, "RunService")

local Place_ID = game.PlaceId
local Server_ID = game.JobId
local UI_Service = FindFirstChildWhichIsA(game, "GuiService")
local Virtual_Input = game:GetService("VirtualInputManager")
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
local ConfirmBtn = InventoryUI.FmCharacter.FmItemInfo.FmDelete.FmBottombar.BfConfirm.TextButton

Player.CharacterAdded:Connect(function()
  local New_Char = Player.Character or Player.CharacterAdded:Wait()
  
  PlayerGui = Player["PlayerGui"]
  Backpack = Player["Backpack"]
  Character = New_Char
  Humanoid = FindFirstChildWhichIsA(New_Char, "Humanoid")
  RootPart = FindFirstChildWhichIsA(New_Char, "HumanoidRootPart")

  MainUI = PlayerGui.MainGui.FmMain
  InventoryUI = MainUI.FmInventory
  ItemInfo = InventoryUI.FmCharacter.FmItemInfo

  ItemsUI = InventoryUI.FmItems.FmContainer.SfScroller
  DeleteBtn = ItemInfo.FmBottombar.BfDelete.TextButton
  ConfirmBtn = InventoryUI.FmCharacter.FmItemInfo.FmDelete.FmBottombar.BfConfirm.TextButton
    
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

-- [[ FUNCTIONS ]] --
do
  function Click()
    Virtual_Input:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    twait(0.5)
    Virtual_Input:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
  end
  
  function DeleteItem(Item_Name: string)
    if not MainUI.Visible then MainUI.Visible = true end
  
    for _, Items in next, QueryDescendants(ItemsUI, "Frame") do
      if Items.Name == Item_Name and Items:FindFirstChild("TextButton") then
        local Button = Items:FindFirstChildOfClass("TextButton")

        Button.Visible = true
        UI_Service.SelectedObject = Button
        Click()
        
        twait(0.5)
          
        DeleteBtn.Visible = true
        UI_Service.SelectedObject = DeleteBtn
        Click()
        
        twait(0.5)
        
        ConfirmBtn.Visible = true
        UI_Service.SelectedObject = ConfirmBtn
        Click()
      end
    end
  end
  
  function GetChest()
    if not RootPart or RootPart == nil then return end
    
    for _, Chest in next, QueryDescendants(Chests, "Model") do
      local Base = Chest:FindFirstChild("Circle.001")
      local Prompt = Base:FindFirstChild("ProximityPrompt")
      
      if Base and Prompt and Prompt.Enabled then
        RootPart.CFrame = Base.CFrame - Vector3.new(0, 6, 0)
        return FirePrompt(Prompt)
      end
    end
  end
  
  function Serverhop()
    local Servers_IDS = {}
    local Servers_Url = "https://games.roblox.com/v1/games/" .. Place_ID .. "/servers/Public?sortOrder=Asc&limit=100"
    local Servers_Data = Http_Service:JSONDecode(HttpGetAsync(Servers_Url)).data
    
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

-- [[ Toggles ]] --

tspawn(function()
  while twait(2.5) do
    if getgenv().ChestToggle and not Farm then
      GetChest()
    end
  end
end)

tspawn(function()
  while twait(10.5) do
    if getgenv().ScytheToggle then
      Farm = true

      DeleteItem("Grass Cutter Scythe")
      twait(1)
      Farm = false
    end
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
