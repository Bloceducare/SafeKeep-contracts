pragma solidity 0.8.4;

import "solmate.git/tokens/ERC20.sol";

contract VaultERC20Token is ERC20("VAULTTOKEN", "VLT",18) {
    constructor() {
        _mint(msg.sender, 1000000e18);
    }
}
