// pragma solidity 0.8.4;

// import "./DiamondDeployments.sol";

// contract ERC20FacetTest is DDeployments {
//   function testERC20tokens() public {
//     //approve the vault to spend ERC20
//     erc20t.approve(newVaault, 1000000e18);
//     ERC20Facet(newVaault).depositERC20Token(address(erc20t), 1e18);

//     //checkbalance is exactly the amount sent to the vault
//     assertEq(erc20t.balanceOf(address(newVaault)), 1e18);

//     //prank the owner of the vault
//     vm.startPrank(Vault1Owner);
//     //allocate erc20 to wrong inheritor and expect it to revert
//     vm.expectRevert(LibKeep.NotInheritor.selector);
//     VaultFacet(newVaault).allocateERC20Tokens(
//       address(erc20t),
//       toSingletonAdd(mkaddr("er20inheritor")),
//       toSingletonUINT(0)
//     );

//     //add a new inheritor
//     VaultFacet(newVaault).addInheritors(
//       toSingletonAdd(mkaddr("erc20inheritor")),
//       toSingletonUINT(0)
//     );

//     //add a previously added inheritor and expect revert
//     vm.expectRevert(LibKeep.ActiveInheritor.selector);
//     VaultFacet(newVaault).addInheritors(
//       toSingletonAdd(mkaddr("erc20inheritor")),
//       toSingletonUINT(0)
//     );

//     //allocate erc20 to right inheritor and check the balance of total amount allocated
//     VaultFacet(newVaault).allocateERC20Tokens(
//       address(erc20t),
//       toSingletonAdd(mkaddr("ann")),
//       toSingletonUINT(1e18)
//     );
//     uint256 allocERC20 = VaultFacet(newVaault).allTokenAllocations(
//       address(erc20t)
//     );
//     assertEq(allocERC20, 1e18);

//     VaultFacet.AllInheritorEtherAllocs[] memory allocEther = VaultFacet(
//       newVaault
//     ).allEtherAllocations();
//     assertEq(allocEther[0].inheritor, mkaddr("ann"));
//     assertEq(allocEther[0].weiAlloc, 10000);

//     //deposit 19 ethers plus the 1 ether deposited  in the setup to make a total of 20 ethers in the vault

//     vm.deal(Vault1Owner, 19 ether);
//     //deposit 19 ethers plus the 1 ether deposited  in the setup to make a total of 20 ethers in the vault
//     VaultFacet(newVaault).depositEther{ value: 19 ether }(19 ether);
//     assertEq(newVaault.balance, 20 ether);
//     assertEq(Vault2.balance, 2 ether);

//     //withdrawing ether to a random guy and checking it's balance
//     VaultFacet(newVaault).withdrawEther(1 ether, mkaddr("1etherguy"));
//     assertEq(mkaddr("1etherguy").balance, 1 ether);

//     VaultFacet(newVaault).withdrawEther(1 ether, Vault1Owner);
//     assertEq(Vault1Owner.balance, 1 ether);

//     VaultFacet(newVaault).addInheritors(
//       toSingletonAdd(mkaddr("inheritor with ether alloc")),
//       toSingletonUINT(2 ether)
//     );
//     uint256 etherAlloc = VaultFacet(newVaault).inheritorEtherAllocation(
//       mkaddr("inheritor with ether alloc")
//     );

//     assertEq(etherAlloc, 2 ether);

//     VaultFacet(newVaault).removeInheritors(
//       toSingletonAdd(mkaddr("inheritor with ether alloc"))
//     );

//     //make sure ether allocated to the address removed is now free to withdraw

//     VaultFacet(newVaault).withdrawEther(17 ether, mkaddr("1etherguy"));
//     assertEq(newVaault.balance, 1 ether);

//     //allocated the remaining erc20 token
//     vm.expectRevert(LibKeep.NotInheritor.selector);
//     VaultFacet(newVaault).allocateERC20Tokens(
//       address(erc20t),
//       toSingletonAdd(mkaddr("inheritor with ether alloc")),
//       toSingletonUINT(1000000)
//     );

//     //transfer ownership
//     VaultFacet(newVaault).transferOwnership(mkaddr("newowner"));
//     address newOwner = VaultFacet(newVaault).vaultOwner();
//     assertEq(mkaddr("newowner"), newOwner);

//     vm.expectRevert(NoPermissions.selector);
//     VaultFacet(newVaault).transferBackup(mkaddr("newBackUp"));

//     vm.stopPrank();

