import nico
import fixedGrid
import unit

const 
  orgName = "pixelsane"
  appName = "mxn"

const 
  gunslinger = 0
  fencer = 1
  lerpSpeed = 0.2
  gridPxW = 32
  gridPxH = 32

type 
  Settings = object
    showLoadout* : bool
    loadoutX : float32
    loadoutY : float32

  Clickable* = object
    x0*: float32
    y0*: float32
    x1*: float32
    y1*: float32
  
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
    hovering = 
      mx >= showButton.x0 and mx < showButton.x1 and
      my >= showButton.y0 and my < showButton.y1

  if hovering and mousebtnp(0): settings.showLoadout = not settings.showLoadout

proc gameInit() =
  setPalette (loadPaletteFromGPL "ayy4.gpl")
  loadFont(0, "font.png")
  loadSpritesheet 0, "bg.png", 130, 130
  loadSpritesheet 1, "units.png", 32, 32
  loadSpritesheet 2, "loadoutscreen.png", 130, 130

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

proc gameUpdate(dt: float32) =
  updateLoadout()

proc gameDraw() =
  cls()
  drawScreen()

nico.init(orgName, appName)
nico.createWindow(appName, 130, 130, 4, true)
nico.run(gameInit, gameUpdate, gameDraw)
