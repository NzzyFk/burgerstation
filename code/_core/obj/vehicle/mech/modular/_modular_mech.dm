/mob/living/vehicle/mech/modular
	name = "modular mech"
	icon = 'icons/mob/living/advanced/mecha/parts.dmi'
	icon_state = "backbone"

	var/obj/item/mech_part/arms/mech_arms
	var/obj/item/mech_part/legs/mech_legs
	var/obj/item/mech_part/body/mech_body
	var/obj/item/mech_part/head/mech_head

	var/obj/item/mech_part/equipment/right_hand
	var/obj/item/mech_part/equipment/left_hand

	var/obj/item/mech_part/equipment/left_shoulder
	var/obj/item/mech_part/equipment/right_shoulder

	var/obj/item/mech_part/equipment/chest

	var/obj/item/mech_part/equipment/back

	var/obj/item/mech_part/equipment/head

	var/obj/item/powercell/battery

	pixel_x = -8

	value = 500

	armor = /armor/borg

	class = /class/mech

	health = /health/mob/living/vehicle/mech/modular

	health_base = 500

	movement_delay = DECISECONDS_TO_TICKS(4)


/mob/living/vehicle/mech/modular/proc/get_battery()
	return battery

/mob/living/vehicle/mech/modular/handle_movement(var/adjust_delay = 1)

	if(!battery || battery.charge_current <= 0)
		return FALSE

	. = ..()

	if(.)
		battery.charge_current -= 5
	else
		battery.charge_current -= 1

/mob/living/vehicle/mech/modular/get_examine_list(var/mob/caller)

	. = ..()

	if(mech_head) . += span("notice","It has \the [mech_head.name] equipped. ([mech_head.health.health_current]/[mech_head.health.health_max])")
	if(mech_body) . += span("notice","It has \the [mech_body.name] equipped. ([mech_body.health.health_current]/[mech_body.health.health_max])")
	if(mech_arms) . += span("notice","It has \the [mech_arms.name] equipped. ([mech_arms.health.health_current]/[mech_arms.health.health_max])")
	if(mech_legs) . += span("notice","It has \the [mech_legs.name] equipped. ([mech_legs.health.health_current]/[mech_legs.health.health_max])")

	if(right_hand) . += span("notice","It has \the [right_hand.name] equipped in the right hand.")
	if(left_hand) . += span("notice","It has \the [left_hand.name] equipped in the left hand.")

	if(right_shoulder) . += span("notice","It has \the [right_shoulder.name] equipped in the right shoulder.")
	if(left_shoulder) . += span("notice","It has \the [left_shoulder.name] equipped in the left shoulder.")

	if(battery) . += span("notice","It has \the [battery.name] inserted in the chassis. It has a charge rating of ([battery.charge_current]/[battery.charge_max]).")

/mob/living/vehicle/mech/modular/attach_equipment(var/mob/caller,var/obj/item/I)
	return FALSE

/mob/living/vehicle/mech/modular/unattach_equipment(var/mob/caller,var/obj/item/I)
	return FALSE

/mob/living/vehicle/mech/modular/can_attach_weapon(var/mob/caller,var/obj/item/I)

	if(!mech_arms)
		caller?.to_chat(span("notice","You must add a set of arms to this assembly before attaching weapons!"))
		return FALSE

	return ..()


/mob/living/vehicle/mech/modular/click_on_object(var/mob/caller as mob,var/atom/object,location,control,params)

	if(object.plane >= PLANE_HUD)
		return ..()

	if(!mech_arms || (mech_arms && mech_arms.health.health_current <= 0))
		return FALSE

	if(!. && params["right"])
		if(left_shoulder && caller.attack_flags & CONTROL_MOD_DISARM)
			. = left_shoulder.click_on_object(caller,object,location,control,params)
		else if(left_hand)
			. = left_hand.click_on_object(caller,object,location,control,params)

	if(!. && params["left"])
		if(right_shoulder && caller.attack_flags & CONTROL_MOD_DISARM)
			. = right_shoulder.click_on_object(caller,object,location,control,params)
		else if(right_hand)
			. = right_hand.click_on_object(caller,object,location,control,params)

	return TRUE

