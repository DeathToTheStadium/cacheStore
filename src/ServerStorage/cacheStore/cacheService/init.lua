local Package = script:FindFirstAncestor("cacheStore")
local Object = require(Package.util.createObj)


--local NAME = Object.new("NAME")
local cacheService = Object.newExtends("cacheService",require(Package))

function cacheService.new()
	--local obj = NAME:make()
	local obj = cacheService:super()
    print(obj.t)
	return obj
end

return cacheService