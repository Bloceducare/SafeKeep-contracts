
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "forge-std/Test.sol";
import "../contracts/Vault/facets/ERC1155Facet.sol";
import "../contracts/Vault/facets/ERC20Facet.sol";
import "../contracts/Vault/facets/ERC721Facet.sol";
import "../contracts/Vault/facets/VaultFacet.sol";
import "../contracts/VaultFactory/facets/VaultSpawnerFacet.sol";
import "../contracts/VaultFactory/facets/DiamondCutFacet.sol";
import "../contracts/VaultFactory/facets/DiamondLoupeFacet.sol";
import "../contracts/Vault/VaultDiamond.sol";
import "../contracts/VaultFactory/VaultFactoryDiamond.sol";
//import "../contracts/Vault/facets/DiamondCutFacet.sol";
//import "../contracts/Vault/facets/DiamondLoupeFacet.sol";
// import "./MockERC1155.sol";
// import "./MockERC20.sol";
// import "./MockERC721.sol";


contract DDeployments is Test,IDiamondCut {
//separate script to deploy all diamonds and expose them for interaction

ERC1155Facet erc1155Facet;
ERC721Facet erc721Facet;
ERC20Facet erc20Facet;
VaultSpawnerFacet spawner;
VaultFacet vFacet;
VaultDiamond VDiamond;
VaultFactoryDiamond vFactoryDiamond;


function testdeployAllContracts() public{

}



   function generateSelectors(string memory _facetName)
        internal
        returns (bytes4[] memory selectors)
    {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}

}

