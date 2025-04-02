
local component = require("component")
local potential_aspects = {"Cognitio", "Alienis", "Ordo", "Victus"}
local aspect_add_data = {
	Cognitio = {"minecraft:paper", 2},
	Alienis = {"minecraft:ender_pearl", 10},
	Ordo = {"minecraft:stonebrick", 1}
}

local void_jars = {}
local normal_jars = {}
local complist = component.list()
local transposer = component.transposer
local aspectlist = {}
local chestpickupside = 3
local chestburnside = 2
local size = transposer.getInventorySize(chestpickupside)
local sourcechestinventory = {}
local essentiasmelterytype = {"Thaumic", 1.11}


-- flyttar saker från source chest till burn chest
local function stuff_mover(thing, amount)
	for slot=1, size do
		local stack = transposer.getStackInSlot(chestpickupside, slot)
		if stack and stack["name"] == thing and stack["size"] >= amount then
			print("Hittade " .. thing .. "!")
			print("Flyttar " .. amount .. " " .. thing .. " till burn chest!")
			transposer.transferItem(chestpickupside, chestburnside, amount, slot, slot)
			break
		elseif stack and stack["name"] == thing and stack["size"] < amount then
			print("Hittade " .. stack["size"] .. thing .. ". Delflyttar och fortsätter leta!")
			transposer.transferItem(chestpickupside, chestburnside, stack["size"], slot, slot)
			amount = amount - stack["size"]
		end
	end
end


-- function för att nollställa aspect list
local function reset_aspects()
	aspectlist = {}
	print("Aspect list reset")
end


-- function för att byta smelterytyp
local function change_smeltery_type()
	if essentiasmelterytype[1] == "Thaumic" then
		essentiasmelterytype = {"Base", 1.25}
	elseif essentiasmelterytype[1] == "Base" then
		essentiasmelterytype = {"Thaumic", 1.11}
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


-- nya funktionen för att lägga till aspekter
local function add_aspect(aspect, add_amount)
	print("Add-aspect function har blivit tillsagd att lägga till " .. add_amount .. " till " .. aspect)
	if aspect_add_data[aspect] then
		local block_type, no_blocks = table.unpack(aspect_add_data[aspect])
		no_blocks = no_blocks * essentiasmelterytype[2] * add_amount
		print("Antal block att flytta med förbränningsgrad medräknad är " .. no_blocks .. " och avrundat blir det " .. math.floor(no_blocks))
		print("Lägger även till " .. add_amount .. " till aspectlist för " .. aspect)
		print("Före: " .. aspect .. ": " .. aspectlist[aspect])
		aspectlist[aspect] = aspectlist[aspect] + add_amount
		print("Efter: " .. aspect .. ": " .. aspectlist[aspect])

		print(block_type .. ": " .. no_blocks)
	end
	
	-- det behövs också på något sätt läggas till bi-aspekterna
	
	for baseaspect, value in pairs(aspect_add_data) do
		print(baseaspect)
		local block, blockamount = table.unpack(value)
		print(block .. ": " .. blockamount)

	end
end


-- debugfunktionen
local function debug()
	add_aspect("Ordo", 12)
end

-- gamla funktionen för att lägga till aspekter
-- local function add_aspect(aspect, add_amount)
-- 	print("Add-aspect function har blivit tillsagd att lägga till " .. add_amount .. " till " .. aspect)
-- 	if aspect == "Alienis" then
-- 		local nopearls = math.ceil(add_amount / 10)
-- 		stuff_mover("minecraft:ender_pearl", nopearls)
-- 		aspectlist["Alienis"] = aspectlist["Alienis"] + (nopearls * 10)
-- 		aspectlist["Ordo"] = aspectlist["Ordo"] + (nopearls * 7.5)
-- 	end
-- 	if aspect == "Cognitio" then
-- 		local nopaper = math.ceil(add_amount / 2)
-- 		stuff_mover("minecraft:paper", nopaper)
-- 		aspectlist["Cognitio"] = aspectlist["Cognitio"] + (nopaper * 2)
-- 		aspectlist["Victus"] = aspectlist["Victus"] + (nopaper * 1.5)
-- 	end
-- 	if aspect == "Ordo" then
-- 		local nostonebrick = add_amount
-- 		stuff_mover("minecraft:stonebrick", nostonebrick)
-- 		aspectlist["Ordo"] = aspectlist["Ordo"] + nostonebrick
-- 	end
-- end


