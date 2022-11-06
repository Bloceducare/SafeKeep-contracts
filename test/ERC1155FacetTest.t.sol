pragma solidity 0.8.4;

import "./DiamondDeployments.sol";

import "../contracts/Vault/libraries/LibDMS.sol";
import "../contracts/Vault/facets/ERC1155Facet.sol";


contract ERC1155FacetTest is DDeployments{
address depositor1;

function testERC1155VaultOperations() public{
depositor1=mkaddr('depositor1');

//mint some tokens to depositor1
vm.startPrank(depositor1);
//NFT 1
erc1155t.mint(depositor1,0,2);
erc1155t.mint(depositor1,1,2);
erc1155t.mint(depositor1,2,2);
erc1155t.mint(depositor1,3,2);

//NFT 2
erc1155t2.mint(depositor1,0,2);
erc1155t2.mint(depositor1,1,2);
erc1155t2.mint(depositor1,2,2);
erc1155t2.mint(depositor1,3,2);


//approve diamond to spend all tokens
erc1155t.setApprovalForAll(vault1,true);
erc1155t2.setApprovalForAll(vault1,true);

//deposit NFTs singlularly
v1ERC1155Facet.depositERC1155Token(address(erc1155t),0,2);
v1ERC1155Facet.depositERC1155Token(address(erc1155t2),0,2);

//batch deposit
//make sure a failure does not reverts the whole txn
vm.expectRevert(stdError.arithmeticError
);
v1ERC1155Facet.batchDepositERC1155Tokens(address(erc1155t),toTriUINT(1,2,3),toTriUINT(2,2,5));


//deposit tokens normally
v1ERC1155Facet.batchDepositERC1155Tokens(address(erc1155t),toTriUINT(1,2,3),toTriUINT(2,2,2));
v1ERC1155Facet.batchDepositERC1155Tokens(address(erc1155t2),toTriUINT(1,2,3),toTriUINT(2,2,2));

vm.stopPrank();

vm.startPrank(vault1Owner);

///ALLOCATIONS
//try to allocate a token with overflowing balance
vm.expectRevert(abi.encodeWithSelector(LibDMS.TokenAllocationOverflow.selector,address(erc1155t),1));
v1VaultFacet.allocateERC1155Tokens(address(erc1155t),toDualAdd(vault1Inheritor1,vault1Inheritor2),toDualUINT(0,1),toDualUINT(3,3));

//add inheritor2
v1VaultFacet.addInheritors(toSingletonAdd(vault1Inheritor2),toSingletonUINT(1000 wei));

//allocate normally
//allocating id 0 and 1
v1VaultFacet.allocateERC1155Tokens(address(erc1155t),toDualAdd(vault1Inheritor1,vault1Inheritor2),toDualUINT(0,1),toDualUINT(2,2));
v1VaultFacet.allocateERC1155Tokens(address(erc1155t2),toDualAdd(vault1Inheritor1,vault1Inheritor2),toDualUINT(0,1),toDualUINT(2,2));


//allocating id 2 and 3
v1VaultFacet.allocateERC1155Tokens(address(erc1155t),toDualAdd(vault1Inheritor1,vault1Inheritor2),toDualUINT(2,3),toDualUINT(2,2));
v1VaultFacet.allocateERC1155Tokens(address(erc1155t2),toDualAdd(vault1Inheritor1,vault1Inheritor2),toDualUINT(2,3),toDualUINT(2,2));

//confirm storage
ERC1155Facet.AllAllocatedERC1155Tokens[] memory inheritor1Allocs=v1ERC1155Facet.getAllAllocatedERC1155Tokens(vault1Inheritor1);
ERC1155Facet.AllAllocatedERC1155Tokens[] memory inheritor2Allocs=v1ERC1155Facet.getAllAllocatedERC1155Tokens(vault1Inheritor2);

//2 tokens allocated
assertEq(inheritor2Allocs.length,2);

//cannot withdraw allocated tokens
vm.expectRevert('UnAllocate TokensFirst');
v1ERC1155Facet.withdrawERC1155Token(address(erc1155t2),3,2,depositor1);

//make sure unallocation removes address completely
//completely unallocating tokenID 3 from inheritor2
v1VaultFacet.allocateERC1155Tokens(address(erc1155t2),toSingletonAdd(vault1Inheritor2),toSingletonUINT(3),toSingletonUINT(0));
 inheritor2Allocs=v1ERC1155Facet.getAllAllocatedERC1155Tokens(vault1Inheritor2);
 assertEq(inheritor2Allocs.length,1);

//can successfully withdraw now
v1ERC1155Facet.withdrawERC1155Token(address(erc1155t2),3,2,depositor1);


}

}