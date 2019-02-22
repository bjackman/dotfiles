#!/usr/bin/python

import argparse
import SimpleHTTPServer
import SocketServer
import os
from socket import gethostname

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-p', '--port', default=0, type=int)
    parser.add_argument('path')

    args = parser.parse_args()

    Handler = SimpleHTTPServer.SimpleHTTPRequestHandler
    Handler.extensions_map.update({
        '': 'text/plain',
        '.tgz': 'application/x-gzip',
        '.gz': 'application/x-gzip',
    });

    SocketServer.TCPServer.allow_reuse_address = True
    httpd = SocketServer.TCPServer(("", args.port), Handler)

    _addr, port = httpd.server_address
    print('Starting HTTP server, try http://{}:{}/{}'.format(gethostname(),
                                                             port,
                                                             args.path))


    httpd.serve_forever()
