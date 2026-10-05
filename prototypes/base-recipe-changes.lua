local frep = require("__fdsl__.lib.recipe")
local ei_settings = require ("ei-settings")

-- Crushing Industry Mod Settings
local ci_glass = settings.startup["crushing-industry-glass"].value
local ci_ore_crushing = settings.startup["crushing-industry-ore"].value
local ci_byproducts = settings.startup["crushing-industry-byproducts"].value
local ci_coal_crushing = settings.startup["crushing-industry-coal"].value

-- Stone crushing byproduct overwrite
--if ci_glass then
	if ei_settings.ei_ci_overwrite then
		frep.remove_result("sand", "stone")
		if ei_settings.ei_stone_crush_bonus_precursor > 0 then
			frep.add_result("sand", EnrichingIndustry.make_washing_byproduct("stone", ei_settings.ei_crush_bonus_precursor, 1, ei_settings.ei_productivity_precursor))
		end
	end
--end

-- Quartz
--if mods["aai-industry"] then
	if mods["space-age"] then
		frep.replace_ingredient("holmium-solution", "sand", {type="item", name="ei-quartz", amount=3})
		frep.replace_ingredient("electrolyte", "sand", {type="item", name="ei-quartz", amount=4})
		if ci_glass then
			frep.replace_ingredient("molten-glass", "sand", {type="item", name="ei-quartz", amount=100})
		end
	end
--end

-- Ore Refining
if ci_ore_crushing then
	if ei_settings.ei_ci_overwrite then
		-- Modify CI's crushing bonus if enabled
		frep.modify_result("crushed-iron-ore", "crushed-iron-ore", {extra_count_fraction=ei_settings.ei_crush_bonus_direct})
		frep.modify_result("crushed-copper-ore", "crushed-copper-ore", {extra_count_fraction=ei_settings.ei_crush_bonus_direct})
		frep.remove_result("crushed-iron-ore", "iron-ore")
		frep.remove_result("crushed-copper-ore", "copper-ore")
		if ei_settings.ei_crush_bonus_precursor > 0 then
			frep.add_result("crushed-iron-ore", EnrichingIndustry.make_washing_byproduct("iron-ore", ei_settings.ei_crush_bonus_precursor, 1, ei_settings.ei_productivity_precursor), true, 2)
			frep.add_result("crushed-copper-ore", EnrichingIndustry.make_washing_byproduct("copper-ore", ei_settings.ei_crush_bonus_precursor, 1, ei_settings.ei_productivity_precursor), true, 2)
		end
		if ci_byproducts then
			frep.remove_result("crushed-iron-ore", "sand")
			frep.remove_result("crushed-copper-ore", "sand")
			if ei_settings.ei_crush_byprod_sand > 0 then
				frep.add_result("crushed-iron-ore", EnrichingIndustry.make_washing_byproduct("sand", ei_settings.ei_crush_byprod_sand), true, 3)
				frep.add_result("crushed-copper-ore", EnrichingIndustry.make_washing_byproduct("sand", ei_settings.ei_crush_byprod_sand), true, 3)
			end
		end
	end
-- Add secondary metal byproduct to recrystallization if sec. bonus > 0
	if ei_settings.ei_recry_byprod > 0 then
		frep.add_result("ei-enriched-iron-ore-recrystallization", {type="item", name="ei-enriched-copper-ore", amount=1, independent_probability=ei_settings.ei_recry_byprod})
		frep.add_result("ei-enriched-copper-ore-recrystallization", {type="item", name="ei-enriched-iron-ore", amount=1, independent_probability=ei_settings.ei_recry_byprod})
	end
-- Add sulfur after secondary metal to recrystallization
	if ei_settings.ei_nonmetal_byproduct_sulfur_recrystall > 0 then
		frep.add_result("ei-enriched-iron-ore-recrystallization", EnrichingIndustry.make_washing_byproduct("sulfur", ei_settings.ei_nonmetal_byproduct_sulfur_recrystall), false)
		frep.add_result("ei-enriched-copper-ore-recrystallization", EnrichingIndustry.make_washing_byproduct("sulfur", ei_settings.ei_nonmetal_byproduct_sulfur_recrystall), false)
	end
