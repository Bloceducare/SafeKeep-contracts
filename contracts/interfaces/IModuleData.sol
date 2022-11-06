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
        bytes32 fileHash;
        //human readable names of facets involved in alphabetical order
        string[] facetNames;
    }

    function getActiveModules() external view returns (string[] memory);
    function isActiveModule(string memory _name) external view returns (bool exists_);
}
