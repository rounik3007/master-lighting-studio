# ⚡ Master Lighting & Automation Studio

A lightweight, local-first IoT control ecosystem and PWA dashboard built to orchestrate workstation lighting, hardware peripherals, display telemetry, and system automations without relying on cloud services or paid middleware.

![Node.js](https://img.shields.io/badge/Node.js-v18%2B-green?style=flat&logo=nodedotjs)
![Express](https://img.shields.io/badge/Express-4.x-blue?style=flat&logo=express)
![JavaScript](https://img.shields.io/badge/JavaScript-ES6%2B-yellow?style=flat&logo=javascript)
![PowerShell](https://img.shields.io/badge/PowerShell-Native%20WMI-blue?style=flat&logo=powershell)
![License](https://img.shields.io/badge/License-MIT-brightgreen)

---

## 🛠️ System Architecture

+--------------------------+          +-----------------------------------+
|  Mobile PWA Controller   |  HTTP    |     Node.js Server (server.js)     |
| (Galaxy S24 Ultra / Web) | -------> |  Express REST API & Static Server |
+--------------------------+          +-----------------------------------+
|
+----------------------------------------------+----------------------------------------------+
|                                              |                                              |
v                                              v                                              v
+------------------+                          +-------------------+                          +--------------------+
|  Philips WiZ UDP |                          | Windows WMI & CLI |                          | Clevo & Kreo Apps  |
|  (Port: 38899)   |                          | Brightness & CPU  |                          | Per-Key RGB tools  |
+------------------+                          +-------------------+                          +--------------------+


---

## ✨ Features

- 💡 **Smart Lighting Integration:** Direct UDP socket communication (`dgram`) with Philips WiZ smart lamps.
- ⌨️ **Per-Key RGB Control:** Integrated CLI bindings for Clevo keyboard backlighting (`CLEVO_KeyboardColour.exe`) and Kreo Hive 65 process management (`OemDrv.exe`).
- 🖥️ **Native Display Dimming:** Direct WMI PowerShell integration (`WmiMonitorBrightnessMethods`) for screen brightness.
- ⚡ **UI Debouncing:** 100ms client-side debouncing on sliders to prevent process bottlenecks during dragging.
- 🎯 **Preset Profiles (0–35):** One-tap execution of multi-device lighting scenes including Blackout and Shutdown modes.
- 🚀 **Quick Automations:** One-touch application launchers (Valorant, Modern Warfare 4, OBS Studio, Spotify, Discord, YouTube, Steam).
- 📊 **System Telemetry:** Real-time CPU core load polling via PowerShell CIM commands.
- 🌐 **Zero-Cost Remote Access:** Configured for background LocalTunnel execution via VBScript (`start_tunnel.vbs`).

---

## 📁 Repository Structure

text
├── public/
│   ├── index.html        # PWA interface with dark cyber-theme & live controls
│   └── manifest.json     # PWA metadata for installation on mobile devices
├── server.js             # Express server, UDP socket handlers, & WMI execution routes
├── run_menu.ps1          # PowerShell helper script bypassing execution policy
├── start_tunnel.vbs      # Silent background startup script for local tunneling
├── package.json          # Node.js dependencies
└── README.md             # Repository documentation

