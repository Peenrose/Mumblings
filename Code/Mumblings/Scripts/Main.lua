Map = require "Scripts/Map"

--HUD = require "Scripts/HUD"
--Menu = require "Scripts/Menu"

scene = Scene(Scene.SCENE_3D)
hud = Scene(Scene.SCENE_2D)

heightLabel = SceneLabel("Box Count:", 50)
	heightLabel:setPosition(-500, 360)
		hud:addChild(heightLabel)
--heightLabel:setAnchorPoint(-1.0, 1.0, 0.0)

box_count = SceneLabel("0", 50)
	box_count:setPosition(-580, 300)
		hud:addChild(box_count)

camera = scene:getDefaultCamera()
	camera:setPosition(400, 400, 400)
	camera:lookAt(Vector3(0,0,0), Vector3(0, 1, 0))

boxes = {}
for i = -10, 10 do
	boxes[i] = {}
end

function count_boxes()
	local ct = 0
	for x = -10, 10 do
		for z = -10, 10 do
			if (boxes[x][z] ~= nil) then
				ct = ct + 1
			end
		end
	end

	return ct
end

function rand_y()
	local rand = math.random()
	if (rand < (1/3)) then
		return -1
	elseif (rand < (2/3)) then
		return 0
	elseif (rand < (1)) then
		return 1
	end
	return 0
end

function floor_gen()
	while (count_boxes() < 400) do
		boxed = false
		for x = -10, 10 do
			for z = -10, 10 do
				if (boxes[x][z] == nil) then
					if (math.random() < 0.25 and count_boxes() < 400 and boxed == false) then
						boxed = true

						box = Map.newTile({x, rand_y(), z}, nil, scene, "Resources/green_texture.png")
						boxes[x][z] = box
						box_count:setText(""..count_boxes())
					end
				end
				coroutine.yield()
			end
		end
	end
end
floor_gen = coroutine.create(floor_gen)

moving = {}
for i = -10, 10 do
	moving[i] = {}
end

function move_box()
	for x = -10, 10 do
		for z = -10, 10 do
			if (boxes[x][z] ~= nil and moving[x][z] == nil and boxes[x][z]:getPosition() ~= nil) then
				if (math.random() < 0.001) then
					local new_y = math.random(-1, 1)*20
					if (y ~= new_y) then
						moving[x][z] = {
							start_pos = Vector3(x*20, 0, z*20),
							end_pos = Vector3(x*20, new_y, z*20), 
							speed = 10
						}
						setTexture(boxes[x][z], "Resources/pink_texture.png")
					end
				end
			end
		end
	end
end 

function update_moving(dt)
	for x = -10, 10 do
		for z = -10, 10 do
			if (moving[x][z] ~= nil) then
				local box = boxes[x][z]

				--local start_y = moving[x][z].start_pos.y
				local current_y = box:getPosition().y
				local target_y = moving[x][z].end_pos.y

				local speed = moving[x][z].speed

				local movement_this_frame = speed*dt

				down = false
				if (current_y > target_y) then
					movement_this_frame = -movement_this_frame
					down = true
				end

				done = false
				if (down == true and current_y+movement_this_frame < target_y) then
					done = true
				elseif (down == false and current_y+movement_this_frame > target_y) then
					done = true
				end

				if (done == true) then
					box:setPosition(x*20, target_y, z*20)
					setTexture(boxes[x][z], "Resources/green_texture.png")
					moving[x][z] = nil
				end

				box:setPosition(x*20, current_y+movement_this_frame, z*20)

			end
		end
	end
end

floor_gen_timer = 0
camera_angle_timer = 0
runtime = 0

function Loop(dt)

	floor_gen_timer = floor_gen_timer + dt
	camera_angle_timer = camera_angle_timer + dt
	runtime = runtime + dt

	for i = 1, math.random(1, 25) do
		coroutine.resume(floor_gen)
	end
	move_box()
	update_moving(dt)
	--local x = (math.sin(camera_angle_timer-10)*5)+450
	local y = (math.sin(camera_angle_timer-10)*10)+350
	--local z = (math.cos(camera_angle_timer-10)*25)+450

	local x = 600 * cos(runtime / 200 * (2 * math.pi))
	local z = 600 * sin(runtime / 200 * (2 * math.pi))

	camera:setPosition(x, y, z)
	camera:lookAt(Vector3(0,0,0), Vector3(0, 1, 0))

end

function Update(dt)
	-- skip frames while dragging window or running below 45 fps
	if (dt < (1/45)) then
		Loop(dt)
	end
end