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
YML_SOURCE = os.path.join(root_path, 'referers.yml')
JSON_OUT = 'referers.json'

# Target paths
RUBY = os.path.join(root_path, "ruby","data")
JAVA = os.path.join(root_path, "java-scala","src","main","resources")
PYTHON = os.path.join(root_path, "python","referer_parser","data")
NODEJS = os.path.join(root_path, "nodejs","data")
DOTNET = os.path.join(root_path, "dotnet","RefererParser","Resources")
PHP = os.path.join(root_path, "php","data")

def build_json():
    searches = yaml.load(open(YML_SOURCE))
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

# Sync the file
def sync_to(dest):
    copy_file(YML_SOURCE, dest)
    write_file(JSON, os.path.join(dest, JSON_OUT))


sync_to(RUBY)
sync_to(JAVA)
sync_to(NODEJS)
sync_to(PHP)
sync_to(PYTHON)
sync_to(DOTNET)


# Finally commit on current branch
commit = "git commit {0} {1} {2} {3} {4} {5}".format(PYTHON, RUBY, JAVA, NODEJS, PHP, DOTNET)
msg = "\"Updated {0} and {1} in sub-folder following update(s) to master copy\"".format(YML_SOURCE, JSON_OUT)
subprocess.call(commit + ' -m' + msg, shell=True)
