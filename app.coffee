# This imports all the layers for "fooddiary-protomore" into fooddiaryProtomoreLayers5
sk = Framer.Importer.load "imported/fooddiary-protomore"
noColor = "rgba(0,0,0,0)"
Framer.Defaults.Animation =
	curve:"ease-in-out"
	time:0.4

navWrapper = new Layer
	y: Screen.height - 130
	height: 130
	width: Screen.width
	backgroundColor: noColor
	superLayer: null

navWrapper.states.add
	hidden: {y: Screen.height}

sk.tabNav = sk.tabNav
sk.tabNav.y = Screen.height - sk.tabNav.height
sk.tabNav.superLayer = null
navWrapper.addSubLayer(sk.tabNav)
sk.tabNav.x = 0
sk.tabNav.y = navWrapper.height - sk.tabNav.height
navWrapper.bringToFront()

sk.tabNav.states.add
	hidden: { y: Screen.height + sk.tabNav.height }



scroller = new ScrollComponent
	width: Screen.width
	height: Screen.height
scroller.scrollHorizontal = false
sk.mainContent.superLayer = scroller.content
scroller.contentInset = {
    top: 0
    bottom: 0
    right: 0
    left: 0
}
scroller.superLayer = sk.mainscreen
scroller.sendToBack()


bgr = new BackgroundLayer
	backgroundColor: "F0F0F0"



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
toppagerdummy = new Layer
	x: Screen.width
	width: Screen.width
	y: 0
	backgroundColor: noColor
	superLayer: topPager.content
topPager.content.backgroundColor = noColor
topPager.scrollVertical = false
sk.calstats.superLayer = topPager.content
sk.calstats.y = 0
sk.weight.superLayer = topPager.content
sk.weight.y = 0
topPager.originalFrame = topPager.frame
sk.topbarbgr.originalFrame = sk.topbarbgr.frame

sk.pgone.states.add
	transp: {opacity: 0.2}
sk.pgtwo.states.add
	transp: {opacity: 0.2}
sk.pgtwo.states.switchInstant("transp")

topPager.content.on "change:x", ->
	if @.x < -Screen.width/2
		sk.pgone.states.switchInstant("transp")
		sk.pgtwo.states.switchInstant("default")
	else
		sk.pgone.states.switchInstant("default")
		sk.pgtwo.states.switchInstant("transp")

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

datePager.superLayer = sk.mainscreen

sk.dateback.originalFrame = sk.dateback.frame
sk.datefow.originalFrame = sk.datefow.frame
sk.pagecontrol.originalFrame = sk.pagecontrol.frame

mainscreenCompact = false

topPager.superLayer = sk.topbarbgr
sk.pagecontrol.superLayer = sk.topbarbgr
sk.topbarbgr.clip = true

sk.topbarbgr.on "change:y", ->
	#print @.y
	topPager.opacity = (300 + @.y) / 300
	topPager.y = topPager.originalFrame.y - @.y / 2
	datePager.opacity = (300 + @.y) / 300
	datePager.y = datePager.originalFrame.y + @.y / 3
	sk.pagecontrol.opacity = (300 + @.y) / 300
	sk.pagecontrol.y = sk.pagecontrol.originalFrame.y - @.y / 2
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
		showbar()
	else if scroller.content.y < -580
		sk.topbarbgr.animate
			properties:
				y: -580
		mainscreenCompact = true
		showbar()
	else if scroller.content.y > -290 && scroller.content.y < 0
		sk.topbarbgr.animate
			properties:
				y: 0
		scroller.content.animate
			properties:
				y: 0
		mainscreenCompact = false
		hidebar()
	else if scroller.content.y > 0
		sk.topbarbgr.animate
			properties:
				y: 0
		mainscreenCompact = false
		hidebar()


achievementsBar = new Layer
	width: 500
	height: 180
	midX: Screen.width/2
	y: 40
	backgroundColor: noColor
	superLayer: sk.mainscreen

sk.achievements.superLayer = achievementsBar
sk.progressbar.superLayer = achievementsBar
sk.achievements.center()
sk.achievements.y -= achievementsBar.height/4
sk.progressbar.center()
sk.progressbar.y += achievementsBar.height/4

achievementsBar.states.add
	ach: { y: achievementsBar.y }
	prog: { y: achievementsBar.y - achievementsBar.height/2 }

achievementsBar.states.animationOptions =
	curve: "spring(600,30,0)"
	time: 0.2

showbar = () ->
	sk.progressbar.animate
		properties:
			opacity: 1
	sk.achievements.animate
		properties:
			opacity: 0
	achievementsBar.states.switch("prog")
	
hidebar = () ->
	sk.progressbar.animate
		properties:
			opacity: 0
	sk.achievements.animate
		properties:
			opacity: 1
		achievementsBar.states.switch("ach")
	

