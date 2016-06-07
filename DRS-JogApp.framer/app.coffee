# Import all modules
{UISound} = require "uisound"
splitImageArray = require "split-image-array"
myModule = require "myModule"


# Import Sketch File (sizes and positions are scaled 1:2)
sketch = Framer.Importer.load("imported/20160527_JogStation@2x")
# Global Settings
Utils.globalLayers(sketch)
Framer.Defaults.Animation =
	curve: "bezier-curve(0.25, 0.1, 1.25, 1)"
	time: .25
	
Canvas.backgroundColor="ECEBED"
# View configuration
Player.placeBehind(Beginning)
btn_wide.borderRadius= 100
btn_wide.status = "start"
pauseIcon.opacity= 0
jogIcon.opacity= 0
btn_heart.scale=0
btn_list.scale=0
pauseShadow.scale=0
btn_heart.y=0
btn_list.y=0
startScreen.clip=true
gradientOval.destroy()
Oval.y=0
playBackImg.x=Align.center
######create layers
##audio layers

musicFileNames = [
	"neverbelikeyou_cut", 
	"beautifulnow_cut", 
	"cakebytheocean_cut", 
	"dessert_cut", 
	"lushlife_cut"]


musics = []
for f in musicFileNames
	musics.push(new UISound("sounds/#{f}.mp3"))
musics.current = 0
musics.currentSong = () ->
	 this[this.current]
musics.next = () ->
	this.currentSong().stop()
	newSong = this[++this.current]
	return newSong
musics.previous = () ->
	this.currentSong().stop()
	newSong = this[--this.current]
	return newSong
musics.isLastSong = () ->
	this.current == (this.length - 1)

# print musics.currentSong().audio

######make array
#play screen background images
backImgs = [musicA_backImg, musicB_backImg, musicC_backImg, musicD_backImg, musicE_backImg]
#play screen circle images
playImgs = [musicA_playImg, musicB_playImg, musicC_playImg, musicD_playImg, musicE_playImg]
#title text
playTxts = [musicA_txt, musicB_txt, musicC_txt, musicD_txt, musicE_txt]
for p in playTxts # make all playTxts invisible
	p.opacity = 0 
	p.parent = Player
# return the play text for this song
textLayerForSong = (currentSongIndex) ->
	p = playTxts[currentSongIndex]
	return p
	

# PageComponent for the background
#
backPage = new PageComponent
	width: Screen.width+2
	height: Screen.height+2
	scrollVertical: false
	scrollHorizontal: false
	parent: playBackImg
backPage.x = Align.center
backPage.placeBehind(gradient)

for i in backImgs
	index = backImgs.indexOf(i)
	backMask = new Layer
		name: "backMask#{index}"
		size: Screen.size
		x: Screen.width*index
		clip: true
	i.parent = backMask
	backPage.addPage(backMask)


# Bottom Layer that scrolls up
#
bottomScroll = new ScrollComponent
	width: Screen.width
	height: Screen.height
	y: Screen.height
bottomScroll.draggable.horizontal = false
bottomScroll.draggable.constraints =
	y: 0
	height: bottom.height*2-bottom.height/5
bottomScroll.draggable.bounce = false
bottomScroll.draggable.overdrag = false
bottom.parent = bottomScroll
bottom.y=1

######
#player circle image rotation
container = new Layer
	size: Oval.size
	clip: false
	backgroundColor: null

container.originY = 1.5
mask = new Layer
	x: Oval.x
	backgroundColor: "#FFF"
	size: Oval.size
	borderRadius: 300
	backgroundColor: null
mask.clip = true

# Centering the mask layer to the center of window
mask.parent=o_play
window.onresize = -> mask.center()
container.parent = mask

spinLayers = []
for playImg in playImgs
	a = new Layer
		size: container.size
		backgroundColor: null			
	playImg.superLayer = a
	playImg.visible = true
	playImg.center()
	a.superLayer = container
	spinLayers.push(a)
	
rotateAngle = splitImageArray.splitImageArray(spinLayers)
startAngle = 0

###### setup for RUN btn click event 
pauseIcon.states.add
	invisible:
		opacity: 0
		rotation: 180
	visible:
		opacity: 1
		scale:1
		rotation: 360
				
jogIcon.states.add
	invisible:
		opacity: 0
		rotation: 180
	visible:
		opacity: 1
		scale: 1
		rotation: 360

btn_heart.states.add
	scaleA:
		scale:1
		y:60
btn_list.states.add
	scaleA:
		scale:1
		y:60

backgroundImg_jogStation.states.add
	scaleA:
		scale: 1.1
backgroundImg_jogStation.states.animationOptions =
	time: 8
	curve: "ease-in-out"
backgroundImg_jogStation.states.next()
Utils.interval 9, ->
	backgroundImg_jogStation.states.next()


###### Our Circle
#create layers
progressRing = new Layer
	width: Oval.width
	height: Oval.height
	backgroundColor: null
	parent: o_play
progressRing.x = Oval.x
progressRing.placeBehind(mask)

sClip = new Layer
	backgroundColor: null
	width: progressRing.width/2
	height: progressRing.height
	clip: true
	
