#!/usr/bin/python3
from brownie import Qolaba, accounts, network, config
from scripts.helpful_scripts import get_publish_source
from loguru import logger

def main():
    logger.info("in main")
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    # QolabaMarketplace.deploy({"from": dev}, publish_source=get_publish_source())
    Qolaba.deploy({"from": dev}, publish_source=False)
# 0xd97A4D1a1D7A2DC383A92F1c19de03F7d5ACe467
