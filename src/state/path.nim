import os
import sugar
import strformat
import mimetypes
import strutils

let mimedb = newMimetypes();

type Path* = distinct string

iterator items*(location: Path): Path {.raises: [OSError, ValueError].} =
  for file in walkPattern(&"{location.string}/*"):
    yield Path file

proc `$`*(path: Path): string =
    path.string

proc fileName*(path: Path): string =
    path.string.split("/")[^1]

proc absolutePath*(path: Path): Path =
  let absPath = path.string.absolutePath
  Path absPath

proc isDir*(path: Path): bool {.raises: [OSError].} =
  let fileKind = path.string.getFileInfo.kind
  [pcDir, pcLinkToDir].contains fileKind

proc isExecutable*(path: Path): bool {.raises: [OSError].} =
  let filePermissions = path.string.getFileInfo.permissions
  let execPermissions = collect:
    for i in filePermissions:
      if i in [fpUserExec, fpGroupExec, fpOthersExec]: i
  execPermissions.len > 0

proc getMimetype*(path: Path, mimetypes: MimeDB = mimedb): string =
  let fileExt = path.string.split('.')[^1]
  mimetypes.getMimetype(fileExt)

proc gContentTypeGetIconName(mimetype: cstring): cstring {.importc: "g_content_type_get_generic_icon_name".}

proc getIconName*(path: Path, mimetypes: MimeDB = mimedb): string =
  if path.isDir:
    result = "folder"
  else:
    let mimetype = getMimetype(path, mimetypes).cstring
    let iconName = gContentTypeGetIconName(mimetype)
    result = $iconName

proc runExecutable*(path: Path) =
  discard execShellCmd &"/{path}"

proc runFile*(path: Path) =
  discard execShellCmd &"xdg-open {path}"
