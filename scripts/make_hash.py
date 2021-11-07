#!/usr/bin/env python3

import argparse
import hashlib
import json
import sys
from glob import glob
from os.path import basename


def parse_option() -> argparse.Namespace:
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "glob_path",
        help="patten of binary files.",
    )

    parser.add_argument(
        "--algo",
        choices=hashlib.algorithms_guaranteed,
        default="sha256",
        help="hash algorithm. defaults to %(default)s",
    )

    return parser.parse_args()


def main() -> int:
    ns = parse_option()

    h = hashlib.new(ns.algo)
    hashes = {}

    for bin_filepath in glob(ns.glob_path):
        with open(bin_filepath, "rb") as f:
            h.update(f.read())
            hashes[basename(bin_filepath)] = h.hexdigest()

    print(json.dumps(hashes, indent=4))

    return 0


if __name__ == "__main__":
    sys.exit(main())
