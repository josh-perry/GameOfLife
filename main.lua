function love.load()
	immuneGraphic = love.graphics.newImage("immune.png")
	virusGraphic = love.graphics.newImage("virus.png")
	liveGraphic = love.graphics.newImage("live.png")
	deadGraphic = love.graphics.newImage("dead.png")
	generation = 0
	xCells = 40
	yCells = 30
	cellSize = 16
	genTime = 100
	genCurTime = 1
	mouseX, mouseY, selCellX, selCellY, neighbours = 0
	paused = false
	map={}
	bufferMap={}
	randomiseCells()
	love.keyboard.setKeyRepeat(0, 100)
end

function drawMap()
	for y = 1, yCells do
		for x = 1, xCells do
			if map[y][x] == 2 then
				love.graphics.draw(virusGraphic, x * cellSize - cellSize, y * cellSize - cellSize)
			elseif map[y][x] == 1 then
				love.graphics.draw(liveGraphic, x * cellSize - cellSize, y * cellSize - cellSize)
			elseif map[y][x] == 0 then
				love.graphics.draw(deadGraphic, x * cellSize - cellSize, y * cellSize - cellSize)
			elseif map[y][x] == 3 then
				love.graphics.draw(immuneGraphic, x * cellSize - cellSize, y * cellSize - cellSize)
			end
		end
	end
end

function love.draw()
	drawMap()
	love.graphics.print("Generation: "..generation, 10, 10)
	if showHelp == true then
		love.graphics.print("R: Randomise cells", 10, 50)
		love.graphics.print("C: Clear cells", 10, 70)
		love.graphics.print("P: Pause", 10, 90)
		love.graphics.print("1-6: Change generation speed", 10, 110)
		love.graphics.print("H: Toggle help", 10, 130)
	end
	if paused == true then
		love.graphics.print("PAUSED", 300, 10)
	end
end

function randomiseCells()
	clearCells()
	math.randomseed(os.time())
	for y = 1, yCells do
		map[y] = {}
		bufferMap[y] = {}
		for x = 1, xCells do
			map[y][x] = math.random(0, 1)
			bufferMap[y][x] = map[y][x]
		end
	end
end

function mutateRandomCell()
	mY = math.random(1, yCells)
	mX = math.random(1, xCells)
	if map[mY][mX] == 1 then map[mY][mX] = 2 end
end

function immuniseRandomCell()
	mY = math.random(1, yCells)
	mX = math.random(1, xCells)
	if map[mY][mX] ~= 0 and map[mY][mX] ~= 3 then map[mY][mX] = 3 end
end

function clearCells()
	for y = 1, yCells do
		map[y] = {}
		bufferMap[y] = {}
		for x = 1, xCells do
			map[y][x] = 0
			bufferMap[y][x] = 0
		end
	end
	generation = 0
end

