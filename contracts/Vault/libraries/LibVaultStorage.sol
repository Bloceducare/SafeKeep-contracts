pragma solidity 0.8.4;

import "./LibDiamond.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

error NotBackupAddress();
error NotOwnerOrBackupAddress();
error NotExpired();
error HasExpired();
error Claimed();
error NoPermissions();

library Guards {
    function _onlyVaultOwner() internal view {
        LibDiamond.enforceIsContractOwner();
    }

//this will be deprecated
    function _onlyVaultOwnerOrOrigin() internal view {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (tx.origin != vaultData.vaultOwner && msg.sender != vaultData.vaultOwner) {
            revert NoPermissions();
        }
    }

//this will be deprecated
    function _onlyVaultOwnerOrOriginOrBackup() internal view {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (
            tx.origin != vaultData.vaultOwner && msg.sender != vaultData.vaultOwner
                && msg.sender != vaultData.backupAddress && tx.origin != vaultData.backupAddress
        ) {
            revert NoPermissions();
        }
    }

    function _onlyVaultOwnerOrBackup() internal view {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (msg.sender != vaultData.backupAddress && msg.sender != vaultData.vaultOwner) {
            revert NotOwnerOrBackupAddress();
        }
    }

    function _enforceIsBackupAddress() internal view {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (msg.sender != vaultData.backupAddress) {
            revert NotBackupAddress();
        }
    }

    function _activeInheritor(address _inheritor) internal view returns (bool active_) {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (_inheritor == address(0)) {
            active_ = true;
        } else {
            active_ = (vaultData.activeInheritors[_inheritor]);
        }
    }

    function _anInheritor(address _inheritor) internal view returns (bool inh) {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
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
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
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
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (block.timestamp - vaultData.lastPing <= 24 weeks) {
            revert NotExpired();
        }
    }

    function _notExpired() internal view {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (block.timestamp - vaultData.lastPing > 24 weeks) {
            revert HasExpired();
        }
    }

    function _notClaimed(address _inheritor) internal view {
        VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (vaultData.claimed[_inheritor]) {
            revert Claimed();
        }
    }
}
