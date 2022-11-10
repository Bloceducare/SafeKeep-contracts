// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/**
 * Module Upgarde library.
 * /*****************************************************************************
 */

import {FacetAndSelectorData, DMSData} from "./LibLayoutSilo.sol";

import {LibStorageBinder} from "./LibStorageBinder.sol";

library LibUpgradeFacetWithModule {
    function _upgradeModule(string memory _name) internal {
        //set module installation record to true
        FacetAndSelectorData storage fsData = LibStorageBinder
            ._bindAndReturnFacetStorage();
        fsData.activeModule[_name] = true;
        fsData.activeModules.push(_name);
    }

    function _downgradeModule(string memory _name) internal {
        //set module installation record to true
        FacetAndSelectorData storage fsData = LibStorageBinder
            ._bindAndReturnFacetStorage();
        fsData.activeModule[_name] = false;
        // fsData.activeModules.push(_name);
    }
}
