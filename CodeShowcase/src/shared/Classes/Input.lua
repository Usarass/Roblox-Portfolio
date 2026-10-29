--//private fields
local _actionService = game:GetService("ContextActionService")
local _bindedActions = {}

local Input = {}
Input.__index = Input

function Input.new()
  local self = setmetatable({}, Input)
  return self
end

--Bind for the action service
function Input:BindAction(actionName : string, callback : () -> (), createTouchButton : boolean, inputTypes : {Enum.UserInputType})
  if _bindedActions[actionName] then
    warn("Action already binded: " .. actionName)
    return
  end

  _bindedActions[actionName] = {
    actionName = actionName,
    callback = callback,
    createTouchButton = createTouchButton,
    inputTypes = inputTypes
  }
  _actionService:BindAction(actionName, callback, createTouchButton, unpack(inputTypes))
end

function Input:RebindAction(actionName : string, inputTypes : {Enum.UserInputType})
  if not _bindedActions[actionName] then
    warn("Action not binded: " .. actionName)
    return
  end

  local action = _bindedActions[actionName]
  _actionService:UnbindAction(actionName)
  _actionService:BindAction(actionName, action.callback, action.createTouchButton, unpack(inputTypes))
end

function Input:UnbindAction(actionName : string)
  if _bindedActions[actionName] then
    _actionService:UnbindAction(actionName)
    _bindedActions[actionName] = nil
  end
end

--Bind for the user input service
function Input:Bind()
end


return Input
