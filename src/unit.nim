import nico
import std/tables
import settingsHandler

type
  Unit* = object
    health*: float32
    sprID*: int32
    ownerID*: int32
    selected*: bool

const
  GunslingerID* = 0
  FencerID*     = 1

let unitTemplates* = @[
  Unit(health: 100.0, sprID: 0, ownerID: -1),  # Gunslinger
  Unit(health: 100.0, sprID: 1, ownerID: -1)   # Fencer
]

var pool: Table[int32, Unit] = initTable[int32, Unit]()
var loadoutOrder*: seq[int32] = @[]

proc unitById*(id: int32): Unit = unitTemplates[id]

proc addUnit*(unitID: int32, templateID: int32) =
  let newUnit = unitById(templateID)
  pool[unitID] = newUnit
  loadoutOrder.add(unitID)

proc removeUnit*(unitID: int32) =
  if unitID in pool:
    pool.del unitID

proc damageUnit*(id: int32, amount: float32) =
  if id in pool:
    pool[id].health -= amount

proc drawGridUnits*(settings: Settings) =
  discard

proc drawUnitCursor*(settings: Settings) =
  if settings.unitToPlace notin pool: return
  let
    cellTarget = cellClickable(cellUnderMouse())
    unit = pool[settings.unitToPlace]
    (mx, my) = mouse()

  if isOverlapping(mx, my, cellTarget):
    spr unit.sprID, cellTarget.x0, cellTarget.y0

proc drawLoadoutUnits*(settings: Settings) =
  setSpritesheet 1
  let 
    spacingX = 15
    spacingY = 35
    offsetX = 7
    offsetY = -7
    maxPerRow = 7

  let (mx, my) = mouse()

  for i, id in loadoutOrder:
    if id notin pool: continue

    let
      unit = pool[id]
      col = i mod maxPerRow
      row = i div maxPerRow
      x = offsetX + settings.loadoutX + (col * spacingX)
      y = offsetY + settings.loadoutY + (row * spacingY)
      (mx, my) = mouse()

      button = Clickable(x0: x, y0: y, x1: x + 32, y1: y + 32)
      hovering = isOverlapping(mx, my, button)

    if hovering and mousebtnpr(0) and settings.loadoutX <= 1.0:
      for otherID in loadoutOrder:
        pool[otherID].selected = false
      pool[id].selected = true

    spr unit.sprID, x, y

proc selectedUnit*: int =
  for id, unit in pool:
    if unit.selected:
      return id
  return -1

proc loadoutSelection*(settings: Settings) =
  let selected = selectedUnit()
  if selected > -1:
    enableUnitPlacement settings, selected

proc loadoutShowHide*(settings: Settings) =
  let 
    (mx,my) = mouse()
    showButton = Clickable(
      x0: settings.loadoutX, y0: settings.loadoutY,
      x1: settings.loadoutX + 10, y1: settings.loadoutY + 18)
    hovering = isOverlapping(mx, my, showButton)

  if hovering and mousebtnpr(0): settings.showLoadout = not settings.showLoadout
