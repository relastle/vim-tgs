#!/usr/bin/env python3

import sys
from os.path import dirname

sys.path.append(dirname(__file__) + '/..')

from tgs_vim_if.presenter import Tag  # noqa


def main() -> None:
    tag_filepath = sys.argv[1]
    with open(tag_filepath) as f:
        while(True):
            try:
                line = f.readline()
            except UnicodeDecodeError:
                continue
            if not line:
                break
            if (
                line.startswith('!') or
                line.startswith('"')
            ):
                continue
            elms = line.strip().split('\t')
            if len(elms) < 4:
                continue
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
