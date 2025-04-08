
local serpent = require("serpent")
local component = require("component")
local ordered_aspects = {"Cognitio", "Alienis", "Ordo", "Victus", "Perditio", "Potentia", "Ignis"}
-- ordning för hur aspekter ska brännas, med tanke på biaspekter
local preferred_aspect_blocks = {
	Cognitio = {"minecraft:paper"},
	Alienis = {"minecraft:ender_pearl"},
	Ordo = {"minecraft:stonebrick"},
	Victus = {"minecraft:sapling"},
	Perditio = {"minecraft:gunpowder"},
	Potentia = {"minecraft:coal"},
	Ignis = {"minecraft:coal"}
}
-- föredraget block att bränna för att få aspekten
local aspect_add_data = {}
-- lista som populeras av sourcechestinventory(), och som ska innehålla blocktyper i source chest, och deras aspect-värden
local sourcechestinventory = {}
-- source chest inventory. Blocktyper och antal. 
local sourcechesttotals = {}
-- summan av block i source chest
local aspectlist = {}
-- lista för hur mycket aspekter som finns i jars. Kan vara mätt eller beräknad
local checkedcontents = false
-- anger om aspectlist är mätt eller beräknad
local void_jars = {}
local normal_jars = {}
local complist = component.list()
local chesttransposer = component.proxy("dd868d05-f35c-4b63-97b1-5e2e70998eec")
-- det finns just nu bara en transposer, och den har den här adressen
local chestpickupside = 3
local chestburnside = 2
local sourcechestsize = chesttransposer.getInventorySize(chestpickupside)
-- storleken på source chest
local essentiasmelterytype = {"Thaumic", 0.9}


-- flyttar saker från source chest till burn chest
local function stuff_mover(thing, amount)
	print()
	print("Stuff mover har blivit tillsagd att flytta " .. amount .. " av " .. thing)
	-- print("I Stuff mover så är amount en " .. math.type(amount))

	-- for slot=1, sourcechestsize do
	-- 	local stack = chesttransposer.getStackInSlot(chestpickupside, slot)
	-- 	if stack and stack["name"] == thing and stack["size"] >= amount then
	-- 		print("Hittade " .. amount .. " ".. thing .. ". Flyttar dom till burn chest.")
	-- 		chesttransposer.transferItem(chestpickupside, chestburnside, amount, slot, slot)
	-- 		break
	-- 	elseif stack and stack["name"] == thing and stack["size"] < amount then
	-- 		print("Hittade " .. stack["size"] .. " " .. thing .. ". Delflyttar och fortsätter leta!")
	-- 		chesttransposer.transferItem(chestpickupside, chestburnside, stack["size"], slot, slot)
	-- 		amount = amount - stack["size"]
	-- 	end
	-- end

	print(sourcechesttotals[thing])
	print("I Source Chest finns " .. sourcechesttotals[thing] .. " av ".. thing)

	if sourcechesttotals[thing] < amount then
		print("Det finns inte nog av " .. thing  " i källkistan (enligt källkistlistan)")
		print("Kan endast flytta " .. sourcechesttotals[thing] .. " av " .. amount)
		sourcechesttotals.thing = 0
	end

	for pseudoslot, pseudoslotcontent in pairs(sourcechestinventory) do
		-- print(pseudoslotcontent.name)
		if pseudoslotcontent.name == thing and pseudoslotcontent.size > 0 then
			print("Innan omräkning: " .. sourcechesttotals[thing])
			print("Amount: " .. amount)
			sourcechesttotals[thing] = sourcechesttotals[thing] - amount
			print("Efter omräkning: " .. sourcechesttotals[thing])
			if pseudoslotcontent.size >= amount then
				print("Hittade " .. amount .. " av " .. thing .. ". Flyttar till burn chest.")
				chesttransposer.transferItem(chestpickupside, chestburnside, amount, pseudoslot, pseudoslot)
				pseudoslotcontent.size = pseudoslotcontent.size - amount
				break
			elseif pseudoslotcontent.size < amount then
				print("Hittade " .. pseudoslotcontent.size .. " " .. thing .. ". Delflyttar och fortsätter leta!")
				chesttransposer.transferItem(chestpickupside, chestburnside, amount, pseudoslot, pseudoslot)
				pseudoslotcontent.size = 0
			end
		end
	end
	-- for pseudoslot, pseudoslotcontent in pairs(sourcechestinventory) do
	-- 	print(pseudoslot)
	-- 	for x, y in pairs(pseudoslotcontent) do
	-- 		print(x)
	-- 		print(y)
	-- 	end
	-- end
