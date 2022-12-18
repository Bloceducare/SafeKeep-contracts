import "./DiamondDeployments.sol";

import "../contracts/Vault/libraries/LibDMS.sol";

contract DMSFacetTest is DDeployments {
    function testDMSOperations() public {
        address depositor1 = mkaddr("depositor1");
        //mint some tokens to depositor1
        vm.startPrank(depositor1);
        //mint and deposit all token types
        erc1155t.mint(depositor1, 0, 2);
        erc20t.mint(depositor1, 100e18);
        erc721t.mint(depositor1, 0);

        //approve
        erc1155t.setApprovalForAll(vault1, true);
        erc20t.approve(vault1, 10000e18);
        erc721t.setApprovalForAll(vault1, true);

        //deposit
        v1ERC20Facet.depositERC20Tokens(toSingletonAdd(address(erc20t)), toSingletonUINT(100e18));

        v1ERC721Facet.depositERC721Tokens(address(erc721t), toSingletonUINT(0));

        v1ERC1155Facet.batchDepositERC1155Tokens(address(erc1155t), toSingletonUINT(0), toSingletonUINT(2));

        vm.stopPrank();

        vm.startPrank(vault1Owner);
        //test inheritor addition and removal
        //add another inheritor
        v1dmsFacet.addInheritors(toSingletonAdd(vault1Inheritor2), toSingletonUINT(1000 wei));

        DMSFacet.VaultInfo memory vInfo = v1dmsFacet.inspectVault();
        assertEq(vInfo.inheritors.length, 2);

        //cannot remove a non existent inheritor
        vm.expectRevert(LibDMS.NotInheritor.selector);
        v1dmsFacet.removeInheritors(toSingletonAdd(mkaddr("non-existent")));

        //allocate some erc20,erc721 and erc1155 tokens to an inheritor
        //erc20
        v1dmsFacet.allocateERC20Tokens(address(erc20t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(100e18));

        // //erc721
        v1dmsFacet.allocateERC721Tokens(address(erc721t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(0));

        // //erc1155
        v1dmsFacet.allocateERC1155Tokens(
            address(erc1155t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(0), toSingletonUINT(2)
        );

        // //confirm allocations
        v1dmsFacet.getAllAllocatedERC1155Tokens(vault1Inheritor1);
        v1dmsFacet.getAllocatedERC20Tokens(vault1Inheritor1);
        v1dmsFacet.getAllocatedERC721Tokens(vault1Inheritor1);

        v1dmsFacet.removeInheritors(toSingletonAdd(vault1Inheritor1));

        //re-confirm allocations
        assertEq(v1dmsFacet.getAllAllocatedERC1155Tokens(vault1Inheritor1).length, 0);
        assertEq(v1dmsFacet.getAllocatedERC20Tokens(vault1Inheritor1).length, 0);
        assertEq(v1dmsFacet.getAllocatedERC721Tokens(vault1Inheritor1).length, 0);

        vInfo = v1dmsFacet.inspectVault();
        assertEq(vInfo.inheritors.length, 1);

        // //TESTS FOR OWNERSHIP TRANSFER AND BACKUP
        address newVault1Owner = mkaddr("NewVault1Owner");
        //transfer ownership to another address
        v1dmsFacet.transferOwnership(newVault1Owner);
        address newOwner = ownerFacet.owner();
        assertEq(newOwner, newVault1Owner);
        vm.stopPrank();
        vm.startPrank(newVault1Owner);

        // //add inheritor1 again and allocate
        v1dmsFacet.addInheritors(toSingletonAdd(vault1Inheritor1), toSingletonUINT(10000000 wei));

        // //erc20
        v1dmsFacet.allocateERC20Tokens(address(erc20t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(100e18));

        // //erc721
        v1dmsFacet.allocateERC721Tokens(address(erc721t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(0));

        // //erc1155
        v1dmsFacet.allocateERC1155Tokens(
            address(erc1155t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(0), toSingletonUINT(2)
        );

        vm.stopPrank();

        // //attempt to claim
        vm.warp(block.timestamp + 190 days);
        vm.prank(vault1Inheritor1);
        v1dmsFacet.claimAllAllocations();
        // //ALSO TEST BACKUP-OWNER RECLAMATION HERE
        // vm.prank(vault1Backup);
        // v1dmsFacet.claimOwnership(mkaddr("newBackup"));
        //There should be a timelock after reclamation before a backup can make vault changes
    }
}
