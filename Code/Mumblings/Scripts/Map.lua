local Map = {}

function Map.newMap()
	scene = Scene(Scene.SCENE_3D)

	return scene
end

function Map.newTile(position, size, map, texture)
	if (size == nil) then size = { 1, 1, 1 } end

	tile = ScenePrimitive(ScenePrimitive.TYPE_BOX, size[1]*20, size[2]*20, size[3]*20)
	tile:setPosition(position[1]*20, position[2]*20, position[3]*20)
	
	if (map ~= nil)     then map:addChild(tile)        end
	if (texture ~= nil) then tile:loadTexture(texture) end

	return tile
end

function setTexture(tile, texturePath)
	return tile:loadTexture(texturePath)
end

return Map