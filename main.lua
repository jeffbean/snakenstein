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

Wall = require "src.entities.wall"

function love.load()
	love.graphics.setBackgroundColor(0, 0, 0)
	
	width = love.graphics.getWidth()
  	height = love.graphics.getHeight()
	print("getHeight: " .. height)
	print("getWidth: " .. width)

	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  	world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0
	    --These callback function names can be almost any you want:
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
    persisting = 0    

	objects = {} -- table to hold all our physical objects
 
	--let's create the ground
	objects.walls = {}
	wallPoints = {}

	table.insert(wallPoints, {0, 0, 15, height*2})-- left
	table.insert(wallPoints, {0, 0, width*2, 15}) -- top
	table.insert(wallPoints, {width/2, 0, 15, height*2}) -- right
	table.insert(wallPoints, {0, height/2, width*2, 15}) -- bottom

	color = {0, 0, 255}
	for i,point in ipairs(wallPoints) do
		table.insert(objects.walls, Wall(world, point, color))
	end

	--let's create a player
	objects.player = {}
	objects.player.score = 0
	objects.player.body = love.physics.newBody(world, width/2, height/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	
	objects.player.shape = love.physics.newCircleShape(20)
	objects.player.fixture = love.physics.newFixture(objects.player.body, objects.player.shape, 1) -- Attach fixture to body and give it a density of 1.
	objects.player.fixture:setUserData("Player")
	objects.player.fixture:setRestitution(0.1) --let the player bounce
	objects.player.fixture:setFriction(0.9)

	-- This is the coordinates where the level will be rendered.
	treat = {
		x = width / 3,
		y = height / 3,
		w = 15,
		h = 15,
	}
	-- treats 
	objects.treat = {}
	objects.treat.body = love.physics.newBody(world, treat.x, treat.y, "static") 

	objects.treat.shape = love.physics.newRectangleShape(treat.w, treat.h)
	objects.treat.fixture = love.physics.newFixture(objects.treat.body, objects.treat.shape, 1)
	objects.treat.fixture:setUserData("Treat")
end

-- Hello comment
function love.draw()
	-- walls
	for _,wall in ipairs(objects.walls) do
		wall:draw()
	end
	 -- draw a "filled in" polygon using the ground's coordinates
	
	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the player
	-- for _, shape in ipairs(objects.player.shapes) do 
  		love.graphics.circle("fill", objects.player.body:getX(), objects.player.body:getY(), objects.player.shape:getRadius())
	-- end

	-- treat 
	love.graphics.setColor(110, 110, 110) 
	love.graphics.polygon('fill', objects.treat.body:getWorldPoints(objects.treat.shape:getPoints()))

	-- debug prints
	love.graphics.print("Score: " .. objects.player.score, 15, 20)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 15, 2)
end

function love.focus(f) gameIsPaused = not f end
 
function love.update(dt)
	if gameIsPaused then return end
	if objects.treat.isFlagged then
		x, y = randPos()
		objects.treat.body:setPosition(x, y)
		objects.treat.isFlagged = false
	end
	world:update(dt)

	

	if love.keyboard.isDown('right') then
		objects.player.body:applyForce(200, 0)
	end
	if love.keyboard.isDown('left') then
	    objects.player.body:applyForce(-200, 0)
	end
	if love.keyboard.isDown('up') then
		objects.player.body:applyForce(0, -200)
	end
	if love.keyboard.isDown('down') then
		objects.player.body:applyForce(0, 200)
	end
end

function beginContact(a, b, coll)
    x,y = coll:getNormal()
	if a:getUserData() == "Treat"  or b:getUserData() == "Treat" then
		objects.player.score = objects.player.score + 1
		objects.treat.isFlagged = true
	end
	-- print(objects.player.score)
    -- print(a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y)
end
 
 
function endContact(a, b, coll)
    -- persisting = 0    -- reset since they're no longer touching
    -- print(a:getUserData().." uncolliding with "..b:getUserData())
end
 
function preSolve(a, b, coll)
    -- if persisting == 0 then    -- only say when they first start touching
    --     print(a:getUserData().." touching "..b:getUserData())
    -- elseif persisting < 20 then    -- then just start counting
    --     print(" "..persisting)
    -- end
    -- persisting = persisting + 1    -- keep track of how many updates they've been touching for
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
-- we won't do anything with this function
end


function randPos()
	local x,y
	x = math.random(1, width)
	y = math.random(1, height)
	print("Random x"..x.." y"..y)
	return x,y
end

