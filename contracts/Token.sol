//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// This is the main building block for smart contracts.
contract Token is ERC20 {
    uint256 supply = 5_555_000 * 1e18;
    constructor() ERC20("HearVerse Token", "HvT") {
        _mint(msg.sender, supply);
    }
}