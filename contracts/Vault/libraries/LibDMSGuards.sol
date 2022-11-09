// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {DMSData, FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";

error NotBackupAddress();
error NotOwnerOrBackupAddress();
error NotExpired();
error HasExpired();
error Claimed();

library LibDMSGuards {
    //check
    function _onlyVaultOwnerOrBackup() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (msg.sender != vaultData.backupAddress && msg.sender != fsData.vaultOwner) {
            revert NotOwnerOrBackupAddress();
        }
    }

    function _enforceIsBackupAddress() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (msg.sender != vaultData.backupAddress) {
            revert NotBackupAddress();
        }
    }

    function _activeInheritor(address _inheritor) internal view returns (bool active_) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (_inheritor == address(0)) {
            active_ = true;
        } else {
            active_ = (vaultData.activeInheritors[_inheritor]);
        }
    }

    function _anInheritor(address _inheritor) internal view returns (bool inh) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (_inheritor == address(0)) {
            inh = true;
        } else {
            for (uint256 i; i < vaultData.inheritors.length; i++) {
                if (_inheritor == vaultData.inheritors[i]) {
                    inh = true;
                }
            }
        }
    }

    function _anInheritorOrZero(address _inheritor) internal view returns (bool inh) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (_inheritor == address(0)) {
            inh = true;
        } else {
            for (uint256 i; i < vaultData.inheritors.length; i++) {
                if (_inheritor == vaultData.inheritors[i]) {
                    inh = true;
                }
            }
        }
    }

    function _expired() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (block.timestamp - vaultData.lastPing <= 24 weeks) {
            revert NotExpired();
        }
    }

    function _notExpired() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (block.timestamp - vaultData.lastPing > 24 weeks) {
            revert HasExpired();
        }
    }

    function _notClaimed(address _inheritor) internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (vaultData.claimed[_inheritor]) {
            revert Claimed();
        }
    }
}
