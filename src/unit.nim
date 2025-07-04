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

proc doesUnitExist*(i: int32): bool = i in pool

proc unitByTID*(tid: int32): Unit = unitTemplates[tid]

proc unitByID*(id:int32) : Unit =
  if id in pool: return pool[id]

proc addUnit*(unitID: int32, templateID: int32, ownerID: int32 = 0) =
  let newUnit = unitByTID(templateID)
  pool[unitID] = newUnit
  pool[unitID].ownerID = ownerID
  if ownerID == 0:
      loadoutOrder.add(unitID)

proc removeUnit*(unitID: int32) =
  if unitID in pool:
    pool.del unitID

proc damageUnit*(id: int32, amount: float32) =
  if id in pool:
    pool[id].health -= amount

proc drawUnitCursor*(settings: Settings) =
  if not settings.placingUnit: return
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
    (mx, my) = mouse()

  var displayIndex = 0  # Track position for display purposes

  for i, id in loadoutOrder:
    if id notin pool: continue

    let unit = pool[id]

    # Only show units owned by player (ownerID = 0)
    if unit.ownerID != 0: continue

    let
      col = displayIndex mod maxPerRow
      row = displayIndex div maxPerRow
      x = offsetX + settings.loadoutX + (col * spacingX)
      y = offsetY + settings.loadoutY + (row * spacingY)

      button = Clickable(x0: x, y0: y, x1: x + 32, y1: y + 32)
      hovering = isOverlapping(mx, my, button)

    if hovering and mousebtnpr(0) and settings.loadoutX <= 1.0:
      for otherID in loadoutOrder:
        if otherID notin pool: continue
        pool[otherID].selected = false
      pool[id].selected = true

    spr unit.sprID, x, y
    displayIndex += 1  # Only increment for units that are actually displayed

proc unselectUnit* =
  for id, unit in pool:
    if unit.selected:
      pool[id].ownerID = -1
      pool[id].selected = false


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
