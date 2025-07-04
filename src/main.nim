import nico
import fixedGrid
import unit, settingsHandler

const 
  orgName = "pixelsane"
  appName = "microwar"

const 
  lerpSpeed = 0.2
  gridPxW = 32
  gridPxH = 32
 
var settings = Settings(
  showLoadout: false,
  loadoutX: 120,
  loadoutY: 22)

proc updateLoadout =
  let 
    (mx,my) = mouse()
    showButton = Clickable(
      x0: settings.loadoutX, y0: settings.loadoutY,
      x1: settings.loadoutX + 10, y1: settings.loadoutY + 18)
    hovering = isOverlapping(mx, my, showButton)

  if hovering and mousebtnpr(0): settings.showLoadout = not settings.showLoadout

proc gameInit() =
  setPalette (loadPaletteFromGPL "ayy4.gpl")
  loadFont(0, "font.png")
  loadSpritesheet 0, "bg.png", 130, 130
  loadSpritesheet 1, "units.png", 32, 32
  loadSpritesheet 2, "loadoutscreen.png", 130, 130
  addUnit 0, 0
  addUnit 1, 0
  addUnit 2, 1
  addUnit 3, 1

proc drawGrid =
  setColor 4
  let roundness = 12
  for i in 0 ..< MaxCells:
    let
      x : float32 = ((i mod GridWidth) * gridPxW)
      y : float32 = (i div GridWidth) * gridPxH
    rrect x, y, gridPxW + x, gridPxH + y, roundness

proc drawBG =
  setSpritesheet 0
  spr 0, 0, 0

proc drawLoadoutScreen =
  let 
    isShown = settings.showLoadout
    targetX = if isShown: 0 else: 120

  settings.loadoutX = lerp(settings.loadoutX, targetX, lerpSpeed)

  let showButton = Clickable(
    x0: settings.loadoutX, y0: settings.loadoutY,
    x1: settings.loadoutX + 10, y1: settings.loadoutY + 18)
  # DEBUG: rectFill showButton.x0, showButton.y0, showButton.x1, showButton.y1

  setSpritesheet 2
  spr 0, settings.loadoutX, 0

proc drawScreen =
  drawBG()
  drawGrid()
  drawLoadoutScreen()
  drawLoadoutUnits settings

proc gameUpdate(dt: float32) =
  updateLoadout()
  let selected = selectedUnit()
  if selected > -1:
    settings.showLoadout = false
    

proc gameDraw() =
  cls()
  drawScreen()

nico.init(orgName, appName)
nico.createWindow(appName, 130, 130, 4, true)
nico.run(gameInit, gameUpdate, gameDraw)
