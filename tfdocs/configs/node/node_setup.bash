#! /bin/bash
set -e # exit on error

sysctl -w net.ipv4.ip_forward=1
# TODO add dynamic port assignment because t4g instances in AWS use ens5 while x86-based instances (or older Ubuntu versions idrc) use eth0
iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