end
		-- todo: Stuff mover borde utgå från den redan indexerade källkist-listan
		-- todo: stuff mover (alt add_aspect) kan kolla om det finns nog med material för att kunna utföra refill av jars
		-- - som det är nu så händer ingenting, det blir inget felmeddelande, och beräkningen går igenom trots att blocken inte flyttats


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


-- funktion för att lägga till extra-/biaspekter
local function extra_aspect(bi_aspect, bi_aspect_amount)
	local sub_bi_aspect = "OKÄND"
	if bi_aspect == "Motus" then
		sub_bi_aspect = "Ordo"
	elseif bi_aspect == "Herba" then
		sub_bi_aspect = "Victus"
	end
	print("Extraaspektfunktionen har blivit varse om " .. bi_aspect_amount .. " " .. bi_aspect)
	-- print("Centrifugerat blir det: " .. sub_bi_aspect)
	-- print("Lägger till mängden " .. bi_aspect_amount .. " multiplicerat med hälften och effekivitetskoefficient.")
	-- print(bi_aspect_amount .. " * " .. essentiasmelterytype[2] .. " * " .. "0.5")
	local sub_biaspect_added = math.floor(0.5+(bi_aspect_amount * essentiasmelterytype[2] * 0.5))
	-- print("Det blir: " .. sub_biaspect_added .. " av " .. sub_bi_aspect)

	if aspectlist[sub_bi_aspect] then
		aspectlist[sub_bi_aspect] = aspectlist[sub_bi_aspect] + sub_biaspect_added
	elseif not aspectlist[sub_bi_aspect] then
		print("Sub-bi-aspekt fanns inte definierad för " .. bi_aspect)
	end

	-- todo: output kan bli snyggare med aspekter som inte finns i aspectlist och bara notera att de finns, men inte kommer att adderas

end


-- funktion för att lägga till aspekter
local function add_aspect(aspect, add_amount)
	print("Add-aspect function har blivit tillsagd att lägga till " .. add_amount .. " till " .. aspect)
	local preferred_block = preferred_aspect_blocks[aspect][1]
	print("Preferred block: " .. preferred_block)
	local secondary_aspects = {}
	if aspect_add_data[preferred_block] then
		for aspectblock, amountblock in pairs(aspect_add_data[preferred_block]) do
			-- här blev det ett error när coal inte fanns med i source chest. Sannolikt för att coal inte finns i aspect_add_data. 
			if aspect ~= aspectblock then
				secondary_aspects[aspectblock] = amountblock
			end
			-- print(aspectblock) -- blir aspektnamn
			-- print(amountblock) -- blir aspektmängd (per block?)
		end
	else
		print("Det finns ingen passande blocktyp för " .. aspect .. " i source chest. Hoppar över.")
		return
	end

	-- for kk, vv in pairs(secondary_aspects) do
		-- print("kk: " .. kk .. ", vv:" .. vv)
		-- kk = ordningsnummer
		-- vv = biaspekt
	-- end
	local block_value = aspect_add_data[preferred_block][aspect]
	local no_blocks = math.floor(0.5+((add_amount/essentiasmelterytype[2])/block_value))
	print("Antal block att flytta med förbränningsgrad medräknad och avrundat är " .. no_blocks)
	local add_amount_blocks = no_blocks * block_value * essentiasmelterytype[2]
	aspectlist[aspect] = aspectlist[aspect] + add_amount_blocks

	stuff_mover(preferred_block, no_blocks)

	-- extraaspekterna behöver räknas innan man skickar begäran till stuff mover. 
	-- saplings till ex har 5 victus och 15 herba, så det blir mer victus from herban än från victus. 
	-- det blir oftast inte ett problem, men bara för att cognitio skapar så mycket victus, att det knappt behöver skapas för sig självt. 

	for extraaspect, extraamount in pairs(secondary_aspects) do
		-- print("Extraaspekt till biaspektfunktionen: " .. extraaspect)
		-- print("Och såhär många (per block): " .. extraamount)
		local totalextraamount = extraamount*(math.floor(no_blocks))
		-- print("Total mängd utan effektivitet eller halvering: ".. totalextraamount)
		extra_aspect(extraaspect, totalextraamount)
	end
