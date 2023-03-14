#!/bin/bash

# PROPRIETARY AND CONFIDENTIAL
#
# Unauthorized copying of this project via any medium is strictly prohibited.
#
# Copyright (c) 2020-2020 Snowplow Analytics Ltd. All rights reserved.

# Generate the JSON equivalent of the yaml file with the list of referers

import sys
import json
import yaml

if len(sys.argv) != 3:
    print 'USAGE: yaml_to_json.py <input_referers.yaml> <output_referers.json>'
    print '2 arguments must be specified'
    print 'Arguments:'
    print sys.argv[1:]
    sys.exit(1)

input_yaml = sys.argv[1]
output_json = sys.argv[2]

referers = yaml.load(open(input_yaml))
json = json.dumps(referers, sort_keys = False, indent = 4)

print "writing to {0} ".format(output_json)
with open(output_json, 'w') as f:
    f.write(json)
