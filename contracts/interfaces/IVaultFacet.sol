pragma solidity 0.8.4;

interface IVaultFacet {
    struct AllInheritorEtherAllocs {
        address inheritor;
        uint256 weiAlloc;
    }

    struct VaultInfo {
        address owner;
        uint256 weiBalance;
        uint256 lastPing;
        uint256 id;
        address backup;
        address[] inheritors;
    }

    event vaultCreated(
        address indexed owner, address indexed backup, uint256 indexed startingBalance, address[] inheritors
    );

    event EthDeposited(uint256 _amount, uint256 _vaultID);

    function addInheritors(address[] calldata _newInheritors, uint256[] calldata _weiShare) external;

    function transferBackup(address _newBackupAddress) external;
    function allEtherAllocations() external view returns (AllInheritorEtherAllocs[] memory eAllocs);
}
