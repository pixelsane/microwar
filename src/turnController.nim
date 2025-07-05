type 
  Direction* = enum North, South, West, East

  TurnState* = enum
    Begin
    Resolve
    End

  ActionType* = enum
    AttackMelee
    AttackShoot
    Move
    Face

  Action* = object
    actionType*: ActionType
    direction*: Direction
    cost*: int

func moveAction*(dir: Direction) : Action =
  return Action(
    actionType: Move,
    direction: dir,
    cost: 5)
