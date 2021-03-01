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
local manager = {}
local cacheStore = createObj.new("cacheStore")

--methods

--private

--OOP

--local NAME = Object.new("NAME")

function cacheStore.new()
	local obj = cacheStore:make()
    obj.t = 1
    obj.cacheService = cacheService.new()
    obj.cacheProfile = cacheProfile.new()
	return obj
end

local newcache = cacheStore.new()



return cacheStore