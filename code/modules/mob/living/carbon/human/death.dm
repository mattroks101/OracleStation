/mob/living/carbon/human/gib_animation()
	switch(dna.species.species_gibs)
		if("human")
			new /obj/effect/temp_visual/gib_animation(loc, "gibbed-h")
		if("robotic")
			new /obj/effect/temp_visual/gib_animation(loc, "gibbed-r")

/mob/living/carbon/human/dust_animation()
	switch(dna.species.species_gibs)
		if("human")
			new /obj/effect/temp_visual/dust_animation(loc, "dust-h")
		if("robotic")
			new /obj/effect/temp_visual/dust_animation(loc, "dust-r")

/mob/living/carbon/human/spawn_gibs(with_bodyparts)
	if(with_bodyparts)
		switch(dna.species.species_gibs)
			if("human")
				new /obj/effect/gibspawner/human(get_turf(src), dna)
			if("robotic")
				new /obj/effect/gibspawner/robot(get_turf(src))
	else
		switch(dna.species.species_gibs)
			if("human")
				new /obj/effect/gibspawner/humanbodypartless(get_turf(src), dna)
			if("robotic")
				new /obj/effect/gibspawner/robot(get_turf(src))

/mob/living/carbon/human/spawn_dust(just_ash = FALSE)
	if(just_ash)
		new /obj/effect/decal/cleanable/ash(loc)
	else
		switch(dna.species.species_gibs)
			if("human")
				new /obj/effect/decal/remains/human(loc)
			if("robotic")
				new /obj/effect/decal/remains/robot(loc)

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD)
		return
	stop_sound_channel(CHANNEL_HEARTBEAT)
	var/obj/item/organ/heart/H = getorganslot(ORGAN_SLOT_HEART)
	if(H)
		H.beat = BEAT_NONE

	. = ..()

	dizziness = 0
	jitteriness = 0

	if(istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
		if(M.occupant == src)
			M.go_out()

	dna.species.spec_death(gibbed, src)

	if(SSticker.HasRoundStarted())
		SSblackbox.ReportDeath(src)
	if(is_devil(src))
		INVOKE_ASYNC(is_devil(src), /datum/antagonist/devil.proc/beginResurrectionCheck, src)
	unlock_achievement(new/datum/achievement/dead())

/mob/living/carbon/human/proc/makeSkeleton()
	status_flags |= DISFIGURED
	set_species(/datum/species/skeleton)
	return 1


/mob/living/carbon/proc/Drain()
	become_husk()
	disabilities |= NOCLONE
	blood_volume = 0
	return 1