s = new Layer
	borderRadius: 500
	backgroundColor: null
	size: progressRing.size
	superLayer: sClip
	rotation: 180
s.isFinished = ->
	this.rotation == 360
progressRing.s = s

oClip = new Layer
	backgroundColor: null
	width: progressRing.width/2
	height: progressRing.height
	x: 0
	parent: s
	borderColor: null
	clip: true
	
o = new Layer
	borderRadius: 500
	backgroundColor: null
	borderWidth: 8
	borderColor: "9013FE"
	size: progressRing.size
	parent: oClip
	x: 0
	y: 0

sClip2 = sClip.copy()
sClip2.x = progressRing.width/2
sClip2.name = "sClip2"
s2 = sClip2.subLayers[0]
s2.name = "s2"
progressRing.s2 = s2
s2.rotation = 0
s2.x = -progressRing.width/2
oClip2 = s2.subLayers[0]
oClip2.name = "oClip2"
o2 = oClip2.subLayers[0]
o2.name = "o2"
sClip.parent = progressRing
sClip2.parent = progressRing
sClip2.x = progressRing.width/2
progressRing.placeBehind(bottomScroll)	
######

progressRing.animateSecondHalf = (time) ->
	this.s2.animate
		properties:
			rotation: 180
		time: time
		curve: "linear"

progressRing.start = (time) ->
	if this.s.isFinished()
		this.animateSecondHalf(time+5)
	else
		this.s.animate
			properties:
				rotation: 360
			time: time
			curve: "linear"

s.onAnimationEnd ->
	s2.animate
		properties:
			rotation: 180
		time: 10-musics.currentSong().currentTime()
		curve: "linear"	

resetProgressRing = ()->
	#print "reset"
	s.animateStop()
	s2.animateStop()
	s.rotation = 180
	s2.rotation =  0


toggleJogPauseButton = ->
	if jogIcon.states.current != "invisible"
		jogIcon.states.switch("invisible")
		pauseIcon.states.switch("visible")	
	else
		pauseIcon.states.switch("invisible")
		jogIcon.states.switch("visible")

# Setup view dependencies based on song playing
for song in musics
	audio = song.audio
	skipBtns = [nextBtn, previousBtn]
	audio.onplaying = () ->
		pauseShadow.scale=0
		time = 5 - this.currentTime #30-musicA.currentTime()
		progressRing.start(time) 
	audio.onpause = () ->
		pauseShadow.scale = 1
		# stop the circle animation
		s.animateStop()
		s2.animateStop()

		
playFunction = () ->
	currentSong = musics.currentSong()
	if currentSong.audio.paused	
		currentSong.play()
	else 
		currentSong.pause()

#play next song
playNext = () ->
	if !musics.isLastSong()
		# make the previous text disappear
		previousTextLayer = textLayerForSong(musics.current)
		previousTextLayer.opacity = 0		

		# animate only if song is paused
		if musics.currentSong().audio.paused
			toggleJogPauseButton()
	
		# update the song (reality)
		musics.next()
		playFunction()
		
		
		
		# update the view (perception)
		#
		resetProgressRing()
		textLayer = textLayerForSong(musics.current)
		textLayer.opacity=1
		# do something with the textLayer
		previousBtn.opacity = 1
		backPage.snapToNextPage()
		container.animate
			properties: {rotationZ: startAngle - rotateAngle}
			curve: "ease-out"
		startAngle = startAngle - rotateAngle
		if musics.isLastSong()
			nextBtn.opacity = 0.3
		
		
	
#play previous song
playPrevious = () ->
	nextBtn.opacity = 1
	if backPage.previousPage != undefined
		# make the previous text disappear
		previousTextLayer = textLayerForSong(musics.current)
		previousTextLayer.opacity = 0
		
		# animate only if song is paused
		if musics.currentSong().audio.paused
			toggleJogPauseButton()

		# update the song (reality)
		musics.previous()
		playFunction()
		
		# update the views

		textLayer = textLayerForSong(musics.current)
		textLayer.opacity=1
		# do something with the textLayer

		resetProgressRing()
		previousBtn.opacity = 1
		backPage.snapToPreviousPage()
		container.animate
			properties: {rotationZ: startAngle + rotateAngle}
			curve: "ease-out"
		startAngle = startAngle + rotateAngle
		if backPage.previousPage == undefined	
			previousBtn.opacity = 0.3


s2.onAnimationEnd ->
	# if there's another song, go to it
	if !musics.isLastSong()
		playNext()
	# if this was the last song, stop
	else
		resetProgressRing()
		musics.currentSong().stop()
		toggleJogPauseButton()


	
