#!/usr/bin/python3
from brownie import Qolaba, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT
from loguru import logger
from brownie.network.event import _decode_logs
from brownie.network.gas.strategies import GasNowStrategy
from brownie.network.gas.strategies import ExponentialScalingStrategy
from brownie import Wei
import json

sample_token_uri = "ipfs://Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"


def main():
    logger.info("in main")
    dev = accounts.add(config["wallets"]["from_key"])
    # owner = "0x2f3a32f701a20197a2edabe8dde66e17639e56559d0f92078c1813339e245113"
    # print(json.dumps(Qolaba.abi))
    print(network.show_active())
    # print(len(NFTMarketplace))
    # # return
    nft_marketplace = Qolaba[len(Qolaba) - 1]
    gas_strategy = ExponentialScalingStrategy("10 gwei", "50000 gwei")

    # # token_id = nft_marketplace._tokenIds.current()
    # listing_price = nft_marketplace.getListingPrice()
    # print(listing_price)
    # transaction = nft_marketplace.whitelistCreator('0xbeB5e0245971D7Ba5559510aA8902F45b880B5b6',{"from": dev})

    # Create token and set auction
    # transaction = nft_marketplace.createToken("ipfs://QmWbjnPEzAubP495gxHJyPs1VL9UG8D7uFAGFQxTufqUB8?filename=ufo1.png", Wei("0.01 ether"),{"from": dev, "value": Wei("0.025 ether")})
    # transaction = nft_marketplace.setAuctionContract(1, 604800,{"from": dev, "gas_price": gas_strategy})
    # transaction = nft_marketplace.createMarketSale(2, {"from": dev, "value": Wei("0.01 ether"), "gas_price": gas_strategy})

    # transaction = nft_marketplace.setSalePrice(1, Wei("0.045 ether"), {"from": dev, "gas_price": gas_strategy})
    # transaction = nft_marketplace.salePriceOfToken(1, {"from": dev})
    transaction = nft_marketplace.bid(3, {"from": dev, "gas_price": gas_strategy, "value": Wei("0.04 ether")})
    # transaction = nft_marketplace.acceptBid(1, {"from": dev, "gas_price": gas_strategy})
    # transaction = nft_marketplace.ownerOf(1)
    # transaction = nft_marketplace.buy(1, {"from": dev, "gas_price": gas_strategy, "value": Wei("0.045 ether")})
    # print(transaction1, transaction2)
    # Wei("0.025 ether")
    # transaction.wait(1)
    print('transaction events', transaction.events)
    # print('transaction events', transaction1.events, transaction2.events)
    # print("Transaction Logs", _decode_logs(transaction.logs))
    # print(
    #     "Awesome! You can view your NFT at {}".format(
    #         OPENSEA_FORMAT.format(simple_collectible.address, token_id)
    #     )
    # )
    # print('Please give up to 20 minutes, and hit the "refresh metadata" button')

    x  = [{"constant": False, "inputs": [{"name": "_uri", "type": "string"}, {"name": "_editions", "type": "uint256"},
                                    {"name": "_salePrice", "type": "uint256"}], "name": "addNewTokenWithEditions",
      "outputs": [], "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": False, "inputs": [{"name": "_tokenId", "type": "uint256"}, {"name": "_salePrice", "type": "uint256"}],
      "name": "setSalePrice", "outputs": [], "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": True, "inputs": [], "name": "name", "outputs": [{"name": "_name", "type": "string"}],
      "payable": False, "stateMutability": "pure", "type": "function"},
     {"constant": False, "inputs": [{"name": "_to", "type": "address"}, {"name": "_tokenId", "type": "uint256"}],
      "name": "approve", "outputs": [], "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": True, "inputs": [], "name": "totalSupply", "outputs": [{"name": '', "type": "uint256"}],
      "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "currentBidDetailsOfToken",
      "outputs": [{"name": '', "type": "uint256"}, {"name": '', "type": "address"}], "payable": False,
      "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "approvedFor",
      "outputs": [{"name": '', "type": "address"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": False, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "acceptBid", "outputs": [],
      "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": True, "inputs": [{"name": "_creator", "type": "address"}], "name": "isWhitelisted",
      "outputs": [{"name": '', "type": "bool"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": False, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "bid", "outputs": [],
      "payable": True, "stateMutability": "payable", "type": "function"},
     {"constant": True, "inputs": [{"name": "_owner", "type": "address"}], "name": "tokensOf",
      "outputs": [{"name": '', "type": "uint256[]"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": False, "inputs": [{"name": "_percentage", "type": "uint256"}], "name": "setMaintainerPercentage",
      "outputs": [], "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": False, "inputs": [{"name": "_creator", "type": "address"}], "name": "whitelistCreator", "outputs": [],
      "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": True, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "ownerOf",
      "outputs": [{"name": '', "type": "address"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [{"name": "_uri", "type": "string"}], "name": "originalTokenOfUri",
      "outputs": [{"name": '', "type": "uint256"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [{"name": "_owner", "type": "address"}], "name": "balanceOf",
      "outputs": [{"name": '', "type": "uint256"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [], "name": "owner", "outputs": [{"name": '', "type": "address"}], "payable": False,
      "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [], "name": "symbol", "outputs": [{"name": "_symbol", "type": "string"}],
      "payable": False, "stateMutability": "pure", "type": "function"},
     {"constant": False, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "cancelBid", "outputs": [],
      "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": True, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "salePriceOfToken",
      "outputs": [{"name": '', "type": "uint256"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": False, "inputs": [{"name": "_to", "type": "address"}, {"name": "_tokenId", "type": "uint256"}],
      "name": "transfer", "outputs": [], "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": False, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "takeOwnership", "outputs": [],
      "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": False, "inputs": [{"name": "_percentage", "type": "uint256"}], "name": "setCreatorPercentage",
      "outputs": [], "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": True, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "tokenURI",
      "outputs": [{"name": '', "type": "string"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "creatorOfToken",
      "outputs": [{"name": '', "type": "address"}], "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": False, "inputs": [{"name": "_tokenId", "type": "uint256"}], "name": "buy", "outputs": [],
      "payable": True, "stateMutability": "payable", "type": "function"},
     {"constant": False, "inputs": [{"name": "_uri", "type": "string"}], "name": "addNewToken", "outputs": [],
      "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"constant": True, "inputs": [], "name": "creatorPercentage", "outputs": [{"name": '', "type": "uint256"}],
      "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": True, "inputs": [], "name": "maintainerPercentage", "outputs": [{"name": '', "type": "uint256"}],
      "payable": False, "stateMutability": "view", "type": "function"},
     {"constant": False, "inputs": [{"name": "newOwner", "type": "address"}], "name": "transferOwnership",
      "outputs": [], "payable": False, "stateMutability": "nonpayable", "type": "function"},
     {"anonymous": False, "inputs": [{"indexed": True, "name": "_creator", "type": "address"}],
      "name": "WhitelistCreator", "type": "event"}, {"anonymous": False,
                                                     "inputs": [{"indexed": True, "name": "_bidder", "type": "address"},
                                                                {"indexed": True, "name": "_amount", "type": "uint256"},
                                                                {"indexed": True, "name": "_tokenId",
                                                                 "type": "uint256"}], "name": "Bid", "type": "event"},
     {"anonymous": False, "inputs": [{"indexed": True, "name": "_bidder", "type": "address"},
                                     {"indexed": True, "name": "_seller", "type": "address"},
                                     {"indexed": False, "name": "_amount", "type": "uint256"},
                                     {"indexed": True, "name": "_tokenId", "type": "uint256"}], "name": "AcceptBid",
      "type": "event"}, {"anonymous": False, "inputs": [{"indexed": True, "name": "_bidder", "type": "address"},
                                                        {"indexed": True, "name": "_amount", "type": "uint256"},
                                                        {"indexed": True, "name": "_tokenId", "type": "uint256"}],
                         "name": "CancelBid", "type": "event"}, {"anonymous": False, "inputs": [
        {"indexed": True, "name": "_buyer", "type": "address"}, {"indexed": True, "name": "_seller", "type": "address"},
        {"indexed": False, "name": "_amount", "type": "uint256"},
        {"indexed": True, "name": "_tokenId", "type": "uint256"}], "name": "Sold", "type": "event"},
     {"anonymous": False, "inputs": [{"indexed": True, "name": "_tokenId", "type": "uint256"},
                                     {"indexed": True, "name": "_price", "type": "uint256"}], "name": "SalePriceSet",
      "type": "event"}, {"anonymous": False, "inputs": [{"indexed": True, "name": "previousOwner", "type": "address"},
                                                        {"indexed": True, "name": "newOwner", "type": "address"}],
                         "name": "OwnershipTransferred", "type": "event"}, {"anonymous": False, "inputs": [
        {"indexed": True, "name": "_from", "type": "address"}, {"indexed": True, "name": "_to", "type": "address"},
        {"indexed": False, "name": "_tokenId", "type": "uint256"}], "name": "Transfer", "type": "event"},
     {"anonymous": False, "inputs": [{"indexed": True, "name": "_owner", "type": "address"},
                                     {"indexed": True, "name": "_approved", "type": "address"},
                                     {"indexed": False, "name": "_tokenId", "type": "uint256"}], "name": "Approval",
      "type": "event"}]
