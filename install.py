import os
from sys import argv, platform

if platform != "linux":
    print(f"Not linux. ({platform})")
    exit(1)

LIST_CLI_TOOLS = "./lists/cli_tools.txt"
LIST_DEV = "./lists/dev.txt"
LIST_GUI_APT_APPS = "./lists/gui_apt_apps.txt"
LIST_GUI_SNAP_APPS = "./lists/gui_snap_apps.txt"
LIST_PIP = "./lists/pip.txt"


def file_readlines(filepath: str):
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read().splitlines()


def run(cmd: str):
    r = os.system(cmd)
    if r != 0:
        print(f"Command '{cmd}' failed. Exit code: {r}\nStopping.")
        exit(r)


def apt_install(program: str):
    print(f"\nInstalling '{program}'")
    command = f"sudo apt install {program} -y"
    run(command)


def apt_install_from_list(path: str):
    for i in file_readlines(path):
        if i[0] == "#":
            print(f"Skipping '{i}' (comment)")
            continue
        apt_install(i)
        print("_" * 64)
    print("Done.\n")


def cli():
    apt_install_from_list(LIST_CLI_TOOLS)


def dev():
    apt_install_from_list(LIST_DEV)


def gui():
    apt_install_from_list(LIST_GUI_APT_APPS)


def bashrc():
    run("cp  ~/.bashrc ~/.bashrc.old")
    print("Current .bashrc file backed up to '~/.bashrc.old'")
    run("cp ./dotfiles/.bashrc ~/.bashrc")


def ff_tweaks():
    run("sudo bash ./install_scripts/firefox_tweaks.sh")


def pip():
    for i in file_readlines(LIST_PIP):
        run(f"pip install {i}")


def oracle_vb():
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
    ap.add_argument("--oracle-vb", action="store_true")
    args = ap.parse_args()

    if args.all:
        dev()
        cli()
        gui()
        pip()
        bashrc()
        ff_tweaks()
        exit(0)

    if args.dev:
        dev()
    if args.pip():
        pip()
    if args.cli:
        cli()
    if args.gui:
        gui()
    if args.bashrc:
        bashrc()
    if args.firefox_tweaks:
        ff_tweaks()
    if args.oracle_vb:
        oracle_vb()
