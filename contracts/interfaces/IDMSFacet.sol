pragma solidity 0.8.4;

interface IDMSFacet {
    struct VaultInfo {
        address owner;
        uint256 weiBalance;
        uint256 lastPing;
        uint256 id;
        address backup;
        address[] inheritors;
    }

    struct AllInheritorEtherAllocs {
        address inheritor;
        uint256 weiAlloc;
    }

    struct AllocatedERC1155Tokens {
        uint256 tokenID;
        uint256 amount;
    }

    struct AllAllocatedERC1155Tokens {
        address token;
        uint256 tokenID;
        uint256 amount;
    }

    struct AllocatedERC721Tokens {
        address token;
        uint256[] tokenIDs;
    }

    struct AllocatedERC20Tokens {
        address token;
        uint256 amount;
    }

    function inspectVault() external view returns (VaultInfo memory info);

    function allEtherAllocations()
        external
        view
        returns (AllInheritorEtherAllocs[] memory eAllocs);

    function inheritorEtherAllocation(
        address _inheritor
    ) external view returns (uint256 _allocatedEther);

    function getAllocatedEther() external view returns (uint256);

    function getUnallocatedEther() external view returns (uint256 unallocated_);

    function etherBalance() external view returns (uint256);

    function getAllocatedERC20Tokens(
        address _inheritor
    ) external view returns (AllocatedERC20Tokens[] memory tAllocs);

    function inheritorERC20TokenAllocation(
        address _inheritor,
        address _token
    ) external view returns (uint256);

    function getUnallocatedTokens(
        address _token
    ) external view returns (uint256 unallocated_);

    function getAllocatedERC721Tokens(
        address _inheritor
    ) external view returns (AllocatedERC721Tokens[] memory allocated);

    function getAllocatedERC721TokenIds(
        address _inheritor,
        address _token
    ) external view returns (uint256[] memory);

    function getAllocatedERC721TokenAddresses(
        address _inheritor
    ) external view returns (address[] memory);

    function getAllocatedERC1155Tokens(
        address _token,
        address _inheritor
    ) external view returns (AllocatedERC1155Tokens[] memory alloc_);

    function getAllAllocatedERC1155Tokens(
        address _inheritor
    ) external view returns (AllAllocatedERC1155Tokens[] memory alloc_);

    function getUnallocatedERC115Tokens(
        address _token,
        uint256 _tokenId
    ) external view returns (uint256 remaining_);

    function addInheritors(
        address[] calldata _newInheritors,
        uint256[] calldata _weiShare
    ) external;

    function removeInheritors(address[] calldata _inheritors) external;

    function allocateEther(
        address[] calldata _inheritors,
        uint256[] calldata _ethShares
    ) external;

    function allocateERC20Tokens(
        address token,
        address[] calldata _inheritors,
        uint256[] calldata _shares
    ) external;

    function allocateERC721Tokens(
        address token,
        address[] calldata _inheritors,
        uint256[] calldata _tokenIDs
    ) external;

    function allocateERC1155Tokens(
        address token,
        address[] calldata _inheritors,
        uint256[] calldata _tokenIDs,
        uint256[] calldata _amounts
    ) external;

    function claimAllAllocations() external;
}
