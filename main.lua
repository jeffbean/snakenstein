
Player = require "src.entities.player"
Wall = require "src.entities.wall"
Treat = require "src.entities.treat"

function love.load()
	love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  	world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0
	--These callback function names can be almost any you want:
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	-- if love.graphics.setMode(screenW, screenH) == false then love.event.quit() end
	width = love.graphics.getWidth()
  	height = love.graphics.getHeight()

	objects = {}
	objects.entities = {}
	objects.entities.players = {}
	objects.entities.walls = {}
	objects.entities.treat = Treat(60, 60 , GRID_SIZE, GRID_SIZE,{200,255,200} )

	table.insert(objects.entities.players, Player(GRID_SIZE*4, GRID_SIZE, {100,255,100}))
	
	wallPoints = {}
	table.insert(wallPoints, {0, 0, GRID_SIZE, height*2})-- left
	table.insert(wallPoints, {0, 0, width*2, GRID_SIZE}) -- top
	table.insert(wallPoints, {width-GRID_SIZE, 0, GRID_SIZE, height*2}) -- right
	table.insert(wallPoints, {0, height-GRID_SIZE, width*2, GRID_SIZE}) -- bottom

	color = {0, 0, 255}
	for i,point in ipairs(wallPoints) do
		table.insert(objects.entities.walls, Wall(point, color))
	end

end

function love.update(dt)
	if gameIsPaused then return end
	
	world:update(dt)

	for _,o in ipairs(objects.entities.walls) do
		o:update(dt)
	end	
	for _,o in ipairs(objects.entities.players) do
		o:update(dt)
	end	
	objects.entities.treat:update(dt)
end

function love.focus(f) gameIsPaused = not f end

function love.draw()
	for _,o in ipairs(objects.entities.walls) do
		o:draw()
	end
	for _,o in ipairs(objects.entities.players) do
		o:draw()
	end

	objects.entities.treat:draw()

	-- love.graphics.print("Score: " .. objects.entities.players[0].score, GRID_SIZE, 20)
	love.graphics.print("FPS: " .. love.timer.getFPS(), GRID_SIZE, 2)
end

