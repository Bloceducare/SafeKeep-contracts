// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {IDiamondCut} from "../../interfaces/IDiamondCut.sol";
import {LibStorageBinder} from "../../Vault/libraries/LibStorageBinder.sol";
import {IModuleData} from "../../interfaces/IModuleData.sol";
import {IVaultFactory} from "../../interfaces/IVaultFactory.sol";
import {FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";
import {LibDiamond} from "../libraries/LibDiamond.sol";
import {LibArrayHelpers} from "../libraries/LibArrayHelpers.sol";

error ModuleAlreadyInstalled();
error ModuleNotInstalled();

//basically allows vault owners to make atomic module upgrades to their vaults

library LibModuleUpgrades {
    /**
     * address _vault*
     */
    event VaultUpgraded(string indexed _moduleName);
    /**
     * address _vault*
     */
    event VaultDowngraded(string indexed _moduleName);

    function _upgradeVaultWithModule(string calldata _name) internal {
        LibDiamond.enforceIsContractOwner();
        //make sure this module doesn't currently exist in this vault
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (fsData.activeModule[_name]) revert ModuleAlreadyInstalled();
        //get facet data
        //no need to check for existence in registry as this will revert if it does not exist
        IDiamondCut.FacetCut[] memory facetData = IVaultFactory(LibDiamond.vaultFactory()).getFacetCuts(_name);
        //upgrade vault
        IDiamondCut(address(this)).diamondCut(facetData, address(0), "");

        fsData.activeModule[_name] = true;
        fsData.activeModules.push(_name);

        emit VaultUpgraded(_name);
        //consider gossiping this upgrade to vaultFactory
    }

    function _downgradeVaultWithModule(string calldata _name) internal {
        LibDiamond.enforceIsContractOwner();
        //make sure this module doesn't currently exist in this vault
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        if (!fsData.activeModule[_name]) revert ModuleNotInstalled();
        //get facet data
        //no need to check for existence in registry as this will revert if it does not exist
        IDiamondCut.FacetCut[] memory facetData = IVaultFactory(LibDiamond.vaultFactory()).getFacetCuts(_name);
        //upgrade vault
        //remove them
        for (uint256 i = 0; i < facetData.length; i++) {
            facetData[i].action = IDiamondCut.FacetCutAction.Remove;
            facetData[i].facetAddress = address(0);
        }
        //downgrade vault
        IDiamondCut(address(this)).diamondCut(facetData, address(0), "");
        fsData.activeModule[_name] = true;
        LibArrayHelpers.removeString(fsData.activeModules, _name);
        emit VaultDowngraded(_name);
        //consider gossiping this downgrade to vaultFactory
    }
}
