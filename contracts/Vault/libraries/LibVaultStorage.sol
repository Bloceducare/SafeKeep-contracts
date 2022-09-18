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

// struct FacetFunctionSelectors {
//     bytes4[] functionSelectors;
//     uint256 facetAddressPosition; // position of facetAddress in facetAddresses array
// }

// struct VaultStorage {
//     ///VAULT DIAMOND VARS
//     // maps function selector to the facet address and
//     // the position of the selector in the facetFunctionSelectors.selectors array
//     mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
//     // maps facet addresses to function selectors
//     mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
//     // facet addresses
//     address[] facetAddresses;
//     // Used to query if a contract implements an interface.
//     // Used to implement ERC-165.
//     mapping(bytes4 => bool) supportedInterfaces;
//     //VAULT INTERNAL VARS

//     //Vault ID
//     uint256 vaultID;
//     // owner of the vault
//     address vaultOwner;
//     //last time pinged
//     uint256 lastPing;
//     //backup address
//     address backupAddress;
//     //array of all inheritors
//     address[] inheritors;
//     //active inheritors
//     mapping(address => bool) activeInheritors;
//     //inheritor WEI shares
//     mapping(address => uint256) inheritorWeishares;
//     //ERC20
//     //inheritor active tokens
//     mapping(address => mapping(address => bool)) inheritorActiveTokens;
//     //inheritor token shares
//     mapping(address => mapping(address => uint256)) inheritorTokenShares;
//     //address of tokens allocated
//     mapping(address => address[]) inheritorAllocatedERC20Tokens;
//     //ERC721
//     mapping(address => mapping(address => bool)) whitelist;
//     mapping(address => mapping(address => uint256)) inheritorERC721Tokens;
//     mapping(address => mapping(uint256 => address)) ERC721ToInheritor;
//     mapping(address => mapping(uint256 => bool)) allocatedERC721Tokens;
//     mapping(address => address[]) inheritorAllocatedERC721TokenAddresses;
//     //ERC1155
//     mapping(address => mapping(address => mapping(uint256 => uint256))) inheritorERC1155TokenAllocations;
//     mapping(address => address[]) inheritorAllocatedERC1155TokenAddresses;
//     //GLOBAL
//     mapping(address => mapping(address => uint256[])) inheritorAllocatedTokenIds;
//     mapping(address => bool) claimed;

// }

library Guards {
  function _onlyVaultOwner() internal view {
    LibDiamond.enforceIsContractOwner();
  }

  function _onlyVaultOwnerOrOrigin() internal view {
    VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
    if (
      tx.origin != vaultData.vaultOwner && msg.sender != vaultData.vaultOwner
    ) {
      revert NoPermissions();
    }
  }

  function _onlyVaultOwnerOrOriginOrBackup() internal view {
    VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
    if (
      tx.origin != vaultData.vaultOwner &&
      msg.sender != vaultData.vaultOwner &&
      msg.sender != vaultData.backupAddress &&
      tx.origin != vaultData.backupAddress
    ) {
      revert NoPermissions();
    }
  }

  function _onlyVaultOwnerOrBackup() internal view {
    VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
    if (
      msg.sender != vaultData.backupAddress &&
      msg.sender != vaultData.vaultOwner
    ) {
      revert NotOwnerOrBackupAddress();
    }
  }

  function _enforceIsBackupAddress() internal view {
    VaultData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
    if (msg.sender != vaultData.backupAddress) {
      revert NotBackupAddress();
    }
  }

  function _activeInheritor(address _inheritor)
    internal
    view
    returns (bool active_)
  {
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

  function _anInheritorOrZero(address _inheritor)
    internal
    view
    returns (bool inh)
  {
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
