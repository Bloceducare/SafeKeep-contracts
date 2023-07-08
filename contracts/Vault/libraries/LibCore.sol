pragma solidity 0.8.4;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";
import {FacetAndSelectorData, DMSData} from "../libraries/LibLayoutSilo.sol";
import {LibDMSGuards} from "../libraries/LibDMSGuards.sol";

library LibCore {
    event VaultPinged(uint256 lastPing, uint256 vaultID);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, uint256 vaultID);
    event BackupTransferred(address indexed previousBackup, address indexed newBackup, uint256 vaultID);

    //owner check is in external fn
    //move to interact lib
    function _ping() internal {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        fsData.lastPing = block.timestamp;
        emit VaultPinged(block.timestamp, LibDiamond.vaultID());
    }

    function _transferOwnership(address _newOwner) internal {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        address prevOwner = fsData.vaultOwner;
        fsData.vaultOwner = _newOwner;
        emit OwnershipTransferred(prevOwner, _newOwner, LibDiamond.vaultID());
    }

    function _transferBackup(address _newBackupAddress) internal {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        address prevBackup = fsData.backupAddress;
        fsData.backupAddress = _newBackupAddress;
        emit BackupTransferred(prevBackup, _newBackupAddress, LibDiamond.vaultID());
    }

    ///CLAIMS

    function _claimOwnership(address _newBackup) internal {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        LibDMSGuards._expired();
        address prevOwner = fsData.vaultOwner;
        address prevBackup = fsData.backupAddress;
        assert(prevOwner != _newBackup);
        fsData.vaultOwner = msg.sender;
        fsData.backupAddress = _newBackup;
        emit OwnershipTransferred(prevOwner, msg.sender, LibDiamond.vaultID());
        emit BackupTransferred(prevBackup, _newBackup, LibDiamond.vaultID());
    }
}
