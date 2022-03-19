#!/usr/bin/python3
from brownie import NFTMarketplace, accounts, network, config
from scripts.helpful_scripts import get_publish_source
from loguru import logger

def main():
    logger.info("in main")
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    # SimpleCollectible.deploy({"from": dev}, publish_source=get_publish_source())
    NFTMarketplace.deploy({"from": dev}, publish_source=False)
