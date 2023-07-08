// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/**
 * Implementation of a diamond.
 * /*****************************************************************************
 */

import {LibDiamond} from "./libraries/LibDiamond.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";

import {FacetAndSelectorData, DMSData} from "./libraries/LibLayoutSilo.sol";

import {LibStorageBinder} from "./libraries/LibStorageBinder.sol";
import {LibErrors} from "./libraries/LibErrors.sol";

//import "./libraries/LibVaultStorage.sol";

import "../interfaces/IVaultDiamond.sol";

contract VaultDiamond {
	address public vaultFactoryDiamond;

	constructor(
		IDiamondCut.FacetCut[] memory _selectorModule,
		IDiamondCut.FacetCut[] memory _tokenModule,
		address _vaultOwner,
		address _backupAddress,
		uint256 _pingWindow,
		uint256 _vaultID
	) payable {
		LibDiamond.diamondCut(_selectorModule, address(0), "");
		LibDiamond.diamondCut(_tokenModule, address(0), "");
        if(_backupAddress == address(0)) revert LibErrors.NoZeroAddress();
		//set module installation record to true
		FacetAndSelectorData storage fsData = LibStorageBinder
			._bindAndReturnFacetStorage();
		fsData.activeModule["Selector"] = true;
		fsData.activeModule["Token"] = true;
		fsData.activeModules.push("Selector");
		fsData.activeModules.push("Token");
		fsData.backupAddress = _backupAddress;
		fsData.pingWindow = _pingWindow;
		fsData.vaultID = _vaultID;
		LibDiamond.setVaultOwner(_vaultOwner);
		vaultFactoryDiamond = msg.sender;
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
