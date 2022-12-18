pragma solidity 0.8.4;

import {StorageLayout} from "../libraries/LibFactoryAppStorage.sol";
import {LibModuleRegistry} from "../libraries/LibModuleRegistry.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";

import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";

contract ModuleRegistryFacet is StorageLayout {
    /// @notice add modules to the registry
    /// @param _modules to be added
    /// @param _names of modules
    function addModules(IModuleData.ModuleData[] calldata _modules, string[] calldata _names) external {
        LibModuleRegistry._addModules(_modules, _names);
    }

    /// @notice returns the details multiple modules stored in the registry
    function getModules(string[] calldata _names) external view returns (IModuleData.ModuleData[] memory modules_) {
        modules_ = LibModuleRegistry._getModules(_names);
    }

    /// @notice gets the details of a specific module from regigistry
    function getModule(string calldata _name) external view returns (IModuleData.ModuleData memory module_) {
        module_ = LibModuleRegistry._getModule(_name);
    }
    /// @dev returns the facet cuts attached to a module

    function getFacetCuts(string memory _name) external view returns (IDiamondCut.FacetCut[] memory cuts_) {
        cuts_ = LibModuleRegistry._getFacetCuts(_name);
    }

    /// Checks if a module extist, returns false if module is not found
    function moduleExists(string calldata _name) external view returns (bool exists_) {
        exists_ = LibModuleRegistry._moduleExists(_name);
    }
}
