local controllersLoader = require(game.ReplicatedStorage.Loaders.Loader)
local signalsLoader = require(game.ReplicatedStorage.Loaders.SignalsLoader)

signalsLoader.Initiate()

controllersLoader.GatherPath(game.ReplicatedStorage.Controllers)
controllersLoader.Initiate()
