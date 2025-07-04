import std/tables
import std/sequtils

type
  Unit* = object
    health*: float32
    sprID*: int32
    ownerID*: int32

const
  GunslingerID* = 0
  FencerID*     = 1

let unitTemplates* = @[
  Unit(health: 100.0, sprID: 0, ownerID: -1),  # Gunslinger
  Unit(health: 100.0, sprID: 1, ownerID: -1)   # Fencer
]

var pool*: Table[int32, Unit]

proc unitById*(id: int32): Unit = unitTemplates[id]

proc addUnit*(unitID: int32, templateID: int32): int32 =
  let newUnit = unitById(templateID)
  pool[unitID] = newUnit
  return unitID

proc damageUnit*(id: int32, amount: float32) =
  if id in pool:
    pool[id].health -= amount
