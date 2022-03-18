#!/usr/bin/python3
from brownie import AdvancedCollectible
from scripts.helpful_scripts import fund_with_link
from loguru import logger


def main():
    logger.info("inside main")
    advanced_collectible = AdvancedCollectible[len(AdvancedCollectible) - 1]
    fund_with_link(advanced_collectible.address)
