"""Require the application metadata used by the public HDR-capable VideoOut profile.

ProsperoLight documents why attribute=0 is a functional HDR regression:
https://github.com/blackbearreloaded/ProsperoLight/blob/a6e56cf4e8e9e469d5bc5cc06ff71ad4ca16a6a9/docs/PORTING.md
attribute3=0x40040 follows ProsperoLight 01.000.095 for older firmware.
This checks the package declaration, not the console's actual HDMI capabilities.
"""
import argparse
import json
from pathlib import Path


DISPLAY_ATTRIBUTES_HDR = {'attribute': 0x62000000, 'attribute2': 0, 'attribute3': 0x40040}
DISPLAY_ATTRIBUTES_STD = {'attribute': 0, 'attribute2': 0, 'attribute3': 0}


def validate_display_metadata(param):
    for expected_set in (DISPLAY_ATTRIBUTES_HDR, DISPLAY_ATTRIBUTES_STD):
        if all(type(param.get(f)) is int and param.get(f) == exp for f, exp in expected_set.items()):
            if param.get('applicationCategoryType') != 0:
                raise ValueError('Nuvio requires the game application category for its direct memory budget')
            return dict(expected_set)
    raise ValueError(
        f'attribute must match HDR profile (0x62000000, 0x40040) or Standard profile (0, 0); found '
        f"attribute={param.get('attribute')}, attribute3={param.get('attribute3')}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('param', type=Path)
    args = parser.parse_args()
    try:
        validate_display_metadata(json.loads(args.param.read_text()))
    except (ValueError, OSError) as error:
        parser.exit(1, f'Display metadata rejected: {error}\n')
    print('Display metadata: HDR-capable application profile 0x62000000; game category')


if __name__ == '__main__':
    main()
