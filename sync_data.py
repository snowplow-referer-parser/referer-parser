#!/usr/bin/env python

# Copyright (c) 2013 Martin Katrenik, Snowplow Analytics Ltd. All rights reserved.
#
# This program is licensed to you under the Apache License Version 2.0,
# and you may not use this file except in compliance with the Apache
# License Version 2.0.
# You may obtain a copy of the Apache License Version 2.0 at
# http://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the Apache License Version 2.0 is
# distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied.
# See the Apache License Version 2.0 for the specific language
# governing permissions and limitations there under.

# Authors::   Martin Katrenik, Alex Dean (mailto:support@snowplowanalytics.com)
# Copyright:: Copyright (c) 2013 Martin Katrenik, Snowplow Analytics Ltd
# License::   Apache License Version 2.0

# Syncs common referer-parser resources to the
# language-specific sub projects.
#
# Syncs:
# 1. The referers.yml, plus a generated JSON equivalent
# 2. The referer-tests.json
#
# Finishes by committing the synchronized resources.

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
    os.path.join(root_path, "php","data"),
    os.path.join(root_path, "go", "data")
]
TEST_TARGETS = [
    os.path.join(root_path, "java-scala","src","test","resources"),
    # Add remainder as paths determined etc 
]

# JSON builder
def build_json():
    searches = yaml.load(open(REFERER_SOURCE))
    return json.dumps(searches, sort_keys = False, indent = 4)

JSON = build_json()


# File ops
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


# Sync process
def sync_referers_to(dest):
    copy_file(REFERER_SOURCE, dest)
    write_file(JSON, os.path.join(dest, REFERER_JSON_OUT))

def sync_tests_to(dest):
    copy_file(TEST_SOURCE, dest)

for dest in REFERER_TARGETS:
    sync_referers_to(dest)

for dest in TEST_TARGETS:
    sync_tests_to(dest)


# Commit on current branch
commit = "git commit {0}".format(" ".join(REFERER_TARGETS + TEST_TARGETS))
msg = "\"Updated {0}, {1} and {2} in sub-folder following update(s) to master copy\"".format(REFERER_SOURCE, REFERER_JSON_OUT, TEST_SOURCE)
subprocess.call(commit + ' -m' + msg, shell=True)
