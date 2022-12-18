// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "forge-std/Test.sol";
import {IModuleData} from "../contracts/interfaces/IModuleData.sol";

import "../contracts/Vault/facets/ERC1155Facet.sol";
import "../contracts/Vault/facets/ERC20Facet.sol";
import "../contracts/Vault/facets/ERC721Facet.sol";
import "../contracts/Vault/facets/EtherFacet.sol";
import "../contracts/Vault/facets/OwnershipFacet.sol";

import "../contracts/Vault/facets/ModuleManagerFacet.sol";

import "../contracts/Vault/facets/DiamondCutFacet.sol";
import "../contracts/Vault/facets/DiamondLoupeFacet.sol";
import "../contracts/Vault/facets/DMSFacet.sol";
import "../contracts/VaultFactory/facets/VaultSpawnerFacet.sol";
import "../contracts/VaultFactory/facets/ModuleRegistryFacet.sol";

import "../contracts/VaultFactory/facets/DiamondCutFactoryFacet.sol";
import "../contracts/VaultFactory/facets/DiamondLoupeFactoryFacet.sol";
import "../contracts/Vault/VaultDiamond.sol";
import "../contracts/VaultFactory/VaultFactoryDiamond.sol";

import {ModuleAlreadyInstalled} from "../contracts/Vault/libraries/LibModuleUpgrades.sol";
import "./MockERC1155.sol";
import "./MockERC20.sol";
import "./MockERC721.sol";

import {IModuleData} from "../contracts/interfaces/IModuleData.sol";

