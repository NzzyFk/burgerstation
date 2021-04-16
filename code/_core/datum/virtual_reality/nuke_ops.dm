/virtual_reality/team/nuke_ops
	name = "Nuke Ops"
	desc = "NanoTrasen defends Syndicate from planting a bomb."

	teams = list(
		"Syndicate" = list(),
		"NanoTrasen" = list(),
		"Lobby" = list(),
		"Ready" = list(),
		"Specatators" = list()
	)

	team_loadouts = list(
		"Syndicate" = list(
			/loadout/virtual_reality/syndicate
		),
		"NanoTrasen" = list(
			/loadout/virtual_reality/nanotrasen
		),
		"Lobby" = list()
	)


	var/list/needs_loadout = list()

	var/list/valid_syndicate_turfs = list()
	var/list/valid_nanotrasen_turfs = list()

	var/turf/syndicate_marker
	var/turf/nanotrasen_marker
	var/turf/objective_marker

	var/round = 0 //Every 5 rounds is a team swap..

	var/state = 1

	var/list/score = list(
		"NanoTrasen" = 0,
		"Syndicate" = 0


	)

	//1 = waiting for players

	//2 = starting game

	//3 = starting round
	//4 = buy period
	//5 = action peroid
	//6 = round ending, NanoTrasen victory
	//7 = round nding, Syndicate victory

	var/time_left = -1


/virtual_reality/team/nuke_ops/proc/can_round_start()

	/*
	if(length(teams["Ready"]) <= 2)
		return "Waiting for More Players..."
	*/

	if(length(teams["Syndicate"]) <= 0)
		return "Waiting for Syndicate..."

	if(length(teams["NanoTrasen"]) <= 0)
		return "Waiting for NanoTrasen..."


	. = ..()

/virtual_reality/team/nuke_ops/proc/give_loadout(var/mob/living/advanced/A)

	if(length(team_loadouts[A.loyalty_tag]))
		var/loadout/L = pick(team_loadouts[A.loyalty_tag])
		A.equip_loadout(L)

/virtual_reality/team/nuke_ops/proc/on_player_ready(var/mob/living/L)

	if(state >= 2) //Late joiner!
		var/syndicate_length = length(teams["Syndicate"])
		var/nanotrasen_length = length(teams["NanoTrasen"])
		if(syndicate_length > nanotrasen_length)
			move_to_team(L,"NanoTrasen")
		else if(nanotrasen_length > syndicate_length)
			move_to_team(L,"Syndicate")
		else
			if(prob(50))
				move_to_team(L,"NanoTrasen")
			else
				move_to_team(L,"Syndicate")

	return TRUE

/virtual_reality/team/nuke_ops/proc/cleanup_map()
	/* This is BAD for performance.
	for(var/mob/living/L in all_mobs_with_clients)
		if(L.z != 1)
			continue
	var/mission_map = rustg_file_read(SSdmm_suite.map_path)
	dmm_suite.read_map(mission_map,1,1,1,overwrite=DMM_OVERWRITE_OBJS)
	log_subsystem(name,"Cleaned up mission map.")
	*/

/virtual_reality/team/nuke_ops/proc/place_mobs_at_spawn()

	for(var/k in teams["NanoTrasen"])
		var/mob/living/L = k
		var/turf/T = pick(valid_nanotrasen_turfs)
		if(length(valid_nanotrasen_turfs) > 4)
			valid_nanotrasen_turfs -= T
		L.force_move(T)
		L.rejuvenate()
		if(needs_loadout[L] && is_player(L))
			var/mob/living/advanced/player/P = L
			P.adjust_currency(500-P.currency)
		if(L.dead)
			L.revive()
			if(is_advanced(L))
				var/mob/living/advanced/A = L
				A.strip_and_delete_items()
				give_loadout(A)
		else if(needs_loadout[L] && is_advanced(L))
			var/mob/living/advanced/A = L
			A.strip_and_delete_items()
			give_loadout(A)
		needs_loadout -= L

	for(var/k in teams["Syndicate"])
		var/mob/living/L = k
		var/turf/T = pick(valid_syndicate_turfs)
		if(length(valid_syndicate_turfs) > 4)
			valid_syndicate_turfs -= T
		L.force_move(T)
		L.rejuvenate()
		if(needs_loadout[L] && is_player(L))
			var/mob/living/advanced/player/P = L
			P.adjust_currency(500-P.currency)
		if(L.dead)
			L.revive()
			if(is_advanced(L))
				var/mob/living/advanced/A = L
				A.strip_and_delete_items()
				give_loadout(A)
		else if(needs_loadout[L] && is_advanced(L))
			var/mob/living/advanced/A = L
			A.strip_and_delete_items()
			give_loadout(A)
		needs_loadout -= L

/virtual_reality/team/nuke_ops/move_to_team(var/mob/living/L,var/desired_team)

	. = ..()

	if(. && is_advanced(L) && team_loadouts[desired_team])
		needs_loadout[L] = TRUE

	if(desired_team == "Ready")
		on_player_ready(L)

