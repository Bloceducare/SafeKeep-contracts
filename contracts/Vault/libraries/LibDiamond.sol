// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
/******************************************************************************/
import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";

import {FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";
import "../../interfaces/IVaultDiamond.sol";

library LibDiamond {
    error InValidFacetCutAction();
    error NotVaultOwner();
    error NoSelectorsInFacet();
    error NoZeroAddress();
    error SelectorExists(bytes4 selector);
    error SameSelectorReplacement(bytes4 selector);
    error MustBeZeroAddress();
    error NoCode();
    error NonExistentSelector(bytes4 selector);
    error ImmutableFunction(bytes4 selector);
    error NonEmptyCalldata();
    error EmptyCalldata();
    error InitCallFailed();

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function setVaultOwner(address _newOwner) internal {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        address previousOwner = fsData.vaultOwner;
        fsData.vaultOwner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    function vaultOwner() internal view returns (address contractOwner_) {
        contractOwner_ = LibStorageBinder._bindAndReturnFacetStorage().vaultOwner;
    }

    function vaultID() internal view returns (uint256 vaultID_) {
        vaultID_ = LibStorageBinder._bindAndReturnFacetStorage().vaultID;
    }

    function enforceIsContractOwner() internal view {
        if (msg.sender != LibStorageBinder._bindAndReturnFacetStorage().vaultOwner) revert NotVaultOwner();
    }

    function vaultFactory() internal view returns (address) {
        return IVaultDiamond(address(this)).vaultFactoryDiamond();
    }

    event DiamondCut(IDiamondCut.FacetCut[] _diamondCut, address _init, bytes _calldata);

    // Internal function version of diamondCut
    function diamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _init,
        bytes memory _calldata
    ) internal {
        for (uint256 facetIndex; facetIndex < _diamondCut.length; facetIndex++) {
            IDiamondCut.FacetCutAction action = _diamondCut[facetIndex].action;
            if (action == IDiamondCut.FacetCutAction.Add) {
                addFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
            } else if (action == IDiamondCut.FacetCutAction.Replace) {
                replaceFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
            } else if (action == IDiamondCut.FacetCutAction.Remove) {
                removeFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
            } else {
                revert InValidFacetCutAction();
            }
        }
        emit DiamondCut(_diamondCut, _init, _calldata);
        initializeDiamondCut(_init, _calldata);
    }

    function addFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        if (_functionSelectors.length <= 0) revert NoSelectorsInFacet();
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (_facetAddress == address(0)) revert NoZeroAddress();
        uint96 selectorPosition = uint96(fsData.facetFunctionSelectors[_facetAddress].functionSelectors.length);
        // add new facet address if it does not exist
        if (selectorPosition == 0) {
            addFacet(fsData, _facetAddress);
        }
        for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = fsData.selectorToFacetAndPosition[selector].facetAddress;
            if (oldFacetAddress != address(0)) revert SelectorExists(selector);
            addFunction(fsData, selector, selectorPosition, _facetAddress);
            selectorPosition++;
        }
    }

    function replaceFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        if (_functionSelectors.length <= 0) revert NoSelectorsInFacet();
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (_facetAddress == address(0)) revert NoZeroAddress();
        uint96 selectorPosition = uint96(fsData.facetFunctionSelectors[_facetAddress].functionSelectors.length);
        // add new facet address if it does not exist
        if (selectorPosition == 0) {
            addFacet(fsData, _facetAddress);
        }
        for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = fsData.selectorToFacetAndPosition[selector].facetAddress;
            if (oldFacetAddress == _facetAddress) revert SameSelectorReplacement(selector);
            removeFunction(fsData, oldFacetAddress, selector);
            addFunction(fsData, selector, selectorPosition, _facetAddress);
            selectorPosition++;
        }
    }

    function removeFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        if (_functionSelectors.length <= 0) revert NoSelectorsInFacet();
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        // if function does not exist then do nothing and return
        if (_facetAddress != address(0)) revert MustBeZeroAddress();
        for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = fsData.selectorToFacetAndPosition[selector].facetAddress;
            removeFunction(fsData, oldFacetAddress, selector);
        }
    }

    function addFacet(FacetAndSelectorData storage fsData, address _facetAddress) internal {
        enforceHasContractCode(_facetAddress);
        fsData.facetFunctionSelectors[_facetAddress].facetAddressPosition = fsData.facetAddresses.length;
        fsData.facetAddresses.push(_facetAddress);
    }

    function addFunction(
        FacetAndSelectorData storage fsData,
        bytes4 _selector,
        uint96 _selectorPosition,
        address _facetAddress
    ) internal {
        fsData.selectorToFacetAndPosition[_selector].functionSelectorPosition = _selectorPosition;
        fsData.facetFunctionSelectors[_facetAddress].functionSelectors.push(_selector);
        fsData.selectorToFacetAndPosition[_selector].facetAddress = _facetAddress;
    }

    function removeFunction(
        FacetAndSelectorData storage fsData,
        address _facetAddress,
        bytes4 _selector
    ) internal {
        if (_facetAddress == address(0)) revert NonExistentSelector(_selector);
        // an immutable function is a function defined directly in a diamond
        if (_facetAddress == address(this)) revert ImmutableFunction(_selector);
        // replace selector with last selector, then delete last selector
        uint256 selectorPosition = fsData.selectorToFacetAndPosition[_selector].functionSelectorPosition;
        uint256 lastSelectorPosition = fsData.facetFunctionSelectors[_facetAddress].functionSelectors.length - 1;
        // if not the same then replace _selector with lastSelector
        if (selectorPosition != lastSelectorPosition) {
            bytes4 lastSelector = fsData.facetFunctionSelectors[_facetAddress].functionSelectors[lastSelectorPosition];
            fsData.facetFunctionSelectors[_facetAddress].functionSelectors[selectorPosition] = lastSelector;
            fsData.selectorToFacetAndPosition[lastSelector].functionSelectorPosition = uint96(selectorPosition);
        }
        // delete the last selector
        fsData.facetFunctionSelectors[_facetAddress].functionSelectors.pop();
        delete fsData.selectorToFacetAndPosition[_selector];

        // if no more selectors for facet address then delete the facet address
        if (lastSelectorPosition == 0) {
            // replace facet address with last facet address and delete last facet address
            uint256 lastFacetAddressPosition = fsData.facetAddresses.length - 1;
            uint256 facetAddressPosition = fsData.facetFunctionSelectors[_facetAddress].facetAddressPosition;
            if (facetAddressPosition != lastFacetAddressPosition) {
                address lastFacetAddress = fsData.facetAddresses[lastFacetAddressPosition];
                fsData.facetAddresses[facetAddressPosition] = lastFacetAddress;
                fsData.facetFunctionSelectors[lastFacetAddress].facetAddressPosition = facetAddressPosition;
            }
            fsData.facetAddresses.pop();
            delete fsData.facetFunctionSelectors[_facetAddress].facetAddressPosition;
        }
    }

    function initializeDiamondCut(address _init, bytes memory _calldata) internal {
        if (_init == address(0)) {
            if (_calldata.length > 0) revert NonEmptyCalldata();
        } else {
            if (_calldata.length == 0) revert EmptyCalldata();
            if (_init != address(this)) {
                enforceHasContractCode(_init);
            }
            (bool success, bytes memory error) = _init.delegatecall(_calldata);
            if (!success) {
                if (error.length > 0) {
                    // bubble up the error
                    revert(string(error));
                } else {
                    revert InitCallFailed();
                }
            }
        }
    }

    function enforceHasContractCode(address _contract) internal view {
        uint256 contractSize;
        assembly {
            contractSize := extcodesize(_contract)
        }
        if (contractSize <= 0) revert NoCode();
    }
}
