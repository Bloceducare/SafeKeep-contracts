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
    /// @notice ensures that a caller is vault owner or backup address
    function _onlyVaultOwnerOrBackup() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (msg.sender != vaultData.backupAddress && msg.sender != fsData.vaultOwner) {
            revert NotOwnerOrBackupAddress();
        }
    }
    /// @dev checks that caller is a backup address

    function _enforceIsBackupAddress() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (msg.sender != vaultData.backupAddress) {
            revert NotBackupAddress();
        }
    }
    /// checks if an address is an active inheritor on a vault

    function _activeInheritor(address _inheritor) internal view returns (bool active_) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (_inheritor == address(0)) {
            active_ = true;
        } else {
            active_ = (vaultData.activeInheritors[_inheritor]);
        }
    }
    ///  checks if an address has been set as inheritor

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
    /// checks if address is an inheritor or address(0)

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

    /// checks if the vault timeline for inactivity has expired
    function _expired() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (block.timestamp - vaultData.lastPing <= 24 weeks) {
            revert NotExpired();
        }
    }

    /// checks if the vault timeline for inactivity is still valid
    function _notExpired() internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (block.timestamp - vaultData.lastPing > 24 weeks) {
            revert HasExpired();
        }
    }
    /// @notice check if an inheritor has claimed the assets allocated to them

    function _notClaimed(address _inheritor) internal view {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnDMSStorage();
        if (vaultData.claimed[_inheritor]) {
            revert Claimed();
        }
    }
}
