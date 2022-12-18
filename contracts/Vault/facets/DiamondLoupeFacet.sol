// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
/**
 * \
 * Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
 * EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
 * /*****************************************************************************
 */

//import  "../libraries/LibVaultStorage.sol";
import "../libraries/LibDiamond.sol";
import {IDiamondLoupe} from "../../interfaces/IDiamondLoupe.sol";
import {IERC165} from "../../interfaces/IERC165.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

contract DiamondLoupeFacet is IDiamondLoupe, IERC165 {
    // Diamond Loupe Functions
    ////////////////////////////////////////////////////////////////////
    /// These functions are expected to be called frequently by tools.

    /// @notice Gets all facets and their selectors.
    /// @return facets_ Facet
    function facets() external view override returns (Facet[] memory facets_) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        uint256 numFacets = fsData.facetAddresses.length;
        facets_ = new Facet[](numFacets);
        for (uint256 i; i < numFacets; i++) {
            address facetAddress_ = fsData.facetAddresses[i];
            facets_[i].facetAddress = facetAddress_;
            facets_[i].functionSelectors = fsData.facetFunctionSelectors[facetAddress_].functionSelectors;
        }
    }

    /// @notice Gets all the function selectors provided by a facet.
    /// @param _facet The facet address.
    /// @return facetFunctionSelectors_
    function facetFunctionSelectors(address _facet)
        external
        view
        override
        returns (bytes4[] memory facetFunctionSelectors_)
    {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        facetFunctionSelectors_ = fsData.facetFunctionSelectors[_facet].functionSelectors;
    }

    /// @notice Get all the facet addresses used by a diamond.
    /// @return facetAddresses_
    function facetAddresses() external view override returns (address[] memory facetAddresses_) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        facetAddresses_ = fsData.facetAddresses;
    }

    /// @notice Gets the facet that supports the given selector.
    /// @dev If facet is not found return address(0).
    /// @param _functionSelector The function selector.
    /// @return facetAddress_ The facet address.
    function facetAddress(bytes4 _functionSelector) external view override returns (address facetAddress_) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        facetAddress_ = fsData.selectorToFacetAndPosition[_functionSelector].facetAddress;
    }

    // This implements ERC-165.
    function supportsInterface(bytes4 _interfaceId) external view override returns (bool) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        return fsData.supportedInterfaces[_interfaceId];
    }
}
