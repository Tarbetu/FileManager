import os

type
  Path* = distinct string
  Place* = distinct int
  Current* = object
    location*: Path
    locationHistory*: seq[Path]
    place*: Place

iterator items*(location: Path): Path {.raises: [OSError].} =
  for file in location.string.walkDir:
    yield Path file.path

func initalize_state*(): Current {.noSideEffect, raises: [].} = Current(
  location: Path getHomeDir(),
  locationHistory: @[],
  place: Place 1
)
