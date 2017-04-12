
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

	table.insert(objects.entities, Player(15, 15, {100,255,100}))
	
	wallPoints = {}
	table.insert(wallPoints, {0, 0, 15, height*2})-- left
	table.insert(wallPoints, {0, 0, width*2, 15}) -- top
	table.insert(wallPoints, {width/2, 0, 15, height*2}) -- right
	table.insert(wallPoints, {0, height/2, width*2, 15}) -- bottom

	color = {0, 0, 255}
	for i,point in ipairs(wallPoints) do
		table.insert(objects.entities, Wall(world, point, color))
	end

end

function love.update(dt)
	if gameIsPaused then return end
	
	world:update(dt)

	for _,o in ipairs(objects.entities) do
		o:update(dt)
	end	
end

function love.focus(f) gameIsPaused = not f end

function love.draw()
	for _,o in ipairs(objects.entities) do
		o:draw()
	end
		-- debug prints
	-- love.graphics.print("Score: " .. objects.entities.players[0].score, 15, 20)
	love.graphics.print("FPS: " .. love.timer.getFPS(), 15, 2)
end
