# Mini Internet `AS-77`

## Description

This project is about the configuration of a mini internet using the following technologies:

- OSPF
- BGP

The network is made up of 8 routers with a single host each. each router has a number and a name, number being the Y value for substitution in the host network IP address and the name being the name of the router. My AS number is 77. All commands for FRR are done using full name not short hand _(even though short hand is cooler this is for clarity)_.

## Topology

![netTop](https://github.com/user-attachments/assets/b7cd55a8-4570-4e9e-bffc-7f45962de452)

---

## Task 1

### Objective

Set up host networks on all routers. ensure that the host networks are reachable from there corisponding router. Hosts sit on `.1` and routers sit on `.2` of the same subnet.

### Configuration

#### Example for router LOND -- Y = 1

first ssh into the router

```bash
./goto LOND
```

next configure the interface ip and mask. host network always sits on the interface `host` so we will configure the interface with the ip address `77.101.0.2/24` where `Y` is the router number and `X` is my AS number.

```bash
configure terminal
interface host
ip address 77.101.0.2/24
no shutdown
```

redo the above steps for all routers.

#### LOND host

first ssh into the host

```bash
./goto LOND host
```

next add the ip address for the host on the router. the host network always sits on the interface `{direct router name}router` so we will configure the interface with the ip address `77.101.0.1/24`

```bash
ip addr add 77.101.0.1/24 dev LONDrouter
```

redo the above steps for all hosts.

### Verification

both the host and the router should be able to ping each other.

```bash
ping 77.101.0.1 # from the router
ping 77.101.0.2 # from the host
```

```bash
## output router:
LOND_router# ping 77.101.0.1
PING 77.101.0.1 (77.101.0.1) 56(84) bytes of data.
64 bytes from 77.101.0.1: icmp_seq=1 ttl=64 time=0.047 ms
64 bytes from 77.101.0.1: icmp_seq=2 ttl=64 time=0.037 ms
64 bytes from 77.101.0.1: icmp_seq=3 ttl=64 time=0.040 ms
64 bytes from 77.101.0.1: icmp_seq=4 ttl=64 time=0.040 ms
--- 77.101.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3067ms
rtt min/avg/max/mdev = 0.037/0.041/0.047/0.003 ms
```

```bash
## output host:
LOND_host:~# ping 77.101.0.2
PING 77.101.0.2 (77.101.0.2) 56(84) bytes of data.
64 bytes from 77.101.0.2: icmp_seq=1 ttl=64 time=0.043 ms
64 bytes from 77.101.0.2: icmp_seq=2 ttl=64 time=0.051 ms
64 bytes from 77.101.0.2: icmp_seq=3 ttl=64 time=0.046 ms
64 bytes from 77.101.0.2: icmp_seq=4 ttl=64 time=0.055 ms
--- 77.101.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3089ms
rtt min/avg/max/mdev = 0.043/0.048/0.055/0.004 ms
```

repeat the above steps for all routers and hosts. this will ensure that all hosts are reachable from there corresponding routers. This completes task 1.

---

## Task 2

### Objective

Set up loopback interfaces on all routers. ensure that the loopback interfaces are reachable from the routers host.

### Configuration

#### Example for router LOND -- Y = 1

first ssh into the router

```bash
./goto LOND
```

next configure the loopback interface ip and mask. loopback interfaces always sit on the interface `lo` so we will configure the interface with the ip address `77.151.0.1/32`, `/32` is used because loopback interfaces are point to point thus only one ip address is needed.

```bash
configure terminal
interface lo
ip address 77.151.0.1/32
no shutdown
```

redo the above steps for all routers.
\
Also the host will need a default gateway set to ip of the router. this is done by adding a route to the host. this is done with the `ip route add` command `via {router ip}` and `dev {interface to router}`. the command will look like this:

```bash
./goto LOND host
ip route add default via 77.101.0.2 dev LONDrouter
```

The reason for this is that the host needs to know where to send packets that are not on the same subnet. Becase by default the host cant reach the routers loop back interface as it is on a different subnet. This will allow the host to reach the loopback interface.

### Verification

the routers and its host should be able to ping the loopback interface.

```bash
ping 77.151.0.1 # from the router and the host
```

```bash
## output router / host:
LOND_host:~# ping 77.151.0.1
PING 77.151.0.1 (77.151.0.1) 56(84) bytes of data.
64 bytes from 77.151.0.1: icmp_seq=1 ttl=64 time=0.047 ms
64 bytes from 77.151.0.1: icmp_seq=2 ttl=64 time=0.038 ms
64 bytes from 77.151.0.1: icmp_seq=3 ttl=64 time=0.043 ms
64 bytes from 77.151.0.1: icmp_seq=4 ttl=64 time=0.048 ms
--- 77.151.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3069ms
rtt min/avg/max/mdev = 0.038/0.044/0.048/0.004 ms
```

repeat the above steps for all routers. this will ensure that all loopback interfaces are reachable from host / router. This completes task 2.

---

## Task 3

### Objective

Set up all link networks between routers. ensure that the link networks are reachable from the routers in the link. The link networks always sit on the interface `port_{other router on the link}`. The ip address pattern for the link network is always the same for both routers on the link, where 1 router gets `.1` and the other gets `.2`. see diagram for link networks needed.

### Configuration

_this example will be done with a pair of routers LOND and BOST_

#### Example for router LOND -- Y = 1 and BOST -- Y = 6

for LOND, this will add the ip and mask to the interface `port_BOST` which is the interface that connects to BOST, the ip address will be `77.0.7.1/30`, and for BOST this will add the ip and mask to the interface `port_LOND` which is the interface that connects to LOND. the ip address will be `77.0.7.2/30`.

```bash
./goto LOND
configure terminal
interface port_BOST
ip address 77.0.7.1/30
no shutdown
```

for BOST same deal but with the other ip address `.2` in this case.

```bash
./goto BOST
configure terminal
interface port_LOND
ip address 77.0.7.2/30
no shutdown
```

redo the above steps for all routers and all links.

### Verification

the routers should be able to ping each other on the link network.

```bash
ping 77.0.7.2 # from LOND
ping 77.0.7.1 # from BOST
```

```bash
## output LOND:
PING 77.0.7.2 (77.0.7.2) 56(84) bytes of data.
64 bytes from 77.0.7.2: icmp_seq=1 ttl=64 time=20.1 ms
64 bytes from 77.0.7.2: icmp_seq=2 ttl=64 time=20.1 ms
64 bytes from 77.0.7.2: icmp_seq=3 ttl=64 time=20.1 ms
64 bytes from 77.0.7.2: icmp_seq=4 ttl=64 time=27.7 ms
--- 77.0.7.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3045ms
rtt min/avg/max/mdev = 20.126/22.031/27.736/3.293 ms
```

```bash
## output BOST:
PING 77.0.7.1 (77.0.7.1) 56(84) bytes of data.
64 bytes from 77.0.7.1: icmp_seq=1 ttl=64 time=20.1 ms
64 bytes from 77.0.7.1: icmp_seq=2 ttl=64 time=20.1 ms
64 bytes from 77.0.7.1: icmp_seq=3 ttl=64 time=20.1 ms
64 bytes from 77.0.7.1: icmp_seq=4 ttl=64 time=27.7 ms
4 packets transmitted, 4 received, 0% packet loss, time 3045ms
rtt min/avg/max/mdev = 20.126/22.031/27.736/3.293 ms
```

redo the above steps for all routers. this will ensure that all link networks are reachable from the routers in the link. This completes task 3.

---

## Task 4

### Objective

Set up OSPF on all routers. once done all routers should be able to ping each other on the all interfaces advertised on that router, incluiding loopback and non-local subnets. Each router needs a list of things to make this work:

- Router ID -- `this will be the loopback interface ip address as this is unique`
- Area ID -- `0 or 0.0.0.0 for all routers for backbone area`
- List of networks to advertise -- `all interfaces on the router including loopback, and link networks` _(will come back to the host network later as it needs other config)_

for example LOND has the following networks to advertise:

- `77.151.0.1/32` -- loopback interface _\*\* this will be advertised by redistribute conected_
- `77.0.2.0/30` -- to HAML
- `77.0.4.0/30` -- to PARI
- `77.0.8.0/30` -- to NEWY
- `77.0.7.0/30` -- to BOST

### Configuration

#### Example for router LOND -- Y = 1

first ssh into the router

```bash
./goto LOND
```

next configure the OSPF process. the router id will be the loopback interface ip address. the area id will be `0` or `0.0.0.0` for all routers. the networks to advertise will be all interfaces on the router including host, and link networks, loopback will be done via `redistrabute conected`.
\
Also this will enbale the `DNS server` on LOND router (once `OSPF` is enabled and configured on the LOND router), this is done with the `redisribute connected` so no manual configuration is needed. this will enable forward and reverse DNS lookups for anoyone in the network for commands such as `ping`, `traceroute`, and `iperf3`. Thus the following steps insted of ips can be hostnames the following pattern is used:

- `host.{placename}.group{ASnumber}` -- for hosts
- `{placename}.group{ASnumber}` -- for routers

thus for me its `host.LOND.group77` for `LOND host` and `LOND.group77` for `LOND router`. This could convert `77.0.2.1` to `host.HAML.group77` and `77.152.0.1` to `HAML.group77`.

```bash
configure terminal
router ospf
router-id 77.151.0.1
network 77.0.2.0/30 area 0  # to HAML
network 77.0.4.0/30 area 0 # to PARI
network 77.0.8.0/30 area 0 # to NEWY
network 77.0.7.0/30 area 0 # to BOST
redistribute connected # loopback interface and all directly connected networks will be advertised as external routes
```

redo the above steps for all routers.

### Verification

the routers should be able to ping each other on all interfaces advertised on that router. this will ensure that OSPF is working correctly. also check traceroute to see the path taken.
\
This example will show LOND pinging ATLA on the interface to ZURI and the path taken.

```bash
ping 77.0.13.1 # from LOND to ATLA
traceroute 77.0.13.1 # from LOND to ATLA
```

```bash
## output ping:
LOND_router# ping 77.0.13.1
PING 77.0.13.1 (77.0.13.1) 56(84) bytes of data.
64 bytes from 77.0.13.1: icmp_seq=1 ttl=62 time=0.505 ms
64 bytes from 77.0.13.1: icmp_seq=2 ttl=62 time=0.479 ms
64 bytes from 77.0.13.1: icmp_seq=3 ttl=62 time=0.620 ms
64 bytes from 77.0.13.1: icmp_seq=4 ttl=62 time=0.518 ms
--- 77.0.13.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3065ms
rtt min/avg/max/mdev = 0.479/0.530/0.620/0.053 ms
```

```bash
## output traceroute:
LOND_router# traceroute 77.0.13.1
traceroute to 77.0.13.1 (77.0.13.1), 30 hops max, 46 byte packets
 1  pari.group77 (77.0.4.1)  0.130 ms  0.551 ms  0.983 ms
 2  zuri.group77 (77.0.6.2)  0.260 ms  0.250 ms  0.225 ms
 3  atla.group77 (77.0.13.1)  0.472 ms  0.479 ms  0.454 ms
```

As you can see the path taken is from LOND to PARI to ZURI to ATLA, this shows that it takes the correct path to reach the router on the correct side of the link. repeat the above steps for all routers. this will ensure that all routers can ping each other on all interfaces advertised on that router. This completes task 4.
\
Also run verification on all routers to all other routers and there interfaces, this needs to be done to ensure all netorks are being advertised and are reachable. Skipping this step could lead to a network not being reachable and can be annoying later on to diagnose. This completes task 4.

---

## Task 5 - 7

### Objective

1. Testing the network to see if it is working correctly. this will be done by running a series of tests to see if the network is working correctly. the tests will be as follows:

- All routers should be able to ping each other on all interfaces advertised on that router.
- All routers should be able to ping all hosts on the network.
- All hosts should be able to ping all other hosts on the network.
- All hosts should be able to ping all routers on the network.

Also check `TTL` to see if it is correct for the path, use traceroute to see the path taken, and also look at the diagram to see if the path is correct.

2. Check the `OSPF` configuration on each router, check costs, routes, networks, and areas. also check the `OSPF` database to see if all routers are in the database.

### Configuration

The easiest way to do this is to run a script that will ping multiple hosts 1 by one and then check the output to see if the pings were successful. this will be done for all routers and hosts. this will ensure that all routers can ping each other on all interfaces advertised on that router, all routers can ping all hosts on the network, all hosts can ping all other hosts on the network, and all hosts can ping all routers on the network.
\
For this however the routers dont have bash, but the hosts do, so the script will be run on the hosts. Pinging from the hosts to all other hosts on the network will also check that hosts router as well, this is because the host can only reach the other hosts through its own meaning that its router must be working correctly.
\
The script will look like this:

##### mping.sh

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 host1 host2 host3 ..."
    exit 1
fi

# Loop through each host and ping it 4 times
for host in "$@"; do
    echo "Pinging $host..."
    ping -c 4 "$host"
    echo "-------------------------"
done
```

Each host will need a list of hosts to ping this can be made quite easy by making a file and listing each ip the host needs to ping, so for LOND host:

- `77.101.0.1` -- LOND host
- `77.102.0.1` -- HAML host
- `77.103.0.1` -- PARI host
- `77.104.0.1` -- TRGA host
- `77.105.0.1` -- NEWY host
- `77.106.0.1` -- BOST host
- `77.107.0.1` -- ATLA host
- `77.108.0.1` -- ZURI host

add this to a file called `hosts` using `nano`:

##### hosts

```bash
77.101.0.1
77.102.0.1
77.103.0.1
77.104.0.1
77.105.0.1
77.106.0.1
77.107.0.1
77.108.0.1
```

\
Then run the script on each host like this: Example for LOND host

```bash
./goto LOND host
bash ./mping.sh $(cat hosts)
```

```bash
## output:
LOND_host:~# bash ./mping.sh $(cat hosts)
Pinging 77.101.0.1...
PING 77.101.0.1 (77.101.0.1) 56(84) bytes of data.
64 bytes from 77.101.0.1: icmp_seq=1 ttl=64 time=0.033 ms
64 bytes from 77.101.0.1: icmp_seq=2 ttl=64 time=0.035 ms
64 bytes from 77.101.0.1: icmp_seq=3 ttl=64 time=0.037 ms
64 bytes from 77.101.0.1: icmp_seq=4 ttl=64 time=0.038 ms

--- 77.101.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3069ms
rtt min/avg/max/mdev = 0.033/0.035/0.038/0.002 ms
-------------------------
Pinging 77.102.0.1...
PING 77.102.0.1 (77.102.0.1) 56(84) bytes of data.
64 bytes from 77.102.0.1: icmp_seq=1 ttl=62 time=1.33 ms
64 bytes from 77.102.0.1: icmp_seq=2 ttl=62 time=1.27 ms
64 bytes from 77.102.0.1: icmp_seq=3 ttl=62 time=1.34 ms
64 bytes from 77.102.0.1: icmp_seq=4 ttl=62 time=1.34 ms

--- 77.102.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3027ms
rtt min/avg/max/mdev = 1.269/1.321/1.344/0.030 ms
-------------------------
Pinging 77.103.0.1...
PING 77.103.0.1 (77.103.0.1) 56(84) bytes of data.
64 bytes from 77.103.0.1: icmp_seq=1 ttl=62 time=0.165 ms
64 bytes from 77.103.0.1: icmp_seq=2 ttl=62 time=0.145 ms
64 bytes from 77.103.0.1: icmp_seq=3 ttl=62 time=0.162 ms
64 bytes from 77.103.0.1: icmp_seq=4 ttl=62 time=0.140 ms

--- 77.103.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3085ms
rtt min/avg/max/mdev = 0.140/0.152/0.165/0.010 ms
-------------------------
Pinging 77.104.0.1...
PING 77.104.0.1 (77.104.0.1) 56(84) bytes of data.
64 bytes from 77.104.0.1: icmp_seq=1 ttl=62 time=0.226 ms
64 bytes from 77.104.0.1: icmp_seq=2 ttl=62 time=0.223 ms
64 bytes from 77.104.0.1: icmp_seq=3 ttl=62 time=0.222 ms
64 bytes from 77.104.0.1: icmp_seq=4 ttl=62 time=0.234 ms

--- 77.104.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3091ms
rtt min/avg/max/mdev = 0.222/0.226/0.234/0.004 ms
-------------------------
Pinging 77.105.0.1...
PING 77.105.0.1 (77.105.0.1) 56(84) bytes of data.
64 bytes from 77.105.0.1: icmp_seq=1 ttl=62 time=0.365 ms
64 bytes from 77.105.0.1: icmp_seq=2 ttl=62 time=0.349 ms
64 bytes from 77.105.0.1: icmp_seq=3 ttl=62 time=0.302 ms
64 bytes from 77.105.0.1: icmp_seq=4 ttl=62 time=0.309 ms

--- 77.105.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3063ms
rtt min/avg/max/mdev = 0.302/0.331/0.365/0.026 ms
-------------------------
Pinging 77.106.0.1...
PING 77.106.0.1 (77.106.0.1) 56(84) bytes of data.
64 bytes from 77.106.0.1: icmp_seq=1 ttl=62 time=20.4 ms
64 bytes from 77.106.0.1: icmp_seq=2 ttl=62 time=20.5 ms
64 bytes from 77.106.0.1: icmp_seq=3 ttl=62 time=20.3 ms
64 bytes from 77.106.0.1: icmp_seq=4 ttl=62 time=20.4 ms

--- 77.106.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3068ms
rtt min/avg/max/mdev = 20.4/20.3/20.4/0.20 ms
-------------------------

--- 77.106.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3068ms
rtt min/avg/max/mdev = 0.358/0.368/0.384/0.010 ms
-------------------------
Pinging 77.107.0.1...
PING 77.107.0.1 (77.107.0.1) 56(84) bytes of data.
64 bytes from 77.107.0.1: icmp_seq=1 ttl=62 time=0.572 ms
64 bytes from 77.107.0.1: icmp_seq=2 ttl=62 time=0.584 ms
64 bytes from 77.107.0.1: icmp_seq=3 ttl=62 time=0.682 ms
64 bytes from 77.107.0.1: icmp_seq=4 ttl=62 time=0.529 ms

--- 77.107.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3059ms
rtt min/avg/max/mdev = 0.529/0.591/0.682/0.055 ms
-------------------------
Pinging 77.108.0.1...
PING 77.108.0.1 (77.108.0.1) 56(84) bytes of data.
64 bytes from 77.108.0.1: icmp_seq=1 ttl=62 time=0.396 ms
64 bytes from 77.108.0.1: icmp_seq=2 ttl=62 time=0.334 ms
64 bytes from 77.108.0.1: icmp_seq=3 ttl=62 time=0.333 ms
64 bytes from 77.108.0.1: icmp_seq=4 ttl=62 time=0.336 ms

--- 77.108.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3078ms
rtt min/avg/max/mdev = 0.333/0.349/0.396/0.026 ms
-------------------------
```

This shows that all hosts are reachable by the LOND host, we can also concluded that all routers are reachable by the LOND host. For even more checks we can run the script for all the interfaces on the network to see if they are reachable. Redo this for all hosts on the network. This completes task 5 and 6.
\
For task 7 we will need to check the `OSPF` configuration on each router. this can be done by running the `show ip ospf` with `databse`, `interface`, `route`, and `neighbor` options. this will show the `OSPF` configuration on each router. this will ensure that all routers are in the database and are reachable.

```bash
./goto LOND
show ip ospf database
show ip ospf interface
show ip ospf route
show ip ospf neighbor
```

1. `database`
   - this will show the `OSPF` database on the router, this will show insite into the links and how networks are being advertised.
2. `interface`

   - this will show the `OSPF` interfaces on the router, this will show the interfaces that are being used for `OSPF`. This is mainly used ensure that all interfaces are being used for `OSPF` and the Cost of each link.

     ```bash
     port_HAML is up
     ifindex 30552, MTU 1500 bytes, BW 10000 Mbit <UP,BROADCAST,RUNNING,MULTICAST>
     Internet Address 77.0.2.2/30, Broadcast 77.0.2.3, Area 0.0.0.0
     MTU mismatch detection: enabled
     Router ID 77.151.0.1, Network Type BROADCAST, Cost: 5
     Transmit Delay is 1 sec, State DR, Priority 1
     Designated Router (ID) 77.151.0.1 Interface Address 77.0.2.2/30
     Backup Designated Router (ID) 77.152.0.1, Interface Address 77.0.2.1
     Saved Network-LSA sequence number 0x80000398
     Multicast group memberships: OSPFAllRouters OSPFDesignatedRouters
     Timer intervals configured, Hello 10s, Dead 40s, Wait 40s, Retransmit 5
     Hello due in 5.324s
     Neighbor Count is 1, Adjacent neighbor count is 1
     ```

     For example this shows the port_HAML and tells you everything about it including the `OSPF` ID, the `Cost`, and the `State`. This is used to ensure that all interfaces are being used for `OSPF` and the Cost of each link. The cost is used to determine the best path to take to reach a destination. The lower the cost the better the path. pay close attention to the neighbor count and the adjacent neighbor count, this should be 1 for each link.

3. `route`
   - this will show all the routes the router knows about and the first step needed to take (`first hop`), it will also show the cost of the `first hop`. You should be able to see all networks that you have set up as they should all be reachable. This will show you external and internal networks that can be routed and routers that can be routed to.
4. `neighbor`

   - this will show all the neighbors the router has. This is direct neighbors. You should be able to match the `OSPF ID` to the router on the diagram and the interface that they are conected on

     ```bash
     Neighbor ID     Pri State           Up Time         Dead Time Address         Interface                        RXmtL RqstL DBsmL
     77.156.0.1        1 Full/DR         4272480d00h00m    38.560s 77.0.7.2        port_BOST:77.0.7.1                   0     0     0
     ```

     For example this shows that LOND is connected to BOST on the interface `port_BOST` and the ip address `77.156.0.1` this is the loopback ip of BOST _(remember this is the `OSPF` ID of the router)_.

repeat the above steps for all routers. this will ensure `OSPF` configuration is correct. This completes task 7.

## Task 8

### Objective

Verify the hosts are not receiving OSPF packets

### Configuration

This is done by running the `tcpdump` command on the host. This will show all packets that are being sent to the host. This will show if the host is receiving `OSPF` packets or not. This is done by running the following command:

```bash
./goto LOND host
tcpdump -i LONDrouter -n -e -s 0 -c 10 'ip[9] == 89'
```

This should output nothing but if you see this

```bash
09:13:37.456989 IP (tos 0xc0, ttl 1, id 53489, offset 0, flags [none], proto OSPF (89), length 64)
    lond.group77 > 224.0.0.5: OSPFv2, Hello, length 44
        Router-ID lond.group77, Backbone Area, Authentication Type: none (0)
        Options [External]
          Hello Timer 10s, Dead Timer 40s, Mask 255.255.255.0, Priority 1
          Designated Router lond.group77
```

This means that the host is receiving `OSPF` packets and is not configured correctly. This should not be the case as the host should not be receiving `OSPF` packets. This is most likely due to the host network being advertised in `OSPF` simply remove the host network from the `OSPF` configuration on the router. This is done by running the following command:

```bash
./goto LOND
configure terminal
router ospf
no network 77.101.0.0/24 area 0
```

This will remove the host network from the `OSPF` configuration on the router. This will stop the host from receiving `OSPF` packets. This is done for all routers. This completes task 8.

## Task 9-10

### Objective

Testing the network to find high latency or low bandwidth links. This is done by running a series of tests to see if the network is working correctly. Tests will be done between hosts. The tests will be as follows:

- Test latency with `ping` between hosts
- Test bandwidth with `iperf3` between hosts

### Configuration

This can be done exacly the same as 5 and 6 using mping.sh using the same host list as before too:

```bash
./goto LOND host
bash ./mping.sh $(cat hosts)
```

```bash
## output:
LOND_host:~# bash ./mping.sh $(cat hosts)
Pinging 77.101.0.1...
PING 77.101.0.1 (77.101.0.1) 56(84) bytes of data.
64 bytes from 77.101.0.1: icmp_seq=1 ttl=64 time=0.033 ms
64 bytes from 77.101.0.1: icmp_seq=2 ttl=64 time=0.035 ms
64 bytes from 77.101.0.1: icmp_seq=3 ttl=64 time=0.037 ms
64 bytes from 77.101.0.1: icmp_seq=4 ttl=64 time=0.038 ms

--- 77.101.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3069ms
rtt min/avg/max/mdev = 0.033/0.035/0.038/0.002 ms
-------------------------
Pinging 77.102.0.1...
PING 77.102.0.1 (77.102.0.1) 56(84) bytes of data.
64 bytes from 77.102.0.1: icmp_seq=1 ttl=62 time=1.33 ms
64 bytes from 77.102.0.1: icmp_seq=2 ttl=62 time=1.27 ms
64 bytes from 77.102.0.1: icmp_seq=3 ttl=62 time=1.34 ms
64 bytes from 77.102.0.1: icmp_seq=4 ttl=62 time=1.34 ms

--- 77.102.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3027ms
rtt min/avg/max/mdev = 1.269/1.321/1.344/0.030 ms
-------------------------
Pinging 77.103.0.1...
PING 77.103.0.1 (77.103.0.1) 56(84) bytes of data.
64 bytes from 77.103.0.1: icmp_seq=1 ttl=62 time=0.165 ms
64 bytes from 77.103.0.1: icmp_seq=2 ttl=62 time=0.145 ms
64 bytes from 77.103.0.1: icmp_seq=3 ttl=62 time=0.162 ms
64 bytes from 77.103.0.1: icmp_seq=4 ttl=62 time=0.140 ms

--- 77.103.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3085ms
rtt min/avg/max/mdev = 0.140/0.152/0.165/0.010 ms
-------------------------
Pinging 77.104.0.1...
PING 77.104.0.1 (77.104.0.1) 56(84) bytes of data.
64 bytes from 77.104.0.1: icmp_seq=1 ttl=62 time=0.226 ms
64 bytes from 77.104.0.1: icmp_seq=2 ttl=62 time=0.223 ms
64 bytes from 77.104.0.1: icmp_seq=3 ttl=62 time=0.222 ms
64 bytes from 77.104.0.1: icmp_seq=4 ttl=62 time=0.234 ms

--- 77.104.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3091ms
rtt min/avg/max/mdev = 0.222/0.226/0.234/0.004 ms
-------------------------
Pinging 77.105.0.1...
PING 77.105.0.1 (77.105.0.1) 56(84) bytes of data.
64 bytes from 77.105.0.1: icmp_seq=1 ttl=62 time=0.365 ms
64 bytes from 77.105.0.1: icmp_seq=2 ttl=62 time=0.349 ms
64 bytes from 77.105.0.1: icmp_seq=3 ttl=62 time=0.302 ms
64 bytes from 77.105.0.1: icmp_seq=4 ttl=62 time=0.309 ms

--- 77.105.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3063ms
rtt min/avg/max/mdev = 0.302/0.331/0.365/0.026 ms
-------------------------
Pinging 77.106.0.1...
PING 77.106.0.1 (77.106.0.1) 56(84) bytes of data.
64 bytes from 77.106.0.1: icmp_seq=1 ttl=62 time=20.4 ms
64 bytes from 77.106.0.1: icmp_seq=2 ttl=62 time=20.5 ms
64 bytes from 77.106.0.1: icmp_seq=3 ttl=62 time=20.3 ms
64 bytes from 77.106.0.1: icmp_seq=4 ttl=62 time=20.4 ms

--- 77.106.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3068ms
rtt min/avg/max/mdev = 20.4/20.3/20.4/0.20 ms
-------------------------
Pinging 77.107.0.1...
PING 77.107.0.1 (77.107.0.1) 56(84) bytes of data.
64 bytes from 77.107.0.1: icmp_seq=1 ttl=62 time=0.572 ms
64 bytes from 77.107.0.1: icmp_seq=2 ttl=62 time=0.584 ms
64 bytes from 77.107.0.1: icmp_seq=3 ttl=62 time=0.682 ms
64 bytes from 77.107.0.1: icmp_seq=4 ttl=62 time=0.529 ms

--- 77.107.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3059ms
rtt min/avg/max/mdev = 0.529/0.591/0.682/0.055 ms
-------------------------
Pinging 77.108.0.1...
PING 77.108.0.1 (77.108.0.1) 56(84) bytes of data.
64 bytes from 77.108.0.1: icmp_seq=1 ttl=62 time=0.396 ms
64 bytes from 77.108.0.1: icmp_seq=2 ttl=62 time=0.334 ms
64 bytes from 77.108.0.1: icmp_seq=3 ttl=62 time=0.333 ms
64 bytes from 77.108.0.1: icmp_seq=4 ttl=62 time=0.336 ms

--- 77.108.0.1 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3078ms
rtt min/avg/max/mdev = 0.333/0.349/0.396/0.026 ms
-------------------------
```

However we will look at the latency of the links notice how the `LOND -> BOST` has a high latency that will be important.
\
Now do `iperf3` between hosts. This will show the bandwidth between the hosts. However this doesnt have a easy script just yet and will have to be done manually, but because

```math
\binom{8}{2} = \frac{8!}{2!(8-2)!} = \frac{8 \cdot 7}{2 \cdot 1} = 28
```

This means we only have to run 28 tests instead of 56. This is done by running the following command on each host:
\
_This example done with LOND host and BOST host_

```bash
./goto LOND host
iperf3 -s
```

this runs server on LOND host. Now run the following command on BOST host:

```bash
./goto BOST host
iperf3 -c 77.101.0.1
```

```bash
## output:
BOST_host:~# iperf3 -c 77.101.0.1
Connecting to host 77.101.0.1, port 5201
[  5] local 77.106.0.1 port 45422 connected to 77.101.0.1 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  12.75 MBytes  107 Mbits/sec    0    308 KBytes
[  5]   1.00-2.00   sec  12.88 MBytes  108 Mbits/sec    0    368 KBytes
[  5]   2.00-3.00   sec  12.62 MBytes  106 Mbits/sec    0    426 KBytes
[  5]   3.00-4.00   sec  12.75 MBytes  107 Mbits/sec    0    482 KBytes
[  5]   4.00-5.00   sec  12.88 MBytes  108 Mbits/sec    0    543 KBytes
[  5]   5.00-6.00   sec  12.62 MBytes  106 Mbits/sec    0    600 KBytes
[  5]   6.00-7.00   sec  12.75 MBytes  107 Mbits/sec    0    658 KBytes
[  5]   7.00-8.00   sec  12.88 MBytes  108 Mbits/sec    0    717 KBytes
[  5]   8.00-9.00   sec  12.62 MBytes  106 Mbits/sec    0    775 KBytes
[  5]   9.00-10.00  sec  12.75 MBytes  107 Mbits/sec    0    831 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  127 MBytes   107 Mbits/sec    0             sender
[  5]   0.00-10.67  sec  123 MBytes   103 Mbits/sec                  receiver

iperf Done.
```

This shows the bandwidth between the two hosts. This is done for all hosts on the network. This will ensure that all hosts are reachable and the bandwidth is correct. This completes task 9.
\
For task 10 we need to identify a high latency link for this I chose `LOND -> BOST` as it has a high latency. This completes task 10.

## Task 11

### Objective

Plan a cost sheet for the `OSPF` network.

### Configuration
