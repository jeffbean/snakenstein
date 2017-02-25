padding = 15
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
	love.graphics.setBackgroundColor(0, 0, 0)
	
	width = love.graphics.getWidth()
  	height = love.graphics.getHeight()

	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  	world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0
	
	objects = {} -- table to hold all our physical objects
 
	--let's create the ground
	objects.walls = {}
	objects.walls.body = love.physics.newBody(world, 0, 0) 
	objects.walls.wall = {}
	
	objects.walls.left = love.physics.newRectangleShape(0, 0, 15, height*2) 
	objects.walls.top = love.physics.newRectangleShape(0, 0, width*2, 15) 
	objects.walls.right = love.physics.newRectangleShape(width, 0, 15, height*2) 
	objects.walls.bottom = love.physics.newRectangleShape(0, height, width*2, 15) 
	
	love.physics.newFixture(objects.walls.body, objects.walls.left) 
	love.physics.newFixture(objects.walls.body, objects.walls.right)
	love.physics.newFixture(objects.walls.body, objects.walls.top)
	love.physics.newFixture(objects.walls.body, objects.walls.bottom) 

	--let's create a player
	objects.player = {}
	objects.player.body = love.physics.newBody(world, width/2, height/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	
	objects.player.shape = love.physics.newCircleShape(20)
	objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1) -- Attach fixture to body and give it a density of 1.
	objects.player.fixture:setRestitution(0.9) --let the player bounce

	objects.player.body2 = love.physics.newBody(world, width/2, height/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	
	objects.player.shape2 = love.physics.newCircleShape(15)
	objects.player.fixture2 = love.physics.newFixture(objects.player.body2, objects.player.shape2, 1) -- Attach fixture to body and give it a density of 1.
	objects.player.fixture2:setRestitution(0.9) --let the player bounce


	joint = love.physics.newRevoluteJoint( objects.player.body, objects.player.body2, 0, 0, 10, 10, true, 5 )

	-- This is the coordinates where the level will be rendered.
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
	love.graphics.setColor(0, 0, 100) 
  	love.graphics.polygon("fill", objects.walls.body:getWorldPoints(objects.walls.left:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
	love.graphics.setColor(0, 0, 255) 
	love.graphics.polygon("fill", objects.walls.body:getWorldPoints(objects.walls.right:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
	love.graphics.setColor(0, 100, 100) 
  	love.graphics.polygon("fill", objects.walls.body:getWorldPoints(objects.walls.top:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
	love.graphics.setColor(100, 0, 100) 
  	love.graphics.polygon("fill", objects.walls.body:getWorldPoints(objects.walls.bottom:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
	
	
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the player
	-- for _, shape in ipairs(objects.player.shapes) do 
  		love.graphics.circle("fill", objects.player.body:getX(), objects.player.body:getY(), objects.player.shape:getRadius())
	-- end
	love.graphics.setColor(163, 27, 10) 
	love.graphics.circle("fill", objects.player.body2:getX(), objects.player.body2:getY(), objects.player.shape2:getRadius())


	-- treat 
	love.graphics.setColor(110, 110, 110) 
	love.graphics.rectangle('fill', treat.x, treat.y, treat.w, treat.h)

	-- debug prints
	love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 2)
end

function love.focus(f) gameIsPaused = not f end
 
function love.update(dt)
	if gameIsPaused then return end
	
	world:update(dt)

	if love.keyboard.isDown('right') then
		objects.player.body:applyForce(400, 0)
	elseif love.keyboard.isDown('left') then
	    objects.player.body:applyForce(-400, 0)
	elseif love.keyboard.isDown('up') then
		objects.player.body:applyForce(0, -400)
	elseif love.keyboard.isDown('down') then
		objects.player.body:applyForce(0, 200)
	end

	-- if CheckCollision(objects.player, treat) then
	-- 	player.score = player.score + 1
	-- 	treat.x, treat.y = randPos()
	-- 	objects.player.shapes[score] = love.physics.newCircleShape(20)
	-- end
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