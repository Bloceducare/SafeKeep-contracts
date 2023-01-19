// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "../interfaces/IDiamondCut.sol";

interface IModuleData {
    event ModuleAdded(string indexed _name, ModuleData _module);

    struct ModuleData {
        //array of facet data
        IDiamondCut.FacetCut[] facetData;
        //storage location
        bytes32 slot;
        //keccak hash of facets involved
        uint256 timeAdded;
        //human readable names of facets involved in alphabetical order
        string[] facetNames;
    }
    /// @notice returns acive modules in a vault

    function getActiveModules() external view returns (string[] memory);
    /// @notice checks for the status of a module
    function isActiveModule(string memory _name) external view returns (bool exists_);
}
