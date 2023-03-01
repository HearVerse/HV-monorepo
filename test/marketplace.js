const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Marketplace", function () {
  let nft;
  let market;
  let admin;
  let player1;
  let player2;
  let treasury1;
  let treasury2;
  

  it("Deploy NFT", async function () {
    [admin, player1] = await ethers.getSigners();
    const NFTContract = await ethers.getContractFactory("NFT");
    nft = await NFTContract.connect(admin).deploy("NFT1", "NFT1");
    await nft.deployed();
    const mintTx = await nft
      .connect(admin)
      .safeMint(
        player1.address,
        ["ipfs://111", "ipfs://222", "ipfs://333"],
        [
          ethers.utils.keccak256("0x1000"),
          ethers.utils.keccak256("0x2000"),
          ethers.utils.keccak256("0x3000"),
        ],
        ["ipfs://111_real", "ipfs://222_real", "ipfs://333_real"]
      );
    await mintTx.wait();
  });

  it("Deploy Marketplace", async function () {
    const NFTContract = await ethers.getContractFactory("Marketplace");
    market = await NFTContract.connect(admin).deploy(200, admin.address);
    await market.deployed();
  });

  it("List an NFT to sell", async function () {
    await nft.connect(player1).approve(market.address, 0);
    
    await expect(
      market
        .connect(player1)
        .addListing(nft.address, 0, ethers.utils.parseUnits("0.1"), "0x81f91E226c663574b4619926Bea0DDe889d0fe08")
    )
      .to.emit(market, "ItemListed")
      .withArgs(
        nft.address,
        0,
        0,
        player1.address,
        ethers.utils.parseUnits("0.1"),
        "0x81f91E226c663574b4619926Bea0DDe889d0fe08"
      );

    const listingId = 0;
    const totalListings = await market.activeListingCount();
    expect(totalListings.toNumber()).to.equal(1);

    // Get listing_id
    const listing = await market.listings(listingId);
    expect(listing.isActive).to.equal(true);
    expect(listing.price).to.equal(ethers.utils.parseUnits("0.1"));
    expect(listing.tokenId.toNumber()).to.equal(0);
  });

  it("Delist an NFT from the marketplace", async function () {
    await expect(market.connect(player1).removeListing(0))
      .to.emit(market, "ItemDelisted")
      .withArgs(nft.address, 0, 0, player1.address);
  });

});
