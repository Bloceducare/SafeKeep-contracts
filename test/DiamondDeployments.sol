
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "forge-std/Test.sol";
import "../contracts/Vault/facets/ERC1155Facet.sol";
import "../contracts/Vault/facets/ERC20Facet.sol";
import "../contracts/Vault/facets/ERC721Facet.sol";
import "../contracts/Vault/facets/DiamondCutFacet.sol";
import "../contracts/Vault/facets/DiamondLoupeFacet.sol";
import "../contracts/Vault/facets/VaultFacet.sol";
import "../contracts/VaultFactory/facets/VaultSpawnerFacet.sol";
import "../contracts/VaultFactory/facets/DiamondCutFactoryFacet.sol";
import "../contracts/VaultFactory/facets/DiamondLoupeFactoryFacet.sol";
import "../contracts/Vault/VaultDiamond.sol";
import "../contracts/VaultFactory/VaultFactoryDiamond.sol";
//import "../contracts/Vault/facets/DiamondCutFacet.sol";
//import "../contracts/Vault/facets/DiamondLoupeFacet.sol";
import "./MockERC1155.sol";
 import "./MockERC20.sol";
 import "./MockERC721.sol";


contract DDeployments is Test,IDiamondCut {
//separate script to deploy all diamonds and expose them for interaction

ERC1155Facet erc1155Facet;
ERC721Facet erc721Facet;
ERC20Facet erc20Facet;
VaultSpawnerFacet spawner;
VaultFacet vFacet;
//VaultDiamond VDiamond;
VaultFactoryDiamond vFactoryDiamond;
DiamondCutFacet dCutFacet;
DiamondLoupeFacet dLoupeFacet;

DiamondCutFactoryFacet dCutFactoryFacet;
DiamondLoupeFactoryFacet dloupeFactoryFacet;

VaultERC1155Token erc1155t;
VaultERC20Token erc20t;
VaultERC721Token erc721t;




function testdeployAllContracts() public{
    vm.label(tx.origin,"VaultOwner1");
    //deploy Vault facets
erc1155Facet=new ERC1155Facet();
erc721Facet=new ERC721Facet();
erc20Facet=new ERC20Facet();
vFacet=new VaultFacet();
dCutFacet=new DiamondCutFacet();
dLoupeFacet=new DiamondLoupeFacet();

//deploy factory facets
spawner=new VaultSpawnerFacet();
dCutFactoryFacet=new DiamondCutFactoryFacet();
dloupeFactoryFacet=new DiamondLoupeFactoryFacet();
vm.label(address(this),"Factory Lord");
vFactoryDiamond=new VaultFactoryDiamond(address(this),address(dCutFactoryFacet));

//deploy mock tokens
erc1155t=new VaultERC1155Token();
erc20t=new VaultERC20Token();
erc721t=new VaultERC721Token();

//upgrade factory diamond
IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](2);
    cut[0] = IDiamondCut.FacetCut({
      facetAddress: address(spawner),
      action: IDiamondCut.FacetCutAction.Add,
      functionSelectors: generateSelectors("VaultSpawnerFacet")
    });
     cut[1] = IDiamondCut.FacetCut({
      facetAddress: address(dloupeFactoryFacet),
      action: IDiamondCut.FacetCutAction.Add,
      functionSelectors: generateSelectors("DiamondLoupeFactoryFacet")
    });
    IDiamondCut(address(vFactoryDiamond)).diamondCut(cut, address(0), "");

    //add facet addresses and selectors to Appstorage
    address[] memory vaultFacetAddresses=new address[](6);
    vaultFacetAddresses[0]=address(dCutFacet);
     vaultFacetAddresses[1]=address(erc20Facet);
      vaultFacetAddresses[2]=address(erc721Facet);
       vaultFacetAddresses[3]=address(erc1155Facet);
        vaultFacetAddresses[4]=address(dLoupeFacet);
         vaultFacetAddresses[5]=address(vFacet);

    vFactoryDiamond.setAddresses(vaultFacetAddresses);

    //set selectors
    bytes4[][] memory _selectors=new bytes4[][](5);
_selectors[0]=generateSelectors("ERC20Facet");
_selectors[1]=generateSelectors("ERC721Facet");
_selectors[2]=generateSelectors("ERC1155Facet");
_selectors[3]=generateSelectors("DiamondLoupeFacet");
_selectors[4]=generateSelectors("VaultFacet");
vFactoryDiamond.setSelectors(_selectors);

//try to create a vault
address s=mkaddr("ann");


vm.startPrank(tx.origin);
address newVaault=VaultSpawnerFacet(address(vFactoryDiamond)).createVault{value: 1 ether}(toSingletonAdd(s),toSingletonUINT(10000),1e18,mkaddr("lucky guy"));


erc20t.approve(newVaault,10000000000000);
//run a function on the new vault

erc20t.balanceOf(msg.sender);

ERC20Facet(newVaault).depositERC20Token(address(erc20t),1000000);
VaultFacet(newVaault).inspectVault();
vm.stopPrank();
  }
  //mint tokens to tx.origin



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

    function mkaddr(string memory name) public returns (address){
        address addr=address(uint160(uint256(keccak256(abi.encodePacked(name)))));
        vm.label(addr,name);
        return addr;
    }

      function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC1155TokenReceiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC1155TokenReceiver.onERC1155BatchReceived.selector;
    }

      function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }


    function toSingletonUINT(uint256 _no)
        private
        pure
        returns (uint256[] memory)
    {
        uint256[] memory arr = new uint256[](1);
        arr[0] = _no;
        return arr;
    }

    function toSingletonAdd(address _no)
        private
        pure
        returns (address[] memory)
    {
        address[] memory arr = new address[](1);
        arr[0] = _no;
        return arr;
    }

}

