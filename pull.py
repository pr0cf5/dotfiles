#!/usr/bin/env python3

import os
import sys
import shutil
import subprocess
from pathlib import Path

def sync_nvim():
    """Sync nvim config from home to dotfiles repo"""
    src = Path.home() / ".config" / "nvim"
    dest = Path.cwd() / "nvim"
    
    if not src.exists():
        print(f"Error: {src} does not exist")
        sys.exit(1)
    
    if dest.exists():
        shutil.rmtree(dest)
    
    shutil.copytree(src, dest)

def sync_tmux():
    """Sync tmux config from home to dotfiles repo"""
    src = Path.home() / ".tmux.conf"
    dest = Path.cwd() / ".tmux.conf"
    
    if src.exists():
        shutil.copy2(src, dest)

def main():
    repo_name = Path.cwd().name
    
    if repo_name != "dotfiles":
        print("Error: Current directory is not named 'dotfiles'")
        sys.exit(1)
    
    sync_nvim()
    sync_tmux()
    
    subprocess.run(["git", "add", "nvim", ".tmux.conf"], check=True)
    subprocess.run(["git", "commit"], check=True)

if __name__ == "__main__":
    main()