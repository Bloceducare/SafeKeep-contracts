pragma solidity 0.8.4;

import "./LibDiamond.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

library LibGuards {
    /// @notice ensure that caller is vault owner
    function _onlyVaultOwner() internal view {
        LibDiamond.enforceIsContractOwner();
    }
}
