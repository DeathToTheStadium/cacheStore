local CheckType = {}
local Types = require(script.ClassTypes)

function CheckType:IsAType(Type,StringInstance)
	if Type:lower() == "service" then
		if Types[StringInstance].IsService then
			return true
		end
	elseif Type:lower() == "instance" then
		if Types[StringInstance].IsInstance then
			return true
		end
	end
	return false
end

--Example Code
local PseudoClass = {
	Part = {
		Name = "",
		BrickColor = BrickColor.random(),
		Transparency = .5,
		Parent       = workspace
	}
}

for i ,v in pairs(PseudoClass) do
	if CheckType:IsAType("Service",i) then
		local NewService = game:GetService("ServerStorage")
	elseif CheckType:IsAType("Instance",i) then
		local instance = Instance.new(i)
	end
end

return CheckType