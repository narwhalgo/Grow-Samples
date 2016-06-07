# Import file "20160530_Jogstation_statistic_ver2" (sizes and positions are scaled 1:2)
sketch = Framer.Importer.load("imported/20160530_Jogstation_statistic_ver2@2x")
Utils.globalLayers(sketch)
Canvas.backgroundColor = "black"
Framer.Defaults.Animation = time: .25
summary.y = 0
summary.x = 0
summaryOn.y = 0
bottomHeight = summary.height+pageSpeed.height
bottom = new Layer
	height: bottomHeight
	width: Screen.width
	y: Screen.height-bottomHeight
bottom.parent = jogstation
summary.parent = bottom


#statistic page component set up
statistics = [pageSpeed, pageHeart, pageTime, pageDistance]

statisticPage = new PageComponent
	size: pageSpeed.size
	y: summary.height
	parent: bottom
	scrollVertical: false
	scrollHorizontal: false
	
for s in statistics
	statisticPage.addPage(s, "right")
	s.y = 0

#summary selected on/off set up
summaryOnMask = new Layer
	width: summary.width/4
	height: summary.height
	parent: bottom
	clip : true
summaryOn.parent = summaryOnMask

#summary selected on/off function set up
summaryOnMove = () ->
	summaryOnMask.x = summary.width/4*(statisticPage.horizontalPageIndex(statisticPage.currentPage))
	summaryOn.x = summary.width/4*(statisticPage.horizontalPageIndex(statisticPage.currentPage))*-1

summaryOnReset = () ->
	summaryOnMask.x = 0
	summaryOn.x = 0

#statistic page skip button layer set up
btnLeft = new Layer
	size: 120
btnPrevious.parent = btnLeft
btnPrevious.center()

btnRight = new Layer
	size: 120
	x: Screen.width-btnLeft.width
btnNext.parent = btnRight
btnNext.center()

btns = [btnLeft, btnRight]
for btn in btns
	btn.parent = bottom
	btn.y = Align.center
	btn.backgroundColor = null
	
#statistic page skip button function set up
btnLeftFunction = () ->
	statisticPage.snapToPreviousPage()
	summaryOnMove()
	btnRight.opacity = 1


btnRightFunction = () ->
	statisticPage.snapToNextPage()
	summaryOnMove()
	btnLeft.opacity = 1

#####Page Events
#skip
btnRightFunction()
btnLeftFunction()

btnLeft.onClick ->
	btnLeftFunction()
statisticPage.onSwipeRightEnd ->
	btnLeftFunction()

btnRight.onClick ->
	btnRightFunction()
statisticPage.onSwipeLeftEnd ->
	btnRightFunction()

#open and close
bottom.states.add
	close: 
		y: Screen.height - summary.height
bottom.states.animationOptions =
	curve: "ease-in-out"
	
backShadow.states.add
	clear:
		opacity:0

summaryOnMask.states.add
	clear:
		opacity:0

bottom.states.switchInstant("close")
backShadow.states.switchInstant("clear")
summaryOnMask.states.switchInstant("clear")

bottomStates = ()->
	bottom.states.next("close", "default")
	backShadow.states.next("clear", "default")
	summaryOnMask.states.next("clear", "default")

bottom.onSwipeUp ->
	if bottom.states.state == "close"
		bottomStates()
		sign.destroy()
		btnLeft.opacity = 0.3
		btnRight.opacity = 1
jogstation.onSwipeDownEnd ->
	if bottom.states.state != "close"
		bottomStates()
		summaryOnReset()
		statisticPage.snapToPage(statistics[0])


#sign setup
sign.scale = 0
sign.y = bottom.y - sign.height*1.2
finger.opacity = 0	
finger.states.add
	move:
		y: finger.y - 35
		opacity: 1
	opacity:
		opacity:0
finger.states.animationOptions = time: .25

Utils.delay .5, ->
	sign.animate
		properties:
			scale: 1
		curve: "bezier-curve(.5,0.5,.5,1.5)"
	Utils.interval .5, ->
		finger.states.next()


#speedPage graph set up
speedDataSample.opacity = 0


for i in [0..4]
	higher = speedDataSample.height*(i+3.5)
	sampleSize = speedDataSample.width

	speedData = new Layer
		name: "speedData#{i}"
		width: sampleSize
		height: higher
		x: speedDataSample.x + i*(sampleSize*1.78)
		y: speedDataSample.y - higher+sampleSize
		borderRadius: 100
		backgroundColor: "white"
		opacity: .3
		parent: pageSpeed

pageSpeedDefault = ->
	for s in pageSpeed.subLayers[2..6]	
		s.height = speedDataSample.height
		s.y = speedDataSample.y
pageSpeedDefault()

bottom.onSwipeUp ->
	Utils.delay .3, ->
		pageSpeed.subLayersByName("speedData4")[0].style.background = "-webkit-linear-gradient(top, #9013FE 0%, #A840D0 100%)"
		pageSpeed.subLayersByName("speedData4")[0].opacity = 1

		for i in [0..4]	
			s = pageSpeed.subLayers[i+2]
			h = speedDataSample.height*(i+3.5)
			y = speedDataSample.y - h+sampleSize
			o = 0.1*i+0.3
			s.animate
				properties:
					height: h
					y: y
					opacity: o
				time: .75

# animate the heartgraph width from 0 to 438
heartGraphMask = new Layer
	height: heartGraph.height
	width: 0
	x: heartGraph.x
	y: heartGraph.y
	backgroundColor: null
	clip: true
	parent: pageHeart
heartGraphMask.placeBehind(heartDot)
heartGraph.parent = heartGraphMask

pageHeartDefault = ->
	heartGraph.x=0
	heartGraph.y=0
	heartGraphMask.width=0
	heartDot.scale = 0
pageHeartDefault()

round.center()
secMask = new Layer
	size: pageTime.size
	backgroundColor: null
	parent: pageTime
sec.parent = secMask

secNo = new Layer
	parent : pageTime
	width: 250
	backgroundColor: null
secNo.center()

# toMMSS is a function that returns a MM:SS based on X seconds
toMMSS = (seconds) ->
	minutes = Math.floor(seconds / 60 )
	seconds = Math.round(seconds - (minutes * 60))
	
	if (minutes < 10) 
		minutes = "0"+minutes
	if (seconds < 10) 
		seconds = "0"+seconds
	return minutes+':'+seconds

count = 1935
secAngle = 1
Utils.interval 1, ->
	secMask.animate
		properties:
			rotation: 6*(secAngle++)
	count++
	Utils.labelLayer(secNo, toMMSS(count))
	secNo.style =
		"font-size" : "88px"
		"font-family" : "Arial"
		"text-align" : "center"

statisticPage.on "change:currentPage", ->
# 	print this.currentPage
	if this.currentPage.name == "pageSpeed"
		btnLeft.opacity = 0.3
	if this.currentPage.name == "pageHeart"
		heartGraphMask.animate
			properties:
				x: 108
				width: 438
			time: 1
		Utils.delay .75, ->
			heartDot.animate
				properties:
					scale: 1		
				
	if this.currentPage.name == "pageDistance"
		oval.animate
			properties:
				rotation: -360
			time: 2
		btnRight.opacity = 0.3

jogstation.onSwipeDownEnd ->
	pageSpeedDefault()
	pageHeartDefault()
	oval.rotation = 10
