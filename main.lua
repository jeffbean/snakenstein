padding = 18
level = {
	gridSize = 15
}

direction = {
	up = 0,
	down = 1,
	right = 2,
	left = 3
}


function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)
	
	width = love.graphics.getWidth()
  	height = love.graphics.getHeight()

	-- This is the height and the width of the level.
	level.width = width - padding * 2    -- This makes the level as wide as the whole game window.
	level.height = height - padding * 2 -- This makes the level as tall as the whole game window.

	-- This is the coordinates where the level will be rendered.
	level.x = 0 + padding                               
	level.y = 0 + padding     

	player = {
		x = width / 2,
		y = height / 2,
		w = level.gridSize - 2,
		h = level.gridSize - 2, 
		speed = 100,
		color = { 255, 255, 255 },
		direction = direction.up,
		score = 0, 
	}

	treat = {
		x = width / 3,
		y = height / 3,
		w = 15,
		h = 15,
	}
end

-- Hello comment
function love.draw()
	-- level
	love.graphics.setColor(0, 0, 0) 
	love.graphics.rectangle('fill', level.x, level.y, level.width, level.height)

	-- treat 
	love.graphics.setColor(110, 110, 110) 
	love.graphics.rectangle('fill', treat.x, treat.y, treat.w, treat.h)

	-- player
	love.graphics.setColor(player.color)
	love.graphics.rectangle('fill', player.x, player.y, player.w, player.h)

	-- score screen
	love.graphics.print("Score: " .. player.score, padding+10, padding+10)

	-- debug prints
	love.graphics.print("player x: " .. player.x, padding*10, padding+10)
	love.graphics.print("level width: " .. level.width, padding*10, padding+40)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 2)
end

function love.focus(f) gameIsPaused = not f end
 
function love.update(dt)
	if gameIsPaused then return end
 
	-- In the case of snake we should be always moving in a direction and will change statefully with a key
	if love.keyboard.isDown('right') then
		-- This makes sure that the character doesn't go pass the game window's right edge.
		if player.direction ~= direction.left then 
			player.direction = direction.right
		end
	elseif love.keyboard.isDown('left') then
		-- This makes sure that the character doesn't go pass the game window's left edge.
		if player.direction ~= direction.right then 
			player.direction = direction.left
		end
	elseif love.keyboard.isDown('up') then
		if player.direction ~= direction.down then
			player.direction = direction.up
		end
	elseif love.keyboard.isDown('down') then
		if player.direction ~= direction.up then
			player.direction = direction.down
		end
	end

	if player.direction == direction.up then
		player.y = math.clamp(player.y - (player.speed * dt), level.y, level.height)
	elseif player.direction == direction.down then 
	    player.y = math.clamp(player.y + (player.speed * dt), level.y, level.height - player.w + padding)
	elseif player.direction == direction.right then 
		player.x = math.clamp(player.x + (player.speed * dt), level.x, level.width - player.w + padding)
	elseif player.direction == direction.left then
	    player.x = math.clamp(player.x - (player.speed * dt), level.x, level.width)
	end

	if CheckCollision(player, treat) then
		player.score = player.score + 1
		treat.x, treat.y = randPos()
	end
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function CheckCollision(box1, box2)
    if box1.x > box2.x + box2.w - 1 or -- Is box1 on the right side of box2?
       box1.y > box2.y + box2.h - 1 or -- Is box1 under box2?
       box2.x > box1.x + box1.w - 1 or -- Is box2 on the right side of box1?
       box2.y > box1.y + box1.h - 1    -- Is b2 under b1?
    then
        return false
    else
        return true
    end
end

function randPos()
	local x,y
	x = math.random(1, level.width)
	y = math.random(1, level.height)
	print("Random x"..x.." y"..y)
	return x,y
end