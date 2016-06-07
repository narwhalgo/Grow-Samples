# Set background color
Screen.backgroundColor = "#000"

# Create ScrollComponent
scroll = new ScrollComponent
	width: Screen.width
	height: Screen.height
	directionLock: true

# Set scroll on veritcal only
scroll.scrollHorizontal = false

# Variable array which will store parent containers
containers = []

# Create containters in a loop and append to containers array
for i in [0..10]
	layer = new Layer
		parent: scroll.content
		name: "Row #{i}"
		width: 750
		height: 750	
		x: 0
		y: (750+10) * i
		backgroundColor: "#000"
	containers.push(layer)

for container in containers
	# Create PageComponent for each container in containers array
	page = new PageComponent
		parent: container
		name: "Page Group #{container.index}"
		x: Align.center
		y: Align.center
		width: 750
		height: 750
		backgroundColor: "#000"
		scrollVertical: false
		directionLock: true

	# Create and add pages to each pageComponent
	for i in [0..6]
		layer = new Layer 
			parent: page.content
			name: "Page #{i}"
			x: (layer.width + 10) * i
			width: 750
			height: 750
			backgroundColor: Utils.randomColor()