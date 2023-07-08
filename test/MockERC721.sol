pragma solidity 0.8.4;

import "solmate.git/tokens/ERC721.sol";

contract VaultERC721Token is ERC721("VAULTNFT", "VNFT") {
    function mint(address _to,uint256 _id) public{
        _mint(_to,_id);
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory){}
}
