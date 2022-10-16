pragma solidity 0.8.4;

import "solmate.git/tokens/ERC20.sol";

contract VaultERC20Token is ERC20("VAULTTOKEN", "VLT",18) {
 

    function mint(address _to,uint256 _amount) public{
        _mint(_to,_amount);
    }
}
