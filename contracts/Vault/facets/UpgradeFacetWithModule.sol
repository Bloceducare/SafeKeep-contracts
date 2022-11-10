// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

/**
 * Module Upgarde facet.
 * /*****************************************************************************
 */

import "../libraries/LibUpgradeFacet.sol";
import {LibGuards} from "../libraries/LibGuards.sol";
import "../../VaultFactory/facets/ModuleUpgraderFacet.sol";
import {IVaultDiamond} from "../../interfaces/IVaultDiamond.sol";

contract UpgradeFacetWithModule {
    function upgradeModule(string memory _name) external {
        // LibGuards._onlyVaultOwner();
        ModuleUpgraderFacet(IVaultDiamond(address(this)).vaultFactoryDiamond())
            .upgradeVaultWithModule(_name, address(this));
        LibUpgradeFacetWithModule._upgradeModule(_name);
    }

    function downgradeModule(string memory _name) external {
        // LibGuards._onlyVaultOwner();
        ModuleUpgraderFacet(IVaultDiamond(address(this)).vaultFactoryDiamond())
            .downgradeVaultWithModule(_name, address(this));
        LibUpgradeFacetWithModule._downgradeModule(_name);
    }
}
