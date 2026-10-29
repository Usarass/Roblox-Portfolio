local SignalsLoader = {}

function SignalsLoader.Initiate() --Client loader
  local SignalsLocator = require(game:GetService("ReplicatedStorage").Providers.SignalsProvider)
  local GoodSignal = require(game.ReplicatedStorage.Packages.GoodSignal)

  SignalsLocator.provide("PlayerDataLoaded", GoodSignal.new())
  SignalsLocator.provide("PlayerClassLoaded", GoodSignal.new())
end

return SignalsLoader
