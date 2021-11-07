#!/usr/bin/env python3

import os
import sys


def main() -> int:
    github_ref = os.getenv("GITHUB_REF")
    # github_ref = "refs/tags/v1.2.3"

    if not github_ref:
        print("ERROR: GITHUB_REF is not set", file=sys.stderr)
        return -1

    git_tag_name = github_ref.split("/")[-1].lstrip("v")
    print(git_tag_name)

    return 0


if __name__ == "__main__":
    sys.exit(main())