-- funktion för att inventera jars (och transposer) och lagra deras adresser
local function jaradresses()
	reset_aspects()
	for jaradress, jartype in complist do
		if jartype == "jar_void" then
			table.insert(void_jars, jaradress)
			local jar = component.proxy(jaradress)
			sum_aspects(jar)
		elseif jartype == "jar_normal" then
			table.insert(normal_jars, jaradress)
			local jar = component.proxy(jaradress)
			sum_aspects(jar)
		-- elseif jartype == "transposer" then
		-- 	local transposer = component.proxy(jaradress)
		-- den här behövs nog inte alls, förrän jag har fler transposers
		end
	end
	for _, aspect in ipairs(potential_aspects) do
		if not aspectlist[aspect] then
			aspectlist[aspect] = 0
			print("Det finns ingen " .. aspect .. ", lägger till som 0")
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
	for aspect, amount in pairs(aspectlist) do
		if amount < 200 then
			print(aspect .. " är under 200!")
			local add_amount = 250 - amount
			add_aspect(aspect, add_amount)
		end
	end
end


-- funktion för att skriva vad den beräknade aspect list innehåller (dvs eg inte vad som finns i jars)
local function printjarcontents()
	for aspect, amount in pairs(aspectlist) do
		print(aspect .. ": " .. amount)
	end
end


local function main()
	jaradresses()
	while true do
		print(string.format([[
		
Meny: 
1. Samla adresser / indexera jars
2. Visa innehåll i aspectlist
3. Fyll på jars
4. Indexera källkistan
5. Byt Smelterytyp. Nuvarande: %s
6. Debug 
0. Avsluta]], essentiasmelterytype[1]))
		io.write("Välj ett alternativ: ")
		local choice = io.read()
			if choice == "1" then
				jaradresses()
			elseif choice == "2" then
				printjarcontents()
			elseif choice == "3" then
				refilljars()
			elseif choice == "4" then
				sourcechest()
			elseif choice == "5" then
				change_smeltery_type()
			elseif choice == "6" then
				debug()
			elseif choice == "0" then
				break
			else
				print("Ogiltigt val, försök igen.")
			end
		end
end


main()






-- debug
-- print("Void Jars")
-- for _, addr in ipairs(void_jars) do
-- 	print(addr)
-- end


-- print("Warded Jars")
-- for _, addr in ipairs(normal_jars) do
-- 	print(addr)
-- end




-- Ideer
--
-- Behövs säkert städas i de floats som uppstår efteråt
--
--
-- Snygga till formatet för vad som skrivs på skärmen
-- - ex så att aspectrapporterna kommer i rader som står ovanför varandra
--
-- Fixa till sourcechest så att den faktiskt inventerar i källkistan och ger någon sorts rapport av hur mkt potentiella aspects som finns
--
-- Fixa språk så det blir tydligt vad som är potentiella aspects, och vad som redan finns i jars


-- Möjligt att snygga till refilljars med en enda for loop som bara går igenom alla aspects in aspectlist? 

-- Göra en lista med vilken sak som ska adderas för att lägga till essentia för varje aspect, och göra en for loop av det? 
-- - problem om man vill lägga till två alternativ? Går att få till? 

-- Göra en key-value med display-motsvarigheter till minecraft-variablerna för block. Så att den skriver "Stone" istället för 
-- minecraft:stone. 