local HUD = {}

hud_scene = Scene(Scene.SCENE_2D)

hud_items = {}

heightLabel = SceneLabel("Box Count:", 50)
	heightLabel:setPosition(-500, 360)
		hud:addChild(heightLabel)

function HUD.addItem(item_name, default_text, size, x_pos, y_pos)
	local item = SceneLabel(default_text, size)
	item:setPosition(x_pos, y_pos)

	hud_items[item_name] = item
	return item
end

return HUD