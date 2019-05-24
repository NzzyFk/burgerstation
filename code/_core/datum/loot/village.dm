/loot/bushes/
	name = "bush loot"
	id = "village_bush"
	desc = "Loot you find in bushes"
	loot_table = list(
		/obj/item/currency/{value=1} = 10,
		/obj/item/currency/{value=2} = 5,
		/obj/item/currency/{value=3} = 2,
		/obj/item/clothing/mask/gas = 1
	)

/loot/wizard/
	name = "wizard loot"
	id = "wizard"
	desc = "Loot you find off of dead wizards."
	loot_table = list(
		/obj/item/weapon/ranged/magic/scroll/fireball{scroll_count=5} = 100,
		/obj/item/weapon/ranged/magic/staff/basic = 50,
		/obj/item/weapon/ranged/magic/tome/fireball = 25,
		/obj/item/consumable/soulgem = 25,
		/obj/item/food/burger/spellburger = 25,
		/obj/item/clothing/head/hat/wizard/blue = 10,
		/obj/item/weapon/ranged/magic/tome/lightning = 10,
		/obj/item/soapstone/blue = 5,
		/obj/item/color/crayon/blue = 5
	)

	loot_count = 3

/loot/spider/
	name = "spider loot"
	id = "spider"
	desc = "Loot you find off of dead spiders."
	loot_table = list(
		/obj/item/food/spider/spider_leg = 100,
		/obj/item/food/spider/spider_eggs = 25
	)

	loot_count = 4