function updateCells()
	mutateRandomCell()
	immuniseRandomCell()
	for y = 1, yCells do
		for x = 1, xCells do
			neighbours = 0 	-- Non-mutated
			mNeighbours = 0 -- Mutated
			iNeighbours = 0 -- Immune
			tNeighbours = 0 -- Total
			if map[y-1] and map[y-1][x-1] 	and map[y-1][x-1] 	== 1 	then neighbours = neighbours + 1 	end
			if map[y] 	and map[y][x-1] 	and map[y][x-1]		== 1 	then neighbours = neighbours + 1	end
			if map[y+1] and map[y+1][x-1] 	and map[y+1][x-1] 	== 1 	then neighbours = neighbours + 1 	end
			if map[y-1] and map[y-1][x] 	and map[y-1][x] 	== 1 	then neighbours = neighbours + 1 	end
			if map[y+1] and map[y+1][x] 	and map[y+1][x] 	== 1 	then neighbours = neighbours + 1 	end
			if map[y-1] and map[y-1][x+1] 	and map[y-1][x+1] 	== 1 	then neighbours = neighbours + 1 	end
			if map[y] 	and map[y][x+1] 	and map[y][x+1] 	== 1 	then neighbours = neighbours + 1 	end
			if map[y+1] and map[y+1][x+1] 	and map[y+1][x+1] 	== 1 	then neighbours = neighbours + 1 	end
			if map[y-1] and map[y-1][x-1] 	and map[y-1][x-1] 	== 2 	then mNeighbours = mNeighbours + 1 	end
			if map[y] 	and map[y][x-1] 	and map[y][x-1]		== 2 	then mNeighbours = mNeighbours + 1	end
			if map[y+1] and map[y+1][x-1] 	and map[y+1][x-1] 	== 2 	then mNeighbours = mNeighbours + 1 	end
			if map[y-1] and map[y-1][x] 	and map[y-1][x] 	== 2 	then mNeighbours = mNeighbours + 1 	end
			if map[y+1] and map[y+1][x] 	and map[y+1][x] 	== 2 	then mNeighbours = mNeighbours + 1 	end
			if map[y-1] and map[y-1][x+1] 	and map[y-1][x+1] 	== 2 	then mNeighbours = mNeighbours + 1 	end
			if map[y] 	and map[y][x+1] 	and map[y][x+1] 	== 2 	then mNeighbours = mNeighbours + 1 	end
			if map[y+1] and map[y+1][x+1] 	and map[y+1][x+1] 	== 2 	then mNeighbours = mNeighbours + 1 	end
			if map[y-1] and map[y-1][x-1] 	and map[y-1][x-1] 	== 3 	then iNeighbours = iNeighbours + 1 	end
			if map[y] 	and map[y][x-1] 	and map[y][x-1]		== 3 	then iNeighbours = iNeighbours + 1	end
			if map[y+1] and map[y+1][x-1] 	and map[y+1][x-1] 	== 3 	then iNeighbours = iNeighbours + 1 	end
			if map[y-1] and map[y-1][x] 	and map[y-1][x] 	== 3 	then iNeighbours = iNeighbours + 1 	end
			if map[y+1] and map[y+1][x] 	and map[y+1][x] 	== 3 	then iNeighbours = iNeighbours + 1 	end
			if map[y-1] and map[y-1][x+1] 	and map[y-1][x+1] 	== 3 	then iNeighbours = iNeighbours + 1 	end
			if map[y] 	and map[y][x+1] 	and map[y][x+1] 	== 3 	then iNeighbours = iNeighbours + 1 	end
			if map[y+1] and map[y+1][x+1] 	and map[y+1][x+1] 	== 3 	then iNeighbours = iNeighbours + 1 	end
			
			tNeighbours = neighbours + mNeighbours + iNeighbours

			if map[y][x] == 1 then -- Currently alive, unmutated
				if tNeighbours == 3 or tNeighbours == 2 then
					if mNeighbours > 0 then
						bufferMap[y][x] = 2 -- Mutate
					else
						bufferMap[y][x] = 1 -- Survives					
					end
				else
					bufferMap[y][x] = 0 -- Kill
				end
			elseif map[y][x] == 2 then -- Currently alive, mutated
				if tNeighbours == 3 or tNeighbours == 2 then
					if iNeighbours > 0 then
						bufferMap[y][x] = 3 -- Cure
					else
						bufferMap[y][x] = 2 -- Survives
					end
				else
					bufferMap[y][x] = 0 -- Kill
				end
			
			elseif map[y][x] == 3 then -- Currently alive, immunised
				if tNeighbours == 3 or tNeighbours == 2 then
					bufferMap[y][x] = 3 -- Survives					
				else
					bufferMap[y][x] = 0 -- Kill
				end
			elseif map[y][x] == 0 then -- Currently dead
				if tNeighbours == 3 then
					if iNeighbours > 0 then
						bufferMap[y][x] = 1
					elseif mNeighbours > neighbours then
						bufferMap[y][x] = 2 -- New virus
					else
						bufferMap[y][x] = 1 -- New life
					end
				end
			end
		end
	end
	for y = 1, yCells do
		map[y] = {}
		for x = 1, xCells do
			map[y][x] = bufferMap[y][x]
		end
	end
end

function love.keypressed(key, unicode)
	if key == "r" then randomiseCells()	end
	if key == "c" then clearCells()		end
	if key == "1" then genTime = 1		end
	if key == "2" then genTime = 10		end
	if key == "3" then genTime = 20		end
	if key == "4" then genTime = 50		end
	if key == "5" then genTime = 80		end
	if key == "6" then genTime = 100	end
	if key == "i" then
		map[selCellY][selCellX] = 3
		bufferMap[selCellY][selCellX] = 3
	end
	if key == "p" then
		if paused == true then genCurTime = 0 paused = false
		else paused = true
		end
	end
	if key == "h" then
		if showHelp == true then showHelp = false
		else showHelp = true
		end
	end
end

function love.update(dt)
	mouseX, mouseY = love.mouse.getPosition()
	selCellX = math.ceil(mouseX / cellSize)
	selCellY = math.ceil(mouseY / cellSize)
	if love.mouse.isDown("r") then
		map[selCellY][selCellX] = 0
		bufferMap[selCellY][selCellX] = 0
	elseif love.mouse.isDown("l") then
		map[selCellY][selCellX] = 1
		bufferMap[selCellY][selCellX] = 1
	elseif love.mouse.isDown("m") then
		map[selCellY][selCellX] = 2
		bufferMap[selCellY][selCellX] = 2
	end
	if genCurTime >= genTime then
		if paused ~= true then
			updateCells()
			generation = generation + 1
		end
		genCurTime = 0
	end
	genCurTime = genCurTime + 1
end

function love.quit()
end
