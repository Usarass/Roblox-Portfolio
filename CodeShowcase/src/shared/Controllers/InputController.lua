local InputController = {}

function InputController.GetPriority()
  return 2
end

function InputController.Init()
  local Input = require(game:GetService("ReplicatedStorage").Classes.Input)

  local SignalsProvider = require(game:GetService("ReplicatedStorage").Providers.SignalsProvider)
  local InputBeganSignal = SignalsProvider.get('InputBegan')

  local playerInput = Input.new()

  playerInput:BindAction("Attack", function(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
      InputBeganSignal:Fire(inputObject, actionName)
    end
  end, false, {Enum.UserInputType.MouseButton1})

  playerInput:BindAction('Special', function(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
      InputBeganSignal:Fire(inputObject, actionName)
    end
  end, false, {Enum.KeyCode.E})
end

return InputController
