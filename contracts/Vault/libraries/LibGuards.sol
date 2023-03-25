pragma solidity 0.8.4;

import "./LibDiamond.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

library LibGuards {
	error NotBackupAddress();
	error NotOwnerOrBackupAddress();

	function _onlyVaultOwner() internal view {
		LibDiamond.enforceIsContractOwner();
	}

	//check
	function _onlyVaultOwnerOrBackup() internal view {
		FacetAndSelectorData storage fsData = LibStorageBinder
			._bindAndReturnFacetStorage();
		if (msg.sender != fsData.backupAddress && msg.sender != fsData.vaultOwner) {
			revert NotOwnerOrBackupAddress();
		}
	}

	function _enforceIsBackupAddress() internal view {
		FacetAndSelectorData storage fsData = LibStorageBinder
			._bindAndReturnFacetStorage();
		if (msg.sender != fsData.backupAddress) {
			revert NotBackupAddress();
		}
	}
}
