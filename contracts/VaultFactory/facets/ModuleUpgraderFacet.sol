
// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {StorageLayout} from "../libraries/LibFactoryAppStorage.sol";
import {LibModuleUpgrades} from "../libraries/LibModuleUpgrades.sol";

//Modules are atomic upgrades made to existing vaults 
//They consist of at least 1 facet,1 master storage layout and a master slot position
contract ModuleUpgraderFacet is StorageLayout{

function upgradeVaultWithModule(string calldata _moduleName,address _vault) external{
    //do create3 checks here
    //upgrade vault
LibModuleUpgrades._upgradeVaultWithModule(_moduleName,_vault);
}

function downgradeVaultWithModule(string calldata _moduleName,address _vault) external{
    //do create3 checks here
    //upgrade vault
LibModuleUpgrades._downgradeVaultWithModule(_moduleName,_vault);
}

}