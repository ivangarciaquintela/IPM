import locale
import gettext
from pathlib import Path

from models import CheatModel
from views import CheatView
from presenters import CheatPresenter

if __name__ == '__main__':

    locale.setlocale(locale.LC_ALL, '')
    LOCALE_DIR = Path(__file__).parent / "locale"
    locale.bindtextdomain('Cheat.sh', LOCALE_DIR)
    gettext.bindtextdomain('Cheat.sh', LOCALE_DIR)
    gettext.textdomain('Cheat.sh')

    CheatPresenter(
        model=CheatModel(),
        view=CheatView()
    ).run(application_id="es.udc.fic.ipm.Equipo20")
