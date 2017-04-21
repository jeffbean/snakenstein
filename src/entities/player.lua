Class = require "vendor.hump.class"

local Player = Class{}

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
	self.w = GRID_SIZE
	self.h = GRID_SIZE

	self.speed = 40
	self.color = color
    self.score = 0
	
	-- thesemove the char from the update but we only want to move what looks to be on a grid.
	self.phantom_x = self.x
	self.phantom_y = self.y

	-- -- for the many parts of the snake, start with 3 units
	self.body = {}
	for i=1, self.score+3, 1 do
		print("Putting snake" .. i .. " at position x" .. self.x .. " y" .. self.y)
		table.insert(self.body, {x=self.x- (GRID_SIZE * i), y=self.y })
	end
end

function Player:draw()
    love.graphics.setColor(self.color) 
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor({140,255,10}) 
	for _, o in ipairs(self.body) do
		love.graphics.rectangle("fill", o.x, o.y, GRID_SIZE, GRID_SIZE)
	end
end

function Player:update(dt)
	oldPX, oldPY = self.phantom_x, self.phantom_y
	oldModPX = oldPX % GRID_SIZE
	oldModPY = oldPY % GRID_SIZE

	-- FIXME: Need to have a queued up direction since right now you can trick it to move backwards during one mod cycle on the grid

	if love.keyboard.isDown('right') then
		self.phantom_y = self.phantom_y - oldModPY
		
		if self.direction ~= direction.left then 
			self.direction = direction.right
		end
	elseif love.keyboard.isDown('left') then
		self.phantom_y = self.phantom_y - oldModPY

		if self.direction ~= direction.right then 
			self.direction = direction.left
		end
	elseif love.keyboard.isDown('up') then
		self.phantom_x = self.phantom_x - oldModPX

		if self.direction ~= direction.down then
			self.direction = direction.up
		end
	elseif love.keyboard.isDown('down') then
		self.phantom_x = self.phantom_x - oldModPX

		if self.direction ~= direction.up then
			self.direction = direction.down
		end
	end

	if self.direction == direction.up then
		self.phantom_y = math.clamp(self.phantom_y - (self.speed * dt), GRID_SIZE, height)
		modPY = self.phantom_y % GRID_SIZE
		if oldModPY < modPY then
			self.y = self.phantom_y - modPY
		end
	elseif self.direction == direction.down then 
	    self.phantom_y = math.clamp(self.phantom_y + (self.speed * dt), GRID_SIZE, height - GRID_SIZE*2)
		modPY = self.phantom_y % GRID_SIZE
		if oldModPY > modPY then 
			self.y = self.phantom_y - modPY
		end
	elseif self.direction == direction.right then 
		self.phantom_x = math.clamp(self.phantom_x + (self.speed * dt), GRID_SIZE, width - GRID_SIZE*2)
		modPX = self.phantom_x % GRID_SIZE
		if oldModPX > modPX then 
			self.x = self.phantom_x - modPX
		end
	elseif self.direction == direction.left then
	    self.phantom_x = math.clamp(self.phantom_x - (self.speed * dt), GRID_SIZE, width)
		modPX = self.phantom_x % GRID_SIZE
		if oldModPX < modPX then 
			self.x = self.phantom_x - modPX
		end
	end
	if CheckCollisionBox(self, objects.entities.treat) then
		self.score = self.score + 1
		objects.entities.treat.x, objects.entities.treat.y = randPos()
	end
	-- print("player..         .. x:[", self.x, "]", ".. y:[", self.y, "]")
	-- print("phantom player  .. px:[", self.phantom_x, "]", ".. py:[", self.phantom_y, "]", " modX: ", modX)


end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function CheckCollisionBox(box1, box2)
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
function CheckCollision(box, entities)
	for _,o in ipairs(entities) do
		if CheckCollisionBox(box, o) then
			print("coliding with object.. ", o)
			for k,v in pairs(o) do
				print(k,v)
			end
			return true
		end
	end
	return false
end

function randPos()
	numberX = love.math.random( GRID_SIZE, width - GRID_SIZE ) 
	numberY  = love.math.random( GRID_SIZE, height - GRID_SIZE )
	modX, modY = numberX % GRID_SIZE, numberY % GRID_SIZE
	
	return numberX - modX, numberY - modY
end

return Player