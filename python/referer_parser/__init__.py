import os
import json
from urlparse import urlparse, parse_qsl


JSON_FILE = os.path.join(os.path.dirname(__file__), 'data', 'referers.json')
REFERERS = {}
for ref, config in json.load(open(JSON_FILE))['search'].iteritems(): # TODO: update this to support the other referer mediums as well
    for domain in config['domains']:
        REFERERS[domain] = {
            'name': ref,
            'params': map(unicode.lower, config['parameters']),
        }


class Referer(object):
    def __init__(self, url):
        self.uri = urlparse(url)
        host = self.uri.netloc.split(':', 1)[0]
        hostpath = host + self.uri.path
        if hostpath in REFERERS:
            host = hostpath
        self.known = False if host not in REFERERS else True
        self.referer = None
        self.search_parameter = ''
        self.search_term = ''
        if self.known:
            self.referer = REFERERS[host]['name']
            for param, val in parse_qsl(self.uri.query):
                if param.lower() in REFERERS[host]['params']:
                    self.search_parameter = param
                    self.search_term = val
