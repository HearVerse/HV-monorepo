const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const factory = await ethers.getContractFactory("Marketplace");
    const contract = await factory.deploy(
        100, //replace
        "0xFf6d86807b3387e10dDE52697C3BD7f59b6A145f" // replace
    );
  
    console.log("Contract address:", contract.address);
}
  
main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
});