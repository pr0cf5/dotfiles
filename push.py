#!/usr/bin/env python3

import os
import sys
import shutil
from pathlib import Path

def sync_nvim():
    """Sync nvim config from dotfiles repo to home"""
    src = Path.cwd() / "nvim"
    dest = Path.home() / ".config" / "nvim"
    
    if not src.exists():
        print(f"Error: {src} does not exist")
        sys.exit(1)
    
    if dest.exists():
        shutil.rmtree(dest)
    
    shutil.copytree(src, dest)

def sync_tmux():
    """Sync tmux config from dotfiles repo to home"""
    src = Path.cwd() / ".tmux.conf"
    dest = Path.home() / ".tmux.conf"
    
    if src.exists():
        shutil.copy2(src, dest)

def sync_claude():
    """Sync Claude config from dotfiles repo to home"""
    src = Path.cwd() / ".claude.json"
    dest = Path.home() / ".claude.json"
    
    if src.exists():
        if dest.exists():
            dest.unlink()  # Remove existing file
        shutil.copy2(src, dest)

def main():
    repo_name = Path.cwd().name
    
    if repo_name != "dotfiles":
        print("Error: Current directory is not named 'dotfiles'")
        sys.exit(1)
    
    sync_nvim()
    sync_tmux()
    sync_claude()

if __name__ == "__main__":
    main()
