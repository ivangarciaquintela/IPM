from __future__ import annotations
import sys
import os
import gettext
import locale
from typing import Callable, Protocol

import gi

gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, GLib, Gdk

location = locale.getlocale()
try:
    loc = gettext.translation('views', localedir='locale', languages=[location[0]])
except:
    loc = gettext.translation('views', localedir='locale', languages=['es_ES'])
loc.install()
_ = loc.gettext
N_ = gettext.ngettext


def run(application_id: str, on_activate: Callable) -> None:
    app = Gtk.Application(application_id=application_id)
    app.connect('activate', on_activate)
    app.run(None)


run_on_main_thread = GLib.idle_add


class CheatViewHandler(Protocol):
    def on_built(view: CheatView) -> None: pass

    def on_search_clicked(self) -> None: pass


WINDOW_PADDING = 20


class CheatView:
    window: Gtk.ApplicationWindow = None
    textbox: Gtk.Entry = None
    textBuffer: Gtk.TextBuffer = None
    textview: Gtk.TextView = None
    scroll: Gtk.ScrolledWindow = None
    grid: Gtk.Grid = None
    search_button: Gtk.Button = None

    def __init__(self):
        self.handler = None

    def init_textview(self):
        self.textview = Gtk.TextView(
            wrap_mode=True,
            margin_bottom=10,
            editable=False
        )
        self.textBuffer = self.textview.get_buffer()
        start_iter = self.textBuffer.get_start_iter()
        self.textBuffer.insert(start_iter, "")
        end_iter = self.textBuffer.get_end_iter()
        self.textBuffer.insert(end_iter, "")

    def set_handler(self, handler: CheatViewHandler) -> None:
        self.handler = handler

    def on_activate(self, app: Gtk.Application) -> None:
        self.build(app)
        self.handler.on_built(self)

    def update(self, data_error: bool, search_enabled: bool) -> None:
        self.search_button.set_sensitive(data_error)

    def add_row(self, string):
        start_iter = self.textBuffer.get_start_iter()
        self.textBuffer.insert(start_iter, string)
        end_iter = self.textBuffer.get_end_iter()
        self.textBuffer.insert(end_iter, "")

    def clear(self):
        self.textBuffer = Gtk.TextBuffer()
        self.textview.set_buffer(self.textBuffer)

    def set_components(self):
        self.scroll = Gtk.ScrolledWindow(
            hexpand=True,
            vexpand=True
        )
        self.grid = Gtk.Grid(
            column_homogeneous=True,
            row_spacing=15,
            baseline_row=15
        )
        img = Gtk.Image(
            pixel_size=200,
            file="cheatsh.png"
        )
        self.textbox = Gtk.Entry(
            hexpand=False,
            vexpand=False
        )
        search_button = Gtk.Button(
            label=_("Etiqueta_Buscar"),
            hexpand=False,
            vexpand=False,
            halign=Gtk.Align.CENTER
        )
        tv_scroll = Gtk.ScrolledWindow(
            min_content_height=300
        )
        self.init_textview()
        tv_scroll.set_child(self.textview)
        tv_scroll.set_vexpand(False)
        self.textbox.connect("activate", lambda _wg: self.handler.on_search_clicked())  # Para buscar al pulsar ENTER
        search_button.connect('clicked', lambda _wg: self.handler.on_search_clicked())
        self.grid.attach(img, 0, 0, 6, 1)
        self.grid.attach(self.textbox, 1, 1, 2, 1)
        self.grid.attach(tv_scroll, 1, 2, 4, 2)
        self.grid.attach(search_button, 4, 1, 1, 1)
        self.grid.attach(self.textview, 1, 1, 2, 1)
        self.grid.attach(tv_scroll, 0, 0, 0, 0)
        self.scroll.set_child(self.grid)

    def build(self, app: Gtk.Application) -> None:
        self.window = win = Gtk.ApplicationWindow(
            title=_("Cheat.sh"),
            resizable=False,
            default_height=800,
            default_width=900
        )
        app.add_window(win)
        win.connect("destroy", lambda win: win.close())
        self.set_components()
        win.set_child(self.scroll)
        win.present()
