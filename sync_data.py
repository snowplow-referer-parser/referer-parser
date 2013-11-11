#!/usr/bin/env python

# Sync the main referers.yml with the dependent ones in the
# sub-folders

import os
import shutil
import json
import yaml
import subprocess


root_path = os.path.dirname(__file__)

# Source paths
REFERER_SOURCE = os.path.join(root_path, 'resources', 'referers.yml')
REFERER_JSON_OUT = 'referers.json'
TEST_SOURCE = os.path.join(root_path, 'resources', 'referer-tests.json')

# Target paths
REFERER_TARGETS = [
    os.path.join(root_path, "ruby","data"),
    os.path.join(root_path, "java-scala","src","main","resources"),
    os.path.join(root_path, "python","referer_parser","data"),
    os.path.join(root_path, "nodejs","data"),
    os.path.join(root_path, "dotnet","RefererParser","Resources"),
    os.path.join(root_path, "php","data")
]
TEST_TARGETS = [
    os.path.join(root_path, "ruby","spec"),
    os.path.join(root_path, "java-scala","src","test","resources"),
    os.path.join(root_path, "php","tests","Snowplow","RefererParser","Tests")
    # Add more as paths determined etc 
]

def build_json():
    searches = yaml.load(open(REFERER_SOURCE))
    return json.dumps(searches, sort_keys = False, indent = 4)

JSON = build_json()


def copy_file(src, dest):
    try:
        print "copying {0} to {1} ".format(src, dest)
        shutil.copy(src, dest)
    except shutil.Error as e:
        print('Error: %s' % e)
    except IOError as e:
        print('IOError: %s' % e.strerror)

def write_file(content, dest):
    print "writing to {0} ".format(dest)
    with open(dest, 'w') as f:
        f.write(content)


def sync_referers_to(dest):
    copy_file(REFERER_SOURCE, dest)
    write_file(JSON, os.path.join(dest, REFERER_JSON_OUT))

def sync_tests_to(dest):
    copy_file(TEST_SOURCE, dest)

for dest in REFERER_TARGETS:
    sync_referers_to(dest)

for dest in TEST_TARGETS:
    sync_tests_to(dest)


# Finally commit on current branch
commit = "git commit {0}".format(" ".join(REFERER_TARGETS + TEST_TARGETS))
msg = "\"Updated {0}, {1} and {2} in sub-folder following update(s) to master copy\"".format(REFERER_SOURCE, REFERER_JSON_OUT, TEST_SOURCE)
subprocess.call(commit + ' -m' + msg, shell=True)
