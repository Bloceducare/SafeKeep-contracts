pragma solidity 0.8.4;

interface ICoreFacet {
    struct Vault {
        address vaultOwner;
        address backupAddress;
        uint256 vaultID;
        uint256 lastPing;
        uint256 pingWindow;
        string[] modules;
    }

    function ping() external;

    function transferBackup(address _newBackupAddress) external;

    function transferOwnership(address _newVaultOwner) external;

    function claimOwnership(address _newBackupAddress) external;

    function execute(address _target, bytes memory _data) external payable;

    function getVault() external view returns (Vault memory vault_);
}
