pragma solidity 0.8.4;

interface IVaultDiamond {
    function vaultFactoryDiamond() external view returns(address);

    //via delegatecall on diamond
    function vaultOwner() external view returns (address);

    function tempOwner() external view returns (address owner_);
}
