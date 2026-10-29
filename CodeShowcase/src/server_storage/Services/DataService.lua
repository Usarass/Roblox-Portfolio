--//Private fields
local PROFILE_TEMPLATE = {
  EquippedWeapon = 1
}
local _profiles = {}

local DataService = {}

function DataService.GetPriority()
  return 1
end

function DataService.Init()
  print("DataService Init")
  local ServicesLocator = require(game:GetService("ReplicatedStorage").Providers.ServiceProvider)
  local SignalsLocator = require(game:GetService("ReplicatedStorage").Providers.SignalsProvider)

  print("ServicesLocator: ", ServicesLocator)

  local profileStore = ServicesLocator.get('ProfileStore')
  print("ProfileStore: ", profileStore)
  local playerDataLoaded = SignalsLocator.get('PlayerDataLoaded')

  local playerStore = profileStore.New("PlayerStore", PROFILE_TEMPLATE)
  local players = game:GetService("Players")

  local function _playerAdded(player)
   -- Start a profile session for this player's data:

   local profile = playerStore:StartSessionAsync(`{player.UserId}`, {
      Cancel = function()
         return player.Parent ~= players
      end,
   })

   -- Handling new profile session or failure to start it:

   if profile ~= nil then

      profile:AddUserId(player.UserId) -- GDPR compliance
      profile:Reconcile() -- Fill in missing variables from PROFILE_TEMPLATE (optional)

      profile.OnSessionEnd:Connect(function()
         _profiles[player] = nil
         player:Kick(`Profile session end - Please rejoin`)
      end)

      if player.Parent == players then
         _profiles[player] = profile
         playerDataLoaded:Fire(player, profile.Data)  
      else
         -- The player has left before the profile session started
         profile:EndSession()
      end

   else
      -- This condition should only happen when the Roblox server is shutting down
      player:Kick(`Profile load fail - Please rejoin`)
   end

  end

  for _, player in players:GetPlayers() do
   task.spawn(_playerAdded, player)
  end

  players.PlayerAdded:Connect(_playerAdded)

  players.PlayerRemoving:Connect(function(player)
     local profile = _profiles[player]
     if profile ~= nil then
        profile:EndSession()
     end
  end)
end

return DataService
