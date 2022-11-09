pragma solidity 0.8.4;

import {StorageLayout} from "../libraries/LibFactoryAppStorage.sol";
import {LibModuleRegistry} from "../libraries/LibModuleRegistry.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";

import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";

contract ModuleRegistryFacet is StorageLayout {
    function addModules(IModuleData.ModuleData[] calldata _modules, string[] calldata _names) external {
        LibModuleRegistry._addModules(_modules, _names);
    }

    function getModules(string[] calldata _names) external view returns (IModuleData.ModuleData[] memory modules_) {
        modules_ = LibModuleRegistry._getModules(_names);
    }

    function getModule(string calldata _name) external view returns (IModuleData.ModuleData memory module_) {
        module_ = LibModuleRegistry._getModule(_name);
    }

    function getFacetCuts(string memory _name) external view returns (IDiamondCut.FacetCut[] memory cuts_) {
        cuts_ = LibModuleRegistry._getFacetCuts(_name);
    }

    function moduleExists(string calldata _name) external view returns (bool exists_) {
        exists_ = LibModuleRegistry._moduleExists(_name);
    }
}
