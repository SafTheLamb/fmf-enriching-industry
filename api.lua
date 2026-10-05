if not EnrichingIndustry then
	EnrichingIndustry = {
		FLAVOR_BYPRODUCT = 0.02,
		STANDARD_BYPRODUCT = 0.05,
		CRUSHED_BYPRODUCT = 0.0625,
		COMMON_BYPRODUCT = 0.15,
		FREQUENT_BYPRODUCT = 0.35
	}

	function EnrichingIndustry.make_washing_icons(item_name_or_path)
		local image_icon, item
		item = data.raw.item[item_name_or_path]
		if item then
			if item.icons then
				local icons = table.deepcopy(item.icons)
				icons[#icons + 1] = {icon="__enriching-industry__/graphics/icons/generic-washing.png"}
				return icons
			else
				image_icon = item.icon
			end
		else
			image_icon = item_name_or_path
		end
		return {
			{icon=image_icon, icon_size=(item and item.icon_size) or 64, shift={0, 3}, scale=0.4},
			{icon="__enriching-industry__/graphics/icons/generic-washing.png"}
		}
	end

	function EnrichingIndustry.make_smelting_icons(item_name_or_path_ingredient, item_name_or_path_product, ingredient_is_fluid, product_is_fluid)
		local image_icon_ingredient, item_ingredient
		if ingredient_is_fluid then
			item_ingredient = data.raw.fluid[item_name_or_path_ingredient]
		else
			item_ingredient = data.raw.item[item_name_or_path_ingredient]
		end
		if item_ingredient then
-- 			if item_ingredient.icons then
-- 				local icons = table.deepcopy(item_ingredient.icons)
-- 				icons[#icons + 1] = {icon="__enriching-industry__/graphics/icons/generic-washing.png"}
-- 				return icons
-- 			else
				image_icon_ingredient = item_ingredient.icon
--			end
		else
			image_icon_ingredient = item_name_or_path_ingredient
		end
		local image_icon_product, item_product
		local icon_product_size = 64
		if product_is_fluid then
			item_product = data.raw.fluid[item_name_or_path_product]
		else
			item_product = data.raw.item[item_name_or_path_product]
		end
		if item_product then
-- 			if item_product.icons then
-- 				local icons = table.deepcopy(item_product.icons)
-- 				icons[#icons + 1] = {icon="__enriching-industry__/graphics/icons/generic-washing.png"}
-- 				return icons
-- 			else
				image_icon_product = item_product.icon
				icon_product_size = item_product.icon_size or 64
--			end
		else
			image_icon_product = item_name_or_path_product
		end
		return {
			{icon=image_icon_ingredient, shift={-12, -12}, scale=0.4},
			{icon=image_icon_product, draw_background=true, icon_size=icon_product_size, scale=32/icon_product_size}
		}
	end

	function EnrichingIndustry.make_washing_byproduct(item_name, probability, amount, allow_productivity)
		probability = probability or EnrichingIndustry.STANDARD_BYPRODUCT
		if probability > 0 then
			amount = amount or 1
			return {
				type = "item",
				name = item_name,
				amount = amount,
				independent_probability = probability,
				ignored_by_stats = not allow_productivity and amount or nil,
				ignored_by_productivity = not allow_productivity and amount or nil,
				show_details_in_recipe_tooltip = false
			}
		end
	end
end
