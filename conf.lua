gameW = 30     -- Game width
gameH = 30     -- Game height
GRID_SIZE = 15  -- Size of the grid squares

function love.conf(t)
	screenW = gameW * GRID_SIZE + 8
	screenH = gameH * GRID_SIZE + 8
	t.title = "Snakenstein"         
	t.window.width = screenW  -- The window width (number)
	t.window.height = screenH -- The window height (number)
end