<div align="center">
  <picture>
    <img src="./.github/assets/banner.png" alt="NOVA Playbook - Windows 11 Optimization" width="800" height="auto">
  </picture>

  <h1>NOVA Playbook for Windows 11</h1>
  <p><strong>System optimization for maximum gaming and productivity performance.</strong></p>

  <p>
    <a href="https://github.com/synoxvf/NOVA/releases/latest" aria-label="Latest Release">
      <img src="https://img.shields.io/github/v/release/synoxvf/NOVA?display_name=release&style=for-the-badge&logo=github&label=RELEASE&color=5B3CA1" alt="Release">
    </a>
    <a href="https://github.com/synoxvf/NOVA/blob/main/LICENSE" aria-label="License">
      <img src="https://img.shields.io/github/license/synoxvf/NOVA?style=for-the-badge&label=LICENSE&color=5B3CA1" alt="License">
    </a>
    <a href="https://github.com/synoxvf/NOVA/releases" aria-label="Downloads">
      <img src="https://img.shields.io/github/downloads/synoxvf/NOVA/total?style=for-the-badge&label=DOWNLOADS&color=5B3CA1" alt="Downloads">
    </a>
    <a href="https://youtu.be/gD3zmOf6Xqc" aria-label="YouTube Review" rel="noopener" target="_blank">
      <img src="https://img.shields.io/badge/YOUTUBE-INTRODUCING-5B3CA1?style=for-the-badge&logo=youtube" alt="YouTube">
    </a>
  </p>

  <p>
    <a href="./README.md" hreflang="en">
      <img src="https://img.shields.io/badge/ENGLISH-5B3CA1?style=for-the-badge&logo=google-translate&logoColor=white" alt="English">
    </a>
    <a href="./README_RU.md" hreflang="ru">
      <img src="https://img.shields.io/badge/РУССКИЙ-5B3CA1?style=for-the-badge&logo=google-translate&logoColor=white" alt="Русский">
    </a>
  </p>
</div>

## Table of Contents

