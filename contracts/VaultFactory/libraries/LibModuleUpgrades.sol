// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";
import {LibStorageBinder} from "../../Vault/libraries/LibStorageBinder.sol";
//import {LibLayoutSilo} from "../../Vault/libraries/LibLayoutSilo.sol";
import {LibFactoryDiamond} from "./LibFactoryDiamond.sol";
import {FactoryAppStorage, LibFactoryAppStorage} from "./LibFactoryAppStorage.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";

error NonExistentModule();
error ModuleAlreadyAdded();
error ModuleAlreadyRemoved();
//basically allows vault owners to make atomic module upgrades to their vaults
library LibModuleUpgrades{
event VaultUpgraded(address _vault,string indexed _moduleName);
event VaultDowngraded(address _vault,string indexed _moduleName);
function _upgradeVaultWithModule(string calldata _name,address _vault) internal{
//first make sure this module exists in the onchain registry
FactoryAppStorage storage fs=LibFactoryAppStorage.factoryAppStorage();
if(fs.masterModules[_name].facetData.length==0) revert NonExistentModule();
//make sure this module hasn't been added to the vault before
if(IModuleData(_vault).isActiveModule(_name)) revert ModuleAlreadyAdded();
//get module details
IModuleData.ModuleData storage moduleData=fs.masterModules[_name];
IDiamondCut.FacetCut[] storage facetCut=moduleData.facetData;
//upgrade vault
IDiamondCut(_vault).diamondCut(facetCut,address(0),"");
emit VaultUpgraded(_vault,_name);
}

function _downgradeVaultWithModule(string calldata _name,address _vault) internal{
//first make sure this module exists in the onchain registry
FactoryAppStorage storage fs=LibFactoryAppStorage.factoryAppStorage();
if(fs.masterModules[_name].facetData.length==0) revert NonExistentModule();
//make sure this module has been added to the vault before
if(!IModuleData(_vault).isActiveModule(_name)) revert ModuleAlreadyRemoved();
//get module details
IModuleData.ModuleData storage moduleData=fs.masterModules[_name];
IDiamondCut.FacetCut[] storage facetCut=moduleData.facetData;
//remove them
for(uint256 i=0;i<facetCut.length;i++){
    facetCut[i].action=IDiamondCut.FacetCutAction.Remove;
}
//downgrade vault
IDiamondCut(_vault).diamondCut(facetCut,address(0),"");
emit VaultDowngraded(_vault,_name);
}

}