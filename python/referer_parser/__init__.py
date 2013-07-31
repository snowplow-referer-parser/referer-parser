import os
import json
from urlparse import urlparse, parse_qsl


JSON_FILE = os.path.join(os.path.dirname(__file__), 'data', 'referers.json')
REFERERS = {}

with open(JSON_FILE) as json_content:
    for medium, conf_list in json.load(json_content).iteritems():
        for ref, config in conf_list.iteritems():
            make_ref = None
            if 'parameters' in config:
                def make_ref_params(config_dict):
                    return {
                        'name': ref,
                        'params': map(unicode.lower, config_dict['parameters']),
                        'medium': medium,
                    }
                make_ref = make_ref_params
            else:
                make_ref = lambda _: {'name': ref, 'medium': medium}
            for domain in config['domains']:
                REFERERS[domain] = make_ref(config)


class Referer(object):
    def __init__(self, ref_url, curr_url=None):
        self.known = False
        self.referer = None
        self.medium = 'unknown'
        self.search_parameter = None
        self.search_term = None

        ref_uri = urlparse(ref_url)
        ref_host = ref_uri.hostname
        self.known = ref_uri.scheme in {'http', 'https'}

        # print "Scheme: %s" % ref_uri.scheme

        if not self.known:
            return

        if curr_url:
            curr_uri = urlparse(curr_url)
            curr_host = curr_uri.hostname
            if curr_host == ref_host:
                self.medium = 'internal'
                return

        # print "Getting referer with path"
        referer = self.__lookup_referer(ref_host, ref_uri.path, True)
        # print "Got %s" % referer
        if not referer:
            # print "Getting referer without path"
            referer = self.__lookup_referer(ref_host, ref_uri.path, False)
            # print "Got %s" % referer
            if not referer:
                self.medium = 'unknown'
                return

        # print "Assigning name %s" % referer['name']
        self.referer = referer['name']
        self.medium = referer['medium']
        
        if referer['medium'] == 'search':
            if 'params' not in referer or not referer['params']:
                # print "Returning"
                return
            for param, val in parse_qsl(ref_uri.query):
                if param.lower() in referer['params']:
                    self.search_parameter = param
                    self.search_term = val

    def __lookup_referer(self, ref_host, ref_path, include_path):
        referer = None
        try:
            referer = REFERERS[ref_host + ref_path] if include_path else REFERERS[ref_host]
        except KeyError:
            if include_path:
                path_parts = ref_path.split('/')
                if len(path_parts) > 1:
                    try:
                        referer = REFERERS[ref_host + '/' + path_parts[1]]
                    except KeyError:
                        pass
        if not referer:
            try:
                idx = ref_host.index('.')
                return self.__lookup_referer(ref_host[idx + 1:], ref_path, include_path)
            except ValueError:
                return None
        else:
            return referer
        
