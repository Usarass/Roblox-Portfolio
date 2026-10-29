local servicesLoader = require(game.ReplicatedStorage.Loaders.Loader)
local modulesLoader = require(game.ServerStorage.Loaders.ModulesLoader)
local signalsLoader = require(game.ServerStorage.Loaders.SignalsLoader)

signalsLoader.Initiate()
modulesLoader.Initiate()

servicesLoader.GatherPath(game.ServerStorage.Services)
servicesLoader.Initiate()
