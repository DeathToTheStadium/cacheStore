local Package = script:FindFirstAncestor("cacheStore")
local Object = require(Package.util.createObj)


--local NAME = Object.new("NAME")
local cacheProfile = Object.newExtends("cacheProfile",Package)

function cacheProfile.new()
	--local obj = NAME:make()
	local obj = cacheProfile:super()

	return obj
end

return cacheProfile