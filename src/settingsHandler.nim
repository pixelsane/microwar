import nico, nico/vec, fixedGrid

const 
  lerpSpeed = 0.2

type
  Settings* = ref object
    showLoadout* : bool
    loadoutX* : float32
    loadoutY*: float32
    placingUnit*: bool
    unitToPlace*: int
    hoveringOnCell*: int

  Clickable* = object
    x0*: float32
    y0*: float32
    x1*: float32
    y1*: float32

func isOverlapping*(x: float32, y: float32, b: Clickable): bool =
  return
      x >= b.x0 and x < b.x1 and
      y >= b.y0 and y < b.y1

proc cellBorder*(x: float32, y: float32): Vec2 =
    return vec2f(
      x: (x mod GridWidth) * gridPxW,
      y: (y div GridWidth) * gridPxH)

proc cellUnderMouse*: int =
  for i in 0 ..< MaxCells:
    let
      x : float32 = ((i mod GridWidth) * gridPxW)
      y : float32 = (i div GridWidth) * gridPxH
      (mx, my) = mouse()

    let button = Clickable(
        x0: x, y0: y,
        x1: x + gridPxW, y1: y + gridPxH)

    if isOverlapping(mx,my,button): return i

proc cellClickable*(target: int): Clickable =
  for i in 0 ..< MaxCells:
    let
      x : float32 = ((i mod GridWidth) * gridPxW)
      y : float32 = (i div GridWidth) * gridPxH

    let button = Clickable(
        x0: x, y0: y,
        x1: x + gridPxW, y1: y + gridPxH)

    if i == target: return button


proc storeCellUnderMouse*(s: Settings) =
  s.hoveringOnCell = cellUnderMouse()

#move to unit
proc enableUnitPlacement*(s: Settings, selected: int) = 
  s.showLoadout = false
  s.placingUnit = true
  s.unitToPlace = selected

proc drawLoadoutScreen*(s: Settings) =
  let 
    isShown = s.showLoadout
    targetX = if isShown: 0 else: 120

  s.loadoutX = lerp(s.loadoutX, targetX, lerpSpeed)

  setSpritesheet 2
  spr 0, s.loadoutX, 0
