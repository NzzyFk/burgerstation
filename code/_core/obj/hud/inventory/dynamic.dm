/obj/hud/inventory/dynamic
	name = "inventory space"
	icon_state = "square_round"

	max_size = -1

	should_draw = FALSE
	drag_to_take = FALSE

	max_slots = 1

	flags = FLAG_HUD_INVENTORY | FLAG_HUD_SPECIAL | FLAG_HUD_CONTAINER

	should_add_to_advanced = FALSE

	var/slot_num = 0

	priority = -100 //Very low priority

/obj/hud/inventory/dynamic/New(var/desired_loc)
	. = ..()
	if(is_atom(desired_loc))
		var/atom/A = desired_loc
		name = "inventory space of [A.name]"
	alpha = 0
	mouse_opacity = 0

/obj/hud/inventory/dynamic/sandwich //Special logic for buns

/obj/hud/inventory/dynamic/sandwich/can_slot_object(var/obj/item/I,var/messages = FALSE,var/bypass=FALSE)

	if(src.loc && istype(src.loc.loc,/obj/hud/inventory/dynamic/sandwich/)) //Our sandwich is in of another sandwich. Do not accept items.
		//No message needed.
		return FALSE

	if(istype(I,/obj/item/container/edible/sandwich/))
		var/obj/item/container/edible/sandwich/S = I
		for(var/obj/hud/inventory/I2 in S.inventories)
			if(length(I2.contents))
				if(owner) owner.to_chat(span("warning","You can't put a sandwich inside another sandwich! That's breaking the laws of sandwich!"))
				return FALSE
		if(loc && loc == I)
			return FALSE

		if(max_slots <= 0)
			return FALSE

		if(is_occupied(TRUE))
			if(messages && src.loc)
				owner.to_chat(span("warning","\The [src.loc.name] is already occupied!"))
			return FALSE

		if(length(contents) >= max_slots)
			if(messages) owner.to_chat(span("warning","You don't see how you can fit any more objects inside \the [src.loc.name]!"))
			return FALSE

		return TRUE

	. = ..()


/*
/obj/hud/inventory/dynamic/belt
	var/obj/hud/button/slot/assoc_slot
	priority = -99 //Belt goes before anything else.


/obj/hud/inventory/dynamic/belt/Destroy()
	assoc_slot = null
	. = ..()

/obj/hud/inventory/dynamic/belt/update_stats() //Something was removed/added.
	. = ..()
	if(assoc_slot)
		var/obj/item/I = get_top_object()
		if(I)
			assoc_slot.store_object(I) //Also calls clear_object()
		else
			assoc_slot.clear_object()
*/
