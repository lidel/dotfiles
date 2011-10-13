#!/usr/bin/env python2
# -*- coding: utf-8 -*-

"""
Simple tool that copies current mpd playlist's files to an external directory.
It also creates a m3u playlist file there (eg. for Android devices).
"""

__author__ = 'Marcin Rataj (http://lidel.org)'
__license__ = 'CC0 (public domain)'


# requires: python-mpd >=0.3.0 (http://jatreuman.indefero.net/p/python-mpd/)
from mpd import (MPDClient, CommandError)
from random import choice
from socket import error as SocketError
from shutil import copy
import argparse
import os
import sys


## SETTINGS
HOST = 'localhost'
PORT = '6600'
PASSWORD = False
LIBRARY_DIR = '/home/lidel/music'


def get_paths(root):
    client = MPDClient()
    client.connect(host=HOST, port=PORT)

    if PASSWORD:
        client.password(PASSWORD)

    playlist = client.playlist()
    client.disconnect()

    return [entry.replace('file: ', root) for entry in playlist if entry.startswith('file: ')]


def copy_files(files, args):
    dest = args.output
    if not os.path.exists(dest):
        os.makedirs(dest)
    for file in files:
        if not args.quiet:
            print "copying '{0}' to '{1}'".format(os.path.basename(file), dest)
        copy(file, dest)

def create_playlist(files, args):
    dest = args.output
    name = os.path.basename(os.path.normpath(args.output))
    playlist_file = open("{0}/{1}.m3u".format(dest,name),'w')
    for song in files:
        playlist_file.write(os.path.basename(song) + '\n')
    playlist_file.close()

def main(parser):
    try:
        args = parser.parse_args()
        playlist_files = get_paths(args.library+"/")
        copy_files(playlist_files, args)
        create_playlist(playlist_files, args)
    except Exception as e:
        print "Error occured:\n{0}\nAborted.".format(e)
        return 1
    else:
        return 0


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('-quiet', default=False, action='store_true', help='Be quiet.')
    parser.add_argument('-output', required=True, help='Output directory. (required)')
    parser.add_argument('-library', default=LIBRARY_DIR, help="MPD library path. Default: {0}".format(LIBRARY_DIR))
    sys.exit(main(parser))

# vim: ai ts=4 sw=4 sts=4 expandtab
