import os
from sys import platform, argv
from argparse import ArgumentParser

if platform != "linux":
    print(f"Not linux. ({platform})")
    exit(1)

LIST_CLI_TOOLS = "./lists/cli_tools.txt"
LIST_DEV = "./lists/dev.txt"
LIST_GUI_APT_APPS = "./lists/gui_apt_apps.txt"
LIST_GUI_SNAP_APPS = "./lists/gui_snap_apps.txt"


def file_readlines(filepath: str):
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read().splitlines()


def run(cmd: str):
    r = os.system(cmd)
    if r != 0:
        print(f"Command '{cmd}' failed. Exit code: {r}")
        print("Stopping.")
        exit(r)


def apt_install(program: str):
    print(f"\nInstalling '{program}'")
    command = f"sudo apt install {program} -y"
    run(command)


def apt_install_from_list(list_path: str):
    l = file_readlines(list_path)
    for i in l:
        if i[0] == "#":
            print(f"Skipping '{i}' (comment)")
            continue
        apt_install(i)
        print("_" * 64)
    print("Done.\n")


if __name__ == '__main__':
    if len(argv) < 2:
        exit(os.system(f"python3 {argv[0]} --help"))

    ap = ArgumentParser()
    ap.add_argument("--cli", action="store_true")
    ap.add_argument("--gui", action="store_true")
    ap.add_argument("--dev", action="store_true")
    ap.add_argument("--bashrc", action="store_true")
    ap.add_argument("--firefox-tweaks", action="store_true")
    ap.add_argument("--run-install-scripts", action="store_true")
    args = ap.parse_args()

    if args.dev:
        apt_install_from_list(LIST_DEV)
    if args.cli:
        apt_install_from_list(LIST_CLI_TOOLS)
        run("sudo apt-get install rubygems -y")
    if args.gui:
        apt_install_from_list(LIST_GUI_APT_APPS)
    if args.bashrc:
        run("cp ./config_files/.bashrc ~/.bashrc")
    if args.firefox_tweaks:
        run("sudo bash ./install_scripts/firefox_tweaks.sh")
    if args.run_install_scripts:
        run("sudo bash ./install_scripts/python3.10.sh")
        run("sudo bash ./install_scripts/lsd.sh")
        run("sudo bash ./install_scripts/croc.sh")
        run("sudo bash ./install_scripts/spacevim.sh")
        run("sudo bash ./install_scripts/jetbrains_toolbox.sh")
        run("sudo bash ./install_scripts/appimage_launcher.sh")