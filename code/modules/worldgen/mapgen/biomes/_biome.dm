///This datum handles the transitioning from a turf to a specific biome, and handles spawning decorative structures and mobs.
/datum/biome
	///Type of turf this biome creates
	var/turf_type
	///Chance of having a structure from the flora types list spawn
	var/flora_density = 0
	///Chance of having a mob from the fauna types list spawn
	var/fauna_density = 0
	///list of type paths of objects that can be spawned when the turf spawns flora. Syntax: list(type = weight)
	var/list/flora_types = list(/obj/tree = 100)
	///list of type paths of mobs that can be spawned when the turf spawns fauna. Syntax: list(type = weight)
	var/list/fauna_types = list()

var/list/area/blacklist_flora_gen = list(/area/shuttle, /area/mining)

///This proc handles the creation of a turf of a specific biome type
/datum/biome/proc/generate_turf(var/turf/gen_turf, flags=0)
	gen_turf.ReplaceWith(turf_type, keep_old_material=FALSE, handle_dir=FALSE)

	if((flags & MAPGEN_IGNORE_FAUNA) == 0)
		if(length(fauna_types) && prob(fauna_density))
			var/mob/fauna = weighted_pick(fauna_types)
			new fauna(gen_turf)

	// Skip areas where flora generation can be problematic due to introduction of dense anchored objects
	if((gen_turf.z == Z_LEVEL_STATION || isgenplanet(gen_turf)) && ((flags & MAPGEN_IGNORE_BUILDABLE) == 0))
		gen_turf.AddComponent(/datum/component/buildable_turf)

		for(var/bad_area in blacklist_flora_gen)
			if(istype(gen_turf.loc, bad_area))
				return

	if( flags & MAPGEN_ALLOW_VEHICLES )
		gen_turf.allows_vehicles = TRUE

	if((flags & MAPGEN_IGNORE_FLORA) == 0)
		if(length(flora_types) && prob(flora_density))
			var/obj/structure/flora = weighted_pick(flora_types)
			new flora(gen_turf)

	var/area/A = get_area(gen_turf)
	A.store_biome(gen_turf, src.type)

/datum/biome/mudlands
	turf_type = /turf/unsimulated/floor/auto/dirt
	flora_types = list(/obj/stone/random = 100, /obj/decal/fakeobjects/smallrocks = 100)
	flora_density = 3

/datum/biome/desert
	turf_type = /turf/unsimulated/floor/auto/sand
	flora_types = list(/obj/stone/random = 100, /obj/decal/fakeobjects/smallrocks = 100)
	flora_density = 1

	fauna_types = list(/mob/living/critter/small_animal/scorpion=15, /mob/living/critter/small_animal/rattlesnake=1, /mob/living/critter/small_animal/armadillo=1, /mob/living/critter/small_animal/wasp=5)
	fauna_density = 0.2

/datum/biome/desert/rough
	turf_type = /turf/unsimulated/floor/auto/sand/rough
	flora_density = 5

/datum/biome/snow
	turf_type = /turf/unsimulated/floor/auto/snow
	flora_types = list(/obj/stone/snow/random = 100, /obj/decal/fakeobjects/smallrocks = 100, /obj/shrub/snow/random{override_default_behaviour=1} = 100, /obj/stone/random = 5)
	flora_density = 2

/datum/biome/snow/rocky
	turf_type = /turf/unsimulated/floor/auto/snow
	flora_types = list(/obj/stone/snow/random = 100, /obj/stone/random = 20, /obj/decal/fakeobjects/smallrocks = 20)
	flora_density = 5

/datum/biome/snow/forest
	flora_types = list(/obj/tree/snow_random = 50, /obj/shrub/snow/random{override_default_behaviour=1} = 100, /obj/stone/snow/random = 10, /obj/decal/fakeobjects/smallrocks = 5)
	flora_density = 20

/datum/biome/snow/forest/thick
	flora_density = 30

/datum/biome/snow/rough
	turf_type = /turf/unsimulated/floor/auto/snow/rough
	flora_types = list(/obj/stone/snow/random = 100, /obj/decal/fakeobjects/smallrocks = 50, /obj/stone/random = 5)
	flora_density = 3

/datum/biome/plains
	turf_type = /turf/unsimulated/floor/auto/grass/swamp_grass
	flora_types = list(/obj/tree/elm_random = 50, /obj/shrub/random{override_default_behaviour=1} = 100, /obj/stone/random = 100, /obj/decal/fakeobjects/smallrocks = 100)
	flora_density = 15

