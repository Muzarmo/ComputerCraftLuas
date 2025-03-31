
local component = require("component")

local void_jars = {}
local normal_jars = {}
local complist = component.list()
local transposer = component.transposer
local aspectlist = {}
local chestpickupside = 3
local chestburnside = 2
local sourcechestinventory = {}


-- funktion för att summera aspekter utifrån en jar (kallas från inventeringsfunktionen) 
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

-- funktion för att lägga till aspekter
local function add_aspect(aspect, add_amount)
	print("Add-amount function har blivit tillsagd att lägga till " .. add_amount .. " till " .. aspect)
	if aspect == "Alienis" then

		print("Lägger ")
	end
end

-- funktion för att inventera kistan med källmaterial (och göra en lista av det?)
local function sourcechest()
	print("Data från chestpickupside")
	print(transposer.getSlotStackSize(chestpickupside, 1) .. " SlotStacSize 1")
	print(transposer.getInventorySize(chestpickupside) .. " getInventorySize")
	local slot1 = (transposer.getStackInSlot(chestpickupside, 1))
	for info, info2 in pairs(slot1) do
		print(info .. " " .. tostring(info2))
	end

	for info3, info4 in pairs(slot1["aspects"]) do
		print(info3 .. " " .. info4)
	end

end



-- funktion för att inventera jars (och transposer) och lagra deras adresser
local function jaradresses()
	for jaradress, jartype in complist do
		if jartype == "jar_void" then
			table.insert(void_jars, jaradress)
			local jar = component.proxy(jaradress)
			sum_aspects(jar)
		elseif jartype == "jar_normal" then
			table.insert(normal_jars, jaradress)
			local jar = component.proxy(jaradress)
			sum_aspects(jar)
		elseif jartype == "transposer" then
			local transposer = component.proxy(jaradress)
		end
	end
end


-- funktion för att fylla på jars utifrån behov
local function refilljars()
	for aspect, amount in pairs(aspectlist) do
		print(aspect .. " " .. amount)
		if amount < 200 then
			print("Det finns mindre än 200 av " .. aspect .. "! Fyller på!")
			local add_amount = (250-amount)
			add_aspect(aspect, add_amount)
		end
	end
end


jaradresses()

refilljars()

sourcechest()



-- debug
print("Void Jars")
for _, addr in ipairs(void_jars) do
	print(addr)
end


print("Warded Jars")
for _, addr in ipairs(normal_jars) do
	print(addr)
end

