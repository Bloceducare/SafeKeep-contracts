// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {LibDiamond} from "../libraries/LibDiamond.sol";


contract OwnershipFacet {
    function owner() external view returns (address owner_) {
        owner_ = LibDiamond.vaultOwner();
    }
}
