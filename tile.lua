function moveTile(tileName, x, y)
	local oldX, oldY

	if x > gameW then x = x % gameW end -- loop around the map
	if y > gameH then y = y % gameH end
	-- checking collistions in the grid
	if grid[x][y] ~= "" then
		print(tileName .. " hit " .. grid[x][y] .. " at position x" .. x .. " y" .. y)
		if pellets[grid[x][y]] then
			eatPellet(grid[x][y])
		else
			return loseGame()
		end
	end
	-- filling the tile value with the object
	grid[x][y] = tileName --grid[tiles[tileName].x][tiles[tileName].y]
	grid[tiles[tileName].x][tiles[tileName].y] = ""

	oldX = tiles[tileName].x
	oldY = tiles[tileName].y
	print("Moving " .. tileName .. " from x" .. oldX .. " y" .. oldY .. " to x" .. x .. " y" .. y)
	tiles[tileName].x = x
	tiles[tileName].y = y
	return oldX, oldY -- return the position it was in before it was moved
end