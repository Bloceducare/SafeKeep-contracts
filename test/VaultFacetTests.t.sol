import "./DiamondDeployments.sol";

import "../contracts/Vault/libraries/LibKeep.sol";
import "../contracts/Vault/facets/VaultFacet.sol";

contract VaultFacetTest is DDeployments {
  function testVaultOperations() public {
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
    v1ERC20Facet.depositERC20Tokens(
      toSingletonAdd(address(erc20t)),
      toSingletonUINT(100e18)
    );

    v1ERC721Facet.depositERC721Tokens(address(erc721t), toSingletonUINT(0));

    v1ERC1155Facet.batchDepositERC1155Tokens(
      address(erc1155t),
      toSingletonUINT(0),
      toSingletonUINT(2)
    );
    vm.stopPrank();

    vm.startPrank(vault1Owner);
    //test inheritor addition and removal
    //add another inheritor
    v1VaultFacet.addInheritors(
      toSingletonAdd(vault1Inheritor2),
      toSingletonUINT(1000 wei)
    );
    VaultFacet.VaultInfo memory vInfo = v1VaultFacet.inspectVault();
    assertEq(vInfo.inheritors.length, 2);

    //cannot remove a non existent inheritor
    vm.expectRevert(LibKeep.NotInheritor.selector);
    v1VaultFacet.removeInheritors(toSingletonAdd(mkaddr("non-existent")));

    //allocate some erc20,erc721 and erc1155 tokens to an inheritor
    //erc20
    v1VaultFacet.allocateERC20Tokens(
      address(erc20t),
      toSingletonAdd(vault1Inheritor1),
      toSingletonUINT(100e18)
    );

    //erc721
    v1VaultFacet.allocateERC721Tokens(
      address(erc721t),
      toSingletonAdd(vault1Inheritor1),
      toSingletonUINT(0)
    );

    //erc1155
    v1VaultFacet.allocateERC1155Tokens(
      address(erc1155t),
      toSingletonAdd(vault1Inheritor1),
      toSingletonUINT(0),
      toSingletonUINT(2)
    );

    //confirm allocations
    v1ERC1155Facet.getAllAllocatedERC1155Tokens(vault1Inheritor1);
    v1ERC20Facet.getAllocatedERC20Tokens(vault1Inheritor1);
    v1ERC721Facet.getAllocatedERC721Tokens(vault1Inheritor1);

    v1VaultFacet.removeInheritors(toSingletonAdd(vault1Inheritor1));

    //re-confirm allocations
    assertEq(
      v1ERC1155Facet.getAllAllocatedERC1155Tokens(vault1Inheritor1).length,
      0
    );
    assertEq(v1ERC20Facet.getAllocatedERC20Tokens(vault1Inheritor1).length, 0);
    assertEq(
      v1ERC721Facet.getAllocatedERC721Tokens(vault1Inheritor1).length,
      0
    );

    vInfo = v1VaultFacet.inspectVault();
    assertEq(vInfo.inheritors.length, 1);

    //TESTS FOR OWNERSHIP TRANSFER AND BACKUP
    address newVault1Owner = mkaddr("NewVault1Owner");
    //transfer ownership to another address
    v1VaultFacet.transferOwnership(newVault1Owner);
    address newOwner = v1VaultFacet.vaultOwner();
    assertEq(newOwner, newVault1Owner);
    vm.stopPrank();
    vm.startPrank(newVault1Owner);

    //add inheritor1 again and allocate
    v1VaultFacet.addInheritors(
      toSingletonAdd(vault1Inheritor1),
      toSingletonUINT(10000000 wei)
    );

    //erc20
    v1VaultFacet.allocateERC20Tokens(
      address(erc20t),
      toSingletonAdd(vault1Inheritor1),
      toSingletonUINT(100e18)
    );

    //erc721
    v1VaultFacet.allocateERC721Tokens(
      address(erc721t),
      toSingletonAdd(vault1Inheritor1),
      toSingletonUINT(0)
    );

    //erc1155
    v1VaultFacet.allocateERC1155Tokens(
      address(erc1155t),
      toSingletonAdd(vault1Inheritor1),
      toSingletonUINT(0),
      toSingletonUINT(2)
    );

    vm.stopPrank();

    //attempt to claim
    vm.warp(block.timestamp + 190 days);
    vm.prank(vault1Inheritor1);
    v1VaultFacet.claimAllAllocations();
    //ALSO TEST BACKUP-OWNER RECLAMATION HERE
    vm.prank(vault1Backup);
    v1VaultFacet.claimOwnership(mkaddr("newBackup"));
    //There should be a timelock after reclamation before a backup can make vault changes
  }
}
//0x00a329c0648769a73afac7f9381e08fb43dbea72
