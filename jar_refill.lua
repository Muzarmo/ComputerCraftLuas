
local component = require("component")
local ordered_aspects = {"Cognitio", "Alienis", "Ordo", "Victus", "Perditio", "Ignis", "Potentia"}
local aspect_add_data = {
	Cognitio = {"minecraft:paper", 2},
	Alienis = {"minecraft:ender_pearl", 10},
	Ordo = {"minecraft:stonebrick", 1}
}


-- chests transposer:   dd868d05-f35c-4b63-97b1-5e2e70998eec
-- smeltery transposer: 0affe223-d7e9-44a3-a8de-7b416e63a241

local void_jars = {}
local normal_jars = {}
local complist = component.list()
local chesttransposer = component.proxy("dd868d05-f35c-4b63-97b1-5e2e70998eec")
local smelttransposer = component.proxy("0affe223-d7e9-44a3-a8de-7b416e63a241")
local aspectlist = {}
local checkedcontents = false
local chestpickupside = 3
local chestburnside = 2
local transpsmeltside = 1
local size = chesttransposer.getInventorySize(chestpickupside)
local sourcechestinventory = {}
local essentiasmelterytype = {"Thaumic", 0.9}


-- flyttar saker från source chest till burn chest
local function stuff_mover(thing, amount)
	print()
	print("Stuff mover har blivit tillsagd att flytta " .. amount .. " av " .. thing)
	print("I Stuff mover så är amount en " .. math.type(amount))
	for slot=1, size do
		local stack = chesttransposer.getStackInSlot(chestpickupside, slot)
		if stack and stack["name"] == thing and stack["size"] >= amount then
			print("Hittade " .. amount .. " ".. thing .. ". Flyttar dom till burn chest.")
			chesttransposer.transferItem(chestpickupside, chestburnside, amount, slot, slot)
			break
		elseif stack and stack["name"] == thing and stack["size"] < amount then
			print("Hittade " .. stack["size"] .. " " .. thing .. ". Delflyttar och fortsätter leta!")
			chesttransposer.transferItem(chestpickupside, chestburnside, stack["size"], slot, slot)
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
		essentiasmelterytype = {"Base", 0.8}
	elseif essentiasmelterytype[1] == "Base" then
		essentiasmelterytype = {"Thaumic", 0.9}
	end
end


-- funktion för att summera aspekter utifrån en jar (kallas från inventeringsfunktionen) 
local function sum_aspects(jar)
	local aspects = jar.getAspects()
	for aspect, amount in pairs(aspects) do
		if aspectlist[aspect] then
			aspectlist[aspect] = aspectlist[aspect] + amount
			print("La till " .. amount .. " till " .. aspect .. ". Ny total: " .. aspectlist[aspect])
		else
			aspectlist[aspect] = amount
			print("Ny jar-aspect: " .. aspect .. ". Total: ".. aspectlist[aspect])
		end
	end
end


-- function för att lägga till extra-/biaspekter
local function extra_aspect(bi_aspect)
	if bi_aspect == "Cognito" then
		print("")
	end
end


-- nya funktionen för att lägga till aspekter
local function add_aspect(aspect, add_amount)
	print("Add-aspect function har blivit tillsagd att lägga till " .. add_amount .. " till " .. aspect)
	if aspect_add_data[aspect] then
		local block_type, block_value = table.unpack(aspect_add_data[aspect])
		local no_blocks = (add_amount/essentiasmelterytype[2])/block_value
		print("Antal block att flytta med förbränningsgrad medräknad är " .. no_blocks .. " och avrundat blir det " .. math.floor(no_blocks))
		local add_amount_blocks = math.floor(math.floor(no_blocks) * block_value * essentiasmelterytype[2])
		print("Lägger även till " .. add_amount_blocks .. " (som har effektivitet medräknad och är avrundat nedåt) till aspectlist för " .. aspect)
		print("Add_amount utan effektivitetsberäkning och avrundning hade varit ".. add_amount)
		print("Före: " .. aspect .. ": " .. aspectlist[aspect])
		aspectlist[aspect] = aspectlist[aspect] + add_amount_blocks
		print("Efter: " .. aspect .. ": " .. aspectlist[aspect])

		stuff_mover(block_type, math.floor(no_blocks))

		print("block_type: " .. block_type)
		print("block_value: " .. block_value)
		print("no_blocks: " .. no_blocks)
	end

	-- det behövs också på något sätt läggas till bi-aspekterna

