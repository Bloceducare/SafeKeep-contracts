pragma solidity 0.8.4;

import "solmate.git/tokens/ERC721.sol";

contract VaultERC721Token is ERC721("VAULTNFT", "VNFT") {
    constructor() {
        _mint(msg.sender, 0);
        _mint(msg.sender, 1);
        _mint(msg.sender, 2);
        _mint(msg.sender, 3);
    }
}
