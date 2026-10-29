--!strict
local Locator = {}

local registry: { [string]: any } = {}
local robloxServicesCache: { [string]: Instance } = {}

function Locator.provide(name: string, service: any)
	registry[name] = service
  return service
end

function Locator.get(name: string): any
	local service = registry[name]
	if not service then
		warn(`[Locator]: Custom service "{name}" not registered`)
    return nil
	end
	return service
end

function Locator.waitGet(name : string, timeout : number?) : any
  local service = registry[name]
  if service then
    return service
  end

  local waitTime = timeout or 1
  local startTime = tick()

  while tick() - startTime < waitTime do
    service = registry[name]
    if service then
      return service
    end
    task.wait(.1)
  end

  warn(`[Locator]: Could not find custom service "{name}" within {waitTime} seconds`)
  return nil
end

function Locator.getRobloxService(name: string): any
	if robloxServicesCache[name] then
		return robloxServicesCache[name]
	end

	local success, service = pcall(game.GetService, game, name)

	if success and service then
		robloxServicesCache[name] = service
		return service
	else
    warn(`[Locator]: Could not find Roblox service "{name}"`)
		return nil
	end
end

return Locator
