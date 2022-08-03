import os
import "./path"

type
  Place* = distinct int
  Current* = object
    location*: Path
    locationHistory*: seq[Path]
    place*: Place

func initalize_state*(): Current {.noSideEffect, raises: [].} = Current(
  location: Path getHomeDir(),
  locationHistory: @[],
  place: Place 1
)
