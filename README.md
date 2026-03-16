# TMS9900 GCC Toolchain Installer

This repository provides a fully automated installer for building and configuring the GCC-based TMS9900 cross‑compiler toolchain along with several essential TI‑99/4A utilities. It is designed for Linux and WSL (Ubuntu recommended) and sets up everything needed to compile TI‑99/4A software using a modern GCC toolchain.

You may **download and run the installer script directly** without cloning this repository.

---

## 🚀 Quick Install (No Repo Clone Required)

You can install the entire TMS9900 GCC toolchain by downloading the installer script and running it.

### 1. Download the installer script
wget [https://raw.githubusercontent.com/GCC-tms9900_install/main/tms9900-gcc_install.sh](https://github.com/shift838/gcc-tms9900_install/blob/main/tms9900-gcc_install.sh)

### 2. Grant execute permissions to the script
chmod +x tms9900-gcc_install.sh

### 3. Run the installer
./tms9900-gcc_installer.sh

# What the Installer Sets Up:
The  script performs a complete toolchain setup:
• 	Installs required system packages:
• 	Creates a working directory for all build operations
• 	Download and extracts:
    - gcc-installer.tar.gz
    - gcc10-patch.zip
•   Runs the official install.sh to build the TMS9900 GCC cross-compiler
• 	Builds and installs:
    - elf2ea5
    - ea5split
    - elf2cart
•   Clones:
	  - (Tursilion’s TI‑99 support library)
    - (Jedimatt42’s 32K memory tester)
• 	Adds required environment variables to .bashrc
    - PATH=~/tms9900gcc/bin:$PATH
    - LIBTI99 =~/libti99
• 	Provides instructions for building the 32K memory tester

The script includes error‑handling logic to stop on failure and only prints a success message when the installation is fully complete.

# POST Installation

1. To activate the updated enviornment variables:
source ~/.bashrc
or simply just open a new terminal

# To build the 32k memory tester project:
1. Edit Makefile to ensure LIBTI99 points to your ~/libti99 directory.
2. Perform the below commands:
cd ~/ti994a-32kmemtest
make

#Repository contents:
tms9900-gcc_install.sh     # Automated installer script
gcc-installer.tar.gz       # GCC TMS9900 installer package
gcc10-patch.zip            # GCC10 compatibility patch
elf2ea5.tar.gz             # elf2ea5 utility source
ea5split3.zip              # ea5split utility source
elf2cart.tar.gz            # elf2cart utility source
README.md                  # Documentation

This installer is intended for Linux and WSL (Ubuntu recommended).
• 	All required toolchain components are hosted in this repository for stable, script‑friendly access.
• 	The installer uses strict error handling to ensure reliability and clear failure reporting.

