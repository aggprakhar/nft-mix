import pytest
from brownie import network, NFTMarketplace, convert, chain, Wei, QolabaMarketplace
from scripts.helpful_scripts import get_account
from brownie.network.gas.strategies import ExponentialScalingStrategy



def test_can_create_simple_collectible():
    if network.show_active() not in ["development"] or "fork" in network.show_active():
        pytest.skip("Only for local testing")

    # Gas Strategy
    gas_strategy = ExponentialScalingStrategy("10 gwei", "50 gwei")

    simple_collectible = NFTMarketplace.deploy(
        {"from": get_account(), "gas_price": gas_strategy}
    )
    simple_collectible.createToken(
        "None", Wei("0.25 ether"), {"from": get_account(), "gas_price": gas_strategy}
    )
    items = simple_collectible.fetchMarketItems()
    listing = simple_collectible.getListingPrice()
    my_nft = simple_collectible.fetchMyNFTs({"from": get_account()})
    print(listing, items, my_nft, QolabaMarketplace)
    assert listing == Wei("0.025 ether")
    # assert True