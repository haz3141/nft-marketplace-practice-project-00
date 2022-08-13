// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

// Import OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFTMarketplace is ERC721URIStorage {
   using Counters for Counters.Counter;
   Counters.Counter private _tokenIds;
   Counters.Counter private _itemsSold;

   uint listingPrice = 0.025 ether;
   address payable owner;

   mapping(uint256 => MarketItem) private idToMarketItem;

   struct MarketItem {
    uint256 tokenId;
    address payable seller;
    address payable owner;
    uint256 price;
    bool sold;
   }

   event MarketItemCreated (
      uint256 indexed tokenId,
      address seller,
      address owner,
      uint256 price,
      bool sold
   );

   constructor() ERC721("Metaverse Tokens", "METT") {
      owner = payable(msg.sender);
   }

   // Updates the listing price of the contract 
   function updateListingPrice(uint _listingPrice) public payable {
      require(owner == msg.sender, "Only marketplace owner can update the listing price.");
      listingPrice = _listingPrice;
   }

   // Returns the listing price of the contract 
   function getListingPrice() public view returns (uint256) {
      return listingPrice;
   }

   // Mints a token and lists it in the marketplace
   function createToken(string memory tokenURI, uint256 price) public payable returns (uint) {
      _tokenIds.increment();
      uint256 newTokenId = _tokenIds.current();

      _mint(msg.sender, newTokenId);
      _setTokenURI(newTokenId, tokenURI);
      createMarketItem(newTokenId, price);
      return newTokenId;
   }

   
}