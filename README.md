# iotDynamicPri
Dynamic Traffic Prioritization in IoT Networks Utilizing SDN (ONOS Controller and Mininet Topology)

Run: `sudo mn --controller=remote,ip=192.168.56.101 --custom=iot_sdn.py --topo=mytopo`

### Description:

With the rapid growth of the Internet of Things (IoT), the number of push-and-forget devices is increasing in traditional networks. These IoT devices are utilized for various applications at the edge server or the cloud.

The primary objective of this project is to effectively prioritize traffic in a network that comprises both IoT and traditional network components. We leverage the application-level knowledge of the IoT network to analyze the significance of data. By employing Software-Defined Networking (SDN), we can translate this application-level knowledge into traffic priorities.

For instance, consider a campus network with motion sensors, cameras, and computers generating user traffic as depicted in the topology. In a specific floor of the building, if a motion sensor detects any movement, the cameras should be given higher priority to stream HD video and web traffic should be given lower priority. Conversely, when there is no motion, the cameras should only stream SD video, and we should ensure that the camera’s UDP traffic does not consume the link bandwidth.
```markdown
# SDN-Based IoT Traffic Prioritization System

## Overview
This project is an SDN-based IoT traffic prioritization system utilizing Mininet (network emulator) and an ONOS (SDN controller). It simulates a campus network integrating cameras, computers, and motion sensors.

### What It Does
The system dynamically reprioritizes network traffic based on motion detection using SDN. 
* **Motion Detected:** Camera traffic receives bandwidth priority to enable HD streaming, while web traffic is deprioritized.
* **No Motion:** Cameras operate on low-priority SD video.

### Topology Architecture
The network consists of 14 hosts and 7 switches in a 3-tier hierarchical topology.

```text
        [ONOS Controller]
       192.168.56.101:6653
              |
    ┌─────── s1 (Core) ───────┐
    |         |     |          |
   h1        h2    s2 ── s3   ...
(Edge      (Internet)  ...
 Server)   Gateway)

```

---

## Prerequisites

**Important:** This system strictly requires a Linux host (Mininet is not compatible with macOS).

1. Set up a Linux VM and install the required dependencies:
```bash
sudo apt-get install mininet iperf3 python-requests openvswitch-switch

```

2. Create the necessary output directories:
```bash
mkdir -p /home/onos/iotDynamicPri/Results/{Internet,Stream}

```

3. Ensure you have an **ONOS controller** running at `192.168.56.101` on a separate VM.
4. **Python Version:** The codebase is currently written in Python 2. Ensure you have Python 2.7 installed, or update the syntax (e.g., `raw_input` to `input`, add parentheses to `print` statements) to run natively on Python 3.

---

## Running the System

The main entry point for the application builds the topology, configures QoS queues, and presents an interactive menu.

```bash
sudo python miniTopo.py

```

### Menu Options

| Command | Description |
| --- | --- |
| `1` or `static` | Run in static priority mode. |
| `2` or `dynamic` | Run in dynamic priority mode (SDN-controlled). |
| `3` or `cli` | Access the Mininet command-line interface. |

### Additional Commands

* **Simulate motion detection manually:**
```bash
sudo python motion_activity.py

```
* **Testing without ONOS controller:**
```bash
sudo python OVSminiTopo.py

```
---

## Project Structure

| Script | Description |
| --- | --- |
| `miniTopo.py` | Main entry point; builds the network topology and initializes the system. |
| `iot_sdn.py` | Core SDN logic and orchestration. |
| `configs.py` | Configuration variables and network parameters. |
| `add_queues.py` | Configures QoS queues on the switches. |
| `data_flows.py` | Manages background data transmission and flow generation. |
| `staticflow.py` | Applies static flow rules to the network. |
| `dynamicflow.py` | Handles dynamic, event-driven flow rule adjustments. |
| `postflow.py` | REST API interactions to push flows to the ONOS controller. |
| `motion_activity.py` | Simulates hardware motion sensor triggers. |
| `OVSminiTopo.py` | Standalone topology execution bypassing the ONOS controller requirement. |

---

## Results & Analytics

After running simulations, telemetry and data are collected and stored in the following locations:

* **PCAP Captures:** `Results/<switch>-<port>.pcap`
* **Internet Throughput Logs:** `Results/Internet/<host>.txt`
* **Camera Throughput Logs:** `Results/Stream/<host>.txt`

*Pro-tip:* Compare the throughput metrics in static vs. dynamic modes to visualize the SDN priority switching in real-time.

```

```

### Topology:

![Topology](https://github.com/uurname/iotDynamicPri/blob/master/topology.png)
