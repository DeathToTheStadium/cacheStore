--Scripted by DeathToTheStadium @ 8:21 PST 02/28/21

--CacheStore rewrite 

-- What Should a CacheStore be ?

--Feature Ideas 
--[[
   compiles to a Json Object that Can Be Pass to mongodb or a php Server to Sql
   Allow Connection Strings to other dataStores
   Session Locked
   break Down Code to be Wrapped in there own Seperate caches
   ordered caches that automaticall sort Index can only store arrays 
   store all of robloxes data types such as (Vector3s,Cframes,BrickColors,Color3s,Region3s
   rays,(Enums), Etc....?
   Store any kind of Instance as reference such as part Model or value
]]


--_Services 
local HttpService   = game:GetService("HttpService")
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

--_Requires
local require      = require(script.util.customRequire)
local createObj    = require("createObj")
local compiler     = require("compiler")
local cacheService = require("cacheService")
local cacheProfile = require("cacheStore")


--_Variables

--_Tables
local _cacheManager = {}
_cacheManager.maxCaches          = 5    ;
_cacheManager.cacheMaxWrites     = 800  ;
_cacheManager.cacheMaxRead       = 800  ;
_cacheManager.orderedCacheReads  = 160  ;
_cacheManager.orderedCacheWrites = 160  ;
_cacheManager.profileWrites      = 10   ;
_cacheManager.profileMaxRead     = 5    ;
_cacheManager.profileAutoSave    = true ;
_cacheManager.dbMaxChar          = 25   ;
_cacheManager.prefixMaxChar      = 25   ;

local cacheStore = createObj.new("cacheStore")

--methods

--private

--OOP

--local NAME = Object.new("NAME")

function cacheStore.new()
	local self = cacheStore:make()
    self._manager = _cacheManager
    self.cacheService = cacheService
    self.cacheProfile = cacheProfile.new()
	return self
end


local t = cacheStore.new() -- instantioan the Module

t.cacheService:makeprofile()

local cache = t.cacheService.new() -- Builds a Profile 



return cacheStore