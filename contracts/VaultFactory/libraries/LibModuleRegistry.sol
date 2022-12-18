// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";
import "../../Vault/libraries/LibStorageBinder.sol";
import {LibFactoryDiamond} from "./LibFactoryDiamond.sol";
import {FactoryAppStorage, LibFactoryAppStorage} from "./LibFactoryAppStorage.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";

error ModuleExists(string moduleName);
error NonExistentModule(string moduleName);

library LibModuleRegistry {
    event ModuleAdded(string indexed _name, IModuleData.ModuleData _module);

    //allow Proxy Factory admin(multisig) to add modules to Module Registry
    /// @param _modules data to be registered
    /// @param _names of modules to be regustered
    function _addModules(IModuleData.ModuleData[] calldata _modules, string[] calldata _names) internal {
        assert(_modules.length == _names.length);
        LibFactoryDiamond.enforceIsContractOwner();
        FactoryAppStorage storage fs = LibFactoryAppStorage.factoryAppStorage();
        for (uint256 i = 0; i < _modules.length; i++) {
            IModuleData.ModuleData storage m = fs.masterModules[_names[i]];
            if (m.facetData.length > 0) revert ModuleExists(_names[i]);
            //add the modules to storage
            fs.masterModules[_names[i]] = _modules[i];
            emit ModuleAdded(_names[i], _modules[i]);
        }
    }
    //TODO: _removeModules

    /// @notice get the details of  modules
    function _getModules(string[] memory _names) internal view returns (IModuleData.ModuleData[] memory modules_) {
        modules_ = new IModuleData.ModuleData[](_names.length);
        for (uint256 i = 0; i < _names.length; i++) {
            modules_[i] = _getModule(_names[i]);
        }
    }

    /// @notice checks for details of a specific module
    /// reverrts if module does not exist
    function _getModule(string memory _name) internal view returns (IModuleData.ModuleData memory module_) {
        FactoryAppStorage storage fs = LibFactoryAppStorage.factoryAppStorage();
        IModuleData.ModuleData storage m = fs.masterModules[_name];
        if (m.facetData.length == 0) revert NonExistentModule(_name);
        module_ = m;
    }

    /// @notice returns the facet cuts attached to a module
    /// reverts if module parsed in with _name does not exist
    function _getFacetCuts(string memory _name) internal view returns (IDiamondCut.FacetCut[] memory cuts_) {
        FactoryAppStorage storage fs = LibFactoryAppStorage.factoryAppStorage();
        IModuleData.ModuleData storage m = fs.masterModules[_name];
        if (m.facetData.length == 0) revert NonExistentModule(_name);
        cuts_ = fs.masterModules[_name].facetData;
    }

    /// @notice checks if a module exist, returns false if its not available
    function _moduleExists(string memory _name) internal view returns (bool exists_) {
        FactoryAppStorage storage fs = LibFactoryAppStorage.factoryAppStorage();
        IModuleData.ModuleData storage m = fs.masterModules[_name];
        if (m.facetData.length > 0) exists_ = true;
    }
}
