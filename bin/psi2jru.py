#!/bin/env python3
import sys
import argparse
import xml.etree.ElementTree as etree
from xml.parsers.expat import ExpatError

"""
Converts all contacts from PSI 0.14 accounts.xml file to JRU format.

May be used as a recovery utility in case of XMPP server failure.
"""

__author__ = 'Marcin Rataj (http://lidel.org)'
__license__ = 'Public Domain'
__vcs_id__ = '$Id$'
__version__ = '1.0'

def main(parser):
    try:
        f = "{{http://psi-im.org/options}}{0}".format
        jru_line = "+,{0},\"{1}\",{2},{3}"
        jru_group = "\"{0}\""

        args = parser.parse_args()
        tree = etree.parse(args.infile)
        args.infile.close()
        root = tree.getroot()
        accounts = tree.find(f('accounts'))
        cached_roster = []
        for account in accounts:
            cache = account.find(f('roster-cache'))
            if cache:
                cached_roster.extend(list(cache))
        jru = []
        for contact in cached_roster:
            subscription = contact.find(f('subscription')).text
            name = contact.find(f('name')).text
            ask = contact.find(f('ask')).text
            jid = contact.find(f('jid')).text
            cached_groups = contact.find(f('groups')).findall(f('item'))
            groups = []
            for group in cached_groups:
                groups.append(jru_group.format(group.text))
            jru_contact = jru_line.format(jid,name,subscription,",".join(groups))
            jru.append(jru_contact)
        args.outfile.write("\n".join(jru))
    except ExpatError as e:
        print("Error occured while parsing input file:\n{0}\nAborted.".format(e))
        return 1
    except Exception as e:
        print("Error occured:\n{0}\nAborted.".format(e))
        return 1
    else:
        return 0

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Convert PSI 0.14 accounts.xml file to JRU format.')
    parser.add_argument('infile', nargs='?', type=argparse.FileType('r'), default=sys.stdin, help='location of the account.xml file [default: stdin]')
    parser.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout, help='[default: stdout]')
    sys.exit(main(parser))

