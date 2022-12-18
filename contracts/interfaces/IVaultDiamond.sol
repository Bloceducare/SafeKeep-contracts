pragma solidity 0.8.4;

import "../interfaces/IModuleData.sol";

interface IVaultDiamond {
    function vaultFactoryDiamond() external view returns (address);

    //via delegatecall on diamond
    function vaultOwner() external view returns (address);
}
