pragma solidity 0.8.4;
import "solmate.git/tokens/ERC1155.sol";

contract VaultERC1155Token is ERC1155{
    constructor() {
        _mint(tx.origin, 0,10,"");
          _mint(tx.origin, 1,10,"");
           _mint(tx.origin, 2,10,"");
    }
}