local PlayerService = {}

function PlayerService.GetPriority()
  return 2
end 

function PlayerService.Init()
  local SignalsLocator = require(game:GetService("ReplicatedStorage").Providers.SignalsProvider)

  local playerDataLoaded = SignalsLocator.get('PlayerDataLoaded')
  local playerClassLoaded = SignalsLocator.get('PlayerClassLoaded')

  local playerClass = require(game:GetService("ServerStorage").Classes.Player)

  playerDataLoaded:Connect(function(player : Player, data : {})
    local playerObject = playerClass.new(player, data)
    playerClassLoaded:Fire(playerObject)
  end)
end

return PlayerService
