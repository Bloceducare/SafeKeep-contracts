pragma solidity 0.8.4;

import {IModuleData} from "../interfaces/IModuleData.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";

interface IVaultFactory {
    /// @notice This is used to get the details of several  modules
    /// @param _names the name of the modules to be fetched
    function getModules(string[] memory _names) external view returns (IModuleData.ModuleData[] memory modules_);

    /// @notice used to get the details of a a single module
    /// @param _name of the module
    function getModule(string calldata _name) external view returns (IModuleData.ModuleData memory module_);

    /// @notice checks if a module exists
    /// @param _name the name of the module to be checked
    function moduleExists(string calldata _name) external view returns (bool exists_);

    /// @notice return the cuts associated with a facet
    /// @param _name of a facet
    function getFacetCuts(string memory _name) external view returns (IDiamondCut.FacetCut[] memory cuts_);
}
