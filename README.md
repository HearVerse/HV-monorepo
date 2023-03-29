# INFT.sol 
defines an interface for a non-fungible token (NFT) that extends the ERC721 standard. The contract includes several functions and events related to minting, updating, and manipulating NFTs.

The INFT interface defines the same functions as the IERC721 interface but includes additional functions for minting and manipulating NFTs with specific attributes such as level, durability, repair count, and replication count.

The contract includes several events such as AttributeAdded, AttributeUpdated, and PermanentURI, which are triggered when certain actions are performed on NFTs, such as adding or updating attributes or revealing a permanent URI.

The functions in the contract allow for safe minting of NFTs, setting and updating various attributes, and retrieving attributes of a specific NFT. There is also a function to reveal the real token URI of an NFT.

Overall, this Solidity code defines an interface for an NFT that includes additional functions and events for manipulating and tracking various attributes of the NFT.
# Marketplace.sol
enables users to buy and sell NFTs (Non-Fungible Tokens) with ERC20 tokens. The contract allows users to list NFTs with a specified price in an ERC20 token, and other users can buy them with the same token. The contract includes functionalities to add listings, remove listings, and buy NFTs.

The contract is built on the OpenZeppelin Contracts library and uses the ERC721 and ERC20 token standards. It also includes the ReentrancyGuard, Ownable, and Pausable contracts to ensure secure and efficient operations.

The contract keeps track of the number of listings and active listings using the “listingCount” and “activeListingCount” variables. It also defines a “Listing” struct to store information about each NFT listing, including the owner, whether the listing is active, the NFT contract address, the token ID, the price, and the ERC20 token address for payment.

The “addListing” function enables users to add a new listing to the marketplace. The function takes four parameters: the NFT contract address, the token ID, the price in the ERC20 token, and the ERC20 token address. It creates a new listing object and transfers the NFT from the owner to the contract. The function also emits an “ItemListed” event.

The “removeListing” function enables users to remove a listing from the marketplace. The function takes one parameter, the listing ID, and marks the listing as inactive. It transfers the NFT back to the owner and emits an “ItemDelisted” event.

The “buy” function enables users to buy an NFT from the marketplace. The function takes one parameter, the listing ID, and transfers the ERC20 token payment to the seller and the NFT to the buyer. It also charges a fee on the transaction and sends it to a treasury address defined in the contract. The function emits an “ItemSold” event.

The contract also includes error messages for various scenarios, such as zero addresses, zero prices, incorrect ownership, inactive listings, invalid parameters, and invalid amounts. Finally, the contract defines an event “FeesChanged” for when the fee or treasury address is changed.

# NFT.sol

has some special properties related to a game. The contract inherits from several OpenZeppelin libraries, including ERC721, ERC721URIStorage, ERC721Burnable, AccessControl, and Pausable.

The contract defines a struct called “VariableAttributes” that contains information about the NFT, such as its level, durability, and replication count. It also defines several roles, such as “MINTER_ROLE”, “GAME_ROLE”, and “REVEAL_ROLE”, which restrict access to certain functions based on the caller's role.

The “safeMint” function is used to create new NFTs and assign them to a specific address. The function takes in an array of URIs, hashes, and real URIs. The “_safeMint” function is then called, which assigns the NFT to the specified address, increments the token ID, and sets the token URI, hash, and real URI.

The “revealRealTokenURI” function is used to reveal the real URI of an NFT, which was previously hidden for security reasons. This function can only be called by a user with the “REVEAL_ROLE”.

The “setLevel” function is used to update the level of an NFT. The function takes in the token ID and the new level, and the function emits an event with the updated level.

Overall, this contract defines a specialized NFT with certain game-related properties and roles to restrict access to certain functions.

# Token.sol
called "HearVerse Token" with the symbol "HvT". The token is built using the ERC20 standard, which is a common standard for fungible tokens on the Ethereum blockchain. The token has a total supply of 5,555,000 with 18 decimal places.

The contract inherits from the ERC20 contract provided by the OpenZeppelin library, which means it already has implemented the basic functions of a standard ERC20 token, such as transferring tokens, checking balances, and approving token spending.

The constructor function initializes the token by minting the total supply to the contract deployer, which is the account that deployed the contract to the blockchain.

# deployNFTMarketplace.js
uses the Hardhat framework to deploy a smart contract called "Marketplace". Here is a breakdown of what the code does:
1.	Import the ethers library from the Hardhat framework.
2.	Define an async function called "main()".
3.	Inside the "main()" function, get the signer account from Hardhat using “ethers.getSigners()”. The await keyword is used to wait for the promise to resolve before continuing with the next line of code.
4.	Print out the address of the deployer account and its balance using console.log().
5.	Get the contract factory for the "Marketplace" smart contract using “ethers.getContractFactory()”.
6.	Deploy the smart contract with the specified constructor arguments using “factory.deploy()”. In this case, the first argument is 100 and the second argument is "0xFf6d86807b3387e10dDE52697C3BD7f59b6A145f".
7.	Print out the address of the deployed smart contract using console.log().
8.	The main() function is then called using the “main().then() syntax”. If there are no errors, the script will exit with a status of 0. If there is an error, it will be caught by the catch() block and the script will exit with a status of 1.

# marketplace.js
uses the Mocha testing framework and the Chai assertion library. It tests the functionality of a smart contract named "Marketplace" and an NFT (non-fungible token) contract named "NFT".

The test file has several sections, each containing a set of tests:
1.	"Deploy NFT": Deploys the NFT contract and mints an NFT to the admin account.
2.	"Deploy Marketplace": Deploys the Marketplace contract.
3.	"List an NFT to sell": Approves the Marketplace contract to sell the NFT and lists it for sale at a specified price. Tests that the listing was successfully added to the Marketplace contract and that its properties are correct.
4.	"Delist an NFT from the marketplace": Removes the NFT listing from the Marketplace contract. Tests that the listing was successfully removed from the Marketplace contract.
# Overall
The provided code consists of four Solidity contracts and a JavaScript file. The INFT.sol defines an interface for a non-fungible token that extends the ERC721 standard, with additional functions and events related to minting, updating, and manipulating NFTs. The Marketplace.sol enables users to buy and sell NFTs with ERC20 tokens. The NFT.sol is specialized for a game and defines a struct for NFT information, roles for access restriction, and functions for NFT creation and updates. The Token.sol defines an ERC20 standard token with a total supply of 5,555,000 and inherits from OpenZeppelin ERC20 contract. The deployNFTMarketplace.js file uses the Hardhat framework to deploy the Marketplace contract.
