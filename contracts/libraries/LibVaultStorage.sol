pragma solidity 0.8.4;

import "./LibDiamond.sol";
struct FacetAddressAndPosition {
    address facetAddress;
    uint96 functionSelectorPosition; // position in facetFunctionSelectors.functionSelectors array
}
error NotBackupAddress();

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
    //inheritor active tokens
    mapping(address => mapping(address => bool)) inheritorActiveTokens;
    //inheritor token shares
    mapping(address => mapping(address => uint256)) inheritorTokenShares;
    //address of tokens allocated
    mapping(address => address[]) inheritorAllocatedTokens;
}

contract ModifiersAndGuards {
    VaultStorage internal vs;

    modifier onlyVaultOwner() {
        LibDiamond.enforceIsContractOwner();
        _;
    }

    function _enforceIsBackupAddress() internal view {
        if (msg.sender != vs.backupAddress) revert NotBackupAddress();
    }
}
