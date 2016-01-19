# This imports all the layers for "fooddiary-protomore" into fooddiaryProtomoreLayers5
sk = Framer.Importer.load "imported/fooddiary-protomore"
noColor = "rgba(0,0,0,0)"

nav = sk.tabNav
nav.y = Screen.height - nav.height

scroller = ScrollComponent.wrap(sk.mainContent)
scroller.scrollHorizontal = false

Framer.Defaults.Animation =
	curve:"ease-in-out"
	time:0.4

sk.weight.x += Screen.width

sk.calendar.opacity = 0
sk.progressbar.opacity = 0
sk.datanext.x += 2*Screen.width
sk.datatoday.x += Screen.width

topPager = new PageComponent
	x: 0
	y: 250
	width: Screen.width
	height: 420
	backgroundColor: noColor
	
topPager.content.backgroundColor = noColor
topPager.scrollVertical = false
sk.calstats.superLayer = topPager.content
sk.calstats.y = 0
sk.weight.superLayer = topPager.content
sk.weight.y = 0
topPager.originalFrame = topPager.frame
sk.topbarbgr.originalFrame = sk.topbarbgr.frame

datePager = new PageComponent
	y: 137
	width: Screen.width
	
datePager.content.backgroundColor = noColor
datePager.scrollVertical = false
datePagerDummy = new Layer
	width: Screen.width * 3
	backgroundColor: noColor
	superLayer: datePager.content
datePager.originalFrame = datePager.frame
sk.datatoday.superLayer = datePager.content
sk.datatoday.y = 18
sk.datayesterday.superLayer = datePager.content
sk.datayesterday.y = 18
sk.datanext.superLayer = datePager.content
sk.datanext.y = 18

sk.dateback.originalFrame = sk.dateback.frame
sk.datefow.originalFrame = sk.datefow.frame
sk.pagecontrol.originalFrame = sk.pagecontrol.frame

mainscreenCompact = false

sk.topbarbgr.on "change:y", ->
	#print @.y
	topPager.opacity = (300 + @.y) / 300
	topPager.y = topPager.originalFrame.y + @.y / 2
	datePager.opacity = (300 + @.y) / 300
	datePager.y = datePager.originalFrame.y + @.y / 3
	sk.pagecontrol.opacity = (300 + @.y) / 300
	sk.pagecontrol.y = sk.pagecontrol.originalFrame.y + @.y / 2
	sk.dateback.opacity = (300 + @.y) / 300
	sk.dateback.y = sk.dateback.originalFrame.y + @.y / 3
	sk.datefow.opacity = (300 + @.y) / 300
	sk.datefow.y = sk.datefow.originalFrame.y + @.y / 3
	
	

scroller.on Events.Scroll, ->
	if scroller.content.y < 0 && scroller.content.y > -580
		sk.topbarbgr.y = sk.topbarbgr.originalFrame.y + scroller.content.y
		
scroller.on Events.ScrollEnd, ->
	if scroller.content.y < -290 && scroller.content.y > -580
		sk.topbarbgr.animate
			properties:
				y: -580
		scroller.content.animate
			properties:
				y: -580
		mainscreenCompact = true
	else if scroller.content.y < -580
		sk.topbarbgr.animate
			properties:
				y: -580
		mainscreenCompact = true
	else if scroller.content.y > -290 && scroller.content.y < 0
		sk.topbarbgr.animate
			properties:
				y: 0
		scroller.content.animate
			properties:
				y: 0
		mainscreenCompact = false
	else if scroller.content.y > 0
		sk.topbarbgr.animate
			properties:
				y: 0
		mainscreenCompact = false


achievementsBar = new Layer
	width: 500
	height: 90
	midX: Screen.width/2
	y: 40
	backgroundColor: noColor

sk.achievements.superLayer = achievementsBar
sk.progressbar.superLayer = achievementsBar
sk.achievements.center()
sk.progressbar.center()







	