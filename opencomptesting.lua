

cognitojar = component.proxy("f53d07dc-322f-4bc2-a7e8-e3195812ac74")

victusjar = component.proxy("b48a7b5f-084e-446c-857c-b4cf9d66ec4b")

ordojar = component.proxy("76b3de14-73f0-49cd-85e5-1ff4111f9c50")

alienisjar = component.proxy("787a1c51-2249-4869-a6ce-60904ac7274c")













-- så inte helt uppenbart vad strategin ska vara för påfyllnad av jars
-- sannolikt en runda där alla jars innehåll analyseras
-- sen påfyllnad av alla? prioriteringsrunda?
-- prioritering skulle kunna vara att ta aspects som har "bonusaspects" genom centrifugering först, och sen omvärdering
-- kanske ändå bättre att bara ta alla och försöka räkna på hur mycket bonus det blir för varje

-- Nästa grej blir att bestämma hur långa cyklerna ska vara
-- tre möjligheter
-- 1. höfta
-- 2. ha en adapter som kollar när den aktiva cykeln är klar genom att se om det är något i smelteryt
-- 3. hade en till idé, men minns inte just nu =)
--  - men kanske det var att bekräfta att aspects dyker upp? och sen börja en ny cykel. det är ett rätt bra mellansteg

-- När ska en ny cykel starta? Med bestämda mellanrum, eller när en aspect går lågt? Känns snajdigare med start när en aspect är låg. 
-- I så fall en funktion för att analysera mängder, och en för att göra en påfyllnadscykel. Och kanske en för att avgöra när cykeln är slut? 





-- framtida saker:
-- analysera jars och designera för varje uppstart



-- aspects3 = jar3.getAspects()
--
-- for aspect, amount in pairs(aspects3) do
--     print("jar3")
--     print(aspect .. ": " .. amount)
-- end
--
-- aspects4 = jar4.getAspects()
--
-- for aspect, amount in pairs(aspects4) do
--     print("jar4")
--     print(aspect .. ": " .. amount)
--     end

