pragma solidity 0.8.4;

import "./DiamondDeployments.sol";
import "../contracts/Vault/libraries/LibDiamond.sol";
import {InsufficientTokens} from "../contracts/Vault/libraries/LibTokens.sol";
import "../contracts/Vault/libraries/LibDMS.sol";

contract ERC721FacetTest is DDeployments {
    address depositor1;

    function testERC721VaultOperations() public {
        depositor1 = mkaddr("depositor1");

        //mint some tokens to depositor1
        vm.startPrank(depositor1);
        //NFT 1
        erc721t.mint(depositor1, 0);
        erc721t.mint(depositor1, 1);
        erc721t.mint(depositor1, 2);
        erc721t.mint(depositor1, 3);

        //NFT 2
        erc721t2.mint(depositor1, 0);
        erc721t2.mint(depositor1, 1);
        erc721t2.mint(depositor1, 2);
        erc721t2.mint(depositor1, 3);

        //approve diamond to spend all tokens
        erc721t.setApprovalForAll(vault1, true);
        erc721t2.setApprovalForAll(vault1, true);

        // deposit multiple tokens
        v1ERC721Facet.depositERC721Tokens(address(erc721t), toTriUINT(0, 1, 2));
        v1ERC721Facet.depositERC721Tokens(address(erc721t2), toTriUINT(0, 1, 2));

        //confirm deposit
        assertEq(erc721t.balanceOf(vault1), 3);
        assertEq(erc721t2.balanceOf(vault1), 3);

        vm.stopPrank();
        vm.startPrank(vault1Owner);

        //     //ALLOCATIONS
        //     //trying to allocate a non existent token should not revert the whole txn
        v1dmsFacet.allocateERC721Tokens(address(erc721t), toSingletonAdd(vault1Inheritor1), toSingletonUINT(9));

        //     //trying to allocate a token not owned by the vault should not revert the whole txn
        v1dmsFacet.allocateERC721Tokens(
            address(erc721t), toDualAdd(vault1Inheritor1, vault1Inheritor1), toDualUINT(0, 3)
        );

        //     //confirm storage
        DMSFacet.AllocatedERC721Tokens[] memory vault1Inheritor1Alloc =
            v1dmsFacet.getAllocatedERC721Tokens(vault1Inheritor1);
        assertEq(vault1Inheritor1Alloc[0].token, address(erc721t));
        assertEq(vault1Inheritor1Alloc[0].tokenIDs[0], 0);

        //     //cannot withdraw an allocated NFT
        vm.expectRevert("UnAllocate Token First");
        v1ERC721Facet.withdrawERC721Token(address(erc721t), 0, vault1Owner);

        //     //add inheritor2
        v1dmsFacet.addInheritors(toSingletonAdd(vault1Inheritor2), toSingletonUINT(1000 wei));

        //     //can easily reallocate tokens to inheritor2
        v1dmsFacet.allocateERC721Tokens(address(erc721t), toSingletonAdd(vault1Inheritor2), toSingletonUINT(0));
        v1dmsFacet.allocateERC721Tokens(address(erc721t), toSingletonAdd(vault1Inheritor2), toSingletonUINT(0));

        //     //confirm storage
        DMSFacet.AllocatedERC721Tokens[] memory vault1Inheritor2Alloc =
            v1dmsFacet.getAllocatedERC721Tokens(vault1Inheritor2);
        assertEq(vault1Inheritor2Alloc[0].token, address(erc721t));
        assertEq(vault1Inheritor2Alloc[0].tokenIDs[0], 0);

        //     //make sure token is unallocated from previous inheritor
        vault1Inheritor1Alloc = v1dmsFacet.getAllocatedERC721Tokens(vault1Inheritor1);
        assertEq(vault1Inheritor1Alloc.length, 0);

        //     //unallocate and withdraw
        v1dmsFacet.allocateERC721Tokens(address(erc721t), toSingletonAdd(address(0)), toSingletonUINT(0));
        assertEq(v1dmsFacet.getAllocatedERC721TokenIds(vault1Inheritor2, address(erc721t)).length, 0);
        //     //withdraw the token
        v1ERC721Facet.withdrawERC721Token(address(erc721t), 0, vault1Owner);
        //     //confirm ownership
        assertEq(erc721t.ownerOf(0), vault1Owner);

        //     //cannot allocate to non existent inheritor
        vm.expectRevert((LibDMS.NotInheritor.selector));
        v1dmsFacet.allocateERC721Tokens(address(erc721t2), toSingletonAdd(mkaddr("noninheritor")), toSingletonUINT(1));

        //     //mass allocate tokens
        v1dmsFacet.allocateERC721Tokens(
            address(erc721t2), toTriAddress(vault1Inheritor2, vault1Inheritor2, vault1Inheritor2), toTriUINT(0, 1, 2)
        );

        //     //double check storage
        vault1Inheritor2Alloc = v1dmsFacet.getAllocatedERC721Tokens(vault1Inheritor2);
        assertEq(vault1Inheritor2Alloc[0].tokenIDs.length, 3);
    }
}
