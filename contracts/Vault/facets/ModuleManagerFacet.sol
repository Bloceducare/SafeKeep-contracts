pragma solidity 0.8.4;

import "../libraries/LibStorageBinder.sol";
import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibModuleUpgrades.sol";

contract ModuleManagerFacet {
    /// @notice returns the active modules in the vault
    function getActiveModules() external view returns (string[] memory) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        return fsData.activeModules;
    }

    /// @notice checks if a module is active in vault
    function isActiveModule(string memory _name) external view returns (bool exists_) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        exists_ = fsData.activeModule[_name];
    }

    //upgrade
    /// @notice allows vaul to be upgraded with a module
    function upgradeVaultWithModule(string calldata _name) external {
        LibModuleUpgrades._upgradeVaultWithModule(_name);
    }

    //downgrade
    /// @notice allows vault to be downgraded by removing a module
    function downgradeVaultWithModule(string calldata _name) external {
        LibModuleUpgrades._downgradeVaultWithModule(_name);
    }
}
