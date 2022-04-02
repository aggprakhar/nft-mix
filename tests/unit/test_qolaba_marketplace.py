import pytest
from brownie import network, NFTMarketplace, convert, chain, Wei, QolabaMarketplace
from scripts.helpful_scripts import get_account
from brownie.network.gas.strategies import ExponentialScalingStrategy
from scripts.utils.Strings import *
from loguru import logger


def test_qolaba_marketplace():
    if network.show_active() not in ["development"] or "fork" in network.show_active():
        pytest.skip("Only for local testing")

    # Gas Strategy
    gas_strategy = ExponentialScalingStrategy("10 gwei", "50 gwei")

    qolaba_marketplace_contract = QolabaMarketplace.deploy(
        {"from": get_account(), "gas_price": gas_strategy}
    )
    # print(qolaba_marketplace_contract.events)
    create_token_transaction = qolaba_marketplace_contract.addNewToken(
        TEST_TOKEN_URI, {"from": get_account(), "gas_price": gas_strategy}
    )
    events = dict(create_token_transaction.events['Transfer'])
    print(gas_strategy.get_gas_price())
    assert isinstance(events, dict)
    token_id = qolaba_marketplace_contract.originalTokenOfUri(
        TEST_TOKEN_URI
    )
    creator_of_token = qolaba_marketplace_contract.creatorOfToken(token_id)
    logger.info(f"Minted NFT ID {events['_tokenId']} with uri - {TEST_TOKEN_URI} for {events['_to']}")

    token_uri = qolaba_marketplace_contract.tokenURI(token_id)


    current_bid_details_of_token = qolaba_marketplace_contract.currentBidDetailsOfToken(token_id)
    current_bid = current_bid_details_of_token[0]
    current_bidder = current_bid_details_of_token[1]



    sale_price_of_token = qolaba_marketplace_contract.salePriceOfToken(token_id)
    # items = simple_collectible.fetchMarketItems()
    # listing = simple_collectible.getListingPrice()
    # my_nft = simple_collectible.fetchMyNFTs({"from": get_account()})
    print(token_id, TEST_TOKEN_URI, current_bid, current_bidder, creator_of_token,
          sale_price_of_token)
    print(qolaba_marketplace_contract.balanceOf(get_account()))
    assert token_id == 1
    assert token_uri == TEST_TOKEN_URI
    # assert True