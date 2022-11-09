pragma solidity 0.8.4;

import "../libraries/LibStorageBinder.sol";
import "../libraries/LibLayoutSilo.sol";
import "../libraries/LibModuleUpgrades.sol";

contract ModuleManagerFacet {
    function getActiveModules() external view returns (string[] memory) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        return fsData.activeModules;
    }

    function isActiveModule(string memory _name) external view returns (bool exists_) {
        FacetAndSelectorData storage fsData = LibStorageBinder._bindAndReturnFacetStorage();
        exists_ = fsData.activeModule[_name];
    }

    //upgrade

    function upgradeVaultWithModule(string calldata _name) external {
        LibModuleUpgrades._upgradeVaultWithModule(_name);
    }

    //downgrade
    function downgradeVaultWithModule(string calldata _name) external {
        LibModuleUpgrades._downgradeVaultWithModule(_name);
    }
}
