#!/usr/bin/env python
# -*- coding: ascii -*-
from scapy.all import *
import binascii

# VARIABLES
src = sys.argv[1]
dst = sys.argv[2]
sport = random.randint(1024,65535)
dport = int(sys.argv[3])
interface = 'eno16777736'

fast_open_data = "%96J 42>6 56DA:E6 >6>42496P"

tcp_seq = random.randint(0,4294967295)

s = conf.L3socket(iface=interface)

# SYN
ip = IP(src=src,dst=dst)
fast_open_packet = TCP(sport=sport,dport=dport,flags='S',seq=tcp_seq)/fast_open_data
SYNACK = s.sr1(ip/fast_open_packet)

tcp_seq = tcp_seq + 1
tcp_seq = tcp_seq + len(fast_open_data)

# ACK finishing 3-way handshake
handshake_ack = TCP(sport=sport,dport=dport, flags='A', seq=tcp_seq, ack=SYNACK.seq + 1)
ACK = s.send(ip/handshake_ack)

# Send the client random
overlap_seq = tcp_seq + 1
client_random = "CLIENT_RANDOM 6CD3920875396719EF7B24A75CA00936CCCA8B508C5DF29AD0A85615737D34D5 491B6F447D0AE95E7CFC00B3BBFDBA1FB63039846FD5C01197FFB1E0D2C9341F7C6FBF7DCB2B8519C6F6E3DEC3E078A9"
client_random_packet = TCP(sport=sport,dport=dport,flags='A',seq=overlap_seq, ack=SYNACK.seq + 1)/client_random
s.send(ip/client_random_packet)

# Now send data overwriting the data sent in the first packet
line1 = "%96J 42>6 56DA:E6 D665:?8P\n%96J 42>6 56DA:E6 2== @7 >J 2EE24<D DF44665:?8P\nx EC:65 E@ DE@A A24<6ED 2?5 E9:D 9@=:52J 7F?\nqFE x 9@A6 J@FV== FD6 r=@F5$92C< 367@C6 E96 52>286 :D 5@?6"

line1_packet = TCP(sport=sport,dport=dport,flags='A',seq=tcp_seq, ack=SYNACK.seq + 1)/line1
ACK = s.sr1(ip/line1_packet)

tcp_seq = tcp_seq + len(line1)
