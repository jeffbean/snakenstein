gameW = 15     -- Game width
gameH = 15     -- Game height
GRID_SIZE = 20  -- Size of the grid squares

function love.conf(t)
	screenW = gameW * GRID_SIZE
	screenH = gameH * GRID_SIZE
	t.title = "Snakenstein"         
	t.window.width = screenW  -- The window width (number)
	t.window.height = screenH -- The window height (number)
end