local item_sounds = require("__base__.prototypes.item_sounds")

local frep = require("__fdsl__.lib.recipe")

local ei_settings = require ("ei-settings")
local ci_ore_crushing = settings.startup["crushing-industry-ore"].value
local ci_hide_player_crafting = settings.startup["crushing-industry-hide-player-crafting"].value

if ci_ore_crushing and mods["bzlead"] then
	local lead_ore = data.raw.item["lead-ore"]

	data:extend({
		{
			type = "item",
			name = "ei-enriched-lead-ore",
			icon = "__enriching-industry__/graphics/icons/enriched-lead-ore.png",
			icon_size = 64,
			pictures =
			{
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-lead-ore.png",   scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-lead-ore-1.png", scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-lead-ore-2.png", scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-lead-ore-3.png", scale = 0.5, mipmap_count = 1 }
			},
			subgroup = "raw-resource",
			order = lead_ore.order.."-d[enriched]",
			hidden = not ci_ore_crushing,
			stack_size = 100,
			weight = 2 * kg
		},
		{
			type = "fluid",
			name = "ei-sulfuric-lead-solution",
			icon = "__enriching-industry__/graphics/icons/sulfuric-lead-solution.png",
			subgroup = "fluid",
			order = "a[fluid]-e[chemicals]-d[sulfuric-lead-solution]",
			hidden = not ci_ore_crushing,
			auto_barrel = ci_ore_crushing,
			default_temperature = 25,
			max_temperature = 100,
			heat_capacity = "0.01kJ",
			base_color = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--neon blue	#67C8FF
			flow_color = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--light blue1	#BFEFFF
			visualization_color = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--light blue1	#BFEFFF
		}
	}
	)

	data:extend({
		{
			type = "recipe",
			name = "ei-enriched-lead-ore",
			icons = EnrichingIndustry.make_washing_icons("crushed-lead-ore"),
			localised_name = {"recipe-name.ei-enriched-lead-ore"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			order = lead_ore.order.."-d[enriched]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 1.2,
			ingredients = {
				{type="item", name="crushed-lead-ore", amount=1},
				{type="fluid", name="water", amount=10}
			},
			results = {
				{type="item", name="ei-enriched-lead-ore", amount=1, extra_count_fraction=ei_settings.ei_wash_bonus_direct},
				{type="fluid", name="ei-tailing-slurry", amount=10, ignored_by_productivity=1000},
				EnrichingIndustry.make_washing_byproduct("crushed-lead-ore", ei_settings.ei_wash_bonus_primprec, 1, ei_settings.ei_productivity_precursor),
				EnrichingIndustry.make_washing_byproduct("lead-ore", ei_settings.ei_wash_bonus_secoprec, 1, ei_settings.ei_productivity_precursor),
			},
			main_product = "ei-enriched-lead-ore",
			crafting_machine_tint =
			{
				primary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
			}
		},
		{
			type = "recipe",
			name = "ei-sulfuric-lead-leaching",
			localised_name = {"recipe-name.ei-sulfuric-lead-leaching"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			subgroup = "raw-resource",--fluid-recipes",
			order = lead_ore.order.."-e[leached]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 1.2,
			ingredients = {
				{type="item", name="crushed-lead-ore", amount=1},
				{type="fluid", name="water", amount=10},
				{type="fluid", name="sulfuric-acid", amount=ei_settings.ei_leach_sulfuric_acid}
			},
			results = {
				{type="fluid", name="ei-sulfuric-lead-solution", amount=ei_settings.ei_leach_bonus_direct + 10},
				EnrichingIndustry.make_washing_byproduct("crushed-lead-ore", ei_settings.ei_leach_bonus_primprec, 1, ei_settings.ei_productivity_precursor),
			},
			main_product = "ei-sulfuric-lead-solution",
			crafting_machine_tint =
			{
				primary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 1.00, g = 1.00, b = 0.49, a = 1.000},--	#FFFF7E	papaya
			}
		},
		{
			type = "recipe",
			name = "ei-enriched-lead-ore-recrystallization",
			icons = EnrichingIndustry.make_smelting_icons("ei-sulfuric-lead-solution", "ei-enriched-lead-ore", true),
			localised_name = {"recipe-name.ei-enriched-lead-ore-recrystallization"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			order = lead_ore.order.."-f[recrystal]",
			factoriopedia_alternative = "ei-enriched-lead-ore",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 0.6,
			ingredients = {
				{type="fluid", name="ei-sulfuric-lead-solution", amount=10}
			},
			results = {
				{type="item", name="ei-enriched-lead-ore", amount=1, extra_count_fraction=ei_settings.ei_recry_bonus_direct},
				{type="fluid", name="water", amount=5, ignored_by_productivity=100},
			},
			main_product = "ei-enriched-lead-ore",
			crafting_machine_tint =
			{
				primary = {r = 0.93, g = 0.76, b = 0.58, a = 1.000}, --	#EDC393	light copper
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
			}
		},
		{
			type = "recipe",
			name = "ei-enriched-lead-smelting",
			icons = EnrichingIndustry.make_smelting_icons("ei-enriched-lead-ore", "lead-plate"),
			categories = {"smelting"},
			order = data.raw.recipe["lead-plate"].order.."-d[enriched]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			hide_from_player_crafting = ci_hide_player_crafting == true,
			energy_required = 3.2,
			ingredients = {{type="item", name="ei-enriched-lead-ore", amount=1}},
			results = {{type="item", name="lead-plate", amount=1}},
			main_product = "lead-plate",
		},
	}
	)

	-- Add secondary metal byproduct to recrystallization if sec. bonus > 0
	if ei_settings.ei_recry_byprod > 0 then
		frep.add_result("ei-enriched-lead-ore-recrystallization", {type="item", name="ei-enriched-copper-ore", amount=1, independent_probability=ei_settings.ei_recry_byprod})
	end
	-- Add sulfur after secondary metal to recrystallization
	if ei_settings.ei_nonmetal_byproduct_sulfur_recrystall > 0 then
		frep.add_result("ei-enriched-lead-ore-recrystallization", EnrichingIndustry.make_washing_byproduct("sulfur", ei_settings.ei_nonmetal_byproduct_sulfur_recrystall), false)
	end

	frep.add_result("ei-tailing-slurry-reprocessing", {type="item", name="ei-enriched-lead-ore", amount=1, independent_probability=0.25})

	if mods["space-age"] then
		frep.replace_ingredient("molten-lead", "crushed-lead-ore", "ei-enriched-lead-ore")
		frep.scale_ingredient("molten-lead", "ei-enriched-lead-ore", {amount=4/3})
	end
end

if ci_ore_crushing and mods["bztin"] then
	local tin_ore = data.raw.item["tin-ore"]

	data:extend(
	{
		{
			type = "item",
			name = "ei-enriched-tin-ore",
			icon = "__enriching-industry__/graphics/icons/enriched-tin-ore.png",
			icon_size = 64,
			pictures =
			{
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-tin-ore.png",   scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-tin-ore-1.png", scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-tin-ore-2.png", scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-tin-ore-3.png", scale = 0.5, mipmap_count = 1 }
			},
			subgroup = "raw-resource",
			order = tin_ore.order.."-d[enriched]",
			hidden = not ci_ore_crushing,
			stack_size = 100,
			weight = 2 * kg
		},
		{
			type = "fluid",
			name = "ei-sulfuric-tin-solution",
			icon = "__enriching-industry__/graphics/icons/sulfuric-tin-solution.png",
			subgroup = "fluid",
			order = "a[fluid]-e[chemicals]-c[sulfuric-tin-solution]",
			hidden = not ci_ore_crushing,
			auto_barrel = ci_ore_crushing,
			default_temperature = 25,
			max_temperature = 100,
			heat_capacity = "0.01kJ",
			base_color = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--neon blue	#67C8FF
			flow_color = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--light blue1	#BFEFFF
			visualization_color = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--light blue1	#BFEFFF
		}
	}
	)

	data:extend({
		{
			type = "recipe",
			name = "ei-enriched-tin-ore",
			icons = EnrichingIndustry.make_washing_icons("crushed-tin-ore"),
			localised_name = {"recipe-name.ei-enriched-tin-ore"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			order = tin_ore.order.."-d[enriched]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 1.2,
			ingredients = {
				{type="item", name="crushed-tin-ore", amount=1},
				{type="fluid", name="water", amount=10}
			},
			results = {
				{type="item", name="ei-enriched-tin-ore", amount=1, extra_count_fraction=ei_settings.ei_wash_bonus_direct},
				{type="fluid", name="ei-tailing-slurry", amount=10, ignored_by_productivity=1000},
				EnrichingIndustry.make_washing_byproduct("crushed-tin-ore", ei_settings.ei_wash_bonus_primprec, 1, ei_settings.ei_productivity_precursor),
				EnrichingIndustry.make_washing_byproduct("tin-ore", ei_settings.ei_wash_bonus_secoprec, 1, ei_settings.ei_productivity_precursor),
			},
			main_product = "ei-enriched-tin-ore",
			crafting_machine_tint =
			{
				primary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
			}
		},
		{
			type = "recipe",
			name = "ei-sulfuric-tin-leaching",
			localised_name = {"recipe-name.ei-sulfuric-tin-leaching"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			subgroup = "raw-resource",--fluid-recipes",
			order = tin_ore.order.."-e[leached]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 1.2,
			ingredients = {
				{type="item", name="crushed-tin-ore", amount=1},
				{type="fluid", name="water", amount=10},
				{type="fluid", name="sulfuric-acid", amount=ei_settings.ei_leach_sulfuric_acid}
			},
			results = {
				{type="fluid", name="ei-sulfuric-tin-solution", amount=ei_settings.ei_leach_bonus_direct + 10},
				EnrichingIndustry.make_washing_byproduct("crushed-tin-ore", ei_settings.ei_leach_bonus_primprec, 1, ei_settings.ei_productivity_precursor),
			},
			main_product = "ei-sulfuric-tin-solution",
			crafting_machine_tint =
			{
				primary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 1.00, g = 1.00, b = 0.49, a = 1.000},--	#FFFF7E	papaya
			}
		},
		{
			type = "recipe",
			name = "ei-enriched-tin-ore-recrystallization",
			icons = EnrichingIndustry.make_smelting_icons("ei-sulfuric-tin-solution", "ei-enriched-tin-ore", true),
			localised_name = {"recipe-name.ei-enriched-tin-ore-recrystallization"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			order = tin_ore.order.."-f[recrystal]",
			factoriopedia_alternative = "ei-enriched-tin-ore",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 0.6,
			ingredients = {
				{type="fluid", name="ei-sulfuric-tin-solution", amount=10}
			},
			results = {
				{type="item", name="ei-enriched-tin-ore", amount=1, extra_count_fraction=ei_settings.ei_recry_bonus_direct},
				{type="fluid", name="water", amount=5, ignored_by_productivity=100},
			},
			main_product = "ei-enriched-tin-ore",
			crafting_machine_tint =
			{
				primary = {r = 0.93, g = 0.76, b = 0.58, a = 1.000}, --	#EDC393	light copper
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
			}
		},
		{
			type = "recipe",
			name = "ei-enriched-tin-smelting",
			icons = EnrichingIndustry.make_smelting_icons("ei-enriched-tin-ore", "tin-plate"),
			categories = {"smelting"},
			order = data.raw.recipe["tin-plate"].order.."-d[enriched]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			hide_from_player_crafting = ci_hide_player_crafting == true,
			energy_required = 3.2,
			ingredients = {{type="item", name="ei-enriched-tin-ore", amount=1}},
			results = {{type="item", name="tin-plate", amount=1}},
			main_product = "tin-plate",
		},
	}
	)

	-- Add secondary metal byproduct to recrystallization if sec. bonus > 0
	if ei_settings.ei_recry_byprod > 0 then
		frep.add_result("ei-enriched-tin-ore-recrystallization", {type="item", name="ei-enriched-copper-ore", amount=1, independent_probability=0.5*ei_settings.ei_recry_byprod})
		frep.add_result("ei-enriched-tin-ore-recrystallization", {type="item", name="ei-enriched-iron-ore", amount=1, independent_probability=0.5*ei_settings.ei_recry_byprod})
	end
	-- Add sulfur after secondary metal to recrystallization
	if ei_settings.ei_nonmetal_byproduct_sulfur_recrystall > 0 then
		frep.add_result("ei-enriched-tin-ore-recrystallization", EnrichingIndustry.make_washing_byproduct("sulfur", ei_settings.ei_nonmetal_byproduct_sulfur_recrystall), false)
	end

	frep.add_result("ei-tailing-slurry-reprocessing", {type="item", name="ei-enriched-tin-ore", amount=1, independent_probability=0.25})

	if mods["space-age"] then
		frep.replace_ingredient("molten-tin", "crushed-tin-ore", "ei-enriched-tin-ore")
		frep.scale_ingredient("molten-tin", "ei-enriched-tin-ore", {amount=4/3})
	end
end

if ci_ore_crushing and mods["bztitanium"] then
	local titanium_ore = data.raw.item["titanium-ore"]

	data:extend({
		{
			type = "item",
			name = "ei-enriched-titanium-ore",
			icon = "__enriching-industry__/graphics/icons/enriched-titanium-ore.png",
			icon_size = 64,
			pictures =
			{
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-titanium-ore.png",   scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-titanium-ore-1.png", scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-titanium-ore-2.png", scale = 0.5, mipmap_count = 1 },
				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-titanium-ore-3.png", scale = 0.5, mipmap_count = 1 }
			},
			subgroup = "raw-resource",
			order = titanium_ore.order.."-d[enriched]",
			hidden = not ci_ore_crushing,
			stack_size = 100,
			weight = 2 * kg
		},
		{
			type = "fluid",
			name = "ei-sulfuric-titanium-solution",
			icon = "__enriching-industry__/graphics/icons/sulfuric-titanium-solution.png",
			subgroup = "fluid",
			order = "a[fluid]-e[chemicals]-e[sulfuric-titanium-solution]",
			hidden = not ci_ore_crushing,
			auto_barrel = ci_ore_crushing,
			default_temperature = 25,
			max_temperature = 100,
			heat_capacity = "0.01kJ",
			base_color = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--neon blue	#67C8FF
			flow_color = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--light blue1	#BFEFFF
			visualization_color = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--light blue1	#BFEFFF
		}
	}
	)

	data:extend({
		{
			type = "recipe",
			name = "ei-enriched-titanium-ore",
			icons = EnrichingIndustry.make_washing_icons("crushed-titanium-ore"),
			localised_name = {"recipe-name.ei-enriched-titanium-ore"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			order = titanium_ore.order.."-d[enriched]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 1.2,
			ingredients = {
				{type="item", name="crushed-titanium-ore", amount=1},
				{type="fluid", name="water", amount=10}
			},
			results = {
				{type="item", name="ei-enriched-titanium-ore", amount=1, extra_count_fraction=ei_settings.ei_wash_bonus_direct},
				{type="fluid", name="ei-tailing-slurry", amount=10, ignored_by_productivity=1000},
				EnrichingIndustry.make_washing_byproduct("crushed-titanium-ore", ei_settings.ei_wash_bonus_primprec, 1, ei_settings.ei_productivity_precursor),
				EnrichingIndustry.make_washing_byproduct("titanium-ore", ei_settings.ei_wash_bonus_secoprec, 1, ei_settings.ei_productivity_precursor),
			},
			main_product = "ei-enriched-titanium-ore",
			crafting_machine_tint =
			{
				primary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
			}
		},
		{
			type = "recipe",
			name = "ei-sulfuric-titanium-leaching",
			localised_name = {"recipe-name.ei-sulfuric-titanium-leaching"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			subgroup = "raw-resource",--fluid-recipes",
			order = titanium_ore.order.."-e[leached]",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 1.2,
			ingredients = {
				{type="item", name="crushed-titanium-ore", amount=1},
				{type="fluid", name="water", amount=10},
				{type="fluid", name="sulfuric-acid", amount=ei_settings.ei_leach_sulfuric_acid}
			},
			results = {
				{type="fluid", name="ei-sulfuric-titanium-solution", amount=ei_settings.ei_leach_bonus_direct + 10},
				EnrichingIndustry.make_washing_byproduct("crushed-titanium-ore", ei_settings.ei_leach_bonus_primprec, 1, ei_settings.ei_productivity_precursor),
			},
			main_product = "ei-sulfuric-titanium-solution",
			crafting_machine_tint =
			{
				primary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 1.00, g = 1.00, b = 0.49, a = 1.000},--	#FFFF7E	papaya
			}
		},
		{
			type = "recipe",
			name = "ei-enriched-titanium-ore-recrystallization",
			icons = EnrichingIndustry.make_smelting_icons("ei-sulfuric-titanium-solution", "ei-enriched-titanium-ore", true),
			localised_name = {"recipe-name.ei-enriched-titanium-ore-recrystallization"},
			categories = mods["space-age"] and {"chemistry", "cryogenics"} or {"chemistry"},
			order = titanium_ore.order.."-f[recrystal]",
			factoriopedia_alternative = "ei-enriched-titanium-ore",
			enabled = false,
			allow_productivity = true,
			auto_recycle = false,
			energy_required = 0.6,
			ingredients = {
				{type="fluid", name="ei-sulfuric-titanium-solution", amount=10}
			},
			results = {
				{type="item", name="ei-enriched-titanium-ore", amount=1, extra_count_fraction=ei_settings.ei_recry_bonus_direct},
				{type="fluid", name="water", amount=5, ignored_by_productivity=100},
			},
			main_product = "ei-enriched-titanium-ore",
			crafting_machine_tint =
			{
				primary = {r = 0.93, g = 0.76, b = 0.58, a = 1.000}, --	#EDC393	light copper
				secondary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
				tertiary = {r = 0.75, g = 0.95, b = 1.00, a = 1.000},--	#BFEFFF	light blue1
				quaternary = {r = 0.40, g = 0.78, b = 1.00, a = 1.000},--	#67C8FF	neon blue
			}
		},
		
	}
	)

	
	if mods["space-age"] then
		-- modify titanium processing to be unique since crushing titanium is unique in SA
	else
		data:extend({
			{
				type = "recipe",
				name = "ei-enriched-titanium-smelting",
				icons = EnrichingIndustry.make_smelting_icons("ei-enriched-titanium-ore", "titanium-plate"),
				categories = {"smelting"},
				order = data.raw.recipe["titanium-plate"].order.."-d[enriched]",
				enabled = false,
				allow_productivity = true,
				auto_recycle = false,
				hide_from_player_crafting = ci_hide_player_crafting == true,
				energy_required = 3.2,
				ingredients = {{type="item", name="ei-enriched-titanium-ore", amount=1}},
				results = {{type="item", name="titanium-plate", amount=1}},
				main_product = "titanium-plate",
			},
		})
	end

	-- Add secondary metal byproduct to recrystallization if sec. bonus > 0
	if ei_settings.ei_recry_byprod > 0 then
		frep.add_result("ei-enriched-titanium-ore-recrystallization", {type="item", name="ei-enriched-iron-ore", amount=1, independent_probability=ei_settings.ei_recry_byprod})
	end
	-- Add sulfur after secondary metal to recrystallization
	if ei_settings.ei_nonmetal_byproduct_sulfur_recrystall > 0 then
		frep.add_result("ei-enriched-titanium-ore-recrystallization", EnrichingIndustry.make_washing_byproduct("sulfur", ei_settings.ei_nonmetal_byproduct_sulfur_recrystall), false)
	end

	frep.add_result("ei-tailing-slurry-reprocessing", {type="item", name="ei-enriched-titanium-ore", amount=1, independent_probability=0.125})
end

-- if ci_ore_crushing and mods["bzzirconium"] then
-- 	data:extend({
-- 		{
-- 			type = "item",
-- 			name = "ei-enriched-zircon-ore",
-- 			icon = "__enriching-industry__/graphics/icons/enriched-zircon-ore.png",
-- 			icon_size = 64,
-- 			pictures =
-- 			{
-- 				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-zircon-ore.png",   scale = 0.5, mipmap_count = 1 },
-- 				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-zircon-ore-1.png", scale = 0.5, mipmap_count = 1 },
-- 				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-zircon-ore-2.png", scale = 0.5, mipmap_count = 1 },
-- 				{ size = 64, filename = "__enriching-industry__/graphics/icons/enriched-zircon-ore-3.png", scale = 0.5, mipmap_count = 1 }
-- 			},
-- 			subgroup = "raw-resource",
-- 			order = "g-f[zircon-ore]-d[enriched]",
-- 			hidden = not ci_ore_crushing,
-- 			stack_size = 100,
-- 			weight = 2 * kg
-- 		}
-- 	})
-- end
