Here’s a breakdown of what needs to be committed at each step of the assignment, based on the instructions provided:

---

### **Step 1: Configure Host and Router Interfaces**
- **What to do:** Configure the IP addresses for the interfaces between hosts and routers as per the addressing plan in Figure 1.
- **What to commit:**
  - Configuration files for all routers (e.g., `LOND.conf`, `HAML.conf`, etc.).
  - Configuration files for all hosts (e.g., `LOND-host.conf`, `HAML-host.conf`, etc.).
  - Ensure the host interfaces are configured as `X.[100+Y].0.1/24` and the router interfaces as `X.[100+Y].0.2/24`.
  - Verify connectivity using `ping` between hosts and their respective routers.
- **Commit message example:**  
    `"Step 1: Configured host and router interfaces. Verified connectivity using ping."`

---

### **Step 2: Configure Router Loopback Interfaces**
- **What to do:** Configure the loopback interfaces on all routers as per the addressing plan in Figure 1.
- **What to commit:**
  - Updated configuration files for all routers with loopback addresses configured as `X.[150+Y].0.1/32`.
  - Verify connectivity using `ping` between hosts and their respective router loopback interfaces.
- **Commit message example:**  
    `"Step 2: Configured router loopback interfaces. Verified connectivity using ping."`

---

### **Step 3: Configure Addresses on All Links**
- **What to do:** Configure IP addresses on all router-to-router links as per the addressing plan in Figure 1.
- **What to commit:**
  - Updated configuration files for all routers with IP addresses assigned to all router-to-router links.
  - Verify connectivity using `ping` between directly connected routers.
- **Commit message example:**  
    `"Step 3: Configured IP addresses on all router-to-router links. Verified connectivity using ping."`

---

### **Step 4: Configure OSPF on All Routers**
- **What to do:** Configure OSPF on all routers using the backbone area `0.0.0.0`. Set the router ID to the router’s loopback address and use the `network` command to advertise the appropriate networks.
- **What to commit:**
  - Updated configuration files for all routers with OSPF configuration.
  - Verify OSPF adjacency and route sharing between routers.
- **Commit message example:**  
    `"Step 4: Configured OSPF on all routers. Verified OSPF adjacency and route sharing."`

---

### **Step 5: Verify Full Connectivity**
- **What to do:** Verify that all routers can ping and traceroute all other routers and their interfaces.
- **What to commit:**
  - No new configuration files, but ensure all previous configurations are correct.
  - Include a text file (e.g., `step-5.txt`) with the output of `ping` and `traceroute` commands showing full connectivity.
- **Commit message example:**  
    `"Step 5: Verified full connectivity between all routers. Added step-5.txt with ping and traceroute outputs."`

---

### **Step 6: Add Default Routes on Hosts**
- **What to do:** Add a default route on each host to its corresponding router.
- **What to commit:**
  - Updated configuration files for all hosts with default routes configured.
  - Verify that hosts can reach all other hosts on the network.
- **Commit message example:**  
    `"Step 6: Added default routes on all hosts. Verified full host-to-host connectivity."`

---

### **Step 7: Check Routing Tables and OSPF Database**
- **What to do:** Check the routing table, OSPF database, and OSPF routing table on each router.
- **What to commit:**
  - No new configuration files, but include a text file (e.g., `step-7.txt`) with the output of `show ip route`, `show ip ospf route`, and `show ip ospf database` commands.
- **Commit message example:**  
    `"Step 7: Checked routing tables and OSPF database. Added step-7.txt with outputs."`

---

### **Step 8: Verify OSPF Packets Are Not Leaked**
- **What to do:** Verify that hosts are not receiving OSPF packets using `tcpdump` or by checking the OSPF interface configuration on the router.
- **What to commit:**
  - No new configuration files, but include a text file (e.g., `step-8.txt`) with the output of `tcpdump` or OSPF interface configuration checks.
- **Commit message example:**  
    `"Step 8: Verified OSPF packets are not leaked to hosts. Added step-8.txt with verification outputs."`

---

### **Step 9: Measure Link Latency and Bandwidth**
- **What to do:** Measure and record the latency and bandwidth of all links between routers.
- **What to commit:**
  - A text file named `step-9.txt` containing the latency and bandwidth measurements for all links.
- **Commit message example:**  
    `"Step 9: Measured link latency and bandwidth. Added step-9.txt with results."`

---

### **Step 10: Identify High-Latency Path**
- **What to do:** Identify a high-latency path and run `ping`, `traceroute`, and `iperf3` between the affected hosts.
- **What to commit:**
  - A text file named `step-10.txt` containing the output of `ping`, `traceroute`, and `iperf3` commands for the high-latency path.
- **Commit message example:**  
    `"Step 10: Identified high-latency path. Added step-10.txt with ping, traceroute, and iperf3 outputs."`

---

### **Step 11: Adjust OSPF Link Costs**
- **What to do:** Adjust OSPF link costs to prefer low-latency paths.
- **What to commit:**
  - Updated configuration files for all routers with adjusted OSPF link costs.
  - A text file named `step-11.txt` reporting the new link costs and measured latencies after the changes.
- **Commit message example:**  
    `"Step 11: Adjusted OSPF link costs. Added step-11.txt with new costs and latencies."`

---

### **Step 12: Verify Improved Latency**
- **What to do:** Re-run `ping`, `traceroute`, and `iperf3` on the previously high-latency path to verify improvements.
- **What to commit:**
  - A text file named `step-12.txt` containing the new output of `ping`, `traceroute`, and `iperf3` for the improved path.
- **Commit message example:**  
    `"Step 12: Verified improved latency after OSPF cost adjustments. Added step-12.txt with new outputs."`

---

### **Step 13: Final Verification**
- **What to do:** Verify that all routing tables include routes to every host network, link, and router loopback. Ensure hosts can ping each other and router loopbacks.
- **What to commit:**
  - No new configuration files, but ensure all configurations are correct and complete.
- **Commit message example:**  
    `"Step 13: Final verification of routing tables and host connectivity."`

---

### **Step 14: Tidy Up Configuration**
- **What to do:** Clean up the configuration by removing unintended lines using the `no` command.
- **What to commit:**
  - Final configuration files for all routers and hosts.
- **Commit message example:**  
    `"Step 14: Tidied up configurations and removed unintended lines."`

---

### **Final Checklist**
- Ensure all required files are committed to the GitLab repo:
  - Configuration files for all routers and hosts.
  - `step-9.txt`, `step-10.txt`, `step-11.txt`, and `step-12.txt`.
  - A `readme.md` file with additional notes (if any).

---

By following this breakdown, you can ensure that each step is properly documented and committed to your GitLab repository.
