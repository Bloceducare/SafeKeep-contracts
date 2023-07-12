// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "forge-std/Script.sol";
import "../contracts/VaultFactory/facets/VaultSpawnerFacet.sol";
import "../contracts/VaultFactory/facets/ModuleRegistryFacet.sol";

import "../contracts/VaultFactory/facets/DiamondCutFactoryFacet.sol";
import "../contracts/VaultFactory/facets/DiamondLoupeFactoryFacet.sol";

import "../contracts/VaultFactory/VaultFactoryDiamond.sol";

//vaults

import "../contracts/Vault/facets/ERC20Facet.sol";
import "../contracts/Vault/facets/ERC721Facet.sol";
import "../contracts/Vault/facets/EtherFacet.sol";
import "../contracts/Vault/facets/OwnershipFacet.sol";

import "../contracts/Vault/facets/CoreFacet.sol";

import "../contracts/Vault/facets/ModuleManagerFacet.sol";

import "../contracts/Vault/facets/DiamondCutFacet.sol";
import "../contracts/Vault/facets/DiamondLoupeFacet.sol";
import "../contracts/Vault/facets/DMSFacet.sol";

contract DDeploymentScript is Script {
    //factory
    VaultSpawnerFacet spawner;
    ModuleRegistryFacet registry;
    // ModuleUpgraderFacet FUpgradeFacet;
    VaultFactoryDiamond vFactoryDiamond;

    DiamondCutFactoryFacet dCutFactoryFacet;
    DiamondLoupeFactoryFacet dloupeFactoryFacet;

    //Vault facet Addresss
    ERC1155Facet erc1155Facet;
    ERC721Facet erc721Facet;
    ERC20Facet erc20Facet;
    EtherFacet etherFacet;
    OwnershipFacet ownerFacet;
    CoreFacet coreFacet;
    // VaultFacet vFacet;
    DMSFacet switchFacet;

    //UpgradeVault facet
    ModuleManagerFacet managerFacet;
    // UpgradeFacetWithModule VUpgraderFacet;

    //Diamond script
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupeFacet;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("SECRET");
        address owner = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);
        // anvil_setBalance(owner, 200 ether);

        //deploy factory facets
        spawner = new VaultSpawnerFacet();
        registry = new ModuleRegistryFacet();
        dCutFactoryFacet = new DiamondCutFactoryFacet();
        dloupeFactoryFacet = new DiamondLoupeFactoryFacet();

        vFactoryDiamond = new VaultFactoryDiamond(owner, address(dCutFactoryFacet));

        //deploy Vault Token facets
        erc1155Facet = new ERC1155Facet();
        erc721Facet = new ERC721Facet();
        erc20Facet = new ERC20Facet();
        etherFacet = new EtherFacet();
        switchFacet = new DMSFacet();
        coreFacet = new CoreFacet();

        //selector facet
        dCutFacet = new DiamondCutFacet();
        dLoupeFacet = new DiamondLoupeFacet();
        ownerFacet = new OwnershipFacet();
        managerFacet = new ModuleManagerFacet();

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

        IDiamondCut.FacetCut[] memory selectorCut = new IDiamondCut.FacetCut[](4);
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

        IDiamondCut.FacetCut[] memory TokenCut = new IDiamondCut.FacetCut[](5);

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
        TokenCut[4] = IDiamondCut.FacetCut({
            facetAddress: address(coreFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("CoreFacet")
        });

        IModuleData.ModuleData[] memory data = new IModuleData.ModuleData[](2);
        data[0].facetData = selectorCut;
        data[1].facetData = TokenCut;

        string[] memory selectorName = new string[](2);
        selectorName[0] = "Selector";
        selectorName[1] = "Token";
        //Register Selector and Token Modules in Factory
        ModuleRegistryFacet(address(vFactoryDiamond)).addModules(data, selectorName);
        //Register DMS Module in factory diamond

        IDiamondCut.FacetCut[] memory DMSCut = new IDiamondCut.FacetCut[](1);
        DMSCut[0] = IDiamondCut.FacetCut({
            facetAddress: address(switchFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: generateSelectors("DMSFacet")
        });

        IModuleData.ModuleData[] memory DMSdata = new IModuleData.ModuleData[](1);
        DMSdata[0].facetData = DMSCut;

        string[] memory DMSselectorName = new string[](1);
        DMSselectorName[0] = "DMS";

        ModuleRegistryFacet(address(vFactoryDiamond)).addModules(DMSdata, DMSselectorName);
        vm.stopBroadcast();
    }

    function generateSelectors(string memory _facetName) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }
}
