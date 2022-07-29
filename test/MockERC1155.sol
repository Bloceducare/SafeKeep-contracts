pragma solidity 0.8.4;
import "solmate.git/tokens/ERC1155.sol";

contract VaultERC1155Token is ERC1155{
    constructor() {
        _mint(msg.sender, 0,10,"");
          _mint(msg.sender, 1,10,"");
           _mint(msg.sender, 2,10,"");
    }
}