pragma solidity 0.8.4;

import "./DiamondDeployments.sol";

contract ERC721FacetTest is DDeployments {
  function testERC721DepositAndAllocations() public {
    erc721t.setApprovalForAll(newVaault, true);
    erc721t.approve(newVaault, 1);
    ERC721Facet(newVaault).depositERC721Token(address(erc721t), 0);
    ERC721Facet(newVaault).depositERC721Token(address(erc721t), 1);
    assertEq(erc721t.ownerOf(0), newVaault);

    vm.expectRevert(NoPermissions.selector);
    VaultFacet(newVaault).addInheritors(
      toSingletonAdd(mkaddr("invalid owner adding inheritor")),
      toSingletonUINT(0)
    );

    vm.startPrank(Vault1Owner);
    erc721t.setApprovalForAll(newVaault, true);

    // ERC721Facet(newVaault).depositERC721Token(address(erc721t), 3);

    assertEq(erc721t.ownerOf(3), newVaault);

    VaultFacet(newVaault).addInheritors(
      toSingletonAdd(mkaddr("valid owner adding inheritor")),
      toSingletonUINT(0)
    );

    VaultFacet(newVaault).allocateERC721Tokens(
      address(erc721t),
      toSingletonAdd(mkaddr("valid owner adding inheritor")),
      toSingletonUINT(3)
    );

    address[] memory _inheritors = VaultFacet(newVaault).getAllinheritors();
    assertEq(_inheritors.length, 2);

    //allocate to wrong inheritor
    vm.expectRevert(LibKeep.NotInheritor.selector);
    VaultFacet(newVaault).allocateERC721Tokens(
      address(erc721t),
      toSingletonAdd(mkaddr("random guy")),
      toSingletonUINT(0)
    );

    //allocate to right inheritor
    VaultFacet(newVaault).allocateERC721Tokens(
      address(erc721t),
      toSingletonAdd(mkaddr("ann")),
      toSingletonUINT(0)
    );
    VaultFacet(newVaault).allocateERC721Tokens(
      address(erc721t),
      toSingletonAdd(mkaddr("ann")),
      toSingletonUINT(1)
    );
    ERC721Facet(newVaault).getAllocatedERC721Tokens(mkaddr("ann"));
    VaultFacet(newVaault).addInheritors(
      toSingletonAdd(mkaddr("ann1")),
      toSingletonUINT(0)
    );

    //make sure it can be allocated again to another inheritor
    VaultFacet(newVaault).allocateERC721Tokens(
      address(erc721t),
      toSingletonAdd(mkaddr("ann1")),
      toSingletonUINT(0)
    );

    ERC721Facet(newVaault).getAllocatedERC721Tokens(mkaddr("ann"));
    ERC721Facet(newVaault).getAllocatedERC721Tokens(mkaddr("ann1"));

    address _vault1Owner = VaultFacet(newVaault).vaultOwner();
    assertEq(_vault1Owner, Vault1Owner);
    VaultFacet.VaultInfo memory _inspect = VaultFacet(newVaault).inspectVault();
    assertEq(_inspect.id, 0);

    vm.stopPrank();
  }
}
