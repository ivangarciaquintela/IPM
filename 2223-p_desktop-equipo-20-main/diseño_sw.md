# Diseño software

## Tarea 1: Diseño software e implementación

Seleccionamos el patrón arquitectónico de **modelo-vista-presentador**  ([MVP](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter))

En este patrón el modelo se encarga de definir los datos que se mostrarán,
el presentador recoge los datos del modelo y los formatea para que sean mostrados por la vista.


## Estático
```mermaid
    classDiagram

CheatPresenter --> CheatView
CheatPresenter --> CheatModel
CheatPresenter ..> CheatModel : << usa >>
CheatPresenter ..> CheatView : << usa >>
CheatView --> CheatViewHandler
CheatView --> Gtk
CheatView ..> Gtk : << crea >>
CheatModel --> CheatData 


class CheatPresenter{
    string
    model
    view
    run(str)
    on_built(CheatView)
    _update_view()
    on_search_clicked()
    threadSearch(str)
    parseResult(str) str
}


class CheatViewHandler{
    on_built()
    on_search_clicked()
}

class CheatView{
    window: Gtk.ApplicationWindow
    textbox: Gtk.Entry
    textBuffer: Gtk.TextBuffer
    textView: Gtk.TextView
    scroll: Gtk.ScrolledWindow
    grid: Gtk.Grid
    search_button: Gtk.Button
    set_handler(CheatViewHandler) 
    on_activate(Gtk.Application)
    update(bool, bool)
    add_row(string)
    clear()
    set_components()
    build(Gtk.Application)
}
	class Gtk
	<<package>> Gtk

class CheatData{
    mark: str
    description: str
    commands: str
    tags: str
    __str__(str) str
}
    
class CheatModel{
        build_data() CheatData
        parse_text(str) list
        parse_chunk(str) CheatData
        get_cheatsheet(str) Sequence
		
}
```

## Dinamico
```mermaid 
sequenceDiagram
    participant View
    participant Presenter
    participant Model
    participant Thread
    Presenter->>View: run(app) 
    View->>View: set_handler(self)
    View->>View: run(app, on_activate)
    View->>View: on_activate()
    View->>View: build(app)
    View->>View: set_components()
    View->>Presenter:     on_search_clicked()
    Presenter->>Thread: threadSearch(command)
    Thread->>Model: get_cheatsheet()
    Model->>Thread: return CheatData
    Thread->>Thread: parseResult(CheatData)
    Thread->>Presenter:     GLib.idle_add(_update_view, goodresult)
    Presenter->>View:     _update_view()
    View->>View: clear()
    View->>View: add_row(string)

```

