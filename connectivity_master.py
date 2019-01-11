#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Trigger a number of hosts to test connectivity to particular addresses in parallel.
#
# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-11

import os
import sys
import threading

hostspath = '/root/hosts'
pythonscript = '/root/connectivity_test.py'
faillist = []

def runtest(srchost, desthost, destport):
    result = os.system('ssh -o StrictHostKeyChecking=no root@%s "python %s -n %s -p %s"' % (srchost, pythonscript, desthost, destport))
    if result != 0:
        faillist.append(srchost)

def echolist(srclist, desthost, destport):
    for i, host in enumerate(srclist, 1):
        print '%s \033[31;1m%s failed to connect to %s on port %s\033[0m' % (i, host, desthost, destport)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print '\033[31;1mSyntax Error.\033[0m'
        print 'Usage:python %s <destination_IP> <destination_port>' % sys.argv[0]
        sys.exit(1)
    desthost = sys.argv[1]
    destport = sys.argv[2]
    sourcehosts = []
    with open(hostspath, 'r') as f:
        for line in f.readlines():
            sourcehosts.append(line.strip())
    for srchost in sourcehosts:
        t = threading.Thread(target=runtest, args=[srchost, desthost, destport])
        t.start()
        t.join()
    if faillist:
        echolist(faillist, desthost, destport)
    else:
        print '\033[32;1mAll hosts can connect to %s on port %s successfully\033[0m' % (desthost, destport)
