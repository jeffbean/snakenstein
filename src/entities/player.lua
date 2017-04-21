Class = require "vendor.hump.class"

local Player = Class{}

local direction = {
	up = 0,
	down = 1,
	right = 2,
	left = 3
}
BODY_TRIM = 3

function Player:init(x, y, color)
	-- TODO: not default to direction right since many players willl start different places
    self.direction = direction.right
	self.x = x
	self.y = y
	self.w = GRID_SIZE
	self.h = GRID_SIZE

	self.speed = 20
	self.color = color
    self.score = 0
	
	-- thesemove the char from the update but we only want to move what looks to be on a grid.
	self.phantom_x = self.x
	self.phantom_y = self.y

	-- -- for the many parts of the snake, start with 3 units
	self.body = {}
	table.insert(self.body, {name="head", x=self.x, y=self.y})
	for i=1, self.score+3, 1 do
		print("Putting snake" .. i .. " at position x" .. self.x .. " y" .. self.y)
		table.insert(self.body, {name=i, x=self.x- (GRID_SIZE * i), y=self.y })
	end
end

function Player:draw()
    love.graphics.setColor(self.color) 
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	for i, o in ipairs(self.body) do
		if i ~= 1 then
			love.graphics.setColor({255, 140,10}) 
			love.graphics.rectangle("fill", o.x+BODY_TRIM, o.y+BODY_TRIM, GRID_SIZE-(BODY_TRIM*2), GRID_SIZE-(BODY_TRIM*2))
			
			love.graphics.setColor(0, 0, 255, 255)		
			love.graphics.print(i, o.x+BODY_TRIM, o.y+BODY_TRIM)
		end
	end
end

function Player:update(dt)
	oldX, oldY = self.x, self.y
	oldPX, oldPY = self.phantom_x, self.phantom_y
	oldModPX = oldPX % GRID_SIZE
	oldModPY = oldPY % GRID_SIZE

	-- FIXME: Need to have a queued up direction since right now you can trick it to move backwards during one mod cycle on the grid

	if love.keyboard.isDown('right') then
		-- self.phantom_y = self.phantom_y - oldModPY
		
		if self.direction ~= direction.left then 
			self.direction = direction.right
		end
	elseif love.keyboard.isDown('left') then
		-- self.phantom_y = self.phantom_y - oldModPY

		if self.direction ~= direction.right then 
			self.direction = direction.left
		end
	elseif love.keyboard.isDown('up') then
		-- self.phantom_x = self.phantom_x - oldModPX

		if self.direction ~= direction.down then
			self.direction = direction.up
		end
	elseif love.keyboard.isDown('down') then
		-- self.phantom_x = self.phantom_x - oldModPX

		if self.direction ~= direction.up then
			self.direction = direction.down
		end
	end
	-- flag_me tels us to move the body
	flag_me = false
	if self.direction == direction.up then
		self.phantom_y = math.clamp(self.phantom_y - (self.speed * dt), GRID_SIZE, height)
		modPY = self.phantom_y % GRID_SIZE
		if oldModPY < modPY then
			self.y = self.phantom_y - modPY
			flag_me = true
		end
	elseif self.direction == direction.down then 
	    self.phantom_y = math.clamp(self.phantom_y + (self.speed * dt), GRID_SIZE, height - GRID_SIZE*2)
		modPY = self.phantom_y % GRID_SIZE
		if oldModPY > modPY then 
			self.y = self.phantom_y - modPY
			flag_me = true
		end
	elseif self.direction == direction.right then 
		self.phantom_x = math.clamp(self.phantom_x + (self.speed * dt), GRID_SIZE, width - GRID_SIZE*2)
		modPX = self.phantom_x % GRID_SIZE
		if oldModPX > modPX then 
			self.x = self.phantom_x - modPX
			flag_me = true
		end
	elseif self.direction == direction.left then
	    self.phantom_x = math.clamp(self.phantom_x - (self.speed * dt), GRID_SIZE, width)
		modPX = self.phantom_x % GRID_SIZE
		if oldModPX < modPX then 
			self.x = self.phantom_x - modPX
			flag_me = true
		end
	end
	

	if CheckCollisionBox(self, objects.entities.treat) then
		self.score = self.score + 1
		objects.entities.treat.x, objects.entities.treat.y = randPos()
		self:newBodyPart(self.direction)
	end
	if self:CheckCollision(table.slice(self.body, 2)) then
		print("SNAKE COLLIDE")

	end
	-- need to do the final update to the body movement last becasue we move all the values around here
	--   we still need them to be in place for any addition calculations and such
	if flag_me == true then
		self:updateBody(oldX, oldY)
	end
	-- print("phantom player  .. px:[", self.phantom_x, "]", ".. py:[", self.phantom_y, "]", " modX: ", modX)
