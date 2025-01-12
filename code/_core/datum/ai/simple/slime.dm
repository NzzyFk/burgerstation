/ai/slime/
	roaming_distance = 32

/ai/slime/proc/can_absorb_slime(var/mob/living/simple/slime/S)

	var/mob/living/simple/slime/self = owner

	if(!S || !self || S == self)
		return FALSE

	if(S.slime_color == self.slime_color)
		return FALSE

	if(S.stored_slimes > self.stored_slimes)
		return FALSE

	if(self.stored_slimes >= self.stored_slimes_max)
		return FALSE

	if(self.stored_slimes + S.stored_slimes > self.stored_slimes_max)
		return FALSE

	if(!S.can_attack(S,self,S,null,null))
		return FALSE

	return TRUE

/ai/slime/get_possible_targets()

	. = list()

	var/mob/living/simple/slime/self = owner

	for(var/mob/living/advanced/A in view(radius_find_enemy,owner))
		if(should_attack_mob(A))
			.[A] = TRUE

	if(!length(.) && self.stored_slimes < self.stored_slimes_max)
		for(var/mob/living/simple/slime/S in viewers(radius_find_enemy,owner))
			if(can_absorb_slime(S))
				.[S] = TRUE

/ai/slime/do_attack(var/atom/atom_to_attack)

	if(!istype(atom_to_attack,/mob/living/simple/slime/) || !can_absorb_slime(atom_to_attack))
		return ..()

	var/mob/living/simple/slime/self = owner
	self.absorb_slime(atom_to_attack)

	return TRUE
