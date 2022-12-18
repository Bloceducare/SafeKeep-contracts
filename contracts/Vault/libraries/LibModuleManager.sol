pragma solidity 0.8.4;

import {FacetAndSelectorData} from "../libraries/LibLayoutSilo.sol";
import {LibStorageBinder} from "../libraries/LibStorageBinder.sol";

library LibModuleManager {
    /// @notice checks if the module parsed in with _name is active 
    function _isActiveModule(string memory _name) internal view returns (bool active_) {
        FacetAndSelectorData storage fs = LibStorageBinder._bindAndReturnFacetStorage();
        active_ = fs.activeModule[_name];
    }
}