end


-- debugfunktionen
local function debug()
	print()
	-- add_aspect("Alienis", 57)

	-- print("Skriver värden i aspectlist, förhoppningsvis i ordning")
	-- for _, aspect in ipairs(ordered_aspects) do
	-- 	if aspectlist[aspect] then
	-- 		print(aspect, aspectlist[aspect])
	-- 	end	
	-- end

	local invname = smelttransposer.getInventoryName(transpsmeltside)
	local invsize = smelttransposer.getInventorySize(transpsmeltside)
	local fluid = smelttransposer.getTankLevel(transpsmeltside, 1)
	-- local stackinslot = smelttransposer.getStackInSlot(transpsmeltside, 1)
	-- print(invname)
	-- print(invsize)
	for one, two in pairs(fluid) do
		print(one)
		print(two)
	end
end


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
	for _, aspect in ipairs(ordered_aspects) do
		if not aspectlist[aspect] then
			aspectlist[aspect] = 0
			print("Det finns ingen " .. aspect .. ", lägger till som 0")
		end
	end
	checkedcontents = true
end


-- funktion för att inventera kistan med källmaterial (och göra en lista av det?)
local function sourcechest()
	print("Data från chestpickupside")
	print(chesttransposer.getSlotStackSize(chestpickupside, 1) .. " SlotStacSize 1")
	print(chesttransposer.getInventorySize(chestpickupside) .. " getInventorySize")
	local slot1 = (chesttransposer.getStackInSlot(chestpickupside, 1))
	for info, info2 in pairs(slot1) do
		print(info .. " " .. tostring(info2))
	end

	for info3, info4 in pairs(slot1["aspects"]) do
		print(info3 .. " " .. info4)
	end
end


-- funktion för att fylla på jars utifrån behov
local function refilljars()
	jaradresses()
	for _, aspect in ipairs(ordered_aspects) do
		if aspectlist[aspect] < 200 then
			print(aspect .. " är under 200!")
			local add_amount = 250 - aspectlist[aspect]
			add_aspect(aspect, add_amount)
		end
	end
	checkedcontents = false
end


-- funktion för att skriva vad aspect list innehåller
local function printjarcontents()
	print()
	for aspect, amount in pairs(aspectlist) do
		print(aspect .. ": " .. amount)
	end
	if checkedcontents == true then
		print("Innehållet i listan är KONTROLLERAT")
	elseif checkedcontents == false then
		print("Innehållet i listan är BERÄKNAT")
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
4. Indexera source chest
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


-- chests transposer:   dd868d05-f35c-4b63-97b1-5e2e70998eec
-- smeltery transposer: 0affe223-d7e9-44a3-a8de-7b416e63a241





-- Ideer
--
--
-- Snygga till formatet för vad som skrivs på skärmen
-- - ex så att aspectrapporterna kommer i rader som står ovanför varandra

-- Fixa till sourcechest så att den faktiskt inventerar i källkistan och ger någon sorts rapport av hur mkt potentiella aspects som finns

-- Fixa språk så det blir tydligt vad som är potentiella aspects, och vad som redan finns i jars


-- Göra en lista med vilken sak som ska adderas för att lägga till essentia för varje aspect, och göra en for loop av det? 
-- - problem om man vill lägga till två alternativ? Går att få till? 
-- - vore egentligen snyggare att indexera innehållet i source chest och sen läsa direkt från thaumcraft-aspect-taggarna vad för potentiella aspekter och 
--   biaspekter som finns där, och sen använda den infon i add_aspect, snarare än min egenihopsnickrade lista. 

-- Göra en key-value med display-motsvarigheter till minecraft-variablerna för block. Så att den skriver "Stone" istället för 
-- minecraft:stone. 
