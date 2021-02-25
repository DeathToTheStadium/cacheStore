--Scripted By DeathToTheStadium 2/23/21
-- local game = {}
--MainTable
local cacheStore = {}
cacheStore.__index = cacheStore

--Settings
local _Settings = {}
_Settings.maxCaches          = 5    ;
_Settings.cacheMaxWrites     = 800  ;
_Settings.cacheMaxRead       = 800  ;
_Settings.orderedCacheReads  = 160  ;
_Settings.orderedCacheWrites = 160  ;
_Settings.profileWrites      = 10   ;
_Settings.profileMaxRead     = 5    ;
_Settings.profileAutoSave    = true ;
_Settings.dbMaxChar          = 25   ;
_Settings.prefixMaxChar      = 25   ;


--Variables
local datastoreService = game:GetService("DataStoreService")
local httpService      = game:GetService("HttpService")
local insertService    = game:GetService("InsertService")
local runService       = game:GetService("RunService")
local teleportService  = game:GetService("TeleportService")
local messagingService = game:GetService("MessagingService")
-- local Template = {}
-- local setup = {
--     player   = {},
--     dbName   = {},
--     orderDb  = {},
--     prefix   = {},
--     template = Template
-- }

--Private Functions
function tableDeserialization(index)
	local SerializationIDEAS = {
		["#Name2"] = {123,232,345},-- Vector3
		["#Name3"] = {"R:123","G:232","B:231"},-- Color3.Rgb
		["#Name4"] = {123,232,345,232,323,123,12,12,23,34,123,123},--CFrame
		["#Name5"] = {                              --Ray
			{123,232,345},
			{123,232,345}
		},
		["#Name6"] = "Nougat" ,--BrickColor
		["#Name7"] = 123,      --BrickColor Using Code 
		["#Name8"] = {"R:123","G:232","B:231"},-- Color3.Rgb
		["#Name9"] = {"H:123","S:232","V:231"},-- Color3.Rgb
		["Name"] = 123   -- Not the Same As ^ BrickColor Encode will be Returned As a Normal Value
	}
end

function dataSerializationlogic(index,value,parent)
	local dataValue,typecheck,_valuecode 
	local valueCheck = { 
		types = {
			["string"]     = 1,
			["number"]     = 2,
			["CFrame"]     = 3,
			["Vector3"]    = 4,
			["boolean"]    = 5,
			["Ray"]        = 6,
			["BrickColor"] = 7,
			["Instance"]   = 8
		},
		values = {
			[1] = "StringValue"     ,
			[2] = "NumberValue"     ,
			[3] = "CFrameValue"     ,
			[4] = "Vector3Value"    ,
			[5] = "BooleanValue"    ,
			[6] = "RayValue"        ,
			[7] = "BrickColorValue" ,
			[8] = "Objectvalue"
		}
	}
	typecheck = true
	if typecheck then
		dataValue = Instance.new(valueCheck.values[typecheck],parent)
		dataValue.Name = index
		dataValue.Value = Value
	end
end

function dataSerializer()
end

function saveToProfile(self)
	local cacheTypes = {"caches","orderedCaches"}
	for _,Type in pairs(cacheTypes) do
		for i,v in pairs(self[Type]) do
			self.profileStore[self.playerKey][i] = v
		end
	end
end

--Prevents cacheFrom having More than One Dictionary Key or Array Key
function cacheMetaLogic(self)
	local deb = false
	local cacheMethods = {}
	--Props

	--Methods
	function cacheMethods:getValue(key)
		--Returns the Value For a specific
		-- local function Recurse()
		--     for i,v in pairs() do
		--         if table then
		--             Recurse(v)
		--         elseif array then
		--         end
		--     end
		-- end
	end

	function cacheMethods:typeOf(type,IsArray)
		--Returns an Array Of types 
	end

	function cacheMethods:getInfo()
		--creates a Info Objects
	end

	function cacheMethods:addValue()
	end
	--Events
	function cacheMethods:updated(Value)
		--Event Listener for Cache
	end

	return {
		__index = {cacheMethods},
		__newindex = function(tab,key,val)
			if tab[key] == nil then
				if deb == false then
					deb = true
					rawset(tab,key,val)
				elseif deb then
					error("Can Only Have One Index per cache")
				end
			elseif tab[key] then
				rawset(tab,key,val)
			end
		end
	}
end

