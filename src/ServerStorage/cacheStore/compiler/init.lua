--

--Needs to handle numbers small than 1 
--and manage negative numbers
local compiler = {}
compiler.valueTypes = {"userdata","classValue"}
local tokens  = require(script.Parent.config.tokens)
local Http = game:GetService("HttpService")

function bignumtoNotation(n:number)
	local n1,n2,num,value,reducer
	num = tostring(n)
	value = string.split(num,".")
	print("1",n,"2",num)
	if value[2]:len() > 5 then
		--print("Reducing Decimal Accuracy to 5 Digit Prcision")
		reducer = value[2]:len() - (value[2]:len() - 5)

		return ("%.".. (num:len() - (reducer - 2)) .."e"):format(num)
	elseif value[2]:len() < 5 then
		print("Adding on the 5 Decimal point Accuracy for big nums")
		n1 = 5 - value[2]:len()
		n2 = n1 + value[2]:len()
		print(((value[1]:len()+ n2) -  1))
		return ("%.".. ((value[1]:len() + n2) -  1) .."e"):format(num)
	end
	return ("%.".. (num:len() + -  1) .."e"):format(num)
end

local function vectortoTable(vectorValue:Vector3)
	if typeof(vectorValue) ~= "Vector3" then error(" \n Vector3 Expected Got ["..typeof(vectorValue).."]") end
	type vectorCheck = {X:number,Y:number,Z:number}
	local vector3:vectorCheck = {X = 0, Y=0, Z=0}

	vector3.X = vectorValue.X
	vector3.Y = vectorValue.Y
	vector3.Z = vectorValue.Z
	local lock = {}
	lock.__index = function(t,k)

	end
	lock.__newindex = function(vectors,index,vector)
		if vectors[index] then
			rawset(vectors,index,vector)
		else
			--Lock the Table so no new index can be made
			error("Sealed Table")
		end
	end
	return setmetatable(vector3,lock),compiler.valueTypes[1]
end

local function cframetoTable(cframeValue:CFrame)
	if typeof(cframeValue) ~= "CFrame" then error(" \n CFrame Expected Got ["..typeof(cframeValue).."]") end
	type cframeCheck = {
		X:number,Y:number,Z:number,
		X1:number,Y1:number,Z1:number,
		X2:number,Y2:number,Z2:number,
		X3:number,Y3:number,Z3:number
	}
	local cframe:cframeCheck = {
		X = 0, Y = 0,Z = 0,
		X1= 0, Y1= 0,Z1= 0,
		X2= 0, Y2= 0,Z2= 0,
		X3= 0, Y3= 0,Z3= 0
	}
	local X:number,Y:number,Z:number,
	X1:number,Y1:number,Z1:number,
	X2:number,Y2:number,Z2:number,
	X3:number,Y3:number,Z3:number = cframeValue:GetComponents()
	-- (X,Y,Z)      (RightVector)   (UpVector)  (LookVector)
	cframe.X = X;  cframe.X1 = X1; cframe.X2 = X2; cframe.X3 = X3;
	cframe.Y = Y;  cframe.Y1 = Y1; cframe.Y2 = Y2; cframe.Y3 = Y3;
	cframe.Z = Z;  cframe.Z1 = Z1; cframe.Z2 = Z2; cframe.Z3 = Z3;

	local lock = {}
	lock.__index = function(t,k)

	end
	lock.__newindex = function(vectors,index,vectorValue)
		if vectors[index] then
			rawset(vectors,index,vectorValue)
		else
			--Lock the Table so no new index can be made
			error("Sealed Table")
		end
	end

	return setmetatable(cframe,lock),compiler.valueTypes[1]
end

local function raytoTable(rayvalue:Ray)
	if typeof(rayvalue) ~= "Ray" then error(" \n Ray Expected Got ["..typeof(rayvalue).."]") end
	type rayCheck<value> = {[number]:{X:value,Y:value,Z:value}}
	local ray:rayCheck<number> = {
		{X = 0,Y = 0,Z = 0},
		{X = 0,Y = 0,Z = 0}
	}
	ray[1] = {X = rayvalue.Origin.X,Y = rayvalue.Origin.Y,Z = rayvalue.Origin.Z}
	ray[2] = {X = rayvalue.Direction.X,Y = rayvalue.Direction.Y,Z = rayvalue.Direction.Z}
	local lock = {}
	lock.__index = function(t,k)

	end
	lock.__newindex = function(vectors,index,vectorValue)
		if vectors[index] then
			rawset(vectors,index,vectorValue)
		else
			--Lock the Table so no new index can be made
			error("Sealed Table")
		end
	end

	return setmetatable(ray,lock),compiler.valueTypes[1]
end

local function colortoTable(colorValue:Color3)	
	if typeof(colorValue) ~= "Color3" then error(" \n Color3 Expected Got ["..typeof(colorValue).."]") end
	type colorCheck<value> = {R:value,G:value,B:value}
	local color3:colorCheck<string> = {R="",G="",B=""}
	color3.R ..= colorValue.R
	color3.G ..= colorValue.G
	color3.B ..= colorValue.B
	local lock = {}
	lock.__index = function(t,k)

	end
	lock.__newindex = function(vectors,index,vectorValue)
		if vectors[index] then
			rawset(vectors,index,vectorValue)
		else
			--Lock the Table so no new index can be made
			error("Sealed Table")
		end
	end

	return setmetatable(color3,lock),compiler.valueTypes[1]
