#!/usr/bin/env python3

import logging
import subprocess
import sys
from xml.etree import ElementTree

PORTS = {
    "tensin.name": [
        22,  # Gitea
        80,  # Web server
        443,  # Web server
        993,  # SSH
    ],
    "vpn.tensin.name": [
        993,  # SSH
        6003,  # i2pd
        7002,  # Tor (OR port)
        7003,  # Tor (DIR port)
    ],
    "vpn-ru.tensin.name": [
        993,  # SSH
    ],
}

PORTS["192.168.205.8"] = PORTS["tensin.name"] + [
    9090,  # Anubis Prometheus metrics
]

PORTS["192.168.205.254"] = PORTS["vpn.tensin.name"] + [
    80,  # Web server
    5001,  # Dante
    6001,  # i2pd (SOCKS proxy)
    6002,  # i2pd (HTTP proxy)
    6004,  # i2pd (Web UI)
    7001,  # Tor (SOCKS proxy)
]

PORTS["192.168.205.253"] = PORTS["vpn-ru.tensin.name"] + [
    80,  # Web server
    5001,  # Dante
]


def setup_logging():
    logging.basicConfig(
        level=logging.DEBUG,
        datefmt="%Y-%m-%d %H:%M:%S%z",
        # The 8 below is for "CRITICAL"
        format="%(asctime)s | %(levelname)8s | %(message)s",
    )


def run(*args, **kwargs):
    logging.debug("Running: %s", args)
    try:
        result = subprocess.run(
            args,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            encoding="utf-8",
            **kwargs
        )
    except subprocess.CalledProcessError as e:
        logging.error("An error occured:\n%s", e.stdout)
        raise
    return result.stdout


def run_nmap(host):
    #     -Pn (assume all hosts are up) is used because it doesn't work from
    #         GitHub Actions otherwise.
    return run("nmap", "-sS", "--open", "-p-", "-T4", "-Pn", "-oX", "-", host)


def get_open_ports_for(host):
    doc = ElementTree.fromstring(run_nmap(host))
    return [int(port.attrib["portid"]) for port in doc.findall(".//port")]


def validate_ports_for(host, expected):
    logging.info("Checking ports for %s...", host)
    expected = set(expected)
    actual = set(get_open_ports_for(host))
    if expected != actual:
        logging.error("... Expected: %s", sorted(expected))
        logging.error("... Actual:   %s", sorted(actual))
        return False
    logging.info("... Looks good")
    return True


def validate_ports_for_all():
    return all([validate_ports_for(host, ports) for host, ports in PORTS.items()])


def main():
    setup_logging()
    sys.exit(0 if validate_ports_for_all() else 1)


if __name__ == "__main__":
    main()