end
function table.slice(tbl, first, last, step)
	local sliced = {}

	for i = first or 1, last or #tbl, step or 1 do
		sliced[#sliced+1] = tbl[i]
	end

	return sliced
end
function Player:updateBody(leading_x, leading_y) 
	self.body[1].x = leading_x
	self.body[1].y = leading_y
	-- print("player..         .. x:[", self.x, "]", ".. y:[", self.y, "]")
	-- print("OLD player..     .. x:[", oldX, "]", ".. y:[", oldY, "]")
	-- print("body 1 state..      x:[", self.body[1].x, "]", ".. y:[", self.body[1].y, "]")
	-- This goes backwards through a list to move a snake body 
	for i=#self.body, 2, -1 do 
		-- print("BEFORE body ", i ," state..      x:[", self.body[i].x, "]", ".. y:[", self.body[i].y, "]")
		self.body[i].x = self.body[i-1].x
		self.body[i].y = self.body[i-1].y
		-- print("AFTER body ", i ," state..      x:[", self.body[i].x, "]", ".. y:[", self.body[i].y, "]")
	end
end

function Player:newBodyPart()
	-- TODO: collistion on walls when adding new parts
	table_length = table.getn(self.body)
	lastX, lastY = self.body[table_length].x, self.body[table_length].y
	nextX, nextY = self.body[table_length-1].x, self.body[table_length-1].y
	if lastX < nextX then 
		add_direction = direction.left
	elseif lastX > nextX then
		add_direction = direction.right
	elseif lastY < nextY then
		add_direction = direction.down
	elseif lastY > nextY then
		add_direction = direction.up
	end 
	-- print("add_direction detected: ", add_direction)
	-- print("last x", table_length, ": ", lastX, "y", table_length, ": ", lastY)
	-- print("next x", table_length-1, ": ", nextX, "y", table_length-1, ": ", nextY)

	if add_direction == direction.up then
		new_body = {x=self.body[table_length].x, y=self.body[table_length].y + GRID_SIZE}
	elseif add_direction == direction.down then
		new_body = {x=self.body[table_length].x, y=self.body[table_length].y - GRID_SIZE}
	elseif add_direction == direction.right then
		new_body = {x=self.body[table_length].x + GRID_SIZE, y=self.body[table_length].y}
	elseif add_direction == direction.left then
		new_body = {x=self.body[table_length].x - GRID_SIZE, y=self.body[table_length].y}
	end
	print("Adding new body part: diretion ".. add_direction .. " x:" .. new_body.x .." y:" .. new_body.y)
	table.insert(self.body, new_body)
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end

function CheckCollisionBox(box1, box2)
	
    if box1.x > box2.x + GRID_SIZE - 1 or -- Is box1 on the right side of box2?
       box1.y > box2.y + GRID_SIZE - 1 or -- Is box1 under box2?
       box2.x > box1.x + GRID_SIZE - 1 or -- Is box2 on the right side of box1?
       box2.y > box1.y + GRID_SIZE - 1    -- Is b2 under b1?
    then
        return false
    else
        return true
    end
end
function Player:CheckCollision(entities)
	for _,o in ipairs(entities) do
		if CheckCollisionBox(self, o) then
			-- print(self.name)
			-- for k,v in pairs(o) do
			-- 	print(k,v)
			-- end
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