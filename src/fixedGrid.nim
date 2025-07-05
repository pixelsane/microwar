const 
  EmptyID* = -1
  GridWidth* = 4
  GridHeight* = 4
  MaxCells* = GridWidth * GridHeight
  gridPxW* = 32
  gridPxH* = 32

# Add or remove types according to need
type 
  CellKind* = enum
    Player1
    Player2

  ID* = int

  Cell* = object 
    kind: CellKind
    occupant: ID

  GridMap* = array[MaxCells, Cell]

var
  gridMap*: GridMap

func xOf*(index: ID) : int = index mod GridWidth
func yOf*(index: ID) : int = index div GridHeight
func indexOf*(x: int, y: int) : int = y * GridWidth + x

proc assertIndex(index: int) = 
  assert index >= 0 and index < gridMap.len, "Index out of bounds"

proc kind*(index: int) : CellKind =
  assertIndex index
  return gridMap[index].kind

proc kindOf*(x: int, y: int) : CellKind =
  return kind(indexOf(x,y))

proc occupant*(index: int) : ID =
  assertIndex index
  return gridMap[index].occupant

proc occupantOf*(x: int, y: int) : ID =
  return occupant(indexOf(x,y))
proc getGridMap*(): var GridMap = gridMap

proc prepareGridMap(kind: CellKind) =
  for i in 0..<MaxCells:
    gridMap[i].kind = kind
    gridMap[i].occupant = EmptyID

proc prepareGrid*(kind: CellKind) = 
  prepareGridMap(kind)
  
proc changeKindByIndex*(kind: CellKind, index: int) =
  assertIndex index
  gridMap[index].kind = kind

proc changeKind*(kind: CellKind, x: int, y: int) = changeKindByIndex(kind, indexOf(x, y))

proc changeOccupantByIndex*(occupant: ID, index: int) =
  assertIndex index
  gridMap[index].occupant = occupant

proc changeOccupant*(occupant: ID, x: int, y: int) = changeOccupantByIndex(occupant, indexOf(x, y))

proc moveOccupantUpByIndex*(index: int, clearValue: ID = EmptyID) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)

  if y - 1 < 0:
    return false

  let 
    targetIndex = indexOf(x, y - 1)
    occupantToMove = occupant(index)

  if occupantToMove == EmptyID:
    return false # no occupant to move

  gridMap[targetIndex].occupant = occupantToMove
  gridMap[index].occupant = clearValue

  return true

proc moveOccupantDownByIndex*(index: int, clearValue: ID = EmptyID) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)

  if y + 1 >= GridHeight:
    return false

  let 
    targetIndex = indexOf(x, y + 1)
    occupantToMove = occupant(index)

  if occupantToMove == EmptyID:
    return false # no occupant to move

  gridMap[targetIndex].occupant = occupantToMove
  gridMap[index].occupant = clearValue

  return true

proc moveOccupantLeftByIndex*(index: int, clearValue: ID = EmptyID) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)
  
  if x - 1 < 0:
    return false

  let 
    targetIndex = indexOf(x - 1, y)
    occupantToMove = occupant(index)

  if occupantToMove == EmptyID:
    return false

  gridMap[targetIndex].occupant = occupantToMove
  gridMap[index].occupant = clearValue

  return true

proc moveOccupantRightByIndex*(index: int, clearValue: ID = EmptyID) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)

  if x + 1 >= GridWidth:
    return false

  let 
    targetIndex = indexOf(x + 1, y)
    occupantToMove = occupant(index)

  if occupantToMove == EmptyID:
    return false # no occupant to move

  gridMap[targetIndex].occupant = occupantToMove
  gridMap[index].occupant = clearValue

  return true

proc moveOccupantUp*(x: int, y: int, clearValue: ID = EmptyID) : bool =
  return moveOccupantUpByIndex(indexOf(x, y), clearValue)

proc moveOccupantDown*(x: int, y: int, clearValue: ID = EmptyID) : bool =
  return moveOccupantDownByIndex(indexOf(x, y), clearValue)

proc moveOccupantLeft*(x: int, y: int, clearValue: ID = EmptyID) : bool =
  return moveOccupantLeftByIndex(indexOf(x, y), clearValue)

proc moveOccupantRight*(x: int, y: int, clearValue: ID = EmptyID) : bool =
  return moveOccupantRightByIndex(indexOf(x, y), clearValue)

