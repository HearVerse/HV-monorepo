// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

error NoZeroAddress();
error NoZeroPrice();
error NotOwner();
error NotActived();
error InvalidParam();
error NotWhitelisted();
error InvalidAmount();

struct Listing {
  address owner;
  bool isActive;
  address nftAddress;
  uint256 tokenId;
  uint256 price;
  IERC20 tokenAddress;
}

/// @title Music NFT
/// @dev Based on OpenZeppelin Contracts.
contract Marketplace is ReentrancyGuard, Ownable, Pausable {
  using SafeERC20 for IERC20;

  uint256 public constant DECIMAL_FACTOR = 100_00; // change from uint to uint256
  uint256 public listingCount;
  uint256 public activeListingCount;
  uint256 private fee;
  address private treasury;

  mapping (address => bool) public whitelistedTokens;
  mapping (uint256 => Listing) public listings;

  /// @notice Event Listed
  event ItemListed( 
    address nftAddress,
    uint256 listingId,
    uint256 tokenId,
    address seller,
    uint256 price,
    address payTokenAddress
  );

  /// @notice Event Delisted
  event ItemDelisted(
    address nftAddress,
    uint256 listingId,
    uint256 tokenId,
    address seller
  );

  /// @notice EventItem Sold
  event ItemSold(
    address nftAddress,
    uint256 listingId,
    uint256 tokenId,
    address seller,
    address buyer,
    uint256 price,
    uint256 fee
  );

  /// @notice Event Fee changed
  event FeesChanged(
    uint256 fee,
    address treasury,
    address changedBy
  );

  /// @notice Token constructor
  constructor(uint256 _fee, address _treasury) {
    fee = _fee;
    treasury = _treasury;
  }

  /// @notice add a Listing to the Marketplace
  /// @dev Creates a new entry for a Listing object and transfers the Token to the contract
  /// @param nftAddress NFT Token Address.
  /// @param tokenId NFT TokenId.
  /// @param price Price in NFTs.
  /// @param payTokenAddress ERC20 token address to buy NFT.
  function addListing(address nftAddress, uint256 tokenId, uint256 price, IERC20 payTokenAddress) public nonReentrant whenNotPaused
  {
    if (price == 0) revert NoZeroPrice();
    if (nftAddress == address(0)) revert NoZeroAddress();
//remove unneccesary line : uint256 listingId = listingCount;
    listings[listingCount] = Listing({
      owner: _msgSender(),
      isActive: true,
      nftAddress: nftAddress,
      tokenId: tokenId,
      price: price,
      tokenAddress: payTokenAddress
    });
    listingCount = listingCount + 1;
    activeListingCount = activeListingCount + 1;
    
    IERC721(nftAddress).transferFrom(
      _msgSender(),
      address(this),
      tokenId);

    emit ItemListed(nftAddress, listingId, tokenId, _msgSender(), price, address(payTokenAddress));
  }

  /// @notice Remove a Listing from the Marketplace
  /// @dev Marks Listing as not active object and transfers the Token back
  /// @param listingId NFT Listing Id.
  function removeListing(uint256 listingId) public nonReentrant
  {
    Listing memory listing = listings[listingId]; // change to memory
    if (listing.owner != _msgSender()) revert NotOwner();
    if (!listing.isActive) revert NotActived();
    listing.isActive = false;
    
    IERC721(listing.nftAddress).transferFrom(
      address(this),
      _msgSender(),
      listing.tokenId
    );
    activeListingCount = activeListingCount - 1;
    emit ItemDelisted(listing.nftAddress, listingId, listing.tokenId, _msgSender() );
  }

  /// @notice Buys a listed NFT
  /// @dev Trabsfers both the ERC20 token (price) and the NFT.
  /// @param listingId NFT Listing Id.
  function buy(uint256 listingId) public payable nonReentrant whenNotPaused
  {
    if (!listings[listingId].isActive) revert NotActived();

    listings[listingId].isActive = false;
    IERC20 payTokenAddress = listings[listingId].tokenAddress;
    uint256 listedPrice = listings[listingId].price; // change from uint to uint256
    uint256 buyingFee = (fee * listedPrice / DECIMAL_FACTOR);

    if (address(payTokenAddress) == address(0)) {
      if (msg.value != listedPrice) revert InvalidAmount();
      if (buyingFee > 0) {
        (bool sent, ) = payable(treasury).call{value: buyingFee}("");
        require(sent, "Failed to send Ether to treasury1"); // is it possible to change require to revert
      }
      (bool sent, ) = payable(listings[listingId].owner).call{value: listedPrice - buyingFee}("");
      require(sent, "Failed to send Ether"); // is it possible to change require to revert
    } else {
      if (msg.value != 0) revert InvalidAmount();
      if (buyingFee > 0) {
        payTokenAddress.safeTransferFrom( 
          _msgSender(),
          treasury,
          buyingFee
        );
      }
      payTokenAddress.safeTransferFrom( 
        _msgSender(),
        listings[listingId].owner,
        listedPrice - buyingFee
      );
    }
    IERC721(listings[listingId].nftAddress).transferFrom(
      address(this),
      _msgSender(),
      listings[listingId].tokenId
    );
    activeListingCount = activeListingCount - 1;

    emit ItemSold(
      listings[listingId].nftAddress,
      listingId,
      listings[listingId].tokenId,
      listings[listingId].owner,
      _msgSender(),
      listedPrice,
      buyingFee
    );
  }

  /// @notice Sets a new Fee
  /// @param _fee new Fee.
  /// @param _treasury New treasury address.
  function setFee(uint256 _fee, address _treasury) public onlyOwner
  {
    if (_fee >= DECIMAL_FACTOR) revert InvalidParam();
    if (_treasury == address(0)) revert NoZeroAddress();

    fee = _fee;
    treasury = _treasury;

    emit FeesChanged(
      fee,
      treasury,
      _msgSender()
    );
  }

  // @notice Pauses/Unpauses the contract
  // @dev While paused, addListing, and buy are not allowed
  // @param stop whether to pause or unpause the contract.
  function pause(bool stop) external onlyOwner {
    if (stop) {
      _pause();
    } else {
      _unpause();
    }
  }
}
