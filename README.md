# Tools

A collection of simple scripts and references for use on remote systems - designed for system administration, penetration testing, and CTF challenges.

## Overview

This repository contains lightweight, portable tools that can be quickly deployed on remote systems where you may have limited resources or restricted environments. The focus is on simplicity, reliability, and ease of use.

## Usage

### Quick Deploy

Clone or download individual scripts as needed:

```bash
# Clone the entire repository
git clone https://github.com/spencershepard/Tools.git
```

Or download a specific script (use whatever is available):
```bash 
curl -O https://raw.githubusercontent.com/spencershepard/Tools/main/nix/recon.sh
```

```bash
wget https://raw.githubusercontent.com/spencershepard/Tools/main/nix/recon.sh
```

```bash
python -c "import urllib.request; urllib.request.urlretrieve('https://raw.githubusercontent.com/spencershepard/Tools/main/nix/recon.sh', 'recon.sh')"
```

```bash
perl -MLWP::Simple -e 'getstore("https://raw.githubusercontent.com/spencershepard/Tools/main/nix/recon.sh", "recon.sh")'
```
