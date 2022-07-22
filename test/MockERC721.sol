pragma solidity 0.8.4;

import "solmate.git/tokens/ERC721.sol";

contract VaultERC721Token is ERC721("VAULTNFT", "VNFT") {
    constructor() {
        _mint(tx.origin, 0);
        _mint(tx.origin, 1);
        _mint(tx.origin, 2);
        _mint(tx.origin, 3);
    }
}
