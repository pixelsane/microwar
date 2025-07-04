import std/tables

type
  Unit* = object
    health*: float32
    sprID*: int32
    ownerID*: int32

let
  gunslinger = Unit(
    health: 100.0,
    sprID: 0,
    ownerID: -1)

  fencer = Unit(
    health: 100.0,
    sprID: 1,
    ownerID: -1)

var pool = initTable[int32, Unit]
var units: seq[Unit] = @[
  gunslinger,
  fencer
]

proc addUnit*() =
  discard
