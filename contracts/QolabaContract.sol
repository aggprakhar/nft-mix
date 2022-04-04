//// SPDX-License-Identifier: MIT
//pragma solidity ^0.8.4;
//
//import "@openzeppelinupgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
//import "@openzeppelinupgradeable/contracts/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
//import "@openzeppelinupgradeable/contracts/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
//import "@openzeppelinupgradeable/contracts/token/ERC721/extensions/IERC721MetadataUpgradeable.sol";
//import "@openzeppelinupgradeable/contracts/access/OwnableUpgradeable.sol";
//import "@openzeppelin/contracts/utils/Counters.sol";
//
//library SafeMath {
//
//    /**
//    * @dev Multiplies two numbers, throws on overflow.
//  */
//    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
//        if (a == 0) {
//            return 0;
//        }
//        uint256 c = a * b;
//        assert(c / a == b);
//        return c;
//    }
//
//    /**
//    * @dev Integer division of two numbers, truncating the quotient.
//  */
//    function div(uint256 a, uint256 b) internal pure returns (uint256) {
//        // assert(b > 0); // Solidity automatically throws when dividing by 0
//        uint256 c = a / b;
//        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
//        return c;
//    }
//
//    /**
//    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
//  */
//    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
//        assert(b <= a);
//        return a - b;
//    }
//
//    /**
//    * @dev Adds two numbers, throws on overflow.
//  */
//    function add(uint256 a, uint256 b) internal pure returns (uint256) {
//        uint256 c = a + b;
//        assert(c >= a);
//        return c;
//    }
//}
//
//interface MetadataUpgradeable is IERC721MetadataUpgradeable {}
//
//contract QolabaMarketplace is ERC721URIStorageUpgradeable, OwnableUpgradeable, MetadataUpgradeable {
//    using Counters for Counters.Counter;
//    Counters.Counter private _tokenIds;
//    Counters.Counter private _itemsSold;
//
//    uint256 listingPrice = 0.025 ether;
////    address payable owner;
//
//    mapping(uint256 => MarketItem) private idToMarketItem;
//
//    struct MarketItem {
//      uint256 tokenId;
//      address payable seller;
//      address payable owner;
//      uint256 price;
//      bool sold;
//    }
//
//    event MarketItemCreated (
//      uint256 indexed tokenId,
//      address seller,
//      address owner,
//      uint256 price,
//      bool sold
//    );
//
////    function initialize(address admin) public initializer {
////        _admin = admin;
////    }
//
//    function __ERC721URIStorage_init() internal onlyInitializing {
//      owner = payable(msg.sender);
//    }
//
//    /* Updates the listing price of the contract */
//    function updateListingPrice(uint _listingPrice) public payable {
//      require(owner == msg.sender, "Only marketplace owner can update listing price.");
//      listingPrice = _listingPrice;
//    }
//
//    /* Returns the listing price of the contract */
//    function getListingPrice() public view returns (uint256) {
//      return listingPrice;
//    }
//
//    /* Mints a token and lists it in the marketplace */
//    function createToken(string memory tokenURI, uint256 price) public payable returns (uint) {
//      _tokenIds.increment();
//      uint256 newTokenId = _tokenIds.current();
//
//      _mint(msg.sender, newTokenId);
//      _setTokenURI(newTokenId, tokenURI);
//      createMarketItem(newTokenId, price);
//      return newTokenId;
//    }
//
//    function createMarketItem(
//      uint256 tokenId,
//      uint256 price
//    ) private {
//      require(price > 0, "Price must be at least 1 wei");
////      require(msg.value == listingPrice, "Price must be equal to listing price");
////      require(listingPrice, "Price must be equal to listing price");
//
//      idToMarketItem[tokenId] =  MarketItem(
//        tokenId,
//        payable(msg.sender),
//        payable(address(this)),
//        price,
//        false
//      );
//
//      _transfer(msg.sender, address(this), tokenId);
//      emit MarketItemCreated(
//        tokenId,
//        msg.sender,
//        address(this),
//        price,
//        false
//      );
//    }
//
//    /* allows someone to resell a token they have purchased */
//    function resellToken(uint256 tokenId, uint256 price) public payable {
//      require(idToMarketItem[tokenId].owner == msg.sender, "Only item owner can perform this operation");
//      require(msg.value == listingPrice, "Price must be equal to listing price");
//      idToMarketItem[tokenId].sold = false;
//      idToMarketItem[tokenId].price = price;
//      idToMarketItem[tokenId].seller = payable(msg.sender);
//      idToMarketItem[tokenId].owner = payable(address(this));
//      _itemsSold.decrement();
//
//      _transfer(msg.sender, address(this), tokenId);
//    }
//
//    /* Creates the sale of a marketplace item */
//    /* Transfers ownership of the item, as well as funds between parties */
//    function createMarketSale(
//      uint256 tokenId
//      ) public payable {
//      uint price = idToMarketItem[tokenId].price;
//      address seller = idToMarketItem[tokenId].seller;
//      require(msg.value == price, "Please submit the asking price in order to complete the purchase");
//      idToMarketItem[tokenId].owner = payable(msg.sender);
//      idToMarketItem[tokenId].sold = true;
//      idToMarketItem[tokenId].seller = payable(address(0));
//      _itemsSold.increment();
//      _transfer(address(this), msg.sender, tokenId);
//      payable(owner).transfer(listingPrice);
//      payable(seller).transfer(msg.value);
//    }
//
//    /* Returns all unsold market items */
//    function fetchMarketItems() public view returns (MarketItem[] memory) {
//      uint itemCount = _tokenIds.current();
//      uint unsoldItemCount = _tokenIds.current() - _itemsSold.current();
//      uint currentIndex = 0;
//
//      MarketItem[] memory items = new MarketItem[](unsoldItemCount);
//      for (uint i = 0; i < itemCount; i++) {
//        if (idToMarketItem[i + 1].owner == address(this)) {
//          uint currentId = i + 1;
//          MarketItem storage currentItem = idToMarketItem[currentId];
//          items[currentIndex] = currentItem;
//          currentIndex += 1;
//        }
//      }
//      return items;
//    }
//
//    /* Returns only items that a user has purchased */
//    function fetchMyNFTs() public view returns (MarketItem[] memory) {
//      uint totalItemCount = _tokenIds.current();
//      uint itemCount = 0;
//      uint currentIndex = 0;
//
//      for (uint i = 0; i < totalItemCount; i++) {
//        if (idToMarketItem[i + 1].owner == msg.sender) {
//          itemCount += 1;
//        }
//      }
//
//      MarketItem[] memory items = new MarketItem[](itemCount);
//      for (uint i = 0; i < totalItemCount; i++) {
//        if (idToMarketItem[i + 1].owner == msg.sender) {
//          uint currentId = i + 1;
//          MarketItem storage currentItem = idToMarketItem[currentId];
//          items[currentIndex] = currentItem;
//          currentIndex += 1;
//        }
//      }
//      return items;
//    }
//
//    /* Returns only items a user has listed */
//    function fetchItemsListed() public view returns (MarketItem[] memory) {
//      uint totalItemCount = _tokenIds.current();
//      uint itemCount = 0;
//      uint currentIndex = 0;
//
//      for (uint i = 0; i < totalItemCount; i++) {
//        if (idToMarketItem[i + 1].seller == msg.sender) {
//          itemCount += 1;
//        }
//      }
//
//      MarketItem[] memory items = new MarketItem[](itemCount);
//      for (uint i = 0; i < totalItemCount; i++) {
//        if (idToMarketItem[i + 1].seller == msg.sender) {
//          uint currentId = i + 1;
//          MarketItem storage currentItem = idToMarketItem[currentId];
//          items[currentIndex] = currentItem;
//          currentIndex += 1;
//        }
//      }
//      return items;
//    }
//
//}