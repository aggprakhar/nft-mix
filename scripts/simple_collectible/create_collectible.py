#!/usr/bin/python3
from brownie import SimpleCollectible, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT
from loguru import logger
from brownie.network.event import _decode_logs
from brownie.network.gas.strategies import GasNowStrategy

sample_token_uri = "ipfs://Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"


def main():
    logger.info("in main")
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    print(len(SimpleCollectible))
    # return
    simple_collectible = SimpleCollectible[len(SimpleCollectible) - 1]
    token_id = simple_collectible.tokenCounter()
    transaction = simple_collectible.createCollectible(sample_token_uri, {"from": dev})

    transaction.wait(1)
    print('transaction events', transaction.events)
    print("Transaction Logs", _decode_logs(transaction.logs))
    print(
        "Awesome! You can view your NFT at {}".format(
            OPENSEA_FORMAT.format(simple_collectible.address, token_id)
        )
    )
    print('Please give up to 20 minutes, and hit the "refresh metadata" button')