function profileToDataBase(self)
	local DB = game:GetService("DataStoreService")
	local Budget = DB:GetRequestBudgetForRequestType(Enum.DataStoreRequestType.UpdateAsync)
	print("DataStoreBudget is :",Budget)

	local state,response,tries;
	tries = 0
	function UpdateAsync(data) return self.profileStore[self.playerKey] end
	repeat 
		wait(1)
		state,response = pcall(self.db.Update,self.db,self.playerKey,UpdateAsync)
		if state then

		end
	until (state == true or tries > 3)
end

local PlayerStore = {
	["Player2"] = {},
	["Player3"] = {},
	["Player4"] = {},
}

-- {
--     [Data] = {},
--     [Meta-Data] = {},
--     [Anayltics] = {},
-- }

-- {
--     Data = []
-- }

-- [
--     Meta-Data
-- ]

-- local t= {
--     ["Data1"]  = {},
--     ["Data2"]  = {},
--     ["Data3"]  = {},
--     ["Data4"]  = {},
--     ["Data5"]  = {},
--     ["Data6"]  = {[1]={}}, --OrderedDataStore
-- }


--Object Methods
function cacheStore.new(setup,profileStore)
	local self = {}
	setmetatable(self,cacheStore)
	self.Manager = _Settings

	local playerType,dbType,prefixType,templateType   = typeof(setup.player),typeof(setup.dbName),typeof(setup.prefix),typeof(setup.template)
	assert(playerType         == "Instance","[Error] player not a instance returned"..playerType)
	assert(dbType             == "string"  ,"[Error] dbName not a string returned"..dbType)
	assert(prefixType         == "string"  ,"[Error] prefix not a string returned"..prefixType)
	assert(templateType       == "table"   ,"[Error] Template not a table returned"..templateType)
	assert(setup.dbName:len() <= self.Manager.dbMaxChar ,"[Error] dbName exceeded character limit of ".. self.Manager.dbMaxChar)
	assert(setup.prefix:len() <= self.Manager.prefixMaxChar, "[Error] prefix value exceeded character limit of ".. self.Manager.prefixMaxChar)

	self.profileStore  = profileStore
	self.player        = setup.player
	self.prefix        = setup.prefix
	self.playerKey     = setup.prefix .. setup.player.UserId
	self.db            = datastoreService:GetDataStore(setup.dbName)
	self.template      = setup.template
	self.caches        = {}
	self.orderedCaches = {}
	self.cacheCount    = 0

	local success,response = pcall(self.db.UpdateAsync,self.db,self.playerKey,function(Data)
		if #Data > 0 then
			return Data
		else
			return self.template
		end
	end)

	if success then
		print("has Data")
		self.profileStore[self.playerKey] = response
	else
		print("updated with Template Data")
		self.profileStore[self.playerKey] = self.template
	end

	game:GetService("Players").PlayerRemoving:Connect(function(player)
		if self.player == player then
			self:saveProfile()
		end
	end)
	return self
end

function cacheStore:createCache(typecache:string,datakey)
	local cacheNum,Orderedcachenum = #self.caches,#self.orderedCaches
	assert(typecache         ~= nil ,"Argument[1] cannot be NULL")
	assert(type(typecache)   ~= "number"   , "Argument[1] cannot be a number"        )
	assert(type(typecache)   ~= "boolean"  , "Argument[1] cannot be a Boolean"       )
	assert(type(typecache)   ~= "table"   ,  "Argument[1] cannot be a table"         )
	assert(typeof(typecache) ~= "Instance" , "Argument[1] cannot be a instance"      )
	assert(type(typecache)   ~= "userdata" , "Argument[1] cannot be a userdatavalue" )
	local cacheType = typecache:lower()
	self.cacheCount += 1
	if cacheType == "cache" then
		self.caches[datakey] = self.profileStore[self.playerKey][datakey]
		return setmetatable(self.caches[datakey],cacheMetaLogic(self))
	elseif cacheType == "orderedcache" then
		--Orderedcache Manages Data With Arrays
		self.orderedCaches[datakey] = self.profileStore[self.playerKey][datakey]
		return setmetatable(self.orderedCaches[datakey],cacheMetaLogic())
	else
		assert(false ,[[
            Argument[1] must be Equal to 'orderedcache' OR 'cache'
            ]])
	end
end

function cacheStore:profileSaveToCache()

end

function cacheStore:profileWriteToFolder()

end

function cacheStore:getAllProfiles()
	return self.profileStore
end

function cacheStore:getProfile()
	return self.profileStore[self.playerKey]
end

function cacheStore:saveProfile()
	saveToProfile(self)
end

-- Logic

return cacheStore