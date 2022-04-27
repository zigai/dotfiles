#!/usr/bin/python3
import os
from sys import argv, platform

if platform != "linux":
    print(f"not linux. ({platform})")
    exit(1)

LIST_CLI_TOOLS = "./lists/cli_tools.txt"
LIST_DEV = "./lists/dev.txt"
LIST_PIP = "./lists/pip.txt"
LIST_GUI_APT = "./lists/apt_gui.txt"
LIST_GUI_SNAP = "./lists/snap_gui.txt"
LIST_GUI_FLATPAK = "./lists/flatpak_gui.txt"
LIST_VSCODE_EXT = "./lists/vscode_extensions.txt"


def file_splitlines(filepath: str):
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read().splitlines()


def run(command: str):
    r = os.system(command)
    if r != 0:
        print(f"command '{command}' failed. exit code: {r}\nstopping.")
        exit(r)


def apt_install(package: str):
    print(f"\n[apt] installing '{package}'")
    command = f"sudo apt install {package} -y"
    run(command)


def apt_install_from_list(path: str):
    for i in file_splitlines(path):
        if i[0] == "#":
            print(f"skipping '{i}' (comment)")
            continue
        apt_install(i)
        print("_" * 64)
    print("done.\n")


def cli():
    apt_install_from_list(LIST_CLI_TOOLS)
    cargo_list = ["choose", "broot", "lsd"]
    for i in cargo_list:
        run(f"cargo install {i}")
    run("/scripts/install_appimage_launcer.sh")
    run("/scripts/install_croc.sh")


def dev():
    apt_install_from_list(LIST_DEV)


def gui():
    apt_install_from_list(LIST_GUI_APT)

    for i in file_splitlines(LIST_GUI_SNAP):
        print(f"\n[snap] installing '{i}'")
        run(f"sudo snap install {i}")

    for i in file_splitlines(LIST_GUI_FLATPAK):
        print(f"\n[flatpak] installing '{i}'")
        run(f"flatpak install flathub {i}")


def bashrc():
    print("installing .bashrc")
    run("cp  ~/.bashrc ~/.bashrc.old")
    print("current .bashrc file backed up to '~/.bashrc.old'")
    run("cp ./dotfiles/.bashrc ~/.bashrc")
    print("done.")


def ff_ui_fix():
    run("sudo bash ./scripts/install_firefox_tweaks.sh")


def pip():
    for i in file_splitlines(LIST_PIP):
        print(f"\n[pip] installing '{i}'")
        run(f"pip install {i}")


def vscode_extensions():
    for i in file_splitlines(LIST_VSCODE_EXT):
        run(f"code --install-extension {i}")


def virtual_box():
    run("sudo apt update")
    run("sudo apt install -y --reinstall virtualbox-guest-x11")
    l = ["virtualbox-guest-utils-hwe", "virtualbox-guest-x11-hwe"]
    for i in l:
        apt_install(i)


if __name__ == '__main__':
    if len(argv) < 2:
        exit(os.system(f"python3 {argv[0]} --help"))

    from argparse import ArgumentParser
    ap = ArgumentParser()
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--cli", action="store_true")
    ap.add_argument("--gui", action="store_true")
    ap.add_argument("--dev", action="store_true")
    ap.add_argument("--pip", action="store_true")
    ap.add_argument("--bashrc", action="store_true")
    ap.add_argument("--firefox-tweaks", action="store_true")
    ap.add_argument("--vscode-extensions", action="store_true")
    ap.add_argument("--virtual-box", action="store_true")
    args = ap.parse_args()

    if args.all:
        dev()
        cli()
        gui()
        pip()
        bashrc()
        ff_ui_fix()
        exit(0)

    if args.dev:
        dev()
    if args.pip:
        pip()
    if args.cli:
        cli()
    if args.gui:
        gui()
    if args.firefox_tweaks:
        ff_ui_fix()
    if args.virtual_box:
        virtual_box()
    if args.bashrc:
        bashrc()
    if args.vscode_extensions:
        vscode_extensions()
