
local component = require("component")

local void_jars = {}
local normal_jars = {}
local complist = component.list()
local transposer = component.transposer
local aspectlist = {}
local checkpickupsdie = 3
local checkburnside = 2

local function sum_aspects(jar)
	local aspects = jar.getAspects()
	for aspect, amount in pairs(aspects) do
		if aspectlist[aspect] then
			aspectlist[aspect] = aspectlist[aspect] + amount
			print("La till " .. amount .. " till " .. aspect .. ". Ny total är " .. aspectlist[aspect])
		else
			aspectlist[aspect] = amount
			print("Ny aspect: " .. aspect .. ". Den har ".. aspectlist[aspect])
		end
	end
end

local function add_aspect(aspect, add_amount)
	print("Add-amount function har blivit tillsagd att lägga till " .. add_amount .. " till " .. aspect)
	if aspect == "Ordo" then

		print("Lägger ")
	end
end


for jaradress, jartype in complist do
	if jartype == "jar_void" then
		table.insert(void_jars, jaradress)
		local jar = component.proxy(jaradress)
		sum_aspects(jar)
	elseif jartype == "jar_normal" then
		table.insert(normal_jars, jaradress)
		local jar = component.proxy(jaradress)
		sum_aspects(jar)
	end
end


for aspect, amount in pairs(aspectlist) do
	print(aspect .. " " .. amount)
	if amount < 200 then
		print("Det finns mindre än 200 av " .. aspect .. "! Fyller på!")
		local add_amount = (250-amount)
		add_aspect(aspect, add_amount)
	end

end


print("Void Jars")
for _, addr in ipairs(void_jars) do
	print(addr)
end


print("Warded Jars")
for _, addr in ipairs(normal_jars) do
	print(addr)
end

