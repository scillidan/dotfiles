#!/usr/bin/env python3
"""One-line CPU/RAM/GPU/host summary for the zjstatus command widget."""

import os
import shutil
import socket
import subprocess

try:
    import psutil
except ImportError:
    psutil = None


def cpu_percent():
    if psutil:
        return f"{psutil.cpu_percent(interval=0.1):.0f}%"
    try:
        load = os.getloadavg()[0]
        return f"{min(load / (os.cpu_count() or 1), 1) * 100:.0f}%"
    except (AttributeError, OSError):
        return "?"


def ram_percent():
    if psutil:
        return f"{psutil.virtual_memory().percent:.0f}%"
    if os.path.exists("/proc/meminfo"):
        info = {}
        with open("/proc/meminfo") as f:
            for line in f:
                key, value = line.split(":", 1)
                info[key] = int(value.split()[0])
        available = info.get("MemAvailable", info.get("MemFree", 0))
        return f"{(info['MemTotal'] - available) / info['MemTotal'] * 100:.0f}%"
    return "?"


def gpu_percent():
    exe = shutil.which("nvidia-smi")
    if not exe:
        return None
    try:
        out = (
            subprocess.run(
                [exe, "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"],
                capture_output=True,
                text=True,
                timeout=2,
            )
            .stdout.strip()
            .splitlines()
        )
        return f"{out[0].strip()}%" if out else None
    except (OSError, subprocess.SubprocessError):
        return None


def main():
    parts = [f"cpu:{cpu_percent()}", f"ram:{ram_percent()}"]
    gpu = gpu_percent()
    if gpu:
        parts.append(f"gpu:{gpu}")
    parts.append(socket.gethostname().split(".")[0])
    print(" ".join(parts))


if __name__ == "__main__":
    main()
