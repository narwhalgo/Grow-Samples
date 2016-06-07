{SVGLayer} = require "SVGLayer"
Canvas.backgroundColor = "#ffb03a"


bg_layer = new BackgroundLayer
    backgroundColor: "#ffb03a"


# SVG
circle_layer = new SVGLayer
	x:Align.center
	y:Align.center
	strokeWidth: 2
	visible : false
	dashOffset:0
	width: 436
	height: 430
	scale:0.5
	path: '<path fill="none" stroke="#fff" stroke-width="15" stroke-linecap="round" stroke-miterlimit="10" d="M217.473,68.503c78.883,1.187,142.461,65.5,142.461,144.665c0,79.904-64.774,144.68-144.68,144.68c-79.905,0-144.68-64.775-144.68-144.68c0-79.229,63.681-143.582,142.652-144.667"/></path>'
	
	
circle_layer_viewed = new SVGLayer
	x:Align.center
	y:Align.center
	strokeWidth: 2
	opacity:.3
	width: 436
	height: 430
	scale:0.5
	path: '<path fill="none" stroke="#fff" stroke-width="15" stroke-linecap="round" stroke-miterlimit="10" d="M217.473,68.503c78.883,1.187,142.461,65.5,142.461,144.665c0,79.904-64.774,144.68-144.68,144.68c-79.905,0-144.68-64.775-144.68-144.68c0-79.229,63.681-143.582,142.652-144.667"/></path>'


bg_circle = new Layer
    x: Align.center
    y: Align.center
    width: 150
    height: 150
    dashOffset:0
    opacity: 1
    borderRadius: 150
    backgroundColor: "#ffb03a"
    
loading_circle = new Layer
    x: -80
    y: +150
    width: 300
    height: 300
    dashOffset:0
    opacity: 1
    visible: false
    borderRadius: 500
    parent: bg_circle
    backgroundColor: "#fff"
loading_circle.style.background = "-webkit-linear-gradient(top, #fff 0%, #fa70d 100%)"

#masking
bg_circle.clip = true

circle_layer.states.add
	second:
		dashOffset:-1
	third:
		dashOffset:0

circle_layer.states.animationOptions =
	curve: "spring(80, 30)"



line = new Layer
    x: Align.center
    y: Align.center
    width: 7
    height: 60
    borderRadius: 1000
    backgroundColor: "#fff"


    
arrow_left = new Layer
    x: line.x-12
    y: line.y+27
    rotation: -45
    width: 7
    height: 38
    borderRadius: 1000
    backgroundColor: "#fff"
    
    
arrow_right = new Layer
    x: line.x+12
    y: line.y+27
    rotation: 45
    width: 7
    height: 38
    borderRadius: 1000
    backgroundColor: "#fff"


line.states.add
	second:
		height:7
		y : arrow_left.y+10
	third:
		y : arrow_left.y-73
	fourth:
		x : Align.center
		y : line.y
		height: 60



arrow_left.states.animationOptions =
	curve:"spring(500,10,10)"
	

arrow_right.states.animationOptions =
	curve:"spring(500,10,10)"
	

line.states.animationOptions =
	curve:"spring(50,12,8)"

loading_circle.states.animationOptions =
	curve:"spring(80, 30)"
	
	
arrow_left.states.add
	second:
    	rotation: -90
    	y:line.y+25
    	curve:"spring(500,10,10)"
	third:
    	opacity: 0
    	y:line.y+80
	fourth:
    	backgroundColor: "#ffb03a"
    	opacity:1
    	rotation: -45
    	width: 7
    	x:line.x-17
    	y: line.y+17
    	
    	
arrow_right.states.add
	second:
    	rotation: 90
    	y:line.y+25
    	curve:"spring(500,10,10)"
	third:
    	opacity: 0
    	y:line.y+80
	fourth:
    	backgroundColor: "#ffb03a"
    	opacity:1
    	rotation: 45
    	width: 7
    	height: 50
    	x: line.x+10
    	y: line.y+8
    	

loading_circle.states.add
	second:
    	y:0

timesClicked = 0
bg_circle.on Events.Click, ->
	timesClicked++
	if timesClicked == 1
		DownloadAnimation()
	else
		BackToDefaultFunction()
		

DownloadAnimation = ->
	line.states.switch("second", time:1, curve: "spring(200,20,1)")
	Utils.delay .6, ->
    	arrow_left.states.next()
    	arrow_right.states.next()
    Utils.delay .7, ->
    	line.states.next()
    Utils.delay 1.6, ->
    	circle_layer.visible=true
    	circle_layer.states.switch("second")
    Utils.delay 2.8, ->
    	arrow_left.states.switch("third", time:0.8, curve: "bezier-curve(.5,-0.5,.5,1.5)")
    	arrow_right.states.switch("third", time:0.8, curve: "bezier-curve(.5,-0.5,.5,1.5)")
    Utils.delay 3.2, ->
    	loading_circle.visible=true
    	loading_circle.states.switch("second", time:1, curve: "bezier-curve(.5,-0.5,.5,1.5)")
	Utils.delay 3.8, ->
    	arrow_left.states.switch("fourth", time:0.3, curve: "bezier-curve(.5,-0.5,.5,1.5)")
    	arrow_right.states.switch("fourth", time:0.3, curve: "bezier-curve(.5,-0.5,.5,1.5)")



circle_layer_viewed.placeBefore(bg_circle)
circle_layer.placeBefore(bg_circle)



BackToDefaultFunction = ->
    circle_layer.visible = false
    loading_circle.visible = false
    loading_circle.x = -80
    loading_circle.y = 150
    arrow_left.states.next()
    arrow_right.states.next()
    timesClicked = 0
    circle_layer.states.switch("third")
    line.states.switch("fourth", time:0.3, curve: "bezier-curve(.5,-0.1,.5,1)")
    

