// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "../../interfaces/IDiamondCut.sol";
import "../../Vault/libraries/LibStorageBinder.sol";
import {LibFactoryDiamond} from "./LibFactoryDiamond.sol";
import {FactoryAppStorage, LibFactoryAppStorage} from "./LibFactoryAppStorage.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";

error ModuleExists(string moduleName);

   
library LibModules {
     event ModuleAdded(string indexed _name,IModuleData.ModuleData _module);
    //allow Proxy Factory admin(multisig) to add modules to Module Registry
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
    //to-do _removeModules
}