# Swap functions by index - swaps occupants between two adjacent cells
proc swapOccupantsUpByIndex*(index: int) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)
  
  if y - 1 < 0:
    return false # can't swap with cell above top row
  
  let 
    targetIndex = indexOf(x, y - 1)
    sourceOccupant = occupant(index)
    targetOccupant = occupant(targetIndex)
  
  gridMap[index].occupant = targetOccupant
  gridMap[targetIndex].occupant = sourceOccupant
  
  return true

proc swapOccupantsDownByIndex*(index: int) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)
  
  if y + 1 >= GridHeight:
    return false # can't swap with cell below bottom row
  
  let 
    targetIndex = indexOf(x, y + 1)
    sourceOccupant = occupant(index)
    targetOccupant = occupant(targetIndex)
  
  gridMap[index].occupant = targetOccupant
  gridMap[targetIndex].occupant = sourceOccupant
  
  return true

proc swapOccupantsLeftByIndex*(index: int) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)
  
  if x - 1 < 0:
    return false # can't swap with cell left of leftmost column
  
  let 
    targetIndex = indexOf(x - 1, y)
    sourceOccupant = occupant(index)
    targetOccupant = occupant(targetIndex)
  
  gridMap[index].occupant = targetOccupant
  gridMap[targetIndex].occupant = sourceOccupant
  
  return true

proc swapOccupantsRightByIndex*(index: int) : bool =
  assertIndex index
  let 
    x = xOf(index)
    y = yOf(index)
  
  if x + 1 >= GridWidth:
    return false # can't swap with cell right of rightmost column
  
  let 
    targetIndex = indexOf(x + 1, y)
    sourceOccupant = occupant(index)
    targetOccupant = occupant(targetIndex)
  
  gridMap[index].occupant = targetOccupant
  gridMap[targetIndex].occupant = sourceOccupant
  
  return true

# Swap functions by coordinates - convenience wrappers
proc swapOccupantsUp*(x: int, y: int) : bool =
  return swapOccupantsUpByIndex(indexOf(x, y))

proc swapOccupantsDown*(x: int, y: int) : bool =
  return swapOccupantsDownByIndex(indexOf(x, y))

proc swapOccupantsLeft*(x: int, y: int) : bool =
  return swapOccupantsLeftByIndex(indexOf(x, y))

proc swapOccupantsRight*(x: int, y: int) : bool =
  return swapOccupantsRightByIndex(indexOf(x, y))

proc cellOfByIndex*(index: int) : var Cell = gridMap[index]
proc cellOf*(x: int, y: int) : var Cell = cellOfByIndex(indexOf(x,y))

proc indexRightOf*(x: int, y: int, amount: int = 1) : int =
  if x+1 > GridWidth:
    result = -1 # no valid cell
  else:
    result = indexOf(x+amount, y)

proc indexLeftOf*(x: int, y: int, amount: int = 1) : int =
  if x-1 < 0:
    result = -1 # no valid cell
  else:
    result = indexOf(x-amount, y)

proc indexAboveOf*(x: int, y: int, amount: int = 1): int =
  if y + 1 > GridHeight:
    result = -1 # no valid cell
  else:
    result = indexOf(x, y - amount)

proc indexBelowOf*(x: int, y: int, amount: int = 1): int =
  if y + 1 > GridHeight:
    result = -1 # no valid cell
  else:
    result = indexOf(x, y + amount)

proc aboveOf*(x: int, y: int, amount: int = 1): Cell =
  cellOf x, y - amount

proc belowOf*(x: int, y: int, amount: int = 1): Cell =
  cellOf x, y + amount

template cellAbove*(index: SomeInteger, amount: SomeInteger = 1) : untyped =
  index - (GridWidth * amount)

template cellBelow*(index: SomeInteger, amount: SomeInteger = 1) : untyped =
  index + (GridWidth * amount)

template cellLeft*(index: SomeInteger, amount: SomeInteger = 1): untyped =
  index - amount

template cellRight*(index: SomeInteger, amount: SomeInteger = 1): untyped =
  index + amount

proc isOutOfBounds*(x:int, y:int) : bool =
  if x > GridWidth or x < 0 or 
  y > GridHeight or y < 0: 
    result = true
  else:
    result = false

proc clearColumn*(row: int, clearKind: CellKind) =
  let
    startingColumn = row * GridWidth
    endingColumn = (row * GridWidth) + GridWidth

  for i in startingColumn ..< endingColumn:
    changeKindByIndex clearKind, i
    changeOccupantByIndex EmptyID, i