contract DDeployments is Test {
    //Vault facet Addresss
    ERC1155Facet erc1155Facet;
    ERC721Facet erc721Facet;
    ERC20Facet erc20Facet;
    EtherFacet etherFacet;
    OwnershipFacet ownerFacet;
    // VaultFacet vFacet;
    DMSFacet switchFacet;

    //UpgradeVault facet
    ModuleManagerFacet managerFacet;
    // UpgradeFacetWithModule VUpgraderFacet;

    //Diamond script
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupeFacet;

    //factory
    VaultSpawnerFacet spawner;
    ModuleRegistryFacet registry;
    // ModuleUpgraderFacet FUpgradeFacet;
    VaultFactoryDiamond vFactoryDiamond;

    DiamondCutFactoryFacet dCutFactoryFacet;
    DiamondLoupeFactoryFacet dloupeFactoryFacet;

    //2 instances of eachMocktoken
    VaultERC1155Token erc1155t;
    VaultERC20Token erc20t;
    VaultERC721Token erc721t;

    VaultERC1155Token erc1155t2;
    VaultERC20Token erc20t2;
    VaultERC721Token erc721t2;

    address vault1;
    address vault1Owner;
    address vault1Inheritor1;
    address vault1Inheritor2;

    //Facet types tied to vaultAddresses
    ERC20Facet v1ERC20Facet;
    ERC721Facet v1ERC721Facet;
    ERC1155Facet v1ERC1155Facet;
    EtherFacet v1EtherFacet;
    DMSFacet v1dmsFacet;

    function setUp() public {
        //deploy mock tokens
        erc1155t = new VaultERC1155Token();
        erc20t = new VaultERC20Token();
        erc721t = new VaultERC721Token();

        //second tokens
        erc1155t2 = new VaultERC1155Token();
        erc20t2 = new VaultERC20Token();
        erc721t2 = new VaultERC721Token();

        //deploy Vault Token facets
        erc1155Facet = new ERC1155Facet();
        erc721Facet = new ERC721Facet();
        erc20Facet = new ERC20Facet();
        etherFacet = new EtherFacet();
        switchFacet = new DMSFacet();

        //selector facet
        dCutFacet = new DiamondCutFacet();
        dLoupeFacet = new DiamondLoupeFacet();
        ownerFacet = new OwnershipFacet();
        managerFacet = new ModuleManagerFacet();

        //deploy factory facets
        spawner = new VaultSpawnerFacet();
        registry = new ModuleRegistryFacet();
        dCutFactoryFacet = new DiamondCutFactoryFacet();
        dloupeFactoryFacet = new DiamondLoupeFactoryFacet();
        vm.label(address(this), "Factory Lord");
        vFactoryDiamond = new VaultFactoryDiamond(
            address(this),
            address(dCutFactoryFacet)
        );

        //upgrade factory diamond
        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](3);
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

        cut[2] = IDiamondCut.FacetCut({
            facetAddress: address(registry),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("ModuleRegistryFacet")
        });
        IDiamondCut(address(vFactoryDiamond)).diamondCut(cut, address(0), "");

        //upgrade Selector Module Vault diamond

        IDiamondCut.FacetCut[] memory selectorCut = new IDiamondCut.FacetCut[](
            4
        );
        selectorCut[0] = IDiamondCut.FacetCut({
            facetAddress: address(dCutFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondCutFacet")
        });
        selectorCut[1] = IDiamondCut.FacetCut({
            facetAddress: address(dLoupeFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("DiamondLoupeFacet")
        });

        selectorCut[2] = IDiamondCut.FacetCut({
            facetAddress: address(ownerFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("OwnershipFacet")
        });
        selectorCut[3] = IDiamondCut.FacetCut({
            facetAddress: address(managerFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("ModuleManagerFacet")
        });

        //upgrade Token Module Vault diamond

        IDiamondCut.FacetCut[] memory TokenCut = new IDiamondCut.FacetCut[](4);

        TokenCut[0] = IDiamondCut.FacetCut({
            facetAddress: address(erc20Facet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("ERC20Facet")
        });
        TokenCut[1] = IDiamondCut.FacetCut({
            facetAddress: address(erc721Facet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("ERC721Facet")
        });

        TokenCut[2] = IDiamondCut.FacetCut({
            facetAddress: address(erc1155Facet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("ERC1155Facet")
        });

        TokenCut[3] = IDiamondCut.FacetCut({
            facetAddress: address(etherFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("EtherFacet")
        });

        IModuleData.ModuleData[] memory data = new IModuleData.ModuleData[](2);
        data[0].facetData = selectorCut;
        data[1].facetData = TokenCut;

        string[] memory selectorName = new string[](2);
        selectorName[0] = "Selector";
        selectorName[1] = "Token";
        //Register Selector and Token Modules in Factory
        ModuleRegistryFacet(address(vFactoryDiamond)).addModules(data, selectorName);

        vault1Owner = mkaddr("vault1Owner");
        vault1Inheritor1 = mkaddr("vault1Inheritor1");
        vault1Inheritor2 = mkaddr("vault1Inheritor2");

        //make sure vault1Owner is tx.origin
        vm.prank(address(this), vault1Owner);
        vault1 = VaultSpawnerFacet(address(vFactoryDiamond)).createVault{value: 1 ether}(vault1Owner, 1e18);

        //Register DMS Module in factory diamond

        IDiamondCut.FacetCut[] memory DMSCut = new IDiamondCut.FacetCut[](1);
        DMSCut[0] = IDiamondCut.FacetCut({
            facetAddress: address(switchFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("DMSFacet")
        });

        IModuleData.ModuleData[] memory DMSdata = new IModuleData.ModuleData[](
            1
        );
        DMSdata[0].facetData = DMSCut;

        string[] memory DMSselectorName = new string[](1);
        DMSselectorName[0] = "DMS";

        ModuleRegistryFacet(address(vFactoryDiamond)).addModules(DMSdata, DMSselectorName);
        //upgrade DMS Module Vault diamond
        vm.prank(vault1Owner);
        ModuleManagerFacet(address(vault1)).upgradeVaultWithModule("DMS");

        //export contract types
        v1ERC20Facet = ERC20Facet(vault1);
        v1ERC721Facet = ERC721Facet(vault1);
        v1ERC1155Facet = ERC1155Facet(vault1);
        v1EtherFacet = EtherFacet(vault1);
        v1dmsFacet = DMSFacet(vault1);
        ownerFacet = OwnershipFacet(vault1);

        vm.prank(vault1Owner);
        v1dmsFacet.addInheritors(toSingletonAdd(vault1Inheritor1), toSingletonUINT(10000));
    }

    function testDefaultModules() public {
        // OwnershipFacet(address(vault1)).owner();

        vm.startPrank(vault1Owner);
        OwnershipFacet(address(vault1)).owner();

        // upgrade an already existing vault
        ModuleManagerFacet(address(vault1)).getActiveModules();
        vm.expectRevert(ModuleAlreadyInstalled.selector);
        ModuleManagerFacet(address(vault1)).upgradeVaultWithModule("Selector");

        // downgrade an already exosting vault
        ModuleManagerFacet(address(vault1)).downgradeVaultWithModule("Selector");
        // vm.stopPrank();
    }

    function testUpgradeModule() public {
        ModuleManagerFacet(address(vault1)).getActiveModules();
        ModuleManagerFacet(address(vault1)).isActiveModule("DMS");
    }

    function generateSelectors(string memory _facetName) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(uint160(uint256(keccak256(abi.encodePacked(name)))));
        vm.label(addr, name);
        return addr;
    }
}

function toSingletonUINT(uint256 _no) pure returns (uint256[] memory) {
    uint256[] memory arr = new uint256[](1);
    arr[0] = _no;
    return arr;
}

function toSingletonAdd(address _no) pure returns (address[] memory) {
    address[] memory arr = new address[](1);
    arr[0] = _no;
    return arr;
}

function toDualUINT(uint256 _no, uint256 _no2) pure returns (uint256[] memory) {
    uint256[] memory arr = new uint256[](2);
    arr[0] = _no;
    arr[1] = _no2;
    return arr;
}

function toDualAdd(address _no, address _no2) pure returns (address[] memory) {
    address[] memory arr = new address[](2);
    arr[0] = _no;
    arr[1] = _no2;
    return arr;
}

function toTriUINT(uint256 _no, uint256 _no2, uint256 _no3) pure returns (uint256[] memory) {
    uint256[] memory arr = new uint256[](3);
    arr[0] = _no;
    arr[1] = _no2;
    arr[2] = _no3;
    return arr;
}

function toTriAddress(address _add, address _add2, address _add3) pure returns (address[] memory) {
    address[] memory arr = new address[](3);
    arr[0] = _add;
    arr[1] = _add2;
    arr[2] = _add3;
    return arr;
}
