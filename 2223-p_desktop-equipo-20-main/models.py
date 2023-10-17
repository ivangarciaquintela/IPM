#!/usr/bin/env python3

import re
import requests
import sys
import textwrap
from typing import Iterator, NamedTuple, Sequence


URL = "https://cheat.sh/"

ANSI_ESCAPE = re.compile(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]')


def escape_ansi(line: str):
    return ANSI_ESCAPE.sub('', line)


class CheatData(NamedTuple):
    mark: str
    description: str
    commands: str
    tags: str

    def __str__(self) -> str:
        tags = "" if self.tags == "" else f"tags: {self.tags} "
        return f"({self.mark}) {tags}{self.description}\n{self.commands}".strip()

class CheatModel:

    def build_data(self) -> CheatData:
        return CheatData()

    def parse_text(text: str) -> list[CheatData]:
        default_mark = ""
        recipes = []
        # split("\n\n") splits on blank lines.
        # :warning: Doesn't work for two consecutive blank lines
        for chunk in text.split("\n\n"):
            entry = CheatModel.parse_chunk(chunk)
            if entry.mark == "":
                entry = entry._replace(mark=default_mark)
            elif entry.mark.startswith("cheat"):
                default_mark = entry.mark
            recipes.append(entry)
        return recipes

    def parse_chunk(chunk: str) -> CheatData:
        mark = ""
        tags = ""
        description = []
        commands = []
        for line in chunk.splitlines():
            if line.startswith(" "):
                mark = line.strip()
            elif line.startswith("#"):
                description.append(line[1:])
            elif line == "---":
                # Asumimos que siempre es sintácticamente correcto
                # TODO: parsear esta especie the frontmatter
                pass
            elif line.startswith("tags: "):
                tags = line.removeprefix("tags: ")
            else:
                commands.append(line)
        return CheatData(
            mark=mark,
            description="\n".join(description),
            commands="\n".join(commands),
            tags=tags
        )

    def get_cheatsheet(command: str) -> Sequence[CheatData]:
        r = requests.get(URL + command)
        text = escape_ansi(r.text)
        if text.startswith("Unknown topic."):
            return []
        else:
            return CheatModel.parse_text(text)

