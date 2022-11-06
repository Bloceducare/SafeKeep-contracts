// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
*
* Implementation of a diamond.
/******************************************************************************/

import {LibDiamond} from "./libraries/LibDiamond.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";

import {FacetAndSelectorData,DMSData} from "./libraries/LibLayoutSilo.sol";

import {LibStorageBinder} from "./libraries/LibStorageBinder.sol";

//import "./libraries/LibVaultStorage.sol";

import "../interfaces/IVaultDiamond.sol";

contract VaultDiamond {
    bool _init;

    constructor() payable {
        address _contractOwner = tx.origin;
        LibDiamond.setVaultOwner(_contractOwner);
    }

    function init(address _diamondCutFacet, address _backup) public {
        VaultData storage vaultData = LibStorageBinder
            ._bindAndReturnVaultStorage();
        assert(!_init);
        assert(
            msg.sender == LibDiamond.vaultOwner() ||
                tx.origin == LibDiamond.vaultOwner()
        );
        // Add the diamondCut external function from the diamondCutFacet
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](2);
        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        functionSelectors[1] = IVaultDiamond.tempOwner.selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: _diamondCutFacet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });

        LibDiamond.diamondCut(cut, address(0), "");
        vaultData.backupAddress = _backup;
        _init = true;
    }

    // Find facet for function that is called and execute the
    // function if a facet is found and return any value.
    fallback() external payable {
        FacetAndSelectorData storage fsData = LibStorageBinder
            ._bindAndReturnFacetStorage();

        // get facet from function selector
        address facet = fsData.selectorToFacetAndPosition[msg.sig].facetAddress;
        require(facet != address(0), "Diamond: Function does not exist");
        // Execute external function from facet using delegatecall and return any value.
        assembly {
            // copy function selector and any arguments
            calldatacopy(0, 0, calldatasize())
            // execute function call using the facet
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)
            // get any return value
            returndatacopy(0, 0, returndatasize())
            // return any return value or error back to the caller
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}