# ADD SCREEN ANIMATION

addButton = sk.bigplusbutton
addButton.superLayer = navWrapper
addButton.center()
addButton.bringToFront()
addButton.states.add
	close: {rotation: 45}
addButton.states.animationOptions = 
	curve: "spring(600,30,0)"

sk.shortcuts.visible = true
sk.shortcuts.opacity = 0
sk.shortcuts.center()
sk.shortcuts.states.add
	show: { opacity: 1 }

for button in sk.shbuttons.subLayers
	button.originalFrame = button.frame
	button.shown = false
	
shButtonsIn = () ->
	for i,button of sk.shbuttons.subLayers
		if !button.shown
			button.opacity = 0
			button.y = button.originalFrame.y + 80
			button.animate
				properties: 
					y: button.originalFrame.y
					opacity: 1
				delay: i * 0.05
			button.shown = true
		else
			button.animate
				properties: 
					y: button.originalFrame.y + 80
					opacity: 0
				delay: i * 0.05
			button.shown = false


addButton.on Events.TouchEnd, ->
	addButton.states.next()
	sk.tabNav.states.next()
	sk.shortcuts.states.next()
	shButtonsIn()


# CALENDAR
calbgr = new Layer
	width: Screen.width
	height: sk.topbarbgr.height
	backgroundColor: "rgba(0,0,0,0.95)"
	superLayer: sk.mainscreen
sk.calendar.superLayer = calbgr
sk.calendar.opacity = 1
calbgr.states.add
	hidden: { opacity: 0, y: -calbgr.height }
calbgr.states.switchInstant("hidden")
calbgr.states.animationOptions = 
	time: 0.4
	curve: "spring(200,23,0)"

sk.calicon.bringToFront()
sk.calicon.states.add
	hidden: { opacity: 0, rotation: -90 }

sk.closecalendar.bringToFront()
sk.closecalendar.states.add
	hidden: { opacity: 0, rotation: 90 }
sk.closecalendar.states.switchInstant("hidden")	
sk.profileicon.bringToFront()
achievementsBar.bringToFront()

switchCal = () ->
	calbgr.states.next()
	sk.calicon.states.next()
	sk.closecalendar.states.next()

sk.calicon.on Events.Click, ->
	switchCal()
	
calbgr.on Events.Click, ->
	switchCal()


# PROFILE SCREEN

sk.profile.x = Screen.width
sk.profile.y = 0

sk.profile.states.add
	shown: {x:0}

sk.mainscreen.states.add
	hidden: {x:-Screen.width}


sk.profileicon.on Events.Click, ->
	sk.mainscreen.states.switch("hidden")
	sk.profile.states.switch("shown")
	navWrapper.states.switch("hidden")
	
sk.profileback.on Events.Click, ->
	sk.mainscreen.states.switch("default")
	sk.profile.states.switch("default")
	navWrapper.states.switch("default")

profileScroll = new ScrollComponent
	width: Screen.width
	height: Screen.height

profileScroll.content.backgroundColor = noColor
profileScroll.superLayer = sk.profile
profileScroll.sendToBack()
profileScroll.scrollHorizontal = false
profileScroll.contentInset = {
    top: 0
    bottom: 100
    right: 0
    left: 0
}

sk.profilecontent.superLayer = profileScroll.content
sk.profiletop.originalFrame = sk.profiletop.frame
sk.profiletitle.superLayer = sk.profile

sk.photos.originalFrame = sk.photos.frame
sk.namePhoto.originalFrame = sk.namePhoto.frame

sk.profiletop.clip = true

sk.profiletop.on "change:y", ->
	#print @.y
	sk.photos.opacity = (300 + @.y) / 300
	sk.photos.y = sk.photos.originalFrame.y - @.y / 2
	sk.namePhoto.opacity = (300 + @.y) / 300
	sk.namePhoto.y = sk.namePhoto.originalFrame.y - @.y / 1.5


profileScroll.on Events.Scroll, ->
	if profileScroll.content.y < 0 && profileScroll.content.y > -580
		sk.profiletop.y = sk.profiletop.originalFrame.y + profileScroll.content.y
		
profileScroll.on Events.ScrollEnd, ->
	if profileScroll.content.y < -290 && profileScroll.content.y > -580
		sk.profiletop.animate
			properties:
				y: -580
		profileScroll.content.animate
			properties:
				y: -580
		
	else if profileScroll.content.y < -580
		sk.profiletop.animate
			properties:
				y: -580
		
	else if profileScroll.content.y > -290 && profileScroll.content.y < 0
		sk.profiletop.animate
			properties:
				y: 0
		profileScroll.content.animate
			properties:
				y: 0
		
	else if profileScroll.content.y > 0
		sk.profiletop.animate
			properties:
				y: 0
		




