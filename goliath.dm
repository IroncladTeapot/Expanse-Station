/obj/mecha/combat/goliath
	desc = "Powered combat armor. Worn by the Martian Marine Corps."
	name = "Goliath"
	icon_state = "goliath"
	initial_icon = "goliath"
	step_in = 2.5
	dir_in = 1 //Facing North.
	health = 550
	deflect_chance = 35
	damage_absorption = list("brute"=0.25,"fire"=1,"bullet"=0.85,"laser"=0.60,"energy"=0.75,"bomb"=0.4)
	max_temperature = 35000
	infra_luminosity = 2
	var/overload = 0
	var/overload_coeff = 2
	wreckage = /obj/effect/decal/mecha_wreckage/goliath
	internal_damage_threshold = 25
	force = 30
	max_equip = 5


/obj/mecha/combat/goliath/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gatlinggun
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/armor_booster/antiproj_armor_booster
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/minimissiles
	ME.attach(src)
	return

/obj/mecha/combat/goliath/add_cell()
	cell = new /obj/item/weapon/cell/hyper(src)

/obj/mecha/combat/goliath/verb/overload()
	set category = "Exosuit Interface"
	set name = "Toggle leg actuators overload"
	set src = usr.loc
	set popup_menu = 0
	if(usr!=src.occupant)
		return
	if(overload)
		overload = 0
		step_in = initial(step_in)
		step_energy_drain = initial(step_energy_drain)
		src.occupant_message("<font color='blue'>You disable leg actuators overload.</font>")
	else
		overload = 1
		step_in = min(1, round(step_in/2))
		step_energy_drain = step_energy_drain*overload_coeff
		src.occupant_message("<font color='red'>You enable leg actuators overload.</font>")
	src.log_message("Toggled leg actuators overload.")
	return

/obj/mecha/combat/goliath/do_move(direction)
	if(!..()) return
	if(overload)
		health--
		if(health < initial(health) - initial(health)/3)
			overload = 0
			step_in = initial(step_in)
			step_energy_drain = initial(step_energy_drain)
			src.occupant_message("<font color='red'>Leg actuators damage threshold exceded. Disabling overload.</font>")
	return


/obj/mecha/combat/goliath/get_stats_part()
	var/output = ..()
	output += "<b>Leg actuators overload: [overload?"on":"off"]</b>"
	return output

/obj/mecha/combat/goliath/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_leg_overload=1'>Toggle leg actuators overload</a>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/goliath/Topic(href, href_list)
	..()
	if (href_list["toggle_leg_overload"])
		src.overload()
	return