//     vm.startPrank(mkaddr("lucky guy"));
//     vm.warp(block.timestamp + 36 weeks);

//     // vm.expectRevert();
//     // VaultFacet(newVaault).claimOwnership(mkaddr("lucky guy"));

//     VaultFacet(newVaault).claimOwnership(mkaddr("lucky next guy"));
//     vm.stopPrank();
//     vm.expectRevert(LibDiamond.NotVaultOwner.selector);
//     VaultFacet(newVaault).withdrawEther(1 ether, mkaddr("1etherguy"));

//     //claim your alloctions
//     vm.startPrank((mkaddr("ann")));
//     vm.warp(block.timestamp + 36 weeks);
//     VaultFacet(address(newVaault)).claimAllAllocations();
//     assertEq(erc20t.balanceOf(mkaddr("ann")), 1e18);
//     assertEq(erc20t.balanceOf(newVaault), 0);
//     VaultFacet(address(newVaault)).claimAllAllocations();
//     vm.stopPrank();

//     address vault2OwnerOnchain = VaultFacet(Vault2).vaultOwner();
//     assertEq(vault2OwnerOnchain, Vault2Owner);

//     vm.startPrank(vault2OwnerOnchain);

//     VaultFacet(Vault2).ping();

//     //approve the vault2 to spend ERC20
//     erc20t.approve(Vault2, 1000000e18);
//     ERC20Facet(Vault2).depositERC20Token(address(erc20t), 1e18);

//     assertEq(erc20t.balanceOf(address(Vault2)), 1e18);

//     vm.expectRevert(LibKeep.InactiveInheritor.selector);
//     VaultFacet(Vault2).allocateEther(
//       toSingletonAdd(mkaddr("er20inheritor")),
//       toSingletonUINT(2 ether)
//     );

//     vm.stopPrank();
//   }

//   function testAllocatedERC20Token() public {
//     address vaultOwner = Vault1Owner;
//     erc20t.approve(newVaault, 1000000e18);
//     ERC20Facet(newVaault).depositERC20Token(address(erc20t), 1e18);
//     uint256 vault2Owneral = erc20t.balanceOf(newVaault);
//     assertEq(vault2Owneral, 1e18);

//     vm.startPrank(vaultOwner);
//     vm.deal(vaultOwner, 19 ether);
//     VaultFacet(newVaault).depositEther{ value: 19 ether }(19 ether);
//     VaultFacet(newVaault).addInheritors(
//       toSingletonAdd(mkaddr("bob")),
//       toSingletonUINT(2 ether)
//     );
//     VaultFacet(newVaault).addInheritors(
//       toSingletonAdd(mkaddr("alice")),
//       toSingletonUINT(2 ether)
//     );

//     VaultFacet(newVaault).allocateERC20Tokens(
//       address(erc20t),
//       toSingletonAdd(mkaddr("bob")),
//       toSingletonUINT(1e18)
//     );

//     uint256 er20Allocated = VaultFacet(newVaault).allTokenAllocations(
//       address(erc20t)
//     );
//     uint256 EtherAllocated = VaultFacet(newVaault).inheritorEtherAllocation(
//       mkaddr("alice")
//     );

//     VaultFacet(newVaault).allocateERC20Tokens(
//       address(erc20t),
//       toSingletonAdd(mkaddr("bob")),
//       toSingletonUINT(0)
//     );

//     VaultFacet(newVaault).allocateERC20Tokens(
//       address(erc20t),
//       toSingletonAdd(mkaddr("alice")),
//       toSingletonUINT(1e18)
//     );
//     assertEq(er20Allocated, 1e18);
//     assertEq(EtherAllocated, 2 ether);

//     vm.stopPrank();
//   }

//   function testVault2() public {
//     vm.startPrank(Vault2Owner);

//     //approve the vault to spend ERC20
//     erc20t.approve(Vault2, 1000000e18);
//     ERC20Facet(Vault2).depositERC20Token(address(erc20t), 1e18);

//     assertEq(erc20t.balanceOf(address(Vault2)), 1e18);
//     address owner2 = VaultFacet(address(Vault2)).vaultOwner();
//     assertEq(owner2, Vault2Owner);

//     vm.stopPrank();
//     VaultFacet.VaultInfo memory structOwner = VaultFacet(address(Vault2))
//       .inspectVault();
//     assertEq(structOwner.backup, mkaddr("Vault2 BackUp"));
//     assertEq(structOwner.weiBalance, 2 ether);
//     assertEq(structOwner.lastPing, 1);
//     assertEq(structOwner.id, 1);
//   }
// }