- [Description](#description)
- [Features](#features)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Post-Installation](#post-installation)
- [Open Source](#open-source)
- [Credits](#credits)
- [Support](#support)

## Description

NOVA is an AME Wizard playbook aimed at improving performance, removing system bloat, and disabling tracking. The project is strictly focused on **ISO Injection** (modifying the image before installation) to ensure maximum system stability.

## Features

- 🚀 **Performance** — Reduces background system activity, disables telemetry, and adjusts power and system parameters for more stable performance.
- ✨ **Usability** — Removes built-in advertising and unnecessary components, and adjusts the Windows interface to simplify everyday use.
- 🔒 **Privacy** — Limits Microsoft's data collection and removes Edge and pre-installed components that are not required for system operation.

## System Requirements

> [!WARNING]  
> **ISO Injection Only.** This playbook is designed exclusively for a clean Windows installation. Running on an already installed system is **not supported**; critical errors may occur.

- **OS:** Windows 11 (Versions 24H2, 25H2)
- **Method:** [AME Wizard ISO Injection](https://docs.amelabs.net/iso_injection.html)
- **Hardware:** USB Flash Drive (8 GB minimum)

## Installation

### 1. Prepare Windows 11 Image

Using **UUP Dump** is recommended to integrate the latest updates.

**Method A: UUP Dump (Recommended):**

1. Visit [uupdump.net](https://uupdump.net/) and select **Latest Public Release build (x64)**.
2. Select your **Language** and **Edition**.
3. At the conversion step, select **"Download and convert to ISO"** and check the following:
   - ✅ **Include updates**
   - ✅ **Run component cleanup**
   - ✅ **Integrate .NET Framework 3.5**
   - ✅ **Use solid (ESD) compression**
4. Download the archive, extract it, and run the download script. Wait for the ISO creation to complete.

**Method B: Alternative:**

- Download the official ISO from the [Microsoft website](https://www.microsoft.com/software-download/windows11).

### 2. Build Modified Image

1. Download the **NOVA** playbook file (`.apbx`) from the [Releases](../../releases) section.
2. Download and launch [**AME Wizard Beta**](https://ame-wizard.com/).
3. Drag and drop your **ISO** into the program window, then select the `.apbx` file.
4. Select the desired settings in the menu and follow the instructions.
5. Wait for the build process to finish.

### 3. Burn and Install

1. Write the modified ISO to a USB drive using the AME Wizard built-in tool or [Rufus](https://rufus.ie/).
2. Boot from the USB drive (via BIOS/UEFI) and perform a clean installation of Windows.
3. The system will be automatically configured upon the first login to the desktop.

## Post-Installation
>
> [!IMPORTANT]
> **DO NOT** apply third-party optimizers, tweakers, or other playbooks on top of NOVA. Use the built-in **Post-Install menu** for system configuration.

<details>
<summary><strong>Drivers</strong></summary>

### 1. Chipset

- **AMD** - [Download from AMD.com](https://www.amd.com/en/support)
- **Intel** - [Download from Intel.com](https://www.intel.com/content/www/us/en/download-center/home.html)

### 2. GPU

- **NVIDIA:**
  - **Recommended** -  [NVCleanstall](https://www.techpowerup.com/download/techpowerup-nvcleanstall/)
- **AMD:**
  - **Recommended** - [RadeonSoftwareSlimmer](https://github.com/GSDragoon/RadeonSoftwareSlimmer)
  - **Custom** - [Amernime Zone](https://www.amernimezone.com/)
- **Intel Arc:**
  - [Download from Intel.com](https://www.intel.com/content/www/us/en/products/docs/arc-discrete-graphics/software/drivers.html).

### 3. Network

- **Realtek** - [Realtek PCIe FE / GBE / 2.5G / Gaming Family Controller](https://www.realtek.com/Download/List?cate_id=584)
- **Intel** -[Intel® Ethernet Adapter Complete Driver Pack](https://www.intel.com/content/www/us/en/download/15084/intel-ethernet-adapter-complete-driver-pack.html)
- **Intel (Wi-Fi)** - [Intel® Wireless Wi-Fi Drivers](https://www.intel.com/content/www/us/en/download/19351/windows-10-and-windows-11-wi-fi-drivers-for-intel-wireless-adapters.html)

</details>

<details>
<summary><strong>Windows Settings</strong></summary>

- **File Explorer:** If necessary, use the batch files in the “Post-Install” folder to remove **Home** and **Gallery** from File Explorer.
- **Power plan:** The **Balanced** power plan is enabled by default in the system, but you can select a different one.
- **Date and time:** Manually set the **Time zone** and synchronize the clock.
- **Services and features:** Use the “Post-Install” menu to enable or disable additional Windows features (printing, Bluetooth, etc.) according to your needs.

</details>

## FAQ

### Do anti-cheats (FACEIT, Vanguard, EAC, etc.) work?

> [!IMPORTANT]
> **Yes.** Anti-cheat-related features are preserved.

- Playbook does not remove components necessary for popular anti-cheats to function.

### Can I install Windows Update?

> [!WARNING]
> **Not recommended.** Windows Update may undo optimizations and restore disabled components.

- **Avoid cumulative updates** - they can be unstable and cause errors.

## Open Source

The NOVA project adheres to Open Source principles. The playbook file (`.apbx`) is a standard [ZIP archive with the password `malte`](https://docs.amelabs.net/developers/getting-started/creation.html), the contents of which are available for extraction and audit.

## Credits

This project utilizes resources and code snippets from the following authors and projects:

- **zoicware** - [DefenderProTools](https://github.com/zoicware/DefenderProTools).
- **Ameliorated-LLC** - [AME Wizard](https://github.com/Ameliorated-LLC)
- **undergroundwires** - [privacy.sexy](https://github.com/undergroundwires/privacy.sexy)

## Support

Have ideas or found a bug? Join the discussion on GitHub!

<div>
  <a href="https://github.com/synoxvf/NOVA/issues" aria-label="Discussions and questions">
    <img src="https://img.shields.io/badge/JOIN-THE_DISCUSSION%2FISSUES%2FFEATURES-5B3CA1?style=for-the-badge&logo=github&logoColor=white" alt="Discussion">
  </a>
</div>