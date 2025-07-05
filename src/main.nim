import nico
import fixedGrid
import unit, settingsHandler
import turnController

const 
  orgName = "pixelsane"
  appName = "microwar"
 
var 
  phase : TurnState = Begin
  settings = Settings(
    showLoadout: false,
    loadoutX: 120,
    loadoutY: 22,
    placingUnit: false,
    unitToPlace: -1)

proc resetUnitEvents =
  unselectUnit()
  settings.unitToPlace = -1
  settings.placingUnit = false

# migrate these procs later to unit once we figure the import order
proc placeUnit*() =
  if settings.unitToPlace < 0: return
  if settings.placingUnit and settings.loadoutX > 118 and mousebtnpr(0) and not(settings.showLoadout):
    if occupant(settings.hoveringOnCell) > -1 or kind(settings.hoveringOnCell) != Player1: return

    changeOccupantByIndex settings.unitToPlace, settings.hoveringOnCell

    resetUnitEvents()
    settings.showLoadout = true

proc drawGridUnits*() =
  setSpritesheet 1
  let grid = getGridMap()
  for i in 0 ..< grid.len:
    let occupantID = occupant(i)
    if occupantID == EmptyID: continue
    if not doesUnitExist(occupantID) or occupantID <= -1: continue
    else:
      let 
        unit = unitByID(occupantID)
        pos = cellClickable(i)  # Use i, not occupantID!
      
      spr unit.sprID, pos.x0, pos.y0


proc resetBattleField =
  clearColumn 0, Player2
  clearColumn 1, Player2
  clearColumn 2, Player1
  clearColumn 3, Player1

proc updateLoadout =
  loadoutShowHide settings
  loadoutSelection settings

proc gameInit() =
  setPalette (loadPaletteFromGPL "ayy4.gpl")
  loadFont(0, "font.png")
  loadSpritesheet 0, "bg.png", 130, 130
  loadSpritesheet 1, "units.png", 32, 32
  loadSpritesheet 2, "loadoutscreen.png", 130, 130
  prepareGrid Player1
  resetBattleField()
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
      (mx, my) = mouse()

    let button = Clickable(
        x0: x, y0: y,
        x1: x + gridPxW, y1: y + gridPxH)

    rrect x, y, gridPxW + x, gridPxH + y, roundness

    if settings.placingUnit and kind(i) != Player1:
      hideMouse()
      setColor 2
      rrectFill x, y, gridPxW + x, gridPxH + y, roundness
      setColor 4
    elif settings.placingUnit and isOverlapping(mx, my, button):
      setColor 4
      hideMouse()
      rrectFill x, y, gridPxW + x, gridPxH + y, roundness

proc drawBG =
  setSpritesheet 0
  spr 0, 0, 0

proc drawScreen =
  showMouse()
  drawBG()
  drawGrid()
  drawGridUnits()
  drawLoadoutScreen settings
  drawLoadoutUnits settings
  drawUnitCursor settings

proc resolveEventListen =
  if resolveBtnPr(settings): 
    settings.showLoadout = false
    phase = Resolve

proc gameUpdate(dt: float32) =
  storeCellUnderMouse settings
  case phase
  of Begin:
    resolveEventListen()
    updateLoadout()
    placeUnit()
  of Resolve:
    resolveActions()
    phase = End
  else:
    echo "End Phase"
    phase = Begin

proc gameDraw() =
  cls()
  drawScreen()

nico.init(orgName, appName)
nico.createWindow(appName, 130, 130, 4, true)
nico.run(gameInit, gameUpdate, gameDraw)