-- Add byproducts if enabled
	if ci_byproducts then
	-- Sulfuric leaching byproducts: Sand & Stone
		if ei_settings.ei_nonmetal_byproduct_sand > 0 then
			frep.add_result("ei-sulfuric-iron-leaching", EnrichingIndustry.make_washing_byproduct("sand", ei_settings.ei_nonmetal_byproduct_sand), false)
			frep.add_result("ei-sulfuric-copper-leaching", EnrichingIndustry.make_washing_byproduct("sand", ei_settings.ei_nonmetal_byproduct_sand), false)
		end
		if ei_settings.ei_nonmetal_byproduct_stone > 0 then
			frep.add_result("ei-sulfuric-iron-leaching", EnrichingIndustry.make_washing_byproduct("stone", ei_settings.ei_nonmetal_byproduct_stone), false)
			frep.add_result("ei-sulfuric-copper-leaching", EnrichingIndustry.make_washing_byproduct("stone", ei_settings.ei_nonmetal_byproduct_stone), false)
		end
	end
	if mods["space-age"] then
		frep.replace_ingredient("tungsten-plate", "crushed-tungsten-ore", "ei-enriched-tungsten-ore")
	--	frep.scale_ingredient("tungsten-plate", "ei-enriched-tungsten-ore", {amount=1.5})
		frep.replace_ingredient("iron-ore-melting", "crushed-iron-ore", "ei-enriched-iron-ore")
		frep.scale_ingredient("iron-ore-melting", "ei-enriched-iron-ore", {amount=4/3})
		frep.replace_ingredient("copper-ore-melting", "crushed-copper-ore", "ei-enriched-copper-ore")
		frep.scale_ingredient("copper-ore-melting", "ei-enriched-copper-ore", {amount=4/3})
		frep.modify_ingredient("holmium-plate", "holmium-solution", {type="item", name="ei-enriched-holmium", amount=1})
		if ci_byproducts then
			frep.add_result("ei-enriched-tungsten-ore", EnrichingIndustry.make_washing_byproduct(ci_coal_crushing and "crushed-coal" or "coal", EnrichingIndustry.FLAVOR_BYPRODUCT), false)
		end
	end
end

-- Tailing slurry: Non-metal by-products
if ci_byproducts then
	if ci_ore_crushing then
		if ei_settings.ei_nonmetal_byproduct_sand > 0 then
			frep.add_result("ei-tailing-slurry-reprocessing", EnrichingIndustry.make_washing_byproduct("sand", ei_settings.ei_nonmetal_byproduct_sand * 10), false)
		end
		if ei_settings.ei_nonmetal_byproduct_stone > 0 then
			frep.add_result("ei-tailing-slurry-reprocessing", EnrichingIndustry.make_washing_byproduct("stone", ei_settings.ei_nonmetal_byproduct_stone * 10), false)
		end
		if ei_settings.ei_nonmetal_byproduct_sulfur_tailrepr > 0 then
			-- R: Add Sulfur if enabled
			frep.add_result("ei-tailing-slurry-reprocessing", EnrichingIndustry.make_washing_byproduct("sulfur", ei_settings.ei_nonmetal_byproduct_sulfur_tailrepr), false)
		end
	end
	if ei_settings.ei_quartz_enabled or ci_ore_crushing then
	-- Tailing slurry filtering and reprocessing byproducts: Sand, Stone & Sulfur
		if ei_settings.ei_nonmetal_byproduct_sand > 0 then
			-- F&R: Add Sand if primary byprod. enabled
			frep.add_result("ei-tailing-slurry-filtering", EnrichingIndustry.make_washing_byproduct("sand", ei_settings.ei_nonmetal_byproduct_sand * 10), false)
		end
		if ei_settings.ei_nonmetal_byproduct_stone > 0 then
			-- F&R: Add Stone if secondary byprod. enabled
			frep.add_result("ei-tailing-slurry-filtering", EnrichingIndustry.make_washing_byproduct("stone", ei_settings.ei_nonmetal_byproduct_stone * 10), false)
		end
		if ei_settings.ei_nonmetal_byproduct_sulfur_tailfilt > 0 then
			-- F: Add Sulfur if enabled
			frep.add_result("ei-tailing-slurry-filtering", EnrichingIndustry.make_washing_byproduct("sulfur", ei_settings.ei_nonmetal_byproduct_sulfur_tailfilt), false)
		end
	end
end
