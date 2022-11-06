pragma solidity 0.8.4;

import "./LibDiamond.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

library LibGuards {
    function _onlyVaultOwner() internal view {
        LibDiamond.enforceIsContractOwner();
    }
}
