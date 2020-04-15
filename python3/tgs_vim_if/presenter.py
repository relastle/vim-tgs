#!/usr/bin/env python3
from typing import Any, Dict, List
from os.path import basename, dirname
from pprint import pformat


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
    """ Object for a single tag line.
    """

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
        """ Represent self as a line of fzf source.
        """
        return '{} {}{}{}:\t{}{}{}{}:\t{}{}{}'.format(
            NERD_FONT_MAP.get(self.decl_type, ICON_DEFAULT),
            Color.GREEN, self.name, Color.RESET,
            Color.CYAN, dirname(self.defined_path) + '/', Color.RESET,
            basename(self.defined_path),
            Color.MAGENTA, self.decl_str, Color.RESET,
        )

    def to_candidate_line(self, count: int) -> str:
        """ Represent self as a line of fzf source.

        It is used for tag jumping specifying its count.
        """
        return '{}: {} {}{}{}: {}{}{}{}: {}{}{}'.format(
            count,
            NERD_FONT_MAP.get(self.decl_type, ICON_DEFAULT),
            Color.GREEN, self.name, Color.RESET,
            Color.CYAN, dirname(self.defined_path) + '/', Color.RESET,
            basename(self.defined_path),
            Color.MAGENTA, self.decl_str, Color.RESET,
        )

    @classmethod
    def of_tag_candidate(cls, d: Dict[str, Any]) -> 'Tag':
        """ Construct `Tag` from single candidate of `taglist` function of vim.
        """
        return Tag(
            d['name'],
            d['filename'],
            d['cmd'],
            d['kind'],
        )

    @classmethod
    def of_tag_candidates(cls, lst: List[Dict[str, Any]]) -> List['Tag']:
        return [
            cls.of_tag_candidate(d) for d in lst
        ]


def get_source_from_candidates(candidates: List[Dict[str, Any]]) -> List[str]:
    tags = Tag.of_tag_candidates(candidates)
    return [tag.to_candidate_line(i + 1) for i, tag in enumerate(tags)]
