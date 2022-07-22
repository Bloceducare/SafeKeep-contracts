pragma solidity 0.8.4;

import "solmate.git/tokens/ERC20.sol";

contract VaultERC20Token is ERC20("VAULTTOKEN", "VLT",18) {
    constructor() {
        _mint(tx.origin, 1000000e18);
        _mint(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84,10000e18);
    }
}
