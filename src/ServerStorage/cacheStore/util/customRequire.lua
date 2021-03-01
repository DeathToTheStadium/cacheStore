--A Customrequire

local PlacesToLook = {
	script.Parent.Parent
}

local Modules = {}

local function ListModulesInPlace(_, Place)
	for _,_Instance in ipairs(Place:GetDescendants()) do
		if not _Instance:IsA("ModuleScript") then continue end 

		Modules[_Instance.Name] = _Instance
	end
end

table.foreach(PlacesToLook, ListModulesInPlace)

return function(ModuleName)
	assert(typeof(ModuleName) == "string", "String expected got "..typeof(ModuleName))
	if Modules[ModuleName] then
		return require(Modules[ModuleName])
	end
end