/virtual_reality/team/nuke_ops/proc/generate_spawnpoints()

	CREATE(/obj/structure/interactive/vending/virtual_reality/ammo,syndicate_marker)
	var/turf/syndicate_marker_2 = get_step(syndicate_marker,EAST)
	CREATE(/obj/structure/interactive/vending/virtual_reality/weapons,syndicate_marker_2)
	var/turf/syndicate_marker_3 = get_step(syndicate_marker,WEST)
	CREATE(/obj/structure/interactive/vr_nuke,syndicate_marker_3)

	CREATE(/obj/structure/interactive/vending/virtual_reality/ammo,nanotrasen_marker)
	var/turf/nanotrasen_marker_2 = get_step(nanotrasen_marker,EAST)
	CREATE(/obj/structure/interactive/vending/virtual_reality/weapons,nanotrasen_marker_2)

	valid_syndicate_turfs = list()
	for(var/turf/simulated/floor/F in view(VIEW_RANGE*0.5,syndicate_marker))
		if(!F.is_safe_teleport())
			continue
		valid_syndicate_turfs += F

	valid_nanotrasen_turfs = list()
	for(var/turf/simulated/floor/F in view(VIEW_RANGE*0.5,nanotrasen_marker))
		if(!F.is_safe_teleport())
			continue
		valid_nanotrasen_turfs += F

/virtual_reality/team/nuke_ops/proc/round_start()
	state = 2
	log_debug("Setting VR state to 2 due to round_start()")
	cleanup_map()
	set_markers()
	generate_spawnpoints()
	if(round == 0)
		set_teams()
	else if(!(round % 5))
		swap_teams()

	place_mobs_at_spawn()

	round = 1
	state = 3
	log_debug("Setting VR state to 3 due to round_start()")
	time_left = 11 //Seconds

/virtual_reality/team/nuke_ops/proc/set_markers()

	var/list/valid_spawnpoints = tdm_spawnpoints.Copy()

	syndicate_marker = pick(valid_spawnpoints)
	valid_spawnpoints -= syndicate_marker

	nanotrasen_marker = null
	var/best_distance = 0
	for(var/k in valid_spawnpoints)
		var/turf/T = k
		var/distance = get_dist(T,syndicate_marker)
		if(!nanotrasen_marker || best_distance < distance)
			nanotrasen_marker = T
			best_distance = distance
	valid_spawnpoints -= nanotrasen_marker

	objective_marker = null
	best_distance = INFINITY
	for(var/k in valid_spawnpoints)
		var/turf/T = k
		var/distance_diff = abs(get_dist(T,syndicate_marker) - get_dist(T,nanotrasen_marker))
		if(!objective_marker || distance_diff < best_distance)
			objective_marker = T
			best_distance = distance_diff

	return TRUE

/virtual_reality/team/nuke_ops/proc/set_teams()

	var/n_count = 0
	var/s_count = 0

	var/i=1 + prob(50)
	for(var/k in teams["Ready"])
		var/mob/living/L = k
		if(i % 2)
			move_to_team(L,"NanoTrasen")
			n_count++
		else
			move_to_team(L,"Syndicate")
			s_count++
		i++

	log_debug("Made [n_count] players NanoTrasen.")
	log_debug("Made [s_count] players Syndicate.")



/virtual_reality/team/nuke_ops/proc/swap_teams()

	var/list/syndicate_members = teams["Syndicate"].Copy()
	var/list/nanotrasen_members = teams["NanoTrasen"].Copy()

	for(var/k in syndicate_members)
		move_to_team(k,"NanoTrasen")

	for(var/k in nanotrasen_members)
		move_to_team(k,"Syndicate")

	return TRUE

/virtual_reality/team/nuke_ops/on_life()

	if(time_left > 0)
		time_left--

	switch(state)
		if(0)
			set_message("Setting up game...")
		if(1)
			set_message("Waiting for players ([length(teams["Ready"])]/1 ready)...")
		if(2)
			set_message("Starting game...")
		if(3)
			set_message("Round starts in [get_clock_time(time_left)].")
		if(4)
			set_message("Buy period: [get_clock_time(time_left)].")
		if(5)
			set_message("NanoTrasen: [score["NanoTrasen"]] | [get_clock_time(time_left)] | Syndicate: [score["Syndicate"]].")
		if(6)
			set_message("NanoTrasen wins!")
		if(7)
			set_message("Syndicate wins!")

	if(state == 1 && length(teams["Ready"]) >= 1)
		round_start()
	else
		log_debug("State: [state], team length: [length(teams["Ready"])].")

	if(time_left <= 0)
		switch(state)
			if(3)
				time_left = 30
				state = 4
			if(4)
				time_left = 600
				state = 5

	. = ..()

/virtual_reality/team/nuke_ops/proc/check_gamemode_win()

	if(state >= 6)
		return FALSE

	if(length(teams["NanoTrasen"]) <= 0)
		state = 7
		score["Syndicate"] += 1
		return TRUE
	else if(length(teams["Syndicate"]) <= 0)
		state = 6
		score["NanoTrasen"] += 1
		return TRUE






/virtual_reality/team/nuke_ops/player_post_death(var/mob/living/advanced/player/virtual/P)
	. = ..()
	check_gamemode_win()