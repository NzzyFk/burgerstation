/obj/hud/inventory/organs/left_foot
	name = "left foot slot"
	icon_state = "slot_foot_left"
	id = BODY_FOOT_LEFT
	screen_loc = "LEFT:3+2,BOTTOM+1:13"
	click_flags = LEFT_FOOT

	item_slot = SLOT_FOOT
	item_slot_mod = SLOT_MOD_LEFT

	max_slots = 3
	worn = TRUE

	flags = FLAG_HUD_INVENTORY | FLAG_HUD_WORN | FLAG_HUD_MOB

	priority = 50

/obj/hud/inventory/organs/right_foot
	name = "right foot slot"
	icon_state = "slot_foot_right"
	id = BODY_FOOT_RIGHT
	screen_loc = "LEFT:1,BOTTOM+1:13"
	click_flags = RIGHT_FOOT

	item_slot = SLOT_FOOT
	item_slot_mod = SLOT_MOD_RIGHT

	max_slots = 3
	worn = TRUE

	flags = FLAG_HUD_INVENTORY | FLAG_HUD_WORN | FLAG_HUD_MOB

	priority = 51