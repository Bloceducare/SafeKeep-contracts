pragma solidity 0.8.4;

import "./DiamondDeployments.sol";

contract ERC721FacetTest is DDeployments{


function testERC721DepositAndAllocations() public{

erc721t.approve(newVaault,0);
erc721t.approve(newVaault,1);
ERC721Facet(newVaault).depositERC721Token(address(erc721t),0);
ERC721Facet(newVaault).depositERC721Token(address(erc721t),1);
assertEq(erc721t.ownerOf(0),newVaault);

vm.startPrank(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38);
//allocate to wrong inheritor
vm.expectRevert(LibKeep.NotInheritor.selector);
VaultFacet(newVaault).allocateERC721Tokens(address(erc721t),toSingletonAdd(mkaddr('random guy')),toSingletonUINT(0));

//allocate to right inheritor
VaultFacet(newVaault).allocateERC721Tokens(address(erc721t),toSingletonAdd(mkaddr('ann')),toSingletonUINT(0));
VaultFacet(newVaault).allocateERC721Tokens(address(erc721t),toSingletonAdd(mkaddr('ann')),toSingletonUINT(1));
ERC721Facet(newVaault).getAllocatedERC721Tokens(mkaddr('ann'));
VaultFacet(newVaault).addInheritors(toSingletonAdd(mkaddr('ann1')),toSingletonUINT(0));

//make sure it can be allocated again to another inheritor
VaultFacet(newVaault).allocateERC721Tokens(address(erc721t),toSingletonAdd(mkaddr('ann1')),toSingletonUINT(0));

ERC721Facet(newVaault).getAllocatedERC721Tokens(mkaddr('ann'));
ERC721Facet(newVaault).getAllocatedERC721Tokens(mkaddr('ann1'));

}}