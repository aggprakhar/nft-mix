 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.4;

 //import "./SimpleAuction.sol";
 //import "./Auction.sol";
 import "@openzeppelin/contracts/utils/Counters.sol";
 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
 import "@openzeppelin/contracts/access/Ownable.sol";
 //import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

 //import "hardhat/console.sol";

 contract Qolaba is ERC721URIStorage {
     using Counters for Counters.Counter;
     Counters.Counter private _tokenIds;
     Counters.Counter private _itemsSold;
     ERC721 private nftContract;
 //    Auction private auction;
    //  uint private biddingTime;

     uint256 listingPrice = 0.025 ether;
     address payable private owner;

     mapping(uint256 => MarketItem) private idToMarketItem;
     mapping(uint256 => BidItem) private idToBidItem;
 //    mapping(uint256 => Auction) private idToBidItem;

     struct BidItem {
         uint256 bidId;
         address payable bidder;
         MarketItem marketItem;
         uint256 price;
         bool accepted;
         bool canceled;
     }

     struct AuctionItem {
         uint256 bidId;
         address payable bidder;
         MarketItem marketItem;
         uint256 price;
         bool accepted;
         bool canceled;
     }

     event BidItemCreated (
         uint256 indexed tokenId,
         address bidder,
         address owner,
         uint256 price,
         bool sold
     );

     event AuctionItemCreated (
         uint256 indexed tokenId,
         address owner,
         uint256 price,
         uint expireTime,
         bool active
     );

     struct MarketItem {
         uint256 tokenId;
         address payable seller;
         address payable owner;
         uint256 price;
         bool sold;
         address payable bidder;
         uint256 bid;
         bool auctionActive;
         uint auctionExpireTime;
     }

     event MarketItemCreated (
         uint256 indexed tokenId,
         address seller,
         address owner,
         uint256 price,
         bool sold
     );

     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

     /**
      * @dev Returns the address of the current owner.
      */
     function marketplace_owner() public view virtual returns (address) {
         return owner;
     }

     /**
      * @dev Throws if called by any account other than the owner.
      */
     modifier onlyOwner() {
         require(marketplace_owner() == msg.sender, "Ownable: caller is not the owner");
         _;
     }

     /**
      * @dev Leaves the contract without owner. It will not be possible to call
      * `onlyOwner` functions anymore. Can only be called by the current owner.
      *
      * NOTE: Renouncing ownership will leave the contract without an owner,
      * thereby removing any functionality that is only available to the owner.
      */
     function renounceOwnership() public virtual onlyOwner {
         _transferOwnership(address(0));
     }

     /**
      * @dev Transfers ownership of the contract to a new account (`newOwner`).
      * Can only be called by the current owner.
      */
     function transferOwnership(address newOwner) public virtual onlyOwner {
         require(newOwner != address(0), "Ownable: new owner is the zero address");
         _transferOwnership(newOwner);
     }

     /**
      * @dev Transfers ownership of the contract to a new account (`newOwner`).
      * Internal function without access restriction.
      */
     function _transferOwnership(address newOwner) internal virtual {
         address oldOwner = owner;
         owner = payable(newOwner);
         emit OwnershipTransferred(oldOwner, newOwner);
     }


     //    function initialize(address admin) public initializer {
     //        _admin = admin;
     //    }

     constructor() ERC721("Qolaba", "QOLA") {
         owner = payable(msg.sender);
 //        auction = new Auction();
 //        creator = payable(msg.sender);
     }

     /* Updates the listing price of the contract */
     function updateListingPrice(uint _listingPrice) public payable {
         require(owner == msg.sender, "Only marketplace owner can update listing price.");
         listingPrice = _listingPrice;
     }

     /* Returns the listing price of the contract */
     function getListingPrice() public view returns (uint256) {
         return listingPrice;
     }

     /* Mints a token and lists it in the marketplace */
     function createToken(string memory tokenURI, uint256 price, string memory _name, string memory _symbol) public payable returns (uint) {
         _tokenIds.increment();
         uint256 newTokenId = _tokenIds.current();
        //  nftContract = new ERC721(_name, _symbol)
         _mint(msg.sender, newTokenId);
         _setTokenURI(newTokenId, tokenURI);
         createMarketItem(newTokenId, price);
         return newTokenId;
     }

     function isGreaterBid(uint256 tokenId) private view returns (bool) {
         return msg.value > idToMarketItem[tokenId].bid;
     }

     modifier notOwnerOf(uint256 tokenId) {
         require(ownerOf(tokenId) != msg.sender);
         _;
     }

     modifier onlyTokenOwner(uint256 tokenId) {
         require(ownerOf(tokenId) == msg.sender);
         _;
     }

     function clearAuction(uint256 tokenId) public onlyOwner {

     }

     function setAuctionContract(uint256 tokenId, uint256 _duration) public {
         require(idToMarketItem[tokenId].auctionActive == false, "Auction already started for this NFT token");
         require(idToMarketItem[tokenId].seller == msg.sender, "Only the NFT token seller can start an auction");
         idToMarketItem[tokenId].auctionActive = true;
         idToMarketItem[tokenId].auctionExpireTime = block.timestamp + _duration;
         emit AuctionItemCreated(
             tokenId,
             idToMarketItem[tokenId].owner,
             idToMarketItem[tokenId].price,
             idToMarketItem[tokenId].auctionExpireTime,
             true
         );
 //        auction.createTokenAuction(_nft, tokenId, _price, _duration);
     }

     function auctionExpired(uint256 tokenId) public returns (bool){
         bool expired;
         if (block.timestamp < idToMarketItem[tokenId].auctionExpireTime) {
             _clearBid(tokenId);
             idToMarketItem[tokenId].auctionExpireTime = 0;
             idToMarketItem[tokenId].auctionActive == false;
             expired = true;
             emit AuctionItemCreated(
             tokenId,
             idToMarketItem[tokenId].owner,
             idToMarketItem[tokenId].price,
             idToMarketItem[tokenId].auctionExpireTime,
             false
         );
         }
         else {
             expired = false;
         }
         return expired;
     }

 //    modifier

 //    /**
 //    * @dev Bids on the token, replacing the bid if the bid is higher than the current bid. You cannot bid on a token you already own.
 //    * @param tokenId uint256 ID of the token to bid on
 //    */
     function bid(uint256 tokenId) public payable {
//         require(auctionExpired(tokenId) != false, "The Auction Period has expired for this NFT token");
         require(idToMarketItem[tokenId].auctionActive == true, "The Auction Period has expired for this NFT token");
         require(block.timestamp < idToMarketItem[tokenId].auctionExpireTime, "The Auction Period has expired for this NFT token");
//         require(isGreaterBid(tokenId));
         require(idToMarketItem[tokenId].owner != msg.sender, "Token owner cannot place a bid");
         require(idToMarketItem[tokenId].seller != msg.sender, "Token seller cannot place a bid");
         require(idToMarketItem[tokenId].price <= msg.value, "Bid cannot be less than token price");
         payable(idToMarketItem[tokenId].seller).transfer(msg.value);
//         idToMarketItem[tokenId].bidder = payable(msg.sender);
         idToMarketItem[tokenId].bid = msg.value;
         emit BidItemCreated(
             tokenId,
             msg.sender,
             idToMarketItem[tokenId].owner,
             msg.value,
             false
         );
     }

     /**
     * @dev Internal function to clear bid
     * @param tokenId uint256 ID of the token with the standing bid
     */
     function _clearBid(uint256 tokenId) private {
         payable(idToMarketItem[tokenId].bidder).transfer(idToMarketItem[tokenId].bid);
         idToMarketItem[tokenId].bidder = payable(address(0));
         idToMarketItem[tokenId].bid = 0;
     }

     /**
      * @dev Cancels the bid on the token, returning the bid amount to the bidder.
      * @param tokenId uint256 ID of the token with a bid
      */
     function cancelBid(uint256 tokenId) public payable {
         require(auctionExpired(tokenId) != false, "The Auction Period has expired for this NFT token");
         require(idToMarketItem[tokenId].bidder == msg.sender, "Only current bidder can cancel bid");
         _clearBid(tokenId);
         emit BidItemCreated(
             tokenId,
             msg.sender,
             idToMarketItem[tokenId].owner,
             msg.value,
             false
         );
     }

     /**
      * @dev Accept the bid on the token, transferring ownership to the current bidder and paying out the owner.
      * @param tokenId uint256 ID of the token with the standing bid
      */
     function acceptBid(uint256 tokenId) public {
         require(auctionExpired(tokenId) != false, "The Auction Period has expired for this NFT token");
         uint256 current_bid = idToMarketItem[tokenId].bid;
         uint256 current_price = idToMarketItem[tokenId].price;
         require(msg.sender == owner, "Only token owner can accept the bid");
         require(current_bid >= current_price, "Bid should be greater than or equal to price");
         idToMarketItem[tokenId].price = current_bid;
         _settleBid(tokenId, payable(msg.sender));
         emit MarketItemCreated(
             tokenId,
             msg.sender,
             idToMarketItem[tokenId].owner,
             current_bid,
             true
         );
     }

     function _settleBid(uint256 tokenId, address payable tokenOwner) private {
 //        current_owner = msg.sender;
         address payable current_bidder = idToMarketItem[tokenId].bidder;
         idToMarketItem[tokenId].owner = current_bidder;
         idToMarketItem[tokenId].sold = true;
         idToMarketItem[tokenId].seller = tokenOwner;
         idToMarketItem[tokenId].bid = 0;
         idToMarketItem[tokenId].bidder = payable(address(0));
         _itemsSold.increment();
         _transfer(tokenOwner, idToMarketItem[tokenId].owner, tokenId);
     }

     function createMarketItem(
         uint256 tokenId,
         uint256 price
     ) private {
         require(price > 0, "Price must be at least 1 wei");
         require(msg.value == listingPrice, "Price must be equal to listing price");
//         require(price > 0, "Price must be at least 1 wei");

         idToMarketItem[tokenId] = MarketItem(
             tokenId,
             payable(msg.sender),
             payable(address(this)),
             price,
             false,
             payable(address(0)),
             0,
             false,
             0
         );

         _transfer(msg.sender, address(this), tokenId);
         emit MarketItemCreated(
             tokenId,
             msg.sender,
             address(this),
             price,
             false
         );
     }

     /* allows someone to resell a token they have purchased */
     function resellToken(uint256 tokenId, uint256 price) public payable {
         require(idToMarketItem[tokenId].owner == msg.sender, "Only item owner can perform this operation");
         require(msg.value == listingPrice, "Price must be equal to listing price");
         idToMarketItem[tokenId].sold = false;
         idToMarketItem[tokenId].price = price;
         idToMarketItem[tokenId].seller = payable(msg.sender);
         idToMarketItem[tokenId].owner = payable(address(this));
         _itemsSold.decrement();

         _transfer(msg.sender, address(this), tokenId);
     }

     /* Creates the sale of a marketplace item */
     /* Transfers ownership of the item, as well as funds between parties */
     function createMarketSale(
         uint256 tokenId
     ) public payable {
         uint price = idToMarketItem[tokenId].price;
         address seller = idToMarketItem[tokenId].seller;
         require(msg.value == price, "Please submit the asking price in order to complete the purchase");
         idToMarketItem[tokenId].owner = payable(msg.sender);
         idToMarketItem[tokenId].sold = true;
         idToMarketItem[tokenId].seller = payable(address(0));
         _itemsSold.increment();
         _transfer(address(this), msg.sender, tokenId);
         payable(owner).transfer(listingPrice);
         payable(seller).transfer(msg.value);
     }


     /* Returns all unsold market items */
     function fetchMarketItems() public view returns (MarketItem[] memory) {
         uint itemCount = _tokenIds.current();
         uint unsoldItemCount = _tokenIds.current() - _itemsSold.current();
         uint currentIndex = 0;

         MarketItem[] memory items = new MarketItem[](unsoldItemCount);
         for (uint i = 0; i < itemCount; i++) {
             if (idToMarketItem[i + 1].owner == address(this)) {
                 uint currentId = i + 1;
                 MarketItem storage currentItem = idToMarketItem[currentId];
                 items[currentIndex] = currentItem;
                 currentIndex += 1;
             }
         }
         return items;
     }

     /* Returns only items that a user has purchased */
     function fetchMyNFTs() public view returns (MarketItem[] memory) {
         uint totalItemCount = _tokenIds.current();
         uint itemCount = 0;
         uint currentIndex = 0;

         for (uint i = 0; i < totalItemCount; i++) {
             if (idToMarketItem[i + 1].owner == msg.sender) {
                 itemCount += 1;
             }
         }

         MarketItem[] memory items = new MarketItem[](itemCount);
         for (uint i = 0; i < totalItemCount; i++) {
             if (idToMarketItem[i + 1].owner == msg.sender) {
                 uint currentId = i + 1;
                 MarketItem storage currentItem = idToMarketItem[currentId];
                 items[currentIndex] = currentItem;
                 currentIndex += 1;
             }
         }
         return items;
     }

     /* Returns only items a user has listed */
     function fetchItemsListed() public view returns (MarketItem[] memory) {
         uint totalItemCount = _tokenIds.current();
         uint itemCount = 0;
         uint currentIndex = 0;

         for (uint i = 0; i < totalItemCount; i++) {
             if (idToMarketItem[i + 1].seller == msg.sender) {
                 itemCount += 1;
             }
         }

         MarketItem[] memory items = new MarketItem[](itemCount);
         for (uint i = 0; i < totalItemCount; i++) {
             if (idToMarketItem[i + 1].seller == msg.sender) {
                 uint currentId = i + 1;
                 MarketItem storage currentItem = idToMarketItem[currentId];
                 items[currentIndex] = currentItem;
                 currentIndex += 1;
             }
         }
         return items;
     }
 }