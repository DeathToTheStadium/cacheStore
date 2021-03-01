local Package = script:FindFirstAncestor("cacheStore")
local Object = require(Package.util.createObj)

-- Crate a Template Profile For cache construction
--local NAME = Object.new("NAME")
local HttpService = game:GetService("HttpService")
local cacheService = Object.newExtends("cacheService",require(Package))

--Methods
--PrivateFunctions 
function construct_Cache_Meta_Data(args)
	return {}
end
--OOP Methds 
function cacheService.new()
	--local obj = NAME:make()
	local self = cacheService:super()
	self.cacheCount = 0
	self.caches        = {}
	self.orderedCaches = {}
	self.key           = {}

	return self
end

function cacheService:makeProfile(profileTemplate)
	local profile = {}
	profile.Data     = profileTemplate
	profile.Meta_Data = {
		["dataCharSize"] = string.len(HttpService:JSONEncode(profileTemplate)),
		['dataScope']    = 0,
		['JobId']        = game.JobId,
		['LastJobId']    = game.JobId,
		["IsJson"]       = false,
		["IsLocked"]     = false,
		["timeStamps"]   = {}
	}
	return profile
end

function cacheService:createCache(key)
	self.caches[key] = {}
	return setmetatable(self.caches[key],construct_Cache_Meta_Data())
end

function cacheService:createOrderdedCache(key)
	self.caches[key] = {}
	return setmetatable(self.orderedCaches[key],construct_Cache_Meta_Data())
end

--Replicated Storage mServerStorage,Workspace ServerStorage
function cacheService:assign_Cache_Node()

end

function cacheService:set_Cache_Node()

end

function cacheService:duplicate_Cache_Node(args)

end
--Decompiles Tree and Saves to Cache

function cacheService:read_Cache_Node()

end

function cacheService:delete_Cache_Node()

end



return cacheService