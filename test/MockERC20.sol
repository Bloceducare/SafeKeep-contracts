pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VaultERC20Token is ERC20("VAULTTOKEN", "VLT") {
    constructor() {
        _mint(msg.sender, 1000000e18);
    }
}
