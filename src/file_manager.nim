import owlkettle
import state/current
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
                    name = "emblem-documents"
                    pixel_size = 64
                  Label:
                    text = file.string

when isMainModule:
  brew gui(App(
    currentView = initalize_state(),
    selectedFile = none(Path)
  ))
