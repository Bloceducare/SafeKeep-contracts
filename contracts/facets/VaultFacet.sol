pragma solidity 0.8.4;

import "../libraries/LibVaultStorage.sol";
import "../libraries/LibKeep.sol";

import "../libraries/LibTokens.sol";
import "../interfaces/IVaultFacet.sol";
import "../libraries/LibDiamond.sol";
import "../interfaces/IERC20.sol";

contract VaultFacet is IVaultFacet, StorageStead {
    error NotInheritor();
    error AmountMismatch();

    ///////////////////
    //VIEW FUNCTIONS//
    /////////////////

    function inspectVault() public view returns (VaultInfo memory info) {
        info.owner = vs.vaultOwner;
        info.weiBalance = address(this).balance;
        info.lastPing = vs.lastPing;
        info.id = vs.vaultID;
        info.backup = vs.backupAddress;
        info.inheritors = vs.inheritors;
    }

    function inheritorTokenAllocations(address _inheritor)
        public
        view
        returns (TokenAllocs[] memory tAllocs)
    {
        if (!Guards._anInheritor(_inheritor)) revert NotInheritor();
        uint256 count = vs.inheritorAllocatedTokens[_inheritor].length;
        if (count == 0) revert("No allocated tokens");
        tAllocs = new TokenAllocs[](count);
        for (uint256 i; i < count; i++) {
            address _t = vs.inheritorAllocatedTokens[_inheritor][i];
            tAllocs[i].amount = vs.inheritorTokenShares[_inheritor][_t];
            tAllocs[i].token = _t;
        }
    }

    function vaultOwner() public view returns (address) {
        return vs.vaultOwner;
    }

    function allEtherAllocations()
        public
        view
        returns (AllInheritorEtherAllocs[] memory eAllocs)
    {
        uint256 count = vs.inheritors.length;
        eAllocs = new AllInheritorEtherAllocs[](count);
        for (uint256 i; i < count; i++) {
            eAllocs[i].inheritor = vs.inheritors[i];
            eAllocs[i].weiAlloc = vs.inheritorWeishares[vs.inheritors[i]];
        }
    }

    function inheritorEtherAllocation(address _inheritor)
        public
        view
        returns (uint256 _allocatedEther)
    {
        if (!Guards._anInheritor(_inheritor)) revert NotInheritor();
        _allocatedEther = vs.inheritorWeishares[_inheritor];
    }

    function etherBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function tokenBalance(address _token) public view returns (uint256) {
        return IERC20(_token).balanceOf(address(this));
    }

    function inheritorTokenAllocation(address _inheritor, address _token)
        public
        view
        returns (uint256)
    {
        return vs.inheritorTokenShares[_inheritor][_token];
    }

    //////////////////////
    ///WRITE FUNCTIONS///
    ////////////////////
    //note: owner restriction is in external fns
    function addInheritors(
        address[] calldata _newInheritors,
        uint256[] calldata _weiShare
    ) external {
        Guards._onlyVaultOwner();
        LibKeep._addInheritors(_newInheritors, _weiShare);
    }

    function removeInheritors(address[] calldata _inheritors) external {
        Guards._onlyVaultOwner();
        LibKeep._removeInheritors(_inheritors);
    }

    function depositEther(uint256 _amount) external payable {
        if (_amount != msg.value) revert AmountMismatch();
        emit EthDeposited(_amount);
    }

    function withdrawEther(uint256 _amount, address _to) external {
        Guards._onlyVaultOwner();
        LibKeep._withdrawEth(_amount, _to);
    }

    function withdrawTokens(
        address[] calldata _tokenAdds,
        uint256[] calldata _amounts,
        address _to
    ) external {
        Guards._onlyVaultOwner();
        LibKeep._withdrawERC20Tokens(_tokenAdds, _amounts, _to);
    }

    function allocateEther(
        address[] calldata _inheritors,
        uint256[] calldata _ethShares
    ) external {
        Guards._onlyVaultOwner();
        LibKeep._allocateEther(_inheritors, _ethShares);
    }

    function allocateTokens(
        address token,
        address[] calldata _inheritors,
        uint256[] calldata _shares
    ) external {
        Guards._onlyVaultOwner();
        LibKeep._allocateTokens(token, _inheritors, _shares);
    }

    function depositTokens(
        address[] calldata _tokens,
        uint256[] calldata _amounts
    ) external {}
}
