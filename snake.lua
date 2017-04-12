Class = require "vendor.hump.class"

local Player = Class{}

local GRID_SIZE = 10
local direction = {
	up = 0,
	down = 1,
	right = 2,
	left = 3
}

function Player:init(x, y, color)
	-- TODO: not default to direction right since many players willl start different places
    self.direction = direction.right
	self.x = x
	self.y = y
	self.color = color
    self.score = 0

	self.entities.body = {}
	
	-- -- for the many parts of the snake, start with 3 units
	-- for i=1, self.score+3, 1 do
		-- print("Putting snake" .. i .. " at position x" .. self.x .. " y" .. self.y)
		-- table.insert(self.entities.body, Player(self.x + GRID_SIZE * i, self.y + GRID_SIZE * i))
	-- end
end

function Player:draw()
    love.graphics.setColor(self.color) 
	-- draw the head thing
	love.graphics.rectangle("fill", self.x, self.y, GRID_SIZE, GRID_SIZE)
    for _,o ipair(self.entities.body) do
        love.graphics.rectangle("fill", o.x, o.y, GRID_SIZE, GRID_SIZE)
    end
end

function eatPellet(pellet)
	print("Snake ate "..pellet)
	grid[tiles[pellet].x][tiles[pellet].y] = ""
	pellets[pellet] = nil
	print("Putting snake"..snakeLen + 1 .." at position x"..tiles["snake"..snakeLen].x.." y"..tiles["snake"..snakeLen].y)
	tiles["snake"..snakeLen+1] = {color="green",x=tiles["snake"..snakeLen].x,y=tiles["snake"..snakeLen].y}
	snakeLen = snakeLen + 1
	score = score + 1
end