#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Read a list of IPs from a file, have them sorted and eliminate duplicates.
#
# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-06

import argparse

def sortlist(args):
    hostlist = []
    with open(args.hostfile, 'r') as fd:
        for host in fd.readlines():
            hostlist.append(host.strip())
    hostlist.sort()
    hostlist = rmdupl(hostlist)
    with open(args.hostfile, 'w') as fd:
        for host in hostlist:
            fd.write('%s\n' % host)

def rmdupl(seq):
    seen = set()
    seen_add = seen.add
    return [x for x in seq if not (x in seen or seen_add(x))]

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('hostfile', type=str, help='name of file of hosts list')
    args = parser.parse_args()
    sortlist(args)
