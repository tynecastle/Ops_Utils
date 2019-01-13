#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Test connectivity to particular hosts and report failed attempts.
#
# Author : Liu Sibo
# Email  : liusibojs@dangdang.com
# Date   : 2019-01-13

import socket
import time
import sys
import argparse

logfile = '/data/conn_fail_log'
# '123.123.123.123' is a test IP to show how the 'failed' branch works
desthosts = ('121.41.175.38','121.41.175.23','www.baidu.com','123.123.123.123')
destport = 80
interval = 10
hostname = socket.gethostname()
localip = socket.gethostbyname(hostname)

def write_to_log(host, port):
    timestamp = time.strftime("%F %T", time.localtime())
    with open(logfile, 'a') as fd:
        fd.write('%s Failed to connect to %s on port %s\n' % (timestamp, host, port))
        fd.close()
        

def main(args):
    global desthosts,destport,interval
    if args.desthost:
        desthosts = (args.desthost,)
    if args.destport:
        destport = args.destport
    if args.interval:
        interval = args.interval
        while True:
            for host in desthosts:
                try:
                    s = socket.socket()
                    s.settimeout(3)
                    s.connect((host, destport))
                    s.close()
                except Exception,e:
                    print(e)
                    write_to_log(host, destport)
            time.sleep(interval)
    # if interval is not specified on command line, the test will be done only once
    else:
        for host in desthosts:
            try:
                s = socket.socket()
                s.settimeout(3)
                s.connect((host, destport))
                s.close()
                print('%s connected to %s on port %s successfully' % (localip, host, destport))
            except Exception:
                print('%s failed to connect to %s on port %s' % (localip, host, destport))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--interval', type=int, help="Time interval between two connecting attempts")
    parser.add_argument('-d', '--desthost', type=int, help="Destination host IP")
    parser.add_argument('-p', '--destport', type=int, help="Destination host port")
    args = parser.parse_args()
    main(args)

