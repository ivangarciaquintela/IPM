from __future__ import annotations
import locale
import threading
from typing import Optional
from models import CheatModel
from views import CheatView, run
import gettext

import gi
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, GLib, Gdk

location = locale.getlocale()
try:
    loc = gettext.translation('presenters', localedir='locale', languages=[location[0]])
except:
    loc = gettext.translation('presenters', localedir='locale', languages=['es_ES'])
loc.install()
_ = loc.gettext
N_ = gettext.ngettext

class CheatPresenter:
    string: str = ""

    def __init__(
            self,
            model: Optional[CheatModel] = None,
            view: Optional[CheatView] = None,
    ) -> None:
        self.model = model or CheatModel()
        self.view = view or CheatView()

    def run(self, application_id: str) -> None:
        self.view.set_handler(self)
        run(application_id=application_id, on_activate=self.view.on_activate)

    def on_built(self, _view: CheatView) -> None:
        self._update_view("")

    def _update_view(self, result) -> None:
        self.view.clear()
        self.view.add_row(result)

    def on_search_clicked(self) -> None:
        txt = self.view.textbox.get_text()
        if txt != "":
            search = CheatModel.parse_text(txt)
            txt_command = search[0].commands
            try:
                threading.Thread(target=self.threadSearch(txt_command), name="petition thread", args=txt_command, daemon=True).start()
            except:
                self.string = _("Etiqueta_ErrorThread")
            self._update_view(self.string)
        else:
            self._update_view("")

    def threadSearch(self, txt_command) -> None:
        try:
            result = CheatModel.get_cheatsheet(txt_command)
            goodResult=self.parseResult(result)
        except:
            goodResult = _("Etiqueta_ErrorConexion")
        GLib.idle_add(self._update_view, goodResult)

    def parseResult(self, result) -> str:
        goodResult = ""
        for r in result:
            if r != None:
                goodResult = f" {goodResult} \n • {r.description} \n {r.commands} \n "
        if goodResult == "":
            goodResult = _("Etiqueta_NoResultados")
        return goodResult