import sys
from os.path import dirname

sys.path.append(dirname(__file__) + '/..')

from tgs_vim_if.presenter import Tag


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