/mob/living/vehicle/mech/modular/clicked_on_by_object(var/mob/caller,var/atom/object,location,control,params)

	DEFER_OBJECT

	if(is_item(defer_object) && is_living(caller))
		var/mob/living/L = caller
		if(L.intent == INTENT_HARM)
			return ..()
		if(length(passengers))
			return ..()
		var/obj/item/I = defer_object
		if(I.flags_tool & FLAG_TOOL_WRENCH)

			INTERACT_CHECK
			INTERACT_CHECK_DEFER
			INTERACT_DELAY(5)

			var/list/valid_weapons = list()

			if(left_hand)
				valid_weapons[left_hand.name] = "left_hand"
			if(right_hand)
				valid_weapons[right_hand.name] = "right_hand"
			if(left_shoulder)
				valid_weapons[left_shoulder.name] = "left_shoulder"
			if(right_shoulder)
				valid_weapons[right_shoulder.name] = "right_shoulder"
			if(head)
				valid_weapons[head.name] = "head"
			if(back)
				valid_weapons[back.name] = "back"
			if(chest)
				valid_weapons[chest.name] = "chest"
			if(battery)
				valid_weapons[battery.name] = "battery"

			if(length(valid_weapons))
				valid_weapons["Cancel"] = "Cancel"
				var/desired_remove = input("What would you like to remove?","Weapon Removal","Cancel") as null|anything in valid_weapons

				desired_remove = valid_weapons[desired_remove]

				if(!caller)
					return TRUE

				if(!desired_remove || desired_remove == "Cancel")
					caller.to_chat(span("notice","You decide not to remove anything."))
				else
					var/obj/item/I2 = vars[desired_remove]
					I2.drop_item(get_turf(caller))
					I2.update_sprite()
					vars[desired_remove] = null
					update_sprite()

			else
				var/list/valid_parts = list(
					"mech_head",
					"mech_arms",
					"mech_body",
					"mech_legs"
				)

				var/removed = FALSE
				for(var/i=1,i<=length(valid_parts),i++)
					var/part_name = valid_parts[i]
					var/obj/item/I2 = vars[part_name]
					if(I2)
						caller?.visible_message(span("notice","\The [caller.name] removes \the [I2.name] from \the [src.name]."),span("notice","You remove \the [I2.name] from \the [src.name]."))
						I2.drop_item(get_turf(src))
						if(caller)
							I2.drop_item(get_turf(caller))
						else
							I2.drop_item(get_turf(src))
						vars[part_name] = null
						update_sprite()
						removed = TRUE
						break

				if(!removed)
					caller?.to_chat(span("notice","There is nothing to remove from \the [src.name]!"))

			return TRUE

		if(istype(I,/obj/item/powercell/))
			INTERACT_CHECK
			INTERACT_CHECK_DEFER
			INTERACT_DELAY(5)
			var/obj/item/powercell/PC = I
			if(battery)
				caller?.visible_message(span("notice","\The [caller.name] replaces \the [battery.name] in \the [src.name] with \the [PC.name]."),span("notice","You replace \the [battery.name] in \the [src.name] with \the [PC.name]."))
				battery.update_sprite()
				battery.drop_item(get_turf(caller))
				battery = null
			else
				caller?.visible_message(span("notice","\The [caller.name] adds \the [PC.name] to \the [src.name]."),span("notice","You add \the [PC.name] to \the [src.name]."))
			PC.drop_item(src)
			battery = PC
			return TRUE

		if(istype(I,/obj/item/mech_part/))
			INTERACT_CHECK
			INTERACT_CHECK_DEFER
			INTERACT_DELAY(5)
			. = FALSE
			if(istype(I,/obj/item/mech_part/arms))
				if(!mech_arms)
					if(!mech_body)
						caller?.to_chat(span("notice","You must add a mech body to this assembly before attaching \the [I.name]!"))
						return TRUE
					mech_arms = I
					. = TRUE
				else
					caller?.to_chat(span("notice","There are already mech arms attached to \the [I.name]!"))
			else if(istype(I,/obj/item/mech_part/legs))
				if(!mech_legs)
					mech_legs = I
					. = TRUE
				else
					caller?.to_chat(span("notice","There are already mech legs attached to \the [I.name]!"))
			else if(istype(I,/obj/item/mech_part/body))
				if(!mech_body)
					if(!mech_legs)
						caller?.to_chat(span("notice","You must add mech legs to this assembly before attaching \the [I.name]!"))
						return TRUE
					mech_body = I
					. = TRUE
				else
					caller?.to_chat(span("notice","There is already a mech body attached to \the [I.name]!"))
			else if(istype(I,/obj/item/mech_part/head))
				if(!mech_head)
					if(!mech_body)
						caller?.to_chat(span("notice","You must add a mech body to this assembly before attaching \the [I.name]!"))
						return TRUE
					mech_head = I
					. = TRUE
				else
					caller?.to_chat(span("notice","There is already a mech head attached to \the [I.name]!"))
			else if(istype(I,/obj/item/mech_part/equipment))
				var/obj/item/mech_part/equipment/E = I
				if(!mech_arms)
					caller?.to_chat(span("notice","You must add mech arms to this assembly before attaching \the [E.name]!"))
					return TRUE
				if(!. && E.slot & MECH_SLOT_HAND)
					if(!right_hand)
						right_hand = E
						E.current_slot = "right hand"
						. = TRUE
					else if(!left_hand)
						left_hand = E
						E.current_slot = "left hand"
						. = TRUE
				if(!. && E.slot & MECH_SLOT_SHOULDER)
					if(!right_shoulder)
						right_shoulder = E
						E.current_slot = "right shoulder"
						. = TRUE
					else if(!left_shoulder)
						left_shoulder = E
						E.current_slot = "left shoulder"
						. = TRUE
				if(!. && E.slot & MECH_SLOT_BACK)
					if(!back)
						back = E
						E.current_slot = "back"
						. = TRUE
				if(!. && E.slot & MECH_SLOT_CHEST)
					if(!chest)
						chest = E
						E.current_slot = "chest"
						. = TRUE
				if(!. && E.slot & MECH_SLOT_HEAD)
					if(!head)
						head = E
						E.current_slot = "head"
						. = TRUE
			if(.)
				I.drop_item(src)
				I.update_sprite()
				caller?.visible_message(span("notice","\The [caller.name] inserts \the [I.name] into \the [src.name]."),span("notice","You insert \the [I.name] into \the [src.name]."))
				update_sprite()
			return TRUE

	return ..()

