pragma solidity 0.8.4;

//A record of data layouts...these are immutable and cannot be extended

///DIAMOND_FACET_SELECTOR
////START/////
struct FacetAddressAndPosition {
    address facetAddress;
    uint96 functionSelectorPosition; // position in facetFunctionSelectors.functionSelectors array
}

struct FacetFunctionSelectors {
    bytes4[] functionSelectors;
    uint256 facetAddressPosition; // position of facetAddress in facetAddresses array
}

struct FacetAndSelectorData {
    // maps function selector to the facet address and
    // the position of the selector in the facetFunctionSelectors.selectors array
    mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
    // maps facet addresses to function selectors
    mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
    // Used to query if a contract implements an interface.
    // Used to implement ERC-165.
    mapping(bytes4 => bool) supportedInterfaces;
    // facet addresses
    address[] facetAddresses;
    //Vault ID
    uint256 vaultID;
    // owner of the vault
    address vaultOwner;
    //Modules
    // module's status
    mapping(string => bool) activeModule;
    /// maps Module to counter
    mapping(string => uint256) moduleStorageCounter;
    // arrays of active modules
    string[] activeModules;
}
/////STOP/////

//DMS_GLOB_DATA
////START////
struct DMSData {
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
    // maps token address to inheritor
    mapping(address => mapping(address => bool)) whitelist;
    // maps number of ERC721 token aloocated to inheritor
    mapping(address => mapping(address => uint256)) inheritorERC721Tokens;
    // maps an address to token and inheritor
    mapping(address => mapping(uint256 => address)) ERC721ToInheritor;
    // allocated ERC721 tokens
    mapping(address => mapping(uint256 => bool)) allocatedERC721Tokens;
    // Erc721 tokens allocated to an inheritor
    mapping(address => address[]) inheritorAllocatedERC721TokenAddresses;
    //ERC1155
    // maps token address and id to inheritor
    mapping(address => mapping(address => mapping(uint256 => uint256))) inheritorERC1155TokenAllocations;
    mapping(address => address[]) inheritorAllocatedERC1155TokenAddresses;
    //GLOBAL
    // total tokens Id's allocated to an inheritor
    mapping(address => mapping(address => uint256[])) inheritorAllocatedTokenIds;
    mapping(address => bool) claimed;
}
////STOP////
