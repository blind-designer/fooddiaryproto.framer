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
	height: Screen.height #- 300
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
	contentInset:
		right: 520
	
datePager.content.backgroundColor = noColor
datePager.scrollVertical = false
# datePagerDummy = new Layer
# 	width: Screen.width * 3
# 	backgroundColor: noColor
# 	superLayer: datePager.content
datePager.originalFrame = datePager.frame
sk.datatoday.superLayer = datePager.content
sk.datatoday.y = 18
#datePager.addPage(sk.datatoday)
sk.datayesterday.superLayer = datePager.content
sk.datayesterday.y = 18
#datePager.addPage(sk.datayesterday)
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

datePager.on "change:currentPage", ->
	topPager.opacity = 0.1
	scroller.opacity = 0.1
	scroller.animate
		properties:
			opacity:1
		delay: 0.15
	topPager.animate
		properties:
			opacity:1

datePagerNext = new Layer
	x: Screen.width - 88
	y: 142
	width: 88
	height: 88
	backgroundColor: noColor
	superLayer: sk.mainscreen

datePagerPrev = new Layer
	x: 0
	y: 142
	width: 88
	height: 88
	backgroundColor: noColor
	superLayer: sk.mainscreen

datePagerNext.on Events.Click, ->
	datePager.snapToNextPage()

datePagerPrev.on Events.Click, ->
	datePager.snapToPreviousPage()

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
	

# SHORTCUTS SCREEN 

sk.bigplusbutton.superLayer = navWrapper
sk.bigplusbutton.center()
sk.bigplusbutton.bringToFront()
sk.bigplusbutton.states.add
	close: {rotation: 45}
sk.bigplusbutton.states.animationOptions = 
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
				curve: "spring(300,20,0)"
				delay: i * 0.05
			button.shown = true
		else
			button.animate
				properties: 
					y: button.originalFrame.y + 80
					opacity: 0
				delay: i * 0.05
				curve: "spring(300,20,0)"
			button.shown = false

dumbShit = new Layer
	superLayer: navWrapper
	frame: sk.bigplusbutton.frame
	backgroundColor: noColor
	
dumbShit.on Events.Click, ->
	#print "click"
	sk.bigplusbutton.states.next()
	sk.tabNav.states.next()
	sk.shortcuts.states.next()
	shButtonsIn()

sk.shaddweight.on Events.Click, ->
	showAddWeight()
	sk.bigplusbutton.states.next()
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

calDumbShit = new Layer
	width: 88
	height: 88
	x: Screen.width - 88
	y: 40
	superLayer: sk.mainscreen
	backgroundColor: noColor


calDumbShit.on Events.Click, ->
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

profileDumbShit = new Layer
	y: 40
	width: 88
	height: 88
	superLayer: sk.profile
	backgroundColor: noColor

profileDumbShit.on Events.Click, ->
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
sk.profiletitle.opacity = 0
sk.profiletop.on "change:y", ->
	#print ((@.y + 576) / 576)
	sk.photos.opacity = (300 + @.y) / 300
	sk.photos.y = sk.photos.originalFrame.y - @.y / 2
	sk.namePhoto.opacity = (300 + @.y) / 300
	sk.profiletitle.opacity = 1 - ((@.y + 576) / 576)
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
		

# MAIN NAVIGATION
currentScreen = sk.mainscreen

activeNav = new Layer
	superLayer: sk.tabNav
	backgroundColor: "rgba(255,255,255,0.1)"
	x: 25
	y: sk.tabNav.height - 98
	height: 98

activeNav.states.add
	second: {x: 157}
	third: {x:483}
	fourth: {x:625}

activeNav.states.animationOptions = 
	curve: "spring(450,28,0)"

switchscreen = (screen) ->
	screen.visible = true
	screen.x = 0
	screen.y = 0
	screen.opacity = 0
	screen.placeBehind(sk.shortcuts)
	screen.animate
		properties:
			opacity: 1
		time: 0.2
	Utils.delay 0.2, ->
		currentScreen.visible = false
		currentScreen = screen