end


-- debugfunktionen
local function debug()
	print()
	add_aspect("Potentia", 17)



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


-- funktion för att inventera kistan med källmaterial (och göra en lista av det)
-- fixar också innehåll till aspect_add_data
local function sourcechest()
	print()
	print("Indexerar källkistan till källkistlistan... ")
	for slot=1, sourcechestsize do
		local stack = chesttransposer.getStackInSlot(chestpickupside, slot)
		if stack then
			sourcechestinventory[slot] = {
				name = stack.name,
				size = stack.size,
			}
		if stack.aspects and not aspect_add_data[stack.name] then
			aspect_add_data[stack.name] = {}
			for aspect, amount in pairs(stack.aspects) do
				aspect_add_data[stack.name][aspect] = amount
			end
		end
		end
	end
	-- for key, value in pairs(preferred_aspect_blocks) do
	-- 	print("sourcechest indexering, visar preferred blocks:")
	-- 	print("key: " .. tostring(key))
	-- 	print("List values:")
	-- 	for k, v in pairs(value) do
	-- 		print("k: " .. k .. ", v: " .. v)
	-- 	end
	-- end
	-- for _, blocklist in pairs(preferred_aspect_blocks) do
	-- 	print(blocklist[1])
	-- 	if not aspect_add_data[blocklist[1]] then
	-- 		print(blocklist[1] .. " fanns inte i aspect_add_data. Lägger till som 0")
	-- 		aspect_add_data[blocklist[1]] = 0
	-- 	end
	-- end
	-- print(serpent.block(aspect_add_data))
	sourcechesttotals = {}
	for _, blocktypelist in pairs(sourcechestinventory) do
		local name = blocktypelist.name
		local size = blocktypelist.size
		sourcechesttotals[name] = (sourcechesttotals[name] or 0) + size
	end
	print("Klart!")
end


-- funktion för att fylla på jars utifrån behov
local function refilljars()
	jaradresses()
	for _, aspect in ipairs(ordered_aspects) do
		if aspectlist[aspect] < 200 then
			print(aspect .. " är under 200!")
			local add_amount = 240 - aspectlist[aspect]
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
	sourcechest()
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




-- Ideer
--
--
-- När allt funkar: en autofunktion som fyller på jars kontinuerligt
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


-- Sourcechestplan:
-- Kolla igenom kistan och summera dels
-- - antalet block och typ
-- - och summera aspekter, dels hur många per blocktyp, men även totalt. 
-- Ska detta bli två olika tables? Lägga till aspekter och mängder per block i aspect_add_data och antal block i sourcechestinventory?
-- Det blir komplext hur man än vrider och vänder på det. På något sätt måste ju scriptet bestämma vilket material det ska använda. 
-- Extraaspekter (som ska gå genom centrifuges) blir också en helt egen historia. 

-- En egen lista med blockpreferenser för olika aspekter? På det sättet löser man beslutsproblet, och sen blir det lätt att ta de skapade aspekterna 
-- från listan som sourcechestinventory skapar. Prövar med detta. 
-- Så först sourcechestinventory som ska innehålla
-- Typ av block, antal, och även lagra aspekter för varje block - men i ett separat table? 

-- Jag får det till att det blir tre listor/tables
-- sourcechestinventory
-- - innehåll i kistan, typ, antal men INTE aspekter - det lagras i aspect_add_data
-- aspect_add_data
-- - potentiella aspekter för varje blocktyp
-- ordered_aspects
-- - ordningen för hur aspekter ska läggas till när jars fylls på
-- - och möjligen preferensordning för vilken blocktyp som ska användas? 
