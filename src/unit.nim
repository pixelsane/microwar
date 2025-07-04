import nico
import std/tables
import settingsHandler

type
  Unit* = object
    health*: float32
    sprID*: int32
    ownerID*: int32
    selected: bool

const
  GunslingerID* = 0
  FencerID*     = 1

let unitTemplates* = @[
  Unit(health: 100.0, sprID: 0, ownerID: -1),  # Gunslinger
  Unit(health: 100.0, sprID: 1, ownerID: -1)   # Fencer
]

var pool: Table[int32, Unit] = initTable[int32, Unit]()

proc getPool* : Table[int32, Unit] = pool

proc unitById*(id: int32): Unit = unitTemplates[id]

proc addUnit*(unitID: int32, templateID: int32) =
  let newUnit = unitById(templateID)
  pool[unitID] = newUnit

proc damageUnit*(id: int32, amount: float32) =
  if id in pool:
    pool[id].health -= amount

proc drawLoadoutUnits*(settings: Settings) =
  setSpritesheet 1
  let 
    spacingX = 15
    spacingY = 20
    offsetX = 7
    offsetY = -7
    maxPerRow = 7

  for id, unit in pool:
    let
      col = id mod maxPerRow
      row = id div maxPerRow
      x = offsetX + settings.loadoutX + (col * spacingX)
      y = offsetY + settings.loadoutY + (row * spacingY)
    spr unit.sprID, x, y