/mob/living/vehicle/mech/modular/update_overlays()
	. = ..()

	//Parts
	if(mech_legs) add_overlay(mech_legs)
	if(mech_body) add_overlay(mech_body)
	if(mech_arms) add_overlay(mech_arms)
	if(mech_head) add_overlay(mech_head)

	//Weapons
	if(right_shoulder) add_overlay(right_shoulder)
	if(left_shoulder) add_overlay(left_shoulder)
	if(right_hand) add_overlay(right_hand)
	if(left_hand) add_overlay(left_hand)
	if(chest) add_overlay(chest)
	if(back) add_overlay(back)
	if(head) add_overlay(head)


/mob/living/vehicle/mech/modular/update_icon()

	. = ..()

	if(mech_body)
		icon_state = "none"
	else
		icon_state = "backbone"
		set_dir(SOUTH)


/mob/living/vehicle/mech/modular/set_dir(var/desired_dir,var/force=FALSE)

	if(!mech_body)
		dir = SOUTH
		return TRUE

	return ..()


/mob/living/vehicle/mech/modular/get_object_to_damage(var/atom/attacker,var/atom/weapon,var/damage_type/damage_type,var/list/params = list(),var/accurate=FALSE,var/find_closest=FALSE,var/inaccuracy_modifier=1)


	var/x_attack = params[PARAM_ICON_X] ? params[PARAM_ICON_X] : 16
	var/y_attack = params[PARAM_ICON_Y] ? params[PARAM_ICON_Y] : 16

	if(mech_arms && (x_attack < 12 || x_attack > 16) && y_attack > 12 && y_attack < 23)
		return mech_arms

	if(mech_legs && y_attack < 13)
		return mech_legs

	if(mech_head && y_attack > 24)
		return mech_head

	if(mech_body)
		return mech_body

	return src

/mob/living/vehicle/mech/modular/handle_movement(var/adjust_delay = 0)

	if(!mech_legs || (mech_legs.health && mech_legs.health.health_current <= 0))
		return FALSE

	return ..()

/mob/living/vehicle/mech/modular/premade/ripley/Generate()

	. = ..()

	mech_arms = new/obj/item/mech_part/arms/loader(src)
	INITIALIZE(mech_arms)
	GENERATE(mech_arms)
	FINALIZE(mech_arms)

	mech_body = new/obj/item/mech_part/body/loader(src)
	INITIALIZE(mech_body)
	GENERATE(mech_body)
	FINALIZE(mech_body)

	mech_legs = new/obj/item/mech_part/legs/loader(src)
	INITIALIZE(mech_legs)
	GENERATE(mech_legs)
	FINALIZE(mech_legs)

	left_hand = new/obj/item/mech_part/equipment/weapon/laser(src)
	left_hand.current_slot = "left hand"
	INITIALIZE(left_hand)
	GENERATE(left_hand)
	FINALIZE(left_hand)

	right_hand = new/obj/item/mech_part/equipment/weapon/drill(src)
	right_hand.current_slot = "right hand"
	INITIALIZE(right_hand)
	GENERATE(right_hand)
	FINALIZE(right_hand)

	battery = new/obj/item/powercell/vehicle(src)
	INITIALIZE(battery)
	GENERATE(battery)
	FINALIZE(battery)

	update_sprite()
