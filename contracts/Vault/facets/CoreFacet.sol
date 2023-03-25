pragma solidity 0.8.4;

import {LibGuards} from "../libraries/LibGuards.sol";
import {LibDMS} from "../libraries/LibDMS.sol";
import {LibDMSGuards} from "../libraries/LibDMSGuards.sol";
import {LibCore} from "../libraries/LibCore.sol";
import {FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";

contract CoreFacet {

    struct Vault{
        address vaultOwner;
        address backupAddress;
        uint256 vaultID;
        uint256 lastPing;
        uint256 pingWindow;
        string[] modules;
    }
	///////////////////
	//WRITE FUNCTIONS//
	/////////////////
	//move to Interactionfacet
	function ping() external {
		LibGuards._onlyVaultOwner();
		LibCore._ping();
	}

	function transferBackup(address _newBackupAddress) public {
		LibGuards._onlyVaultOwnerOrBackup();
		LibCore._transferBackup(_newBackupAddress);
	}

	function transferOwnership(address _newVaultOwner) public {
		LibGuards._onlyVaultOwner();
		LibCore._transferOwnership(_newVaultOwner);
	}

	function claimOwnership(address _newBackupAddress) public {
		LibGuards._enforceIsBackupAddress();
		LibCore._claimOwnership(_newBackupAddress);
	}

    function execute(address _target, bytes memory _data) external payable {
        LibGuards._onlyVaultOwner();
      
        (bool success,) = _target.call{value: msg.value}(_data);
        assert(success);
       
    }

    ///////////////////
    //READ FUNCTIONS//
    //////////////////

    function getVault() external view returns (Vault memory vault_) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        vault_.vaultOwner = fsData.vaultOwner;
        vault_.backupAddress = fsData.backupAddress;
        vault_.vaultID = fsData.vaultID;
        vault_.lastPing = fsData.lastPing;
        vault_.pingWindow = fsData.pingWindow;
        vault_.modules = fsData.activeModules;
    }
}
