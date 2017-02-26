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
Player = require "src.entities.player"
Treat = require "src.entities.treat"

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

	-- let's create a player
	objects.player = Player(world, width/2, height/2, {193, 47, 14})
	-- make a treat to start
	objects.treat = Treat(world, width / 3,  height / 3, 15, 15, {110, 110, 110})
end

-- Hello comment
function love.draw()
	-- walls
	for _,wall in ipairs(objects.walls) do
		wall:draw()
	end
	-- player draw	
	objects.player:draw()
	-- treat 
	objects.treat:draw()

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

	objects.player:update(dt)
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