end
local function brickcolortoTable(brickcolorValue:BrickColor)
	if typeof(brickcolorValue) ~= "BrickColor" then error(" \n BrickColor Expected Got ["..typeof(brickcolorValue).."]") end
	type brickcolorCheck = {[number]:string}
	local brickcolor = {brickcolorValue.Name}
	local lock = {}
	lock.__index = function(t,k)
	end
	lock.__newindex = function(vectors,index,vectorValue)
		if vectors[index] then
			rawset(vectors,index,vectorValue)
		else
			--Lock the Table so no new index can be made
			error("Sealed Table")
		end
	end

	return setmetatable(brickcolor,lock),compiler.valueTypes[1]
end


local function isArray(t)
	local truth = false
	if type(t) ~= "table" then return false end
	-- check array
	if #t > 0 then
		truth = true
	end
	return truth
end

local function isDictionary(t)
	local truth = false
	-- check dictionary
	if type(t) ~= "table" then return false end
	for k,_ in pairs(t) do
		if type(k) ~= "number" then
			truth = true
		end
	end
	return truth
end

local function giveTableType(t)
	local is_arr, is_dict = isArray(t), isDictionary(t)
	if (is_arr and not is_dict) then -- true, false
		return "array"
	elseif (not is_arr and is_dict) then -- false, true
		return "dictionary"
	elseif (is_arr  and is_dict) then -- true, true
		return error("mixed Array and Dictionary unable to retrieve Data")
	elseif (not is_arr and not is_dict) then -- false,false
		return "value"
	end
	return "ERROR!!!"
end

function compiler:dataCompiler(profile)
	local Types = {
		["BrickColor"] = brickcolortoTable,
		["Vector3"]    = vectortoTable,
		["CFrame"]     = cframetoTable,
		["Color3"]     = colortoTable,
		["Ray"]        = raytoTable
	}

	local function DeepRead(encodedData,data)
		local encoder,key
		for i,v in pairs(data) do
			--print(i,typeof(v))
			--print(v)

			if type(i) == 'string' then
				encoder = Types[typeof(data[i])]
				--dictionary Traversal 
				if encoder ~= nil then
					encoder,key = encoder(v)
					encodedData[tokens[key]..i] = encoder
				elseif typeof(v) == "table" then
					encodedData[i] = DeepRead({},v)
				elseif encoder == nil then
					encodedData[i] = v
				end
			elseif type(i) == "number" then
				print(i)
				encoder = Types[typeof(data[i])]
				if type(v) == "table" then
					encodedData[i] = DeepRead({},v)
				elseif encoder ~= nil then
					print(encoder)
					encoder,key = encoder(v)
					print(encoder)
					encodedData[i] = encoder
				elseif encoder == nil then
					print(encoder)
					encodedData[i] = v
				end
			end
		end
		return encodedData
	end

	profile = DeepRead({},profile)
	return Http:JSONEncode(profile)
end

function compiler:dataDecompiler(Value)
	local Data = Http:JSONDecode(Value)
	local function CheckindexSize(val)
		local Count = 0
		for _,k in pairs(val) do Count += 1; end
		return Count
	end
	
	local function Logic(size,v)
		if size == 1 then
			return BrickColor.new(v[size])
		elseif size == 2 then
			if v[1].X and v[1].Y and v[1].Z and v[2].X and v[2].Y and v[2].Z then
				return Ray.new(Vector3.new(v[1].X,v[1].Y,v[1].Z),Vector3.new(v[2].X,v[2].Y,v[2].Z))
			elseif v.X and v.Y then
				return Vector2.new(v.x,v.y)
			end
		elseif size == 3 then
			if v.X and v.Y and v.Z then
				return Vector3.new(v.X,v.Y,v.Z)
			elseif v.R and v.G and v.B then
				return Color3.new(v.R,v.G,v.B)
			end
		elseif size == 12 then
			return CFrame.new(
				v.X,v.Y,v.Z,
				v.X1,v.Y1,v.Z1,
				v.X2,v.Y2,v.Z2,
				v.X3,v.Y3,v.Z3
			)
		else
			return print("Data Mismatched")
		end
	end
	local function reconcilor(v,tabType,i)
		local size;
		print(v)
		if tabType == "dictionary" then
			size = CheckindexSize(v)
			print("Found Dictionary")
			print(size)
			return Logic(size,v)
		elseif tabType == "array"  then
			if type(v) == "table" then
				size = #v
				return Logic(size,v)
			end
			print("found array")
			print(i,v,"Size:",size)
			
			return v
		elseif tabType == "value" then
			
			
			return v
		end
	end

	local function DeepCopy(decodedData,data)
		local index = "";
		for k,v in pairs(data) do
			if type(k) == "string" then
				local specifier = k:match("%p")
				index = k:split(specifier)[2];
				if specifier ~= nil then
					if specifier == "#" then
						--Set UseType
						decodedData[index] = reconcilor(v,giveTableType(data))
					elseif specifier == "$" then
						--do Something L8ter with Instances
					end
				elseif specifier == nil then
					if type(v) ~= "table" then
						decodedData[k] = v
					elseif type(v) == "table" then
						decodedData[k] = DeepCopy({},v)
					end
				end
			elseif type(k) == "number" then
				if giveTableType(v) == "array" then
					decodedData[k] = DeepCopy({},v)
				else
					decodedData[k] = reconcilor(v,giveTableType(v),k)
				end
			end
		end
		return decodedData
	end

	return DeepCopy({},Data)
end

return compiler