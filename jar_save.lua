
local component = require("component")

local void_jars = {}
local normal_jars = {}
local complist = component.list()
local transposer = component.transposer
local aspectlist = {}
local chestpickupside = 3
local chestburnside = 2
local size = transposer.getInventorySize(chestpickupside)
local sourcechestinventory = {}


-- flyttar saker från source chest till burn chest
local function stuff_mover(thing, amount)
	for slot=1, size do
		local stack = transposer.getStackInSlot(chestpickupside, slot)
		if stack and stack["name"] == thing then
			print("Hittade " .. thing .. "!")
			print("Flyttar " .. amount .. " " .. thing .. " till burn chest!")
			transposer.transferItem(chestpickupside, chestburnside, amount, slot, slot)
			break
		end
		-- for stuff, amount in pairs(stack) do
			-- print(stuff .. tostring(amount))
		-- end
	end
end


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
		local nopearls = math.ceil(add_amount / 10)
		stuff_mover("minecraft:ender_pearl", nopearls)
	end
	if aspect == "Cognitio" then
		local nopaper = math.ceil(add_amount / 2)
		stuff_mover("minecraft:paper", nopaper)
	end
	if aspect == "Ordo" then
		local nostonebrick = add_amount
		stuff_mover("minecraft:stonebrick", nostonebrick)
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


-- funktion för att fylla på jars utifrån behov
local function refilljars()
	if aspectlist["Alienis"] then
		if aspectlist["Alienis"] < 200 then
			print("Alienis är under 200!")
			local add_amount = (250-aspectlist["Alienis"])
			add_aspect("Alienis", add_amount)
		end
	end
	if aspectlist["Cognitio"] then
		if aspectlist["Cognitio"] < 200 then
			print("Cognitio är under 200!")
			local add_amount = (250-aspectlist["Cognitio"])
			add_aspect("Cognitio", add_amount)
		end
	end
	if aspectlist["Ordo"] then
		if aspectlist["Ordo"] < 200 then
			print("Ordo är under 200!")
			local add_amount = (250-aspectlist["Ordo"])
			add_aspect("Ordo", add_amount)
		end
	end
end



jaradresses()

refilljars()

-- sourcechest()



-- debug
-- print("Void Jars")
-- for _, addr in ipairs(void_jars) do
-- 	print(addr)
-- end


-- print("Warded Jars")
-- for _, addr in ipairs(normal_jars) do
-- 	print(addr)
-- end

