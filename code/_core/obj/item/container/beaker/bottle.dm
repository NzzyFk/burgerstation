/obj/item/container/simple/beaker/bottle
	name = "small bottle"
	desc = "Remember to read the label before drinking."
	desc_extended = "A bottle used by chemists to contain medicines and other reagents."
	icon = 'icons/obj/item/container/cup/bottle.dmi'
	icon_state = "bottle"
	icon_count = 7

	reagents = /reagent_container/beaker/bottle/

	value = 3


/obj/item/container/simple/beaker/bottle/bicaridine
	name = "bottle of bicaridine"

/obj/item/container/simple/beaker/bottle/bicaridine/Generate()
	reagents.add_reagent(/reagent/medicine/bicaridine,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/dylovene
	name = "bottle of dylovene"

/obj/item/container/simple/beaker/bottle/dylovene/Generate()
	reagents.add_reagent(/reagent/medicine/dylovene,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/kelotane
	name = "bottle of kelotane"

/obj/item/container/simple/beaker/bottle/kelotane/Generate()
	reagents.add_reagent(/reagent/medicine/kelotane,reagents.volume_max)
	return ..()


/obj/item/container/simple/beaker/bottle/epinephrine
	name = "bottle of epinephrine"

/obj/item/container/simple/beaker/bottle/epinephrine/Generate()
	reagents.add_reagent(/reagent/medicine/adrenaline/epinephrine,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/calomel
	name = "bottle of calomel"

/obj/item/container/simple/beaker/bottle/calomel/Generate()
	reagents.add_reagent(/reagent/medicine/purge,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/morphine
	name = "bottle of morphine"

/obj/item/container/simple/beaker/bottle/morphine/Generate()
	reagents.add_reagent(/reagent/medicine/painkiller/morphine,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/antihol
	name = "bottle of antihol"

/obj/item/container/simple/beaker/bottle/antihol/Generate()
	reagents.add_reagent(/reagent/medicine/antihol,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/charcoal
	name = "bottle of charcoal"

/obj/item/container/simple/beaker/bottle/charcoal/Generate()
	reagents.add_reagent(/reagent/medicine/charcoal,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/health_potion
	name = "health potion"

/obj/item/container/simple/beaker/bottle/health_potion/Generate()
	reagents.add_reagent(/reagent/medicine/health_potion,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/stamina_potion
	name = "stamina potion"

/obj/item/container/simple/beaker/bottle/stamina_potion/Generate()
	reagents.add_reagent(/reagent/medicine/stamina_potion,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/mana_potion
	name = "mana potion"

/obj/item/container/simple/beaker/bottle/mana_potion/Generate()
	reagents.add_reagent(/reagent/medicine/mana_potion,reagents.volume_max)
	return ..()

/obj/item/container/simple/beaker/bottle/plant_food
	name = "\improper EZ-Nutrient Bottle"

/obj/item/container/simple/beaker/bottle/plant_food/Generate()
	reagents.add_reagent(/reagent/nutrition/plant_food,reagents.volume_max)
	return ..()



/obj/item/container/simple/beaker/glass
	name = "drinking glass"
	desc = "Bottom's up!"
	desc_extended = "You can put drinks in these."
	icon = 'icons/obj/item/container/cup/glass.dmi'
	icon_state = "glass"
	icon_count = 12

	reagents = /reagent_container/beaker/drink/

	value = 10

	pixel_y = 4

/obj/item/container/simple/beaker/glass/get_consume_size(var/mob/living/L)
	return ..() * 2

/obj/item/container/simple/beaker/shot
	name = "shot glass"
	desc = "Bottom's way up!"
	desc_extended = "You can put drinks in these."
	icon = 'icons/obj/item/container/cup/glass_shot.dmi'
	icon_state = "glass"
	icon_count = 9

	reagents = /reagent_container/beaker/shot_glass/

	value = 5

	pixel_y = 4

/obj/item/container/simple/beaker/shot/get_consume_size(var/mob/living/L)
	return reagents.volume_max

/obj/item/container/simple/beaker/bowl
	name = "glass mixing bowl"
	desc = "A bowl for all your baking needs."
	desc_extended = "You can use this to prepare mixes for baking."
	icon = 'icons/obj/item/container/cup/bowl.dmi'
	icon_state = "bowl"
	icon_count = 23

	reagents = /reagent_container/beaker/large/

	value = 25