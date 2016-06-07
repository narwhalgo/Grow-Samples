screenWidth = Screen.width
screenHeight = Screen.height
firstLoad = true

# Grid settings
gridSize = 7
itemSize = 80
gutter = 5
honeycombOffset = itemSize/2

# Create grid
item = []

grid = new ScrollComponent
	width: screenWidth
	height: screenHeight
	backgroundColor: '#000'

# Grid content config
grid.content.draggable.momentumOptions = friction: 10
grid.content.draggable.overdrag = false
grid.contentInset = 
	top: screenHeight/4
	right: screenWidth/4
	bottom: screenHeight/4
	left: screenWidth/4

# Create icons
for row in [0...gridSize]
	item[row] = []
		
	for column in [0...gridSize]	
		item[row][column] = new Layer
			name: "item" + row + "," + column
			x: (itemSize + gutter) * column
			y: itemSize * row
			width: itemSize
			height: itemSize
			scale: 0
			opacity: 0
			superLayer: grid.content
			
		icon = item[row][column]
				
		# Offset even rows, to form honeycomb
		if row % 2 != 0
			icon.x += honeycombOffset
		
		# Load images
		icon.image = 'images/icons/' + icon.index + '.png'

# Center icons
grid.content.center()

# Compensate honeycomb offset
grid.content.x -= honeycombOffset/2 

# Calculate origin based on distance to center
originFromCenter = (elemMid,gridPos,screenDist) ->
	itemMid = elemMid + gridPos - screenDist
	distPct = Utils.modulate(itemMid, [0,screenDist],[0,1])
	distPctAbs = Math.abs(distPct)
	
	return Math.min(1,Math.max(0,distPctAbs))

# Calculate scale based on distance to center	
scaleFromCenter = (elemMid,gridPos,screenDist) ->
	itemMid = elemMid + gridPos - screenDist / 2
	distPct = Utils.modulate(itemMid, [0,screenDist/1.75],[0,1])
	
	return Math.abs(distPct)

# Calculate scale on X/Y
scaleOnAxis = (elem,axis) ->
	if axis == 'x'
		scale = scaleFromCenter(elem.midX,grid.content.x,screenWidth)
	else
		scale = scaleFromCenter(elem.midY,grid.content.y,screenHeight)
	
	scalePow = 1 - Math.pow(scale,2)
	
	return Math.min(1,Math.max(0,scalePow))

# Calculate distance from center element (load animation)
distanceFromCenter = (row,col) ->
	Math.abs(3-row) + Math.abs(3-col)

# Scale X/Y
scaleGrid = ->	
	for column in [0...gridSize]	
		for row in [0...gridSize]
			itemToScale = item[row][column]
			
			# Calculate scale
			scaleX = scaleOnAxis(itemToScale, 'x')
			scaleY = scaleOnAxis(itemToScale, 'y')
			
			# Calculate origin of transforms
			originX = originFromCenter(itemToScale.midX,grid.content.x,screenWidth)
			originY = originFromCenter(itemToScale.midY,grid.content.y,screenHeight)
				
			# Calculate X/Y combined scale
			scaleXY = (scaleX * 1.5 + scaleY * 0.5) / 2
			
			# Apply scale and origin to items
			itemToScale.originX = originX
			itemToScale.originY = originY
			
			if firstLoad
				itemToScale.animate
					properties:
						scale: scaleXY
						opacity: 1
					delay: 1 + distanceFromCenter(row,column)/12
					time: .5
			else
				itemToScale.scale = scaleXY
				

# Scale on load
scaleGrid()

# Scale on scroll
grid.on Events.Move, ->
	firstLoad = false
	scaleGrid()