sk.homeicon.on Events.Click, ->
	activeNav.states.switch("default")
	switchscreen(sk.mainscreen)

sk.navfood.on Events.Click, ->
	activeNav.states.switch("second")
	switchscreen(sk.recipes)

sk.navnotebook.on Events.Click, ->
	activeNav.states.switch("third")
	switchscreen(sk.ration)
	
sk.navinfo.on Events.Click, ->
	activeNav.states.switch("fourth")
	switchscreen(sk.infoscreen)
	
# RECIPES SCREEN

recipesScroller = new ScrollComponent
	width: Screen.width
	height: Screen.height
	superLayer: sk.recipes
	scrollHorizontal: false

recipesScroller.content.backgroundColor = noColor
recipesScroller.sendToBack()
sk.recscroll.superLayer = recipesScroller.content

recipesPager = new PageComponent
	y: 280
	height: 545
	width: Screen.width
	superLayer: sk.recipes
	scrollVertical: false
	contentInset:
		right: 300
recipesPager.originalFrame = recipesPager.frame
recipesPager.placeBehind(sk.recnav)

recipesScroller.content.on "change:y", ->
	recipesPager.y = recipesPager.originalFrame.y + @.y
#recipesPager.content.backgroundColor = noColor
#sk.recpager.superLayer = recipesPager.content
sk.recpager.y = 0
recipesPager.addPage(sk.recpager)
#sk.recpager.y = 0
#sk.recpagertwo = sk.recpager.copy()
#sk.recpagertwo.superLayer = recipesPager.content
sk.recpagertwo.y = 0
#sk.recpagertwo.x = sk.recpagertwo.width + 80
#sk.recpagertwo.y = sk.recpager.y
recipesPager.addPage(sk.recpagertwo)
sk.recpagertwo.x += 60

sk.recpagerthree = sk.recpager.copy()
sk.recpagerthree.y = 0
#sk.recpagerthree.superLayer = recipesPager.content

#sk.recpagerthree.x = (sk.recpagerthree.width + 63)*2
recipesPager.addPage(sk.recpagerthree)
sk.recpagerthree.x += 60


# RATION SCREEN

rationScroller = new ScrollComponent
	width: Screen.width
	height: Screen.height
	superLayer: sk.ration
	scrollHorizontal: false

rationScroller.content.backgroundColor = noColor
rationScroller.sendToBack()

sk.ratscroll.superLayer = rationScroller.content

# INFO SCREEN

infoScroller = new ScrollComponent
	width: Screen.width
	height: Screen.height
	superLayer: sk.infoscreen
	scrollHorizontal: false

infoScroller.content.backgroundColor = noColor
infoScroller.sendToBack()

sk.infoscroll.superLayer = infoScroller.content


# ADD WEIGHT SCREEN
sk.addweightscreen.x = 0
sk.addweightscreen.y = 0
sk.addweightcontent.cornerRadius = 14
sk.addweightcontent.clip = true
sk.addweightscreen.bringToFront()
sk.addweightscreen.visible = false

addweightVisible = false

showAddWeight = () ->
	addweightVisible = true
	sk.addweightscreen.visible = true
	sk.addweightbgr.opacity = 0
	sk.addweightbgr.animate
		properties:
			opacity: 1
			
	sk.addweightcontent.scale = 0.7
	sk.addweightcontent.opacity = 0
	sk.addweightcontent.animate
		properties:
			opacity: 1
			scale: 1
		curve: "spring(450,20,0)"
		
hideAddWeight = () ->
	addweightVisible = false
	sk.addweightbgr.animate
		properties:
			opacity: 0
			
	sk.addweightcontent.animate
		properties:
			opacity: 0
			scale: 0.7
		curve: "spring(450,20,0)"

sk.addweightbgr.on Events.AnimationEnd, ->
	if !addweightVisible 
		sk.addweightscreen.visible = false
		
sk.addweightbgr.on Events.Click, ->
	hideAddWeight()
