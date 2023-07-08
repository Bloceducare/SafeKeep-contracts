pragma solidity 0.8.4;

interface IVaultSpawnerFacet {
    function createVault(
        address _vaultOwner,
        uint256 _startingBal,
        address _backupAddress,
        uint256 _backupDelay
    ) external payable returns (address addr);
}
