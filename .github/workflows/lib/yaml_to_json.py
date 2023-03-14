import sys
import yaml
import json

with open(sys.argv[1], 'r') as input:
    yml = yaml.safe_load(input)

with open(sys.argv[2], 'w') as output:
    json.dump(yml, output)