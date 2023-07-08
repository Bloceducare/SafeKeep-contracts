pragma solidity 0.8.4;

import "./DiamondDeployments.sol";

contract ModuleTests is DDeployments {
    function testDefaultModules() public {
        // OwnershipFacet(address(vault1)).owner();

        vm.startPrank(vault1Owner);
        OwnershipFacet(address(vault1)).owner();

        // upgrade an already existing vault
        ModuleManagerFacet(address(vault1)).getActiveModules();
        vm.expectRevert(ModuleAlreadyInstalled.selector);
        ModuleManagerFacet(address(vault1)).upgradeVaultWithModule("Selector");

        // downgrade an already existing vault
        ModuleManagerFacet(address(vault1)).downgradeVaultWithModule("Selector");
    }
}
