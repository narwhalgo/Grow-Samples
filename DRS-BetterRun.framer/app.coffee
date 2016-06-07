# Some Framer.js practice
# by Yukyung Kim (designer.yuk@gmail.com)
# Updated May 31, 2016
# Import file "20160530_runAnimation"
sketch = Framer.Importer.load("imported/20160530_runAnimation@1x")
Utils.globalLayers(sketch)
Framer.Defaults.Animation =
    curve: "linear"
run5.destroy()
Artboard_2.y = Align.center()
ground.width = Screen.width
treeS.opacity = 0
treeS.x = 0
treeL.opacity = 0
treeL.x = 0

backgroundA = new BackgroundLayer
	backgroundColor: Artboard_2.backgroundColor

frame = new Layer
	size: Artboard_2.size
	backgroundColor: null
frame.center()


runs = [run1, run2, run3, run4, run6, run7, run8, run9]
for r in runs
	r.parent = frame
	r.opacity = 0
	r.center()

intervalTime = 0.6
delayTime = intervalTime/runs.length

activateRun = (run, ourRuns) ->
	r.opacity = 0 for r in ourRuns
	run.opacity = 1

# I tried to refactor this part, but had some trouble.
# If anyone has a good solution, I would really appreciate 
# some advice!
Utils.interval intervalTime, ->
	activateRun(run1, runs)
	Utils.delay delayTime, ->
		activateRun(run2, runs)
		Utils.delay delayTime, ->
			activateRun(run3, runs)
			Utils.delay delayTime, ->
				activateRun(run4, runs)
				Utils.delay delayTime, ->
					activateRun(run6, runs)
					Utils.delay delayTime, ->
						activateRun(run7, runs)
						Utils.delay delayTime, ->
							activateRun(run8, runs)
							Utils.delay delayTime, ->
								activateRun(run9, runs)

###### move trees
treeS.states.add
	firstHalf:
		opacity: 0.5
		x: treeS.x+Screen.width/2
	secondHalf:
		opacity: 0
		x: treeS.x+Screen.width		

treeRunTime = Utils.randomNumber(0.75,2)
Utils.interval 2, ->
	treeRunTime = Utils.randomNumber(0.75,2)
	
treeDelayTime = Utils.randomNumber(0.1,1)
Utils.interval 1, ->
	treeDelayTime = Utils.randomNumber(0,1)
	
treeL.states.add
	firstHalf:
		opacity: 1
		x: treeL.x+Screen.width/2
	secondHalf:
		opacity: 0
		x: treeL.x+Screen.width	

treeL.states.animationOptions = 
	time: treeRunTime
treeS.states.animationOptions = 
	time: treeRunTime
 
Utils.interval treeRunTime, ->
	treeS.states.next()

Utils.delay treeDelayTime, ->
	Utils.interval treeRunTime, ->	
		treeL.states.next()
