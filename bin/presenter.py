#!/usr/bin/env python3
import sys
from os.path import dirname, basename


class Color:
    BLACK = '\033[30;1m'
    RED = '\033[31;1m'
    GREEN = '\033[32;1m'
    YELLOW = '\033[33;1m'
    BLUE = '\033[34;1m'
    MAGENTA = '\033[35;1m'
    CYAN = '\033[36;1m'
    WHITE = '\033[37;1m'

    RESET = '\033[0m'


"""
C++ these kinds are recommended:
c	class name
d	define (from #define XXX)
e	enumerator
f	function or method name
F	file name
g	enumeration name
m	member (of structure or class data)
p	function prototype
s	structure name
t	typedef
u	union name
v	variable
"""


NERD_FONT_MAP = {
    "f": "",
    "m": "",
    "v": "",
    "s": "פּ",
    "c": "",
    "d": "",
    "e": "",
    "F": "",
    "g": "",
    "p": "襁",
    "t": "",
    "u": "",
}

ICON_DEFAULT = ''


class Tag:

    def __init__(
        self,
        name: str,
        defined_path: str,
        decl_str: str,
        decl_type: str,
    ) -> None:
        self.name = name
        self.defined_path = defined_path
        self.decl_str = decl_str
        self.decl_type = decl_type

    def to_line(self) -> str:
        return '{} {}{}{}: {}{}{}{}: {}'.format(
            NERD_FONT_MAP.get(self.decl_type, ICON_DEFAULT),
            Color.GREEN, self.name, Color.RESET,
            Color.CYAN, dirname(self.defined_path) + '/', Color.RESET,
            basename(self.defined_path),
            self.decl_str,
        )


def main() -> None:
    tag_filepath = sys.argv[1]
    with open(tag_filepath) as f:
        for line in f:
            if (
                line.startswith('!') or
                line.startswith('"')
            ):
                continue
            elms = line.strip().split('\t')
            name = elms[0]
            defined_path = elms[1]
            decl_str = elms[2]
            decl_type = elms[3]
            tag = Tag(name, defined_path, decl_str, decl_type)
            print('{}: {}'.format(
                tag.to_line(),
                dirname(tag_filepath),
            ))
    return


if __name__ == '__main__':
    main()
