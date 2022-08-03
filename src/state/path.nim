import os
import sugar
import strformat

type Path* = distinct string

iterator items*(location: Path): Path {.raises: [OSError].} =
  for file in location.string.walkDir:
    yield Path file.path

proc isDir*(path: Path): bool {.raises: [OSError].} =
  let fileKind = path.string.getFileInfo.kind
  [pcDir, pcLinkToDir].contains fileKind

proc isExecutable*(path: Path): bool {.raises: [OSError].} =
  let filePermissions = path.string.getFileInfo.permissions
  let execPermissions = collect:
    for i in filePermissions:
      if i in [fpUserExec, fpGroupExec, fpOthersExec]: i
  execPermissions.len > 0

proc absolutePath*(path: Path): Path =
  let absPath = path.string.absolutePath
  Path absPath

proc `$`(path: Path): string =
    path.string

proc runExecutable*(path: Path) =
  let absPath = absolutePath path
  discard execShellCmd &"/{absPath}"

proc runFile*(path: Path) =
  let absPath = absolutePath path
  discard execShellCmd &"xdg-open {absPath}"
