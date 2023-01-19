pragma solidity 0.8.4;

import {LibErrors} from "../libraries/LibErrors.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibGuards} from "../libraries/LibGuards.sol";
import {LibEther} from "../libraries/LibEther.sol";

contract EtherFacet {
    //DEPOSITS
    /// @notice deposits Ether into the vault
    function depositEther(uint256 _amount) external payable {
        LibEther._depositEther(_amount);
    }
    /// @notice allows caller to withdraw Ether from the vault

    function withdrawEther(uint256 _amount, address _to) external {
        LibGuards._onlyVaultOwner();
        LibEther._withdrawEth(_amount, _to);
    }
}
