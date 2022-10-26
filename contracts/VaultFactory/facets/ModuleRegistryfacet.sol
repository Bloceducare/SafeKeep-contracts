pragma solidity 0.8.4;

import {StorageLayout} from "../libraries/LibFactoryAppStorage.sol";
import {LibModuleRegistry} from "../libraries/LibModuleRegistry.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";

contract ModuleRegistryFacet is StorageLayout{


 function addModules(IModuleData.ModuleData[] calldata _modules, string[] calldata _names) external{
    LibModuleRegistry._addModules(_modules,_names);
 }  
}