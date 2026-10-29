--//Private fields
local gatheredModules = {}

local Loader = {}
Loader.__index = Loader

function Loader.GatherPath(path : Instance | Folder | BasePart | Model)
  if not path or typeof(path) ~= "Instance" then return end

  for _, module: Instance in pairs(path:GetChildren()) do
    if not module:IsA("ModuleScript") or module == script then continue end

    -- Guard each require: one broken module must never halt the whole bootstrap
    -- (which would take down every other system, e.g. the pet pipeline).
    local ok, result = pcall(require, module)
    if not ok then
      warn("[Loader] Failed to require " .. module:GetFullName() .. ": " .. tostring(result))
      continue
    end

    table.insert(gatheredModules, result)
  end

  --// Priority is varied between [0-10] preferralby
  table.sort(gatheredModules, function(a, b)
    if typeof(a) ~= 'table' or typeof(b) ~= 'table' then return false end

    local aPriority = if a.GetPriority then a.GetPriority() else 0
    local bPriority = if b.GetPriority then b.GetPriority() else 0

    return aPriority < bPriority
  end)
end

function Loader.Initiate()
  for _, module: ModuleScript in pairs(gatheredModules) do
    local loaded = module
    if not loaded then warn("Failed to load module: " .. module.Name) end
    if typeof(loaded) ~= 'table' then continue end
    if not loaded.Init then continue end

    loaded.Init()
  end
end

return Loader
