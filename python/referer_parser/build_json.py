#!/usr/bin/env python
import json

import yaml

def build_json():
    searches = yaml.load(open('./data/search.yml'))
    with open('./data/search.json', 'w') as fp:
        json.dump(searches, fp)

if __name__ == "__main__":
    build_json()
