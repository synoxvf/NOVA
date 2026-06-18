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
- [FAQ](#faq)
- [Open Source](#open-source)
- [Credits](#credits)
- [Support](#support)

## Description

NOVA is a playbook (an automated configuration script) for [AME Wizard](https://ame-wizard.com/) that prepares a Windows 11 installation image. It removes unnecessary system components, reduces background activity, and disables data collection sent to Microsoft.

Settings are applied to the installation image *before* Windows is installed — this approach is called **ISO Injection**. Modifying an already running system is not supported.

## Features

- **Performance** — Reduces background system activity, disables telemetry, and adjusts power and system parameters for more stable performance.
- **Usability** — Removes built-in advertising and unnecessary components, and adjusts the Windows interface to simplify everyday use.
- **Privacy** — Limits Microsoft's data collection and removes Edge and pre-installed components that are not required for system operation.

## System Requirements

> [!WARNING]
> **ISO Injection only.** This playbook is designed for a clean Windows installation. Running it on an already installed system is **not supported** and may cause critical errors.

- **OS:** Windows 11 (versions 24H2, 25H2)
- **Method:** [AME Wizard ISO Injection](https://docs.amelabs.net/iso_injection.html)
- **Hardware:** USB flash drive (8 GB minimum)

## Installation

### 1. Prepare the Windows 11 image

Using **UUP Dump** is recommended — it integrates the latest cumulative updates into the image.

**Method A — UUP Dump (recommended):**

1. Visit [uupdump.net](https://uupdump.net/) and select **Latest Public Release build (x64)**.
2. Choose your **Language** and **Edition**.
3. At the conversion step, select **"Download and convert to ISO"** and enable:
   - ✅ **Include updates**
   - ✅ **Run component cleanup**
   - ✅ **Integrate .NET Framework 3.5**
   - ✅ **Use solid (ESD) compression**
4. Download the archive, extract it, and run the download script. Wait for the ISO to be created.

**Method B — official ISO:**

- Download the ISO directly from the [Microsoft website](https://www.microsoft.com/software-download/windows11). Updates are not pre-integrated.

### 2. Build the modified image

1. Download the **NOVA** playbook file (`.apbx`) from the [Releases](../../releases) page.
2. Download and launch [**AME Wizard Beta**](https://ame-wizard.com/).
3. Drag and drop your **ISO** into the program window, then select the `.apbx` file.
4. Choose the desired options in the menu and follow the on-screen instructions.
5. Wait for the build process to finish.

### 3. Write to USB and install

1. Write the modified ISO to a USB drive using the built-in AME Wizard tool or [Rufus](https://rufus.ie/).
2. Boot from the USB drive (via BIOS/UEFI) and perform a clean Windows installation.
3. The system will be configured automatically on first login to the desktop.

## Post-Installation

> [!IMPORTANT]
> **Do not** apply third-party optimizers, tweakers, or other playbooks on top of NOVA. Use the built-in **Post-Install menu** for any further configuration.

<details>
<summary><strong>Drivers</strong></summary>

### 1. Chipset

- **AMD** — [Download from AMD.com](https://www.amd.com/en/support)
- **Intel** — [Download from Intel.com](https://www.intel.com/content/www/us/en/download-center/home.html)

### 2. GPU

- **NVIDIA:**
  - **Recommended** — [NVCleanstall](https://www.techpowerup.com/download/techpowerup-nvcleanstall/)
- **AMD:**
  - **Recommended** — [RadeonSoftwareSlimmer](https://github.com/GSDragoon/RadeonSoftwareSlimmer)
  - **Custom** — [Amernime Zone](https://www.amernimezone.com/)
- **Intel Arc:**
  - [Download from Intel.com](https://www.intel.com/content/www/us/en/products/docs/arc-discrete-graphics/software/drivers.html)

### 3. Network

- **Realtek** — [Realtek PCIe FE / GBE / 2.5G / Gaming Family Controller](https://www.realtek.com/Download/List?cate_id=584)
- **Intel** — [Intel® Ethernet Adapter Complete Driver Pack](https://www.intel.com/content/www/us/en/download/15084/intel-ethernet-adapter-complete-driver-pack.html)
- **Intel (Wi-Fi)** — [Intel® Wireless Wi-Fi Drivers](https://www.intel.com/content/www/us/en/download/19351/windows-10-and-windows-11-wi-fi-drivers-for-intel-wireless-adapters.html)

</details>

<details>
<summary><strong>Windows Settings</strong></summary>

- **File Explorer:** If needed, use the batch files in the "Post-Install" folder to remove **Home** and **Gallery** from File Explorer.
- **Power plan:** The **Balanced** plan is enabled by default — switch to another if preferred.
- **Date and time:** Manually set the **Time zone** and synchronize the clock.
- **Services and features:** Use the "Post-Install" menu to enable or disable additional Windows features (printing, Bluetooth, etc.) as needed.

</details>

## FAQ

### Are kernel-level anti-cheats supported? (Vanguard, FACEIT, EAC, BattlEye)

> [!IMPORTANT]
> **Yes.** NOVA preserves the system components required by kernel-level anti-cheats.

- **VBS** (Virtualization-Based Security — hardware-assisted memory protection) is enabled by default. It is required for Vanguard and FACEIT AC. VBS can be turned off via the Post-Install menu if you do not play games that require it.
- Driver signature enforcement and **Memory Integrity** remain enabled.
- No services or components related to anti-cheats are removed.

### Can I roll back NOVA changes?

> [!WARNING]
> **There is no automatic rollback.** Because changes are applied to the installation image, NOVA cannot be uninstalled from a running system.

- To return to stock Windows 11, perform a clean installation using an unmodified ISO.
- Some settings can be reverted manually via the **Post-Install menu** (for example, re-enabling Windows Defender or VBS).

### Can I install Windows Updates?

> [!WARNING]
> **Not recommended.** Windows Update may revert NOVA's changes and restore disabled components.

- **Avoid cumulative updates** — they can be unstable and may cause errors.
- To stay current with security updates, rebuild the image with a fresh ISO from UUP Dump instead of installing updates afterwards.

## Open Source

NOVA follows open-source principles. The playbook file (`.apbx`) is a standard [ZIP archive with the password `malte`](https://docs.amelabs.net/developers/getting-started/creation.html) — its contents can be extracted and audited.

## Credits

This project uses resources and code from the following authors and projects:

- **zoicware** — [DefenderProTools](https://github.com/zoicware/DefenderProTools)
- **Ameliorated-LLC** — [AME Wizard](https://github.com/Ameliorated-LLC), [Privacy+](https://github.com/Ameliorated-LLC/privacy_plus)
- **undergroundwires** — [privacy.sexy](https://github.com/undergroundwires/privacy.sexy)
- **valleyofdoom** — [MouseTester](https://github.com/valleyofdoom/MouseTester)
- **spddl** — [GoInterruptPolicy](https://github.com/spddl/GoInterruptPolicy)

## Support

Have ideas or found a bug? Open an issue or join the discussion on GitHub.

<div>
  <a href="https://github.com/synoxvf/NOVA/issues" aria-label="Discussions and questions">
    <img src="https://img.shields.io/badge/JOIN-THE_DISCUSSION%2FISSUES%2FFEATURES-5B3CA1?style=for-the-badge&logo=github&logoColor=white" alt="Discussion">
  </a>
</div>
