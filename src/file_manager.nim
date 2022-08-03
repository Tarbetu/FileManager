import owlkettle
import state/current
import state/path
import options

viewable App:
  currentView: Current
  selectedFile: Option[Path]

method view(app: AppState): Widget =
  result = gui:
    Window:
      title = string app.currentView.location
      ScrolledWindow:
        FlowBox:
          selection_mode = SelectionNone
          for file in app.currentView.location:
            FlowBoxChild {.add_child.}:
              Box(orient = OrientY):
                  Icon:
                    name = file.getIconName
                    pixel_size = 64
                  Button {.expand: false.}:
                    text = file.fileName
                    proc clicked() =
                      if file.isDir:
                        app.currentView.location = file.absolutePath
                        app.currentView.locationHistory.add file.absolutePath
                      else:
                        if file.isExecutable:
                          file.runExecutable
                        else:
                          file.runFile


when isMainModule:
  brew gui(App(
    currentView = initalize_state(),
    selectedFile = none(Path)
  ))
