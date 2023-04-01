pragma solidity 0.8.4;
import {IModuleData} from "./IModuleData.sol";
import {IDiamondCut} from "./IDiamondCut.sol";

interface IModuleRegistryFacet {
    function addModules(
        IModuleData.ModuleData[] calldata _modules,
        string[] calldata _names
    ) external;

    function getModules(
        string[] calldata _names
    ) external view returns (IModuleData.ModuleData[] memory modules_);

    function getModule(
        string calldata _name
    ) external view returns (IModuleData.ModuleData memory module_);

    function getFacetCuts(
        string memory _name
    ) external view returns (IDiamondCut.FacetCut[] memory cuts_);

    function moduleExists(
        string calldata _name
    ) external view returns (bool exists_);
}
