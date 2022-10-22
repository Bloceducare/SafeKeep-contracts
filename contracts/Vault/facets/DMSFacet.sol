pragma solidity 0.8.4;

import "../libraries/LibDMS.sol";

import "../libraries/LibTokens.sol";
import "../libraries/LibDiamond.sol";
import "../../interfaces/IERC20.sol";

import {DMSData, FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";
import {LibDMSGuards} from "../libraries/LibDMSGuards.sol";
import {LibGuards} from "../libraries/LibGuards.sol";

contract DMSFacet {
    ///////////////////
    //VIEW FUNCTIONS//
    /////////////////
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

   

    function inspectVault() public view returns (VaultInfo memory info) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        info.owner = fsData.vaultOwner;
        info.weiBalance = address(this).balance;
        info.lastPing = vaultData.lastPing;
        info.id = fsData.vaultID;
        info.backup = vaultData.backupAddress;
        info.inheritors = vaultData.inheritors;
    }

    function allEtherAllocations() public view returns (AllInheritorEtherAllocs[] memory eAllocs) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        uint256 count = vaultData.inheritors.length;
        eAllocs = new AllInheritorEtherAllocs[](count);
        for (uint256 i; i < count; i++) {
            eAllocs[i].inheritor = vaultData.inheritors[i];
            eAllocs[i].weiAlloc = vaultData.inheritorWeishares[vaultData.inheritors[i]];
        }
    }

    function inheritorEtherAllocation(address _inheritor) public view returns (uint256 _allocatedEther) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        if (!LibDMSGuards._anInheritor(_inheritor)) {
            revert LibDMS.NotInheritor();
        }
        _allocatedEther = vaultData.inheritorWeishares[_inheritor];
    }

    function getAllocatedEther() public view returns (uint256) {
        return LibDMS.getCurrentAllocatedEth();
    }

    function getUnallocatedEther() public view returns (uint256 unallocated_) {
        uint256 currentBalance = address(this).balance;
        if (currentBalance > 0) {
            unallocated_ = currentBalance - LibDMS.getCurrentAllocatedEth();
        }
    }

    function etherBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getAllocatedERC20Tokens(address _inheritor) public view returns (AllocatedERC20Tokens[] memory tAllocs) {
        LibDMSGuards._activeInheritor(_inheritor);
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        uint256 count = vaultData.inheritorAllocatedERC20Tokens[_inheritor].length;
        if (count > 0) {
            tAllocs = new AllocatedERC20Tokens[](count);
            for (uint256 i; i < count; i++) {
                address _t = vaultData.inheritorAllocatedERC20Tokens[_inheritor][i];
                tAllocs[i].amount = vaultData.inheritorTokenShares[_inheritor][_t];
                tAllocs[i].token = _t;
            }
        }
    }

    function inheritorERC20TokenAllocation(address _inheritor, address _token) public view returns (uint256) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        return vaultData.inheritorTokenShares[_inheritor][_token];
    }

    function getUnallocatedTokens(address _token) public view returns (uint256 unallocated_) {
        uint256 bal = IERC20(_token).balanceOf(address(this));
        uint256 allocated = LibDMS.getCurrentAllocatedTokens(_token);
        if (bal > allocated) {
            unallocated_ = bal - allocated;
        }
    }

    function getAllocatedERC721Tokens(address _inheritor)
        public
        view
        returns (AllocatedERC721Tokens[] memory allocated)
    {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        LibDMSGuards._activeInheritor(_inheritor);
        uint256 tokenAddressCount = vaultData.inheritorAllocatedERC721TokenAddresses[_inheritor].length;
        if (tokenAddressCount > 0) {
            allocated = new AllocatedERC721Tokens[](tokenAddressCount);
            for (uint256 i; i < tokenAddressCount; i++) {
                address _token = vaultData.inheritorAllocatedERC721TokenAddresses[_inheritor][i];
                allocated[i].token = _token;
                allocated[i].tokenIDs = vaultData.inheritorAllocatedTokenIds[_inheritor][_token];
            }
        }
    }

    function getAllocatedERC721TokenIds(address _inheritor, address _token) external view returns (uint256[] memory) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        LibDMSGuards._activeInheritor(_inheritor);
        return vaultData.inheritorAllocatedTokenIds[_inheritor][_token];
    }

    function getAllocatedERC721TokenAddresses(address _inheritor) public view returns (address[] memory) {
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        LibDMSGuards._activeInheritor(_inheritor);
        return vaultData.inheritorAllocatedERC721TokenAddresses[_inheritor];
    }

    function getAllocatedERC1155Tokens(address _token, address _inheritor)
        public
        view
        returns (AllocatedERC1155Tokens[] memory alloc_)
    {
        LibDMSGuards._activeInheritor(_inheritor);
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        uint256 tokenCount = vaultData.inheritorAllocatedTokenIds[_inheritor][_token].length;
        if (tokenCount > 0) {
            alloc_ = new AllocatedERC1155Tokens[](tokenCount);
            for (uint256 i; i < tokenCount; i++) {
                uint256 _tid = vaultData.inheritorAllocatedTokenIds[_inheritor][_token][i];
                alloc_[i].tokenID = _tid;
                alloc_[i].amount = vaultData.inheritorERC1155TokenAllocations[_inheritor][_token][_tid];
            }
        }
    }

    function getAllAllocatedERC1155Tokens(address _inheritor)
        public
        view
        returns (AllAllocatedERC1155Tokens[] memory alloc_)
    {
        LibDMSGuards._activeInheritor(_inheritor);
        DMSData storage vaultData = LibStorageBinder._bindAndReturnVaultStorage();
        uint256 tokenAddressCount = vaultData.inheritorAllocatedERC1155TokenAddresses[_inheritor].length;
        for (uint256 j = 0; j < tokenAddressCount; j++) {
            address _token = vaultData.inheritorAllocatedERC1155TokenAddresses[_inheritor][j];
            uint256 tokenCount = vaultData.inheritorAllocatedTokenIds[_inheritor][_token].length;
            alloc_ = new AllAllocatedERC1155Tokens[](tokenCount);
            for (uint256 i; i < tokenCount; i++) {
                uint256 _tid = vaultData.inheritorAllocatedTokenIds[_inheritor][_token][i];
                alloc_[i].tokenID = _tid;
                alloc_[i].amount = vaultData.inheritorERC1155TokenAllocations[_inheritor][_token][_tid];
                alloc_[i].token = _token;
            }
        }
    }

    function getUnallocatedERC115Tokens(address _token, uint256 _tokenId) public view returns (uint256 remaining_) {
        uint256 allocated = LibDMS.getCurrentAllocated1155tokens(_token, _tokenId);
        uint256 available = IERC1155(_token).balanceOf(address(this), _tokenId);
        if (allocated < available) {
            remaining_ = available - allocated;
        }
    }

    //////////////////////
    ///WRITE FUNCTIONS///
    ////////////////////
    //note: owner restriction is in external fns
    function addInheritors(address[] calldata _newInheritors, uint256[] calldata _weiShare) external {
        LibGuards._onlyVaultOwner();
        LibDMS._addInheritors(_newInheritors, _weiShare);
    }

    function removeInheritors(address[] calldata _inheritors) external {
        LibGuards._onlyVaultOwner();
        LibDMS._removeInheritors(_inheritors);
    }

    function allocateEther(address[] calldata _inheritors, uint256[] calldata _ethShares) external {
        LibGuards._onlyVaultOwner();
        LibDMS._allocateEther(_inheritors, _ethShares);
    }

    function allocateERC20Tokens(address token, address[] calldata _inheritors, uint256[] calldata _shares) external {
        LibGuards._onlyVaultOwner();
        LibDMS._allocateERC20Tokens(token, _inheritors, _shares);
    }

    function allocateERC721Tokens(address token, address[] calldata _inheritors, uint256[] calldata _tokenIDs)
        external
    {
        LibGuards._onlyVaultOwner();
        LibDMS._allocateERC721Tokens(token, _inheritors, _tokenIDs);
    }

    function allocateERC1155Tokens(
        address token,
        address[] calldata _inheritors,
        uint256[] calldata _tokenIDs,
        uint256[] calldata _amounts
    ) external {
        LibGuards._onlyVaultOwner();
        LibDMS._allocateERC1155Tokens(token, _inheritors, _tokenIDs, _amounts);
    }

    function transferOwnership(address _newVaultOwner) public {
        LibGuards._onlyVaultOwner();
        LibDMS._transferOwnerShip(_newVaultOwner);
    }

    function transferBackup(address _newBackupAddress) public {
        LibDMSGuards._onlyVaultOwnerOrBackup();
        LibDMS._transferBackup(_newBackupAddress);
    }

    //CLAIMS
    function claimOwnership(address _newBackupAddress) public {
        LibDMSGuards._enforceIsBackupAddress();
        LibDMS._claimOwnership(_newBackupAddress);
    }

    function claimAllAllocations() external {
        LibDMS._claimAll();
    }

    function ping() external {
        LibGuards._onlyVaultOwner();
        LibDMS._ping();
    }
}
