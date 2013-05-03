#!/usr/bin/env python
import json

import yaml

def build_json():
    searches = yaml.load(open('./data/referers.yml'))
    with open('./data/referers.json', 'w') as fp:
        json.dump(searches, fp)

if __name__ == "__main__":
    build_json()
