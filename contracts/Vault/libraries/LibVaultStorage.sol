pragma solidity 0.8.4;

import "./LibDiamond.sol";
struct FacetAddressAndPosition {
    address facetAddress;
    uint96 functionSelectorPosition; // position in facetFunctionSelectors.functionSelectors array
}
error NotBackupAddress();
error NotOwnerOrBackupAddress();
error NotExpired();
error HasExpired();
error Claimed();
error NoPermissions();

struct FacetFunctionSelectors {
    bytes4[] functionSelectors;
    uint256 facetAddressPosition; // position of facetAddress in facetAddresses array
}

struct VaultStorage {
    ///VAULT DIAMOND VARS
    // maps function selector to the facet address and
    // the position of the selector in the facetFunctionSelectors.selectors array
    mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
    // maps facet addresses to function selectors
    mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
    // facet addresses
    address[] facetAddresses;
    // Used to query if a contract implements an interface.
    // Used to implement ERC-165.
    mapping(bytes4 => bool) supportedInterfaces;
    //VAULT INTERNAL VARS

    //Vault ID
    uint256 vaultID;
    // owner of the vault
    address vaultOwner;
    //last time pinged
    uint256 lastPing;
    //backup address
    address backupAddress;
    //array of all inheritors
    address[] inheritors;
    //active inheritors
    mapping(address => bool) activeInheritors;
    //inheritor WEI shares
    mapping(address => uint256) inheritorWeishares;
    //ERC20
    //inheritor active tokens
    mapping(address => mapping(address => bool)) inheritorActiveTokens;
    //inheritor token shares
    mapping(address => mapping(address => uint256)) inheritorTokenShares;
    //address of tokens allocated
    mapping(address => address[]) inheritorAllocatedERC20Tokens;
    //ERC721
    mapping(address => mapping(address => bool)) whitelist;
    mapping(address => mapping(address => uint256)) inheritorERC721Tokens;
    mapping(address => mapping(uint256 => address)) ERC721ToInheritor;
    mapping(address => mapping(uint256 => bool)) allocatedERC721Tokens;
    mapping(address => address[]) inheritorAllocatedERC721TokenAddresses;
    //ERC1155
    mapping(address => mapping(address => mapping(uint256 => uint256))) inheritorERC1155TokenAllocations;
    mapping(address => address[]) inheritorAllocatedERC1155TokenAddresses;
    //GLOBAL
    mapping(address => mapping(address => uint256[])) inheritorAllocatedTokenIds;
    mapping(address => bool) claimed;
}

library Guards {
    function _onlyVaultOwner() internal view {
        LibDiamond.enforceIsContractOwner();
    }

function _onlyVaultOwnerOrOrigin() internal view{
    VaultStorage storage vs = LibDiamond.vaultStorage();
    if(tx.origin != vs.vaultOwner && msg.sender !=vs.vaultOwner )  revert NoPermissions();
}
function _onlyVaultOwnerOrOriginOrBackup() internal view{
    VaultStorage storage vs = LibDiamond.vaultStorage();
    if(tx.origin != vs.vaultOwner && msg.sender !=vs.vaultOwner && msg.sender != vs.backupAddress && tx.origin!= vs.backupAddress )  revert NoPermissions();
}
    function _onlyVaultOwnerOrBackup() internal view {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (msg.sender != vs.backupAddress && msg.sender != vs.vaultOwner) 
            revert NotOwnerOrBackupAddress();
    }

    function _enforceIsBackupAddress() internal view {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (msg.sender != vs.backupAddress) revert NotBackupAddress();
    }

    function _activeInheritor(address _inheritor)
        internal
        view
        returns (bool active_)
    {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (_inheritor == address(0)) {
            active_ == true;
        } else {
            active_ = (vs.activeInheritors[_inheritor]);
        }
    }

    function _anInheritor(address _inheritor) internal view returns (bool inh) {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (_inheritor == address(0)) {
            inh = true;
        } else {
            for (uint256 i; i < vs.inheritors.length; i++) {
                if (_inheritor == vs.inheritors[i]) {
                    inh = true;
                }
            }
        }
    }

    function _expired() internal view {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (block.timestamp - vs.lastPing <= 24 weeks) revert NotExpired();
    }

    function _notExpired() internal view {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (block.timestamp - vs.lastPing > 24 weeks) revert HasExpired();
    }

    function _notClaimed(address _inheritor) internal view {
        VaultStorage storage vs = LibDiamond.vaultStorage();
        if (vs.claimed[_inheritor]) revert Claimed();
    }
}
