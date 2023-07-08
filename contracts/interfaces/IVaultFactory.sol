pragma solidity 0.8.4;

import {IModuleData} from "../interfaces/IModuleData.sol";
import {IDiamondCut} from "../interfaces/IDiamondCut.sol";

interface IVaultFactory {
    function getModules(string[] memory _names) external view returns (IModuleData.ModuleData[] memory modules_);
    function getModule(string calldata _name) external view returns (IModuleData.ModuleData memory module_);

    function moduleExists(string calldata _name) external view returns (bool exists_);
    function getFacetCuts(string memory _name) external view returns (IDiamondCut.FacetCut[] memory cuts_);
}
