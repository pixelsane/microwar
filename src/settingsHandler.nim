type
  Settings* = object
    showLoadout* : bool
    loadoutX* : float32
    loadoutY*: float32

  Clickable* = object
    x0*: float32
    y0*: float32
    x1*: float32
    y1*: float32

proc isOverlapping*(x: float32, y: float32, b: Clickable): bool =
  return
      x >= b.x0 and x < b.x1 and
      y >= b.y0 and y < b.y1

  

