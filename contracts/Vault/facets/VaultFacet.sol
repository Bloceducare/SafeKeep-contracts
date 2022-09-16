pragma solidity 0.8.4;

import "../libraries/LibKeep.sol";

import "../libraries/LibTokens.sol";
import "../libraries/LibDiamond.sol";
import "../../interfaces/IERC20.sol";

import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibStorageBinder.sol";

contract VaultFacet {
    error AmountMismatch();

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

    event EthDeposited(uint256 _amount, uint256 _vaultID);

    function inspectVault() public view returns (VaultInfo memory info) {
        VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
        info.owner = vaultData.vaultOwner;
        info.weiBalance = address(this).balance;
        info.lastPing = vaultData.lastPing;
        info.id = vaultData.vaultID;
        info.backup = vaultData.backupAddress;
        info.inheritors = vaultData.inheritors;
    }

    function vaultOwner() public view returns (address) {
        VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
        return vaultData.vaultOwner;
    }

    function allEtherAllocations() public view returns (AllInheritorEtherAllocs[] memory eAllocs) {
        VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
        uint256 count = vaultData.inheritors.length;
        eAllocs = new AllInheritorEtherAllocs[](count);
        for (uint256 i; i < count; i++) {
            eAllocs[i].inheritor = vaultData.inheritors[i];
            eAllocs[i].weiAlloc = vaultData.inheritorWeishares[vaultData.inheritors[i]];
        }
    }

    function inheritorEtherAllocation(address _inheritor) public view returns (uint256 _allocatedEther) {
        VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
        if (!Guards._anInheritor(_inheritor)) {
            revert LibKeep.NotInheritor();
        }
        _allocatedEther = vaultData.inheritorWeishares[_inheritor];
    }

    function getAllocatedEther() public view returns (uint256) {
        return LibKeep.getCurrentAllocatedEth();
    }

    function getUnallocatedEther() public view returns (uint256 unallocated_) {
        uint256 currentBalance = address(this).balance;
        if (currentBalance > 0) {
            unallocated_ = currentBalance - LibKeep.getCurrentAllocatedEth();
        }
    }

    function etherBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //////////////////////
    ///WRITE FUNCTIONS///
    ////////////////////
    //note: owner restriction is in external fns
    function addInheritors(address[] calldata _newInheritors, uint256[] calldata _weiShare) external {
        Guards._onlyVaultOwnerOrOrigin();
        LibKeep._addInheritors(_newInheritors, _weiShare);
    }

    function removeInheritors(address[] calldata _inheritors) external {
        Guards._onlyVaultOwner();
        LibKeep._removeInheritors(_inheritors);
    }

    function depositEther(uint256 _amount) external payable {
        VaultData storage vaultData=LibStorageBinder._bindAndReturnVaultStorage();
        if (_amount != msg.value) {
            revert AmountMismatch();
        }
        emit EthDeposited(_amount, vaultData.vaultID);
    }

    function withdrawEther(uint256 _amount, address _to) external {
        Guards._onlyVaultOwner();
        LibKeep._withdrawEth(_amount, _to);
    }

    function allocateEther(address[] calldata _inheritors, uint256[] calldata _ethShares) external {
        Guards._onlyVaultOwner();
        LibKeep._allocateEther(_inheritors, _ethShares);
    }

    function allocateERC20Tokens(address token, address[] calldata _inheritors, uint256[] calldata _shares) external {
        Guards._onlyVaultOwner();
        LibKeep._allocateERC20Tokens(token, _inheritors, _shares);
    }

    function allocateERC721Tokens(address token, address[] calldata _inheritors, uint256[] calldata _tokenIDs)
        external
    {
        Guards._onlyVaultOwner();
        LibKeep._allocateERC721Tokens(token, _inheritors, _tokenIDs);
    }

    function allocateERC1155Tokens(
        address token,
        address[] calldata _inheritors,
        uint256[] calldata _tokenIDs,
        uint256[] calldata _amounts
    )
        external
    {
        Guards._onlyVaultOwner();
        LibKeep._allocateERC1155Tokens(token, _inheritors, _tokenIDs, _amounts);
    }

    function transferOwnership(address _newVaultOwner) public {
        Guards._onlyVaultOwner();
        LibKeep._transferOwnerShip(_newVaultOwner);
    }

    function transferBackup(address _newBackupAddress) public {
        Guards._onlyVaultOwnerOrOriginOrBackup();
        LibKeep._transferBackup(_newBackupAddress);
    }

    function claimOwnership(address _newBackupAddress) public {
        Guards._enforceIsBackupAddress();
        LibKeep._claimOwnership(_newBackupAddress);
    }

    function claimAllAllocations() external {
        LibKeep._claimAll();
    }

    function ping() external {
        Guards._onlyVaultOwner();
        LibKeep._ping();
    }
}