###### RUN btn click event 
btn_wide.onClick ->	
	# background
	back = backgroundImg_jogStation
	back.states.remove("scaleA")
	back.states.remove("scaleB")
	
	# animate the "Run" button to a circle
	this.animate 
		properties: 
			width: btn_wide.height
			x: Screen.width/2 - btn_wide.height/2
	
	# move the start screen off the screen
	startScreen.animate
		properties: 	
			x: -startScreen.width
		curve: "linear"
		time:0.2
		
	# move the player on to the screen
	Player.animate
		properties: 
			x: 0
			curve:"linear"
		time:0.2
	
	txt_run.opacity= 0
	Utils.delay 0.25, ->
		#btn_heart.states.switch("scaleA")
		#btn_list.states.switch("scaleA")
		bottomScroll.animate
			properties: 	
				y: Screen.height-bottomBar_summary.height
			curve: "ease-in"
			
	#show the text layer
	textLayer = textLayerForSong(musics.current)
	textLayer.opacity = 1
	#animate circle and btn icons
	playFunction()
	# if on the first song, darken the previous button
	previousBtn.opacity = 0.3 if musics.current == 0
	
	toggleJogPauseButton()
	
		
pauseShadow.onClick ->
	playFunction()
	toggleJogPauseButton()

mask.onClick ->
	playFunction()
	toggleJogPauseButton()

###### Make skip btn work
#skip to the next song
	# skip the background image to the next page
	# animate the play image to the next layer
	# stop the current song and play the next song
previousBtn = new Layer
	midY: skipBtnA.midY
	midX: skipBtnA.midX
	size: 140
	backgroundColor: null
	parent: o_play
skipBtnA.parent=previousBtn
skipBtnA.center()
nextBtn = new Layer
	midY: skipBtnB.midY
	midX: skipBtnB.midX
	size: 140
	backgroundColor: null
	parent:o_play
skipBtnB.parent=nextBtn
skipBtnB.center()

nextBtn.onClick ->
	playNext()
previousBtn.onClick ->
	playPrevious()

Player.on Events.SwipeLeftEnd, (event) ->
	playNext()
Player.on Events.SwipeRightEnd, (event) ->
	playPrevious()

###### Text layer animation
# bottomTxts = [0..3]
# for t in bottomTxts
# 	index = bottomTxts.indexOf(t)
# 	numberLayer = new Layer
# 		opacity: .6
# 		parent: bottomScroll	
# 		name: "number#{index}"
# 		y: bottomBar_summary.height/3
# 		x: bottomBar_summary.width/4*t-10
# 	numberLayer.html.style = {
# 		"fontSize" : "28px"
# 		"textAlign": "center"
# 	}
# 	t.numberLayer = numberLayer
# 	print t.numberLayer
# 	
#  counterValue = 0
#  
# Utils.interval 1, ->
# 	#if isTimerOn == true
# 	counterValue++
# 	if counterValue < 10
# 		bottomTxts[1].numberLayer.html = "00:0#{counterValue}"
# 	else 
# 		number2.html = "00:#{counterValue}"	

	

speedTxt = new Layer
heartTxt = new Layer
timeTxt = new Layer
distanceTxt = new Layer
numberLayers = [speedTxt, heartTxt,timeTxt, distanceTxt]
for n in numberLayers
	index = numberLayers.indexOf(n)
	n.opacity = .6
	n.parent = bottomScroll
	n.backgroundColor = null
	n.y = bottomBar_summary.height/3
	#n.x = bottomBar_summary.width/4*"#{index}"

#speed
speedTxt.html = "2"+"km/h"
Utils.interval 2, ->
	randomSpeed = Utils.randomNumber(2,8)
	randomSpeed = Math.round(randomSpeed * 1) / 1
	speedTxt.html = "#{randomSpeed}"+"km/h"
speedTxt.x = 100
# print randomSpeed

#time setting

toMMSS = (seconds) ->
	minutes = Math.floor(seconds / 60)
	seconds = Math.round(seconds - (minutes * 60))

	if (minutes < 10) 
		minutes = "0"+minutes
	if (seconds < 10) 
		seconds = "0"+seconds
	return minutes+':'+seconds
	
timeTxt.x = bottomBar_summary.width/4*2 +56
counterValue = 0
Utils.interval 1, ->
	#if isPlayerOn == true
	counterValue++
	timeTxt.html = toMMSS(counterValue)
# 	if counterValue < 10
# 		timeTxt.html = "00:0#{counterValue}"
# 	else 
# 		timeTxt.html = "00:#{counterValue}"

#heartbeat
heartTxt.html = "110"
Utils.interval 2, ->
	randomheart = Utils.randomNumber(105,150)
	randomheart = Math.round(randomheart * 1) / 1
	heartTxt.html = "#{randomheart}"
heartTxt.x = bottomBar_summary.width/4+78

# #distance
distanceTxt.html = "0.0km"
distanceNo = 0
Utils.interval 2, ->
	#if isPlayerOn == true
	distanceNo++
	distanceTxt.html = "#{distanceNo/10}"+"km"
# 	if distanceNo < 10
# 	else
# 		distanceTxt.html = "#{distanceNo}"+" km"
distanceTxt.x = bottomBar_summary.width/4*3 +40
# distanceTxt = new Layer
# 	opacity: .6
# 	parent: bottomScroll
# 	y: bottomBar_summary.height/3
# 	x: bottomBar_summary.width-10
# distanceTxt.html = "00:0#{counterValue}"
#text style

##### these lines are used just for now
bottomScroll.draggable.vertical = false
Group_2.opacity = 0
Speed.destroy()




