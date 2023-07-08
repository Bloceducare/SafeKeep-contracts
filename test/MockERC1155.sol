pragma solidity 0.8.4;
import "solmate.git/tokens/ERC1155.sol";

contract VaultERC1155Token is ERC1155 {
    function mint(address _to, uint256 _id, uint256 _amount) public {
        _mint(_to, _id, _amount, "");
    }

    function uri(
        uint256 id
    ) public view virtual override returns (string memory) {}
}