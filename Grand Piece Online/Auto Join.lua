-- [[ Join Thingy ]] --

if game.PlaceId ~= 1730877806 then return end

if not game:IsLoaded() then
  game.Loaded:Wait()
end

local taskwait = task.wait
local taskdelay = task.delay

local FindFirstChildWhichIsA = game.FindFirstChildWhichIsA
local GetService = game.GetService
local UIService = GetService(game, "GuiService")
local VirtualInput = GetService(game, "VirtualInputManager")

local Genv = getgenv()
local Configs = Genv.Settings

local Player = FindFirstChildWhichIsA(game, "Players").LocalPlayer
local PlayerGUI = Player.PlayerGui

local ReplicatedStorage = FindFirstChildWhichIsA(game, "ReplicatedStorage")

function WaitForInstance(Path, Name)
  while twait() do
    if Path and Path:FindFirstChild(Name) then return Path[Name] end
  end
end

function FireClick(Object)
  UIService.SelectedObject = Object

  VirtualInput:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
  twait(0.5)
  VirtualInput:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
end

function JoinPlace()
  if not Configs.Server or not Configs.Place or not Configs.Place then return end
  
  local Event = WaitForInstance(ReplicatedStorage, "Events")
  if not Event then return end
  local Reserved = WaitForInstance(Event, "reserved")
  if not Reserved then return end
  
  Event:InvokeServer(Configs.Server)
  
  taskwait(2.5)
  
  local Types = PlayerGUI:FindFirstChild("chooseType")
  local Confirmation_Prompt = WaitForInstance(PlayerGUI, "ConfirmationPrompt")
      
  local Places = Types.Frame.Options
  local Button = Places[Configs.Place]
  FireClick(Button)
 
  warn("[PLACE] Finished Click-Event")
      
  if not ConfirmationPrompt then return end
      
  if Configs.Sea1 then
    local Button = Confirmation_Prompt.Main.OptionsFrame["First Sea"]
    FireClick(Button)
      
    warn("[SEA1] Finished Click-Event")
    else
      local Button = Confirmation_Prompt.Main.OptionsFrame["Second Sea"]
      FIRE_CLICK(Button)
        
      warn("[SEA2] Finished Click-Event")
  end
end

JoinPlace()