/datum/biome/forest
	turf_type = /turf/unsimulated/floor/grasslush/thin
	flora_types = list(/obj/tree{layer = EFFECTS_LAYER_UNDER_1} = 75, /obj/tree/elm_random=1, /obj/shrub/random{override_default_behaviour=1} = 50)
	flora_density = 20

	fauna_types = list(/mob/living/critter/small_animal/firefly/ai_controlled = 5, /mob/living/critter/small_animal/firefly/pyre/ai_controlled = 1, /mob/living/critter/small_animal/firefly/lightning/ai_controlled = 1, /mob/living/critter/bear=5, /mob/living/critter/small_animal/bird/crow=5)
	fauna_density = 0.2

/datum/biome/forest/dense
	turf_type = /turf/unsimulated/floor/grasslush/thinner
	flora_types = list(/obj/tree{layer = EFFECTS_LAYER_UNDER_1} = 75, /obj/tree/elm_random=1, /obj/shrub/random{override_default_behaviour=1} = 5, /obj/machinery/plantpot/bareplant/tree = 5)
	flora_density = 35

	fauna_types = list(/mob/living/critter/small_animal/dragonfly/ai_controlled = 20, /mob/living/critter/bear=1, /mob/living/critter/small_animal/frog=5, /mob/living/critter/small_animal/bird/owl=5)

/datum/biome/forest/thin
	turf_type = /turf/unsimulated/floor/grasslush
	flora_types = list(/obj/tree{layer = EFFECTS_LAYER_UNDER_1} = 5, /obj/tree/elm_random=5, /obj/shrub/random{override_default_behaviour=1} = 150, /obj/machinery/plantpot/bareplant/tree = 5, /obj/machinery/plantpot/bareplant/flower = 50)
	flora_density = 10

	fauna_types = list(/mob/living/critter/small_animal/mouse=5, /mob/living/critter/small_animal/pig=1, /mob/living/critter/small_animal/snake=1, /mob/living/critter/small_animal/bird/crow=1)
	fauna_density = 0.5

/datum/biome/forest/clearing
	turf_type = /turf/unsimulated/floor/grasslush
	flora_types = list(/obj/shrub/random{override_default_behaviour=1} = 150, /obj/machinery/plantpot/bareplant/flower = 50)
	flora_density = 5

	fauna_types = list(/mob/living/critter/small_animal/mouse=10, /mob/living/critter/small_animal/snake=1)

/datum/biome/jungle
	turf_type = /turf/unsimulated/floor/auto/grass/leafy
	flora_types = list(/obj/tree/elm_random = 75, /obj/shrub/random{override_default_behaviour=1} = 150, /obj/stone/random = 10, /obj/decal/fakeobjects/smallrocks = 10, /obj/machinery/plantpot/bareplant/swamp_flora = 1)
	flora_density = 40

	fauna_types = list(/mob/living/critter/small_animal/dragonfly/ai_controlled = 50, /mob/living/critter/small_animal/firefly/ai_controlled = 10, /mob/living/critter/small_animal/firefly/lightning/ai_controlled = 2, /mob/living/critter/small_animal/firefly/pyre/ai_controlled = 1, /mob/living/critter/small_animal/iguana = 3)
	fauna_density = 0.2

/datum/biome/jungle/deep
	flora_density = 65
	fauna_density = 0.8

/datum/biome/wasteland
	turf_type = /turf/unsimulated/greek/beach

/datum/biome/water
	turf_type = /turf/unsimulated/floor/auto/swamp

/datum/biome/water/swamp
	fauna_types = list(/mob/living/critter/small_animal/dragonfly/ai_controlled=30, /mob/living/critter/small_animal/firefly/lightning/ai_controlled=1, /mob/living/critter/small_animal/firefly/pyre/ai_controlled=1)
	fauna_density = 0.5

/datum/biome/water/clear
	turf_type = /turf/unsimulated/floor/auto/water

/datum/biome/water/ice
	turf_type = /turf/unsimulated/floor/auto/water/ice

/datum/biome/water/ice/rough
	turf_type = /turf/unsimulated/floor/auto/water/ice/rough

/datum/biome/mountain
	turf_type = /turf/simulated/wall/auto/asteroid/mountain

/datum/biome/mountain/desert
	turf_type = /turf/simulated/wall/auto/asteroid/mountain